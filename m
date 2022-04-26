Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEC150F4C0
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345111AbiDZIkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345751AbiDZIj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:39:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043B5403C9;
        Tue, 26 Apr 2022 01:30:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1766617E8;
        Tue, 26 Apr 2022 08:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAC0C385A4;
        Tue, 26 Apr 2022 08:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961847;
        bh=0tuairVe7q3IaM+IniLAqmeXoRU9B7E4EPF5fzmWeV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IU3dlSwgGwt7zdA0jdHj5ZqcEbHUm3GPCyNZmRz/SU0q+0AzEHHl8r7/hO1pWj+vy
         IHbXSFpwJg5Lc8EMHXkdnz47mehWvMVtw6NJUEuIirhnlcAHM/fDmdU29njV/N4vFb
         HQFXLgsUNZwwIDtrvO7JYiMtTvWDQZ29ueA65KXo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Khem Raj <raj.khem@gmail.com>
Subject: [PATCH 5.4 01/62] etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead
Date:   Tue, 26 Apr 2022 10:20:41 +0200
Message-Id: <20220426081737.254741425@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081737.209637816@linuxfoundation.org>
References: <20220426081737.209637816@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 2618a0dae09ef37728dab89ff60418cbe25ae6bd upstream.

With GCC 12, -Wstringop-overread was warning about an implicit cast from
char[6] to char[8]. However, the extra 2 bytes are always thrown away,
alignment doesn't matter, and the risk of hitting the edge of unallocated
memory has been accepted, so this prototype can just be converted to a
regular char *. Silences:

net/core/dev.c: In function ‘bpf_prog_run_generic_xdp’: net/core/dev.c:4618:21: warning: ‘ether_addr_equal_64bits’ reading 8 bytes from a region of size 6 [-Wstringop-overread]
 4618 |         orig_host = ether_addr_equal_64bits(eth->h_dest, > skb->dev->dev_addr);
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
net/core/dev.c:4618:21: note: referencing argument 1 of type ‘const u8[8]’ {aka ‘const unsigned char[8]’}
net/core/dev.c:4618:21: note: referencing argument 2 of type ‘const u8[8]’ {aka ‘const unsigned char[8]’}
In file included from net/core/dev.c:91: include/linux/etherdevice.h:375:20: note: in a call to function ‘ether_addr_equal_64bits’
  375 | static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
      |                    ^~~~~~~~~~~~~~~~~~~~~~~

Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/netdev/20220212090811.uuzk6d76agw2vv73@pengutronix.de
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Khem Raj <raj.khem@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/etherdevice.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -127,7 +127,7 @@ static inline bool is_multicast_ether_ad
 #endif
 }
 
-static inline bool is_multicast_ether_addr_64bits(const u8 addr[6+2])
+static inline bool is_multicast_ether_addr_64bits(const u8 *addr)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
 #ifdef __BIG_ENDIAN
@@ -341,8 +341,7 @@ static inline bool ether_addr_equal(cons
  * Please note that alignment of addr1 & addr2 are only guaranteed to be 16 bits.
  */
 
-static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
-					   const u8 addr2[6+2])
+static inline bool ether_addr_equal_64bits(const u8 *addr1, const u8 *addr2)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
 	u64 fold = (*(const u64 *)addr1) ^ (*(const u64 *)addr2);


