Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B4521CFA
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 19:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbfEQR7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 13:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728225AbfEQR7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 13:59:14 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5541721743;
        Fri, 17 May 2019 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558115954;
        bh=/Tlhfc1GVuoh6D0Js8mUPpqT3cpJdxffuXXTsDUeN6k=;
        h=From:To:Cc:Subject:Date:From;
        b=TI803CxbqdO2IgJ+lMM5qIuYuokZ/+kJKbPPbHn7nJI2Q+u3oTYVeXOHBxOTuIrQ/
         duEc4pOaA6h8GL6em/Zgl4ncLUqc4PGsYuwM8EmQFzmEsJFb4BAR+iTTSQWPw6Ts6H
         /Txbxheuzy4JBJkD82H4OrA12jo9fJiJEX1U6odQ=
From:   David Ahern <dsahern@kernel.org>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, Jason@zx2c4.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2] ip route: Set rtm_dst_len to 32 for all ip route get requests
Date:   Fri, 17 May 2019 10:59:13 -0700
Message-Id: <20190517175913.20629-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Jason reported that ip route get with a prefix length is now
failing:
    $ 192.168.50.0/24
    RTNETLINK answers: Invalid argument

iproute2 now uses strict mode and strict mode in the kernel
requires rtm_dst_len to be 32. Non-strict mode ignores the
prefix length, so this allows ip to work without affecting
existing users who add a prefix length to the request.

Fixes: aea41afcfd6d6 ("ip bridge: Set NETLINK_GET_STRICT_CHK on socket")
Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: David Ahern <dsahern@gmail.com>
---
 ip/iproute.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/ip/iproute.c b/ip/iproute.c
index 2b3dcc5dbd53..d980b86ffd42 100644
--- a/ip/iproute.c
+++ b/ip/iproute.c
@@ -2035,7 +2035,11 @@ static int iproute_get(int argc, char **argv)
 			if (addr.bytelen)
 				addattr_l(&req.n, sizeof(req),
 					  RTA_DST, &addr.data, addr.bytelen);
-			req.r.rtm_dst_len = addr.bitlen;
+			/* kernel ignores prefix length on 'route get'
+			 * requests; to allow ip to work with strict mode
+			 * but not break existing users, just set to 32
+			 */
+			req.r.rtm_dst_len = 32;
 			address_found = true;
 		}
 		argc--; argv++;
-- 
2.11.0

