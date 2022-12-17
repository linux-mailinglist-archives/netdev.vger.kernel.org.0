Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD6CD64F746
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 04:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiLQDHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 22:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiLQDHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 22:07:10 -0500
Received: from pv50p00im-ztdg10012101.me.com (pv50p00im-ztdg10012101.me.com [17.58.6.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E006649B6C
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 19:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zzy040330.moe;
        s=sig1; t=1671246429;
        bh=fNvQnkuKnVzOUlC/PJc/EbNg3vsHt+if+VgLf1PDnd4=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=NzByFag19fYj4hrO5KfIXHOSv7fkQ6OfsSHluY8f0RAVAihSph2NZZnkyr2kZEzGp
         O+9GcDBpgCjdISOIwOJO0hIWG5iBRzXu7qs6Cs9h3h7o7mhHL+bAH3UQc4HvYbMJVu
         jJCkbChTzb0flUJLwWUqCv4xKrHVhy+8ZWMIFjyaUXkIRShvtvdun2sbgywGo95NUq
         66Q0bX/7kET0RJApfke7+icAGmSEvZKwsRTGTM+bsfmwXnTNSj1EubkKsVXDrpaJMd
         2VAQjNX87A2q6GWlMobtMLf+St/h27Y/l8zpzKmQS/0yUAntkN67UxwBRbYrlUPclg
         Mx9Wto2V5GaGA==
Received: from localhost.localdomain (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztdg10012101.me.com (Postfix) with ESMTPSA id DEB6E7403E5;
        Sat, 17 Dec 2022 03:07:05 +0000 (UTC)
From:   Jun ASAKA <JunASAKA@zzy040330.moe>
To:     Jes.Sorensen@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jun ASAKA <JunASAKA@zzy040330.moe>
Subject: [PATCH] wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu
Date:   Sat, 17 Dec 2022 11:06:59 +0800
Message-Id: <20221217030659.12577-1-JunASAKA@zzy040330.moe>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: dZqxiBTEh1IB4iYiQuFvsHE6Xy2mqvCy
X-Proofpoint-GUID: dZqxiBTEh1IB4iYiQuFvsHE6Xy2mqvCy
X-Proofpoint-Virus-Version: =?UTF-8?Q?vendor=3Dfsecure_engine=3D1.1.170-22c6f66c430a71ce266a39bfe25bc?=
 =?UTF-8?Q?2903e8d5c8f:6.0.517,18.0.572,17.0.605.474.0000000_definitions?=
 =?UTF-8?Q?=3D2022-06-21=5F01:2022-06-21=5F01,2020-02-14=5F11,2020-01-23?=
 =?UTF-8?Q?=5F02_signatures=3D0?=
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 clxscore=1030 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=520
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2212170023
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixing transmission failure which results in
"authentication with ... timed out". This can be
fixed by disable the REG_TXPAUSE.

Signed-off-by: Jun ASAKA <JunASAKA@zzy040330.moe>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index a7d76693c02d..9d0ed6760cb6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1744,6 +1744,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
 	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
 	val8 &= ~BIT(0);
 	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
+
+	/*
+	 * Fix transmission failure of rtl8192e.
+	 */
+	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
 }
 
 static s8 rtl8192e_cck_rssi(struct rtl8xxxu_priv *priv, u8 cck_agc_rpt)
-- 
2.31.1

