Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38E5A4BA56D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241269AbiBQQJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:09:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBQQJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:09:39 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AE3187458;
        Thu, 17 Feb 2022 08:09:24 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p15so8410918ejc.7;
        Thu, 17 Feb 2022 08:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W6cqxl/ALNXLXDztiVLAO/QpWZwa8vitYwFUjYdClJU=;
        b=Hbu1lkEXwbpzvl9171+9N/HTuhPnpZI7TN3IpHeBNZsEhhCm/aidYSQqNN8cfx1fPD
         Cuocu4zsTZJYnSrRcyEeIVKrzLjE0HLv+JKoue/PW1tfCJt0kkvK7E7Cna8MeK6QYZ7m
         mBG/QRHWL3WHYmh3YedqarS01z30Tx3TY6fe3GzGl221jMweHoZzy554ImF1KQ+ckfpP
         FnYT91VSi4lGPbtzXV7fpRYljlpJFkInHFFM9Q2Snb/LMdHUNvKvquSqaWwFofHNmr4M
         JDDrFNsF7tD/iLv1zt5pbAqvqnVeqcH1JxOJt+LRbcgRucduO8fXjYCU8TzZyKD9pYP1
         K7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W6cqxl/ALNXLXDztiVLAO/QpWZwa8vitYwFUjYdClJU=;
        b=LnwZ6kUL7DqHRI2/vs7v9J795REgJNGLMKVMIYv5FKB4EUADQ8cZXQ7rzAWre7xv/V
         ykIL+9oDs2VUaDw0+ELSGH/xBas6olY9/C4D5Wmn4JKLPvZFSw686JkbY3nNpyE78xKX
         8gaoQbv9kJnpt3fkWp+sPM8t//UexjtecgPtpjfLxMyd/0TUgBbpAoYLrCQrZPveEcC1
         oSqft8zwXl9Nqsz6mgjRDlI2j9T6ctmKF5SlpAQzcxCv/NWK8uKMKXLZbH1llsT8GLn1
         gUn0GT2FgIqV6CDvh61sm7Haa1ENYFkq847TDZln85BNqj5Wgah0BZ66U00TTnHwgvq7
         8DiQ==
X-Gm-Message-State: AOAM531ltGtI0EL0/wLJIK9sDZOk7MQFbRIc5vf3HirBhgYyJ9oCkapc
        rY673i56OYro3vu8KWqhiZpvsfTDPFaawp1j
X-Google-Smtp-Source: ABdhPJyBg9At4wkqSN22UCtVzUZWrJpalj/CPnarf0JykUkauxFwTqebb8N57hljQBXhxJgYfuyX+A==
X-Received: by 2002:a17:906:cc8d:b0:6c9:6df1:7c55 with SMTP id oq13-20020a170906cc8d00b006c96df17c55mr2864041ejb.317.1645114162838;
        Thu, 17 Feb 2022 08:09:22 -0800 (PST)
Received: from hw-dev-vm01.evs.tv ([212.222.125.68])
        by smtp.gmail.com with ESMTPSA id x14sm3568194edd.63.2022.02.17.08.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 08:09:22 -0800 (PST)
From:   Fred Lefranc <hardware.evs@gmail.com>
Cc:     Fred Lefranc <hardware.evs@gmail.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz & rx_extra_headroom config from devicetree.
Date:   Thu, 17 Feb 2022 17:05:26 +0100
Message-Id: <20220217160528.2662513-1-hardware.evs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow modification of two additional Frame Manager parameters :
- FM Max Frame Size : Can be changed to a value other than 1522
  (ie support Jumbo Frames)
- RX Extra Headroom

Signed-off-by: Fred Lefranc <hardware.evs@gmail.com>
---
 drivers/net/ethernet/freescale/fman/fman.c | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fman/fman.c b/drivers/net/ethernet/freescale/fman/fman.c
index 8f0db61cb1f6..bf4240eacf42 100644
--- a/drivers/net/ethernet/freescale/fman/fman.c
+++ b/drivers/net/ethernet/freescale/fman/fman.c
@@ -2862,6 +2862,32 @@ static struct fman *read_dts_node(struct platform_device *of_dev)
 		of_property_read_bool(fm_node, "fsl,erratum-a050385");
 #endif
 
+	/* Get Max Frame Size */
+	err = of_property_read_u32(fm_node, "fsl,max-frm-sz", &val);
+	if (!err) {
+		if (val > FSL_FM_MAX_POSSIBLE_FRAME_SIZE)
+			fsl_fm_max_frm = FSL_FM_MAX_POSSIBLE_FRAME_SIZE;
+		else if (val < FSL_FM_MIN_POSSIBLE_FRAME_SIZE)
+			fsl_fm_max_frm = FSL_FM_MIN_POSSIBLE_FRAME_SIZE;
+		else
+			fsl_fm_max_frm = (int)val;
+	}
+	dev_dbg(&of_dev->dev, "Configured Max Frame Size: %d\n",
+		fsl_fm_max_frm);
+
+	/* Get RX Extra Headroom Value */
+	err = of_property_read_u32(fm_node, "fsl,rx-extra-headroom", &val);
+	if (!err) {
+		if (val > FSL_FM_RX_EXTRA_HEADROOM_MAX)
+			fsl_fm_rx_extra_headroom = FSL_FM_RX_EXTRA_HEADROOM_MAX;
+		else if (val < FSL_FM_RX_EXTRA_HEADROOM_MIN)
+			fsl_fm_rx_extra_headroom = FSL_FM_RX_EXTRA_HEADROOM_MIN;
+		else
+			fsl_fm_rx_extra_headroom = (int)val;
+	}
+	dev_dbg(&of_dev->dev, "Configured RX Extra Headroom: %d\n",
+		fsl_fm_rx_extra_headroom);
+
 	return fman;
 
 fman_node_put:
-- 
2.25.1

