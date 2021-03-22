Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2FD344E90
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 19:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhCVSbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 14:31:12 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:62916 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbhCVSbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 14:31:02 -0400
Date:   Mon, 22 Mar 2021 18:30:55 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616437860; bh=b5bnSC21HmdPSasvb0lPwEo3mq8xZMPl9SmiGDrxhUA=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=T7gFIEvlwC6tvcyiAGO7XGyjFHGvUsCeAnSnlZePqC9ObCS2k+FPNvlA6BCtbIfvK
         0IiSFn0JyKe8s3lslelNM21/WjpYjbT9egUHW2iXTNhB/Iz9js+pkFG3w8OFZSYBIC
         Fp4PCGRVWGivgvfad8WOg819SMJ6F0CM5PjghkyVxGl3pO2IhW+JmhzjmK4ksM1sUO
         cflq/xEqRaQAAdxnFDGx+PTPBngvlY6XHklEwEtu/tfaYxXsn7zcDXzEWeNGpUaWuN
         O+jKscOJ20r9mriCfMJhbrbzHrA0KOl3WtqfLf2d6xPjBGvsS1S/XTNdwnAACN4M++
         sAcXS508z8sVQ==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH net-next] page_pool: let the compiler optimize and inline core functions
Message-ID: <20210322183047.10768-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per disscussion in Page Pool bulk allocator thread [0],
there are two functions in Page Pool core code that are marked as
'noinline'. The reason for this is not so clear, and even if it
was made to reduce hotpath overhead, in fact it only makes things
worse.
As both of these functions as being called only once through the
code, they could be inlined/folded into the non-static entry point.
However, 'noinline' marks effectively prevent from doing that and
induce totally unneeded fragmentation (baseline -> after removal):

add/remove: 0/3 grow/shrink: 1/0 up/down: 1024/-1096 (-72)
Function                                     old     new   delta
page_pool_alloc_pages                        100    1124   +1024
page_pool_dma_map                            164       -    -164
page_pool_refill_alloc_cache                 332       -    -332
__page_pool_alloc_pages_slow                 600       -    -600

(taken from Mel's branch, hence factored-out page_pool_dma_map())

1124 is a normal hotpath frame size, but these jumps between tiny
page_pool_alloc_pages(), page_pool_refill_alloc_cache() and
__page_pool_alloc_pages_slow() are really redundant and harmful
for performance.

This simple removal of 'noinline' keywords bumps the throughput
on XDP_PASS + napi_build_skb() + napi_gro_receive() on 25+ Mbps
for 1G embedded NIC.

[0] https://lore.kernel.org/netdev/20210317222506.1266004-1-alobakin@pm.me

Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 net/core/page_pool.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index ad8b0707af04..589e4df6ef2b 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -102,7 +102,6 @@ EXPORT_SYMBOL(page_pool_create);

 static void page_pool_return_page(struct page_pool *pool, struct page *pag=
e);

-noinline
 static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
 {
 =09struct ptr_ring *r =3D &pool->ring;
@@ -181,7 +180,6 @@ static void page_pool_dma_sync_for_device(struct page_p=
ool *pool,
 }

 /* slow path */
-noinline
 static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
 =09=09=09=09=09=09 gfp_t _gfp)
 {
--
2.31.0


