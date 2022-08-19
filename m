Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1898F599AA4
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 13:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348739AbiHSLKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 07:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348742AbiHSLKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 07:10:22 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCD6FC325;
        Fri, 19 Aug 2022 04:10:21 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27JAtHpw016663;
        Fri, 19 Aug 2022 04:07:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=PPS06212021;
 bh=PLaVbpp4hNo2EhMbAkEWZSGhegi5n9JUce2ULCMebHo=;
 b=Cm0BwIF5cGcB+Fld/7+IRHbHs1XABQd56EXQgOwn464h5CUOCY/Mqrnxe/F0f4dn0vts
 fW4TKq0MNZ145rR/NvI+/oU2xKydluoOJL+OyGAOQtDfbDDC+Ea+7lyq7QcXYtBhY/Ru
 bp9H0KR7h5nrFcjR2mEJoE1OxiWdic4rIuMqjh8u39gvAvjQ+10/9QZ05hYYyCJZSLa7
 Fvt+D+gm+Npf/YnTRwUafNq5ns5Ir8D9T3gbegcf/nOTDCfQmNZ9WIt3A13j9cthcRp+
 K+CkjReuSSDGl5Az7C1jbdb9TlUVNDCZYGQ/t8D9uSBhhr5bE0d61Yh9MwfL0fbp6tzO Iw== 
Received: from ala-exchng01.corp.ad.wrs.com (unknown-82-252.windriver.com [147.11.82.252])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hxbfjn0j5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Aug 2022 04:07:36 -0700
Received: from otp-dpanait-l2.corp.ad.wrs.com (128.224.125.191) by
 ala-exchng01.corp.ad.wrs.com (147.11.82.252) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 19 Aug 2022 04:07:32 -0700
From:   Dragos-Marian Panait <dragos.panait@windriver.com>
To:     <stable@vger.kernel.org>
CC:     Pavel Skripkin <paskripkin@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5.4 1/1] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
Date:   Fri, 19 Aug 2022 14:07:19 +0300
Message-ID: <20220819110719.915478-2-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220819110719.915478-1-dragos.panait@windriver.com>
References: <20220819110719.915478-1-dragos.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.125.191]
X-ClientProxiedBy: ala-exchng01.corp.ad.wrs.com (147.11.82.252) To
 ala-exchng01.corp.ad.wrs.com (147.11.82.252)
X-Proofpoint-GUID: YPVHyg48XGDGYuPRzs29gU6y8mQQU4nb
X-Proofpoint-ORIG-GUID: YPVHyg48XGDGYuPRzs29gU6y8mQQU4nb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-19_06,2022-08-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=977 clxscore=1015 phishscore=0 bulkscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208190043
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 0ac4827f78c7ffe8eef074bc010e7e34bc22f533 upstream.

Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb() [0]. The
problem was in incorrect htc_handle->drv_priv initialization.

Probable call trace which can trigger use-after-free:

ath9k_htc_probe_device()
  /* htc_handle->drv_priv = priv; */
  ath9k_htc_wait_for_target()      <--- Failed
  ieee80211_free_hw()		   <--- priv pointer is freed

<IRQ>
...
ath9k_hif_usb_rx_cb()
  ath9k_hif_usb_rx_stream()
   RX_STAT_INC()		<--- htc_handle->drv_priv access

In order to not add fancy protection for drv_priv we can move
htc_handle->drv_priv initialization at the end of the
ath9k_htc_probe_device() and add helper macro to make
all *_STAT_* macros NULL safe, since syzbot has reported related NULL
deref in that macros [1]

Link: https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60 [0]
Link: https://syzkaller.appspot.com/bug?id=b8101ffcec107c0567a0cd8acbbacec91e9ee8de [1]
Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com
Signed-off-by: Dragos-Marian Panait <dragos.panait@windriver.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          | 10 +++++-----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |  3 ++-
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 9f64e32381f9..81107100e368 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -325,11 +325,11 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-
-#define TX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
-#define TX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
-#define RX_STAT_INC(c) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
-#define RX_STAT_ADD(c, a) (hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
+#define __STAT_SAFE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
+#define TX_STAT_INC(c) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
+#define TX_STAT_ADD(c, a) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
+#define RX_STAT_INC(c) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
+#define RX_STAT_ADD(c, a) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
 #define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
 
 #define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 11054c17a9b5..eaaafa64a3ee 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -944,7 +944,6 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 	priv->hw = hw;
 	priv->htc = htc_handle;
 	priv->dev = dev;
-	htc_handle->drv_priv = priv;
 	SET_IEEE80211_DEV(hw, priv->dev);
 
 	ret = ath9k_htc_wait_for_target(priv);
@@ -965,6 +964,8 @@ int ath9k_htc_probe_device(struct htc_target *htc_handle, struct device *dev,
 	if (ret)
 		goto err_init;
 
+	htc_handle->drv_priv = priv;
+
 	return 0;
 
 err_init:
-- 
2.37.1

