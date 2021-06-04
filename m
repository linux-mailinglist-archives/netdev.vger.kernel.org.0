Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F07639BB8E
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 17:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhFDPTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 11:19:48 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:54916 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhFDPTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 11:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1622819878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wFEvuNyHfPiVav+6JQ1EDLZB4jXWgskHb1VvAjhvm2A=;
        b=Nfqk1Tx6XQy4/vZ7k+Dk9sFbGxN6IaInu3npUWf/qA0QCjVlgdsFO/1xakviI3UBOG05Vh
        iRsJtgAGK0e/QWfHaSjxjeh6hhFzzWzaGuIcDMhR11l1EPDh7QOg/sc78hDUMpdrWKYJSR
        QQR3yVv8YQtoC0+Vf/JiB1tD+YZ+rqs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5c409dc9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 4 Jun 2021 15:17:58 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hangbin Liu <liuhangbin@gmail.com>, stable@vger.kernel.org
Subject: [PATCH net 2/9] wireguard: selftests: make sure rp_filter is disabled on vethc
Date:   Fri,  4 Jun 2021 17:17:31 +0200
Message-Id: <20210604151738.220232-3-Jason@zx2c4.com>
In-Reply-To: <20210604151738.220232-1-Jason@zx2c4.com>
References: <20210604151738.220232-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some distros may enable strict rp_filter by default, which will prevent
vethc from receiving the packets with an unrouteable reverse path address.

Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/netns.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index 7ed7cd95e58f..ebc4ee0fe179 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -363,6 +363,7 @@ ip1 -6 rule add table main suppress_prefixlength 0
 ip1 -4 route add default dev wg0 table 51820
 ip1 -4 rule add not fwmark 51820 table 51820
 ip1 -4 rule add table main suppress_prefixlength 0
+n1 bash -c 'printf 0 > /proc/sys/net/ipv4/conf/vethc/rp_filter'
 # Flood the pings instead of sending just one, to trigger routing table reference counting bugs.
 n1 ping -W 1 -c 100 -f 192.168.99.7
 n1 ping -W 1 -c 100 -f abab::1111
-- 
2.31.1

