Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01A7A14B9A8
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 15:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732642AbgA1OYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 09:24:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:51356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732572AbgA1OYg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 09:24:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEA112071E;
        Tue, 28 Jan 2020 14:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221475;
        bh=BDZEEsBK6AX+caJfyrsZPuxiKlFI9f3B0vVgXc6IL9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Smh+A9SJPuEjbWKEXever5gBTmQObmvfu9X1luRMrz8v/okNnKUAJfsG+isgKUXlz
         iH9s+i1/K4vKqw8kQwa/kieTxe3EYxoKSzQxSrkHo3LbybdPUY3lwGoC5kVcHfTC12
         RGlIhaj8j91Jr6bkGOmIj591XL94filWx2ONahyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Subject: [PATCH 4.9 240/271] tcp_bbr: improve arithmetic division in bbr_update_bw()
Date:   Tue, 28 Jan 2020 15:06:29 +0100
Message-Id: <20200128135910.406657627@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

[ Upstream commit 5b2f1f3070b6447b76174ea8bfb7390dc6253ebd ]

do_div() does a 64-by-32 division. Use div64_long() instead of it
if the divisor is long, to avoid truncation to 32-bit.
And as a nice side effect also cleans up the function a bit.

Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_bbr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -649,8 +649,7 @@ static void bbr_update_bw(struct sock *s
 	 * bandwidth sample. Delivered is in packets and interval_us in uS and
 	 * ratio will be <<1 for most connections. So delivered is first scaled.
 	 */
-	bw = (u64)rs->delivered * BW_UNIT;
-	do_div(bw, rs->interval_us);
+	bw = div64_long((u64)rs->delivered * BW_UNIT, rs->interval_us);
 
 	/* If this sample is application-limited, it is likely to have a very
 	 * low delivered count that represents application behavior rather than


