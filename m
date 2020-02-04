Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACB51521CA
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 22:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgBDVR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 16:17:59 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:54783 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727589AbgBDVR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Feb 2020 16:17:59 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 43bdac69;
        Tue, 4 Feb 2020 21:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=u5eOg3JFpoesAcRprvw43rjXu
        vs=; b=PO6J8FP4m8PHBghzMrTA6YrpUcTiO4IhzPDLHxUdxyw/8IaM6sS/aLFjH
        xwKklVp9aT8V/dQTF12Mjm/LMkloKSM7mn27zQcBYKEm/yCfv9TY3bKHRfi1jB8O
        7UgXv58WOKD1rWkkggFbXNgfyQk6XcUAGv+KLm40a5bqhKoX1PYNZjrM3KRO5ts/
        8l3f3JTp360wcMXWirW4qYL0MeL61KLqqlHa0blXQRFLZ0z75C2Q5cTIFNVM01W4
        UVWqSQSlf/URVmtfcVBEbqMpZaLpp2aev1Z4m0pikTQof57OYptwHwut5B7puq7F
        UENO8O+920fSAM6VeZyvhQVf5ofbA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3117f1bd (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Tue, 4 Feb 2020 21:17:05 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 3/5] wireguard: selftests: ensure non-addition of peers with failed precomputation
Date:   Tue,  4 Feb 2020 22:17:27 +0100
Message-Id: <20200204211729.365431-4-Jason@zx2c4.com>
In-Reply-To: <20200204211729.365431-1-Jason@zx2c4.com>
References: <20200204211729.365431-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure that peers with low order points are ignored, both in the case
where we already have a device private key and in the case where we do
not. This adds points that naturally give a zero output.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/netns.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index d5c85c7494f2..b03647d1bbf6 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -516,6 +516,12 @@ n0 wg set wg0 peer "$pub2" allowed-ips 0.0.0.0/0,10.0.0.0/8,100.0.0.0/10,172.16.
 n0 wg set wg0 peer "$pub2" allowed-ips 0.0.0.0/0
 n0 wg set wg0 peer "$pub2" allowed-ips ::/0,1700::/111,5000::/4,e000::/37,9000::/75
 n0 wg set wg0 peer "$pub2" allowed-ips ::/0
+n0 wg set wg0 peer "$pub2" remove
+low_order_points=( AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA= AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA= 4Ot6fDtBuK4WVuP68Z/EatoJjeucMrH9hmIFFl9JuAA= X5yVvKNQjCSx0LFVnIPvWwREXMRYHI6G2CJO3dCfEVc= 7P///////////////////////////////////////38= 7f///////////////////////////////////////38= 7v///////////////////////////////////////38= )
+n0 wg set wg0 private-key /dev/null ${low_order_points[@]/#/peer }
+[[ -z $(n0 wg show wg0 peers) ]]
+n0 wg set wg0 private-key <(echo "$key1") ${low_order_points[@]/#/peer }
+[[ -z $(n0 wg show wg0 peers) ]]
 ip0 link del wg0
 
 declare -A objects
-- 
2.25.0

