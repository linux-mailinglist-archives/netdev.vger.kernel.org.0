Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5416013E634
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388961AbgAPRTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:19:00 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39071 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391518AbgAPRSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 12:18:38 -0500
Received: by mail-wm1-f65.google.com with SMTP id 20so4642032wmj.4
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 09:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Van5iMUPt75Dhp2RA0mDMd4+WxnU2QI6ZEJAQ+mejQs=;
        b=iMpomwRv1n5m6cC/trOhTKhG0pWracgFeD6R+Xo3/4Ocb5RJOh7SK1LHxmH98TpaQu
         uNN3uyYZGaUeqEEbqkKex9LUjf/5sUHp2YpBaQ8ud+byMq+696VVVt7/5n9yWjbaJAiM
         TeI0KrcW/7OUwTxUBYaKPI1vBrA8Pk8UgutPXznm0VjKzXpYCzD2ocwHRdlX0xumYVNF
         AnntV8WcQyVuexGRFUPGg5PjHPjnvniSCcc6XGF5t2avoN8FDY2Ayqf56wcs8BsFZdOz
         THFw8SAy0Z66lgQiNC/vHgvdxeMxwBwzdRLmdR0luKsGw3oSsBjUE2MpQ7trCSQmcHl0
         ksrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Van5iMUPt75Dhp2RA0mDMd4+WxnU2QI6ZEJAQ+mejQs=;
        b=FrswTNOfEkkHXnb5VpIGwnR7TofP//aB6aTXhExNksr1MWKWtvRkl9cYSjNV8ICRRH
         cFKuXs2WXnbqerwUuMJSawRrwoduTQwyGm92mOzo61npdzRv3o+KRaUki3yYFtVbRWE7
         d7au9ia7b5K2EF9yxRJGAN224F54kqmtmB1aSzXF9EFEF4M3mnC2/ojA7MqikDXd9ih4
         +m4H8w6ibrFhW8hnSSu6U6JazAtmn5KL/QMXF4OdZbN12SXPRl0JJRGr5AEh+QcHCYZt
         ZZnO6U3RPrFp3+VLDZ4p7U/VToRjw9dNS3FrcNwQQgTGhlNRX8X7mWPUpjpPGnkHaZqI
         yqwQ==
X-Gm-Message-State: APjAAAW05gGmA8rGpdcfqBoa8xyOJTeCFCTnWJhIn7mm4m8jGfHSRlsJ
        B9TRoKZCyPY24kiThHAzUWg=
X-Google-Smtp-Source: APXvYqxGbFzg1+E3KjvOSAkunWkYSJziwphagJqZy6A+i3OVyXyZ86rgeQsBMNhijAYyIONrTl1/CA==
X-Received: by 2002:a1c:2504:: with SMTP id l4mr99959wml.134.1579195116155;
        Thu, 16 Jan 2020 09:18:36 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id q3sm31279962wrn.33.2020.01.16.09.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 09:18:35 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com, po.liu@nxp.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] enetc: Don't print from enetc_sched_speed_set when link goes down
Date:   Thu, 16 Jan 2020 19:18:28 +0200
Message-Id: <20200116171828.2016-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It is not an error to unplug a cable from the ENETC port even with TSN
offloads, so don't spam the log with link-related messages from the
tc-taprio offload subsystem, a single notification is sufficient:

[10972.351859] fsl_enetc 0000:00:00.0 eno0: Qbv PSPEED set speed link down.
[10972.360241] fsl_enetc 0000:00:00.0 eno0: Link is Down

Fixes: 2e47cb415f0a ("enetc: update TSN Qbv PSPEED set according to adjust link speed")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 00382b7c5bd8..0c6bf3a55a9a 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -36,7 +36,6 @@ void enetc_sched_speed_set(struct net_device *ndev)
 	case SPEED_10:
 	default:
 		pspeed = ENETC_PMR_PSPEED_10M;
-		netdev_err(ndev, "Qbv PSPEED set speed link down.\n");
 	}
 
 	priv->speed = speed;
-- 
2.17.1

