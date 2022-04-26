Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC92B50F67F
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbiDZI4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:56:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346073AbiDZItu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:49:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DDCBB921;
        Tue, 26 Apr 2022 01:37:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EABDDB81D19;
        Tue, 26 Apr 2022 08:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58791C385A0;
        Tue, 26 Apr 2022 08:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962269;
        bh=qMpCqUCdhyMR/21WSKQ0+DrkxS6S4vYxyQeR11WMz/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edtD9RsJV3/srcc+ccAchx3L59gpzXCP/VMZ0nP15Emz7Y3k7byp7Nbpb0/8Pvzur
         SaNN0kb6xjmAmJ1e+bYyoCP5wwlswrZe3AjTyJYX4PXXKaGqHK6EFhN8KSwTPCxT51
         ZfjEmAiUd9/zTqS4aDKjvUW4QGg0w4l1nWYyiFNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Khem Raj <raj.khem@gmail.com>
Subject: [PATCH 5.15 008/124] etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead
Date:   Tue, 26 Apr 2022 10:20:09 +0200
Message-Id: <20220426081747.533483888@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
@@ -364,8 +364,7 @@ static inline bool ether_addr_equal(cons
  * Please note that alignment of addr1 & addr2 are only guaranteed to be 16 bits.
  */
 
-static inline bool ether_addr_equal_64bits(const u8 addr1[6+2],
-					   const u8 addr2[6+2])
+static inline bool ether_addr_equal_64bits(const u8 *addr1, const u8 *addr2)
 {
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) && BITS_PER_LONG == 64
 	u64 fold = (*(const u64 *)addr1) ^ (*(const u64 *)addr2);


