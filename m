Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADC1259DAC
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 19:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgIARwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 13:52:46 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:36048 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729209AbgIARwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 13:52:43 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F3C7020118;
        Tue,  1 Sep 2020 17:52:41 +0000 (UTC)
Received: from us4-mdac16-56.at1.mdlocal (unknown [10.110.48.199])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F1579800A3;
        Tue,  1 Sep 2020 17:52:41 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.12])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 68B97100079;
        Tue,  1 Sep 2020 17:52:41 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3202140070;
        Tue,  1 Sep 2020 17:52:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Sep 2020
 18:52:36 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next] ethtool: fix error handling in ethtool_phys_id
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>
Message-ID: <99914576-a923-b9d9-3dea-62732508b4ad@solarflare.com>
Date:   Tue, 1 Sep 2020 18:52:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25638.003
X-TM-AS-Result: No-0.374200-8.000000-10
X-TMASE-MatchedRID: VCCJOFmdGYOwp3P/pT7oqUI4eS9mV4/s1Mc6SC5sKVYRGC0rW8q1Xeda
        H7TzxQ9GOckV578LShbmTWNYT4leR6gZeORpCZ4fPwKTD1v8YV5MkOX0UoduuVVkJxysad/I6+3
        41imwtEX2F344+hM7xA6aU1CZ/iwNnqJVP6YxBLHknMSTG9lH+JtoE1VihShtXE5Co/aUb2CjxY
        yRBa/qJQPTK4qtAgwIlnP9MMAZcdoLbigRnpKlKZvjAepGmdoOS/S4WIrzF1jT6+t5A32fDBW/q
        vh98jJswoxWBvZ3dQdpjWgX+2n/h87IQ7X06q1x0+2mUPei9sO6Op0qjr9XLz7Tgq9Uihwm7X0N
        Uj756kyalV1F4xrI89hfrwWZbOCvsmqnO4HNG+XDa0xNKDTHvg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.374200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25638.003
X-MDID: 1598982761-f9UNB9ywX-Et
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ops->set_phys_id() returned an error, previously we would only break
 out of the inner loop, which neither stopped the outer loop nor returned
 the error to the user (since 'rc' would be overwritten on the next pass
 through the loop).
Thus, rewrite it to use a single loop, so that the break does the right
 thing.  Use u64 for 'count' and 'i' to prevent overflow in case of
 (unreasonably) large values of id.data and n.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 net/ethtool/ioctl.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index e6f5cf52023c..3e74c2f74625 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1861,23 +1861,18 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
 			id.data ? (id.data * HZ) : MAX_SCHEDULE_TIMEOUT);
 	} else {
 		/* Driver expects to be called at twice the frequency in rc */
-		int n = rc * 2, i, interval = HZ / n;
+		int n = rc * 2, interval = HZ / n;
+		u64 count = n * id.data, i = 0;
 
-		/* Count down seconds */
 		do {
-			/* Count down iterations per second */
-			i = n;
-			do {
-				rtnl_lock();
-				rc = ops->set_phys_id(dev,
-				    (i & 1) ? ETHTOOL_ID_OFF : ETHTOOL_ID_ON);
-				rtnl_unlock();
-				if (rc)
-					break;
-				schedule_timeout_interruptible(interval);
-			} while (!signal_pending(current) && --i != 0);
-		} while (!signal_pending(current) &&
-			 (id.data == 0 || --id.data != 0));
+			rtnl_lock();
+			rc = ops->set_phys_id(dev,
+				    (i++ & 1) ? ETHTOOL_ID_OFF : ETHTOOL_ID_ON);
+			rtnl_unlock();
+			if (rc)
+				break;
+			schedule_timeout_interruptible(interval);
+		} while (!signal_pending(current) && (!id.data || i < count));
 	}
 
 	rtnl_lock();
