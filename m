Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B8C534DFE
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 13:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346761AbiEZLWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 07:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346171AbiEZLWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 07:22:07 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C87F21
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:21:54 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id h13so1450030pfq.5
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kNtuB840A1q3OEONvZZSgOOnkUcYtuWuq+G8qAKrj5A=;
        b=IHDSwip5ZkMn+jZZWR3D8OeVtPwjy0QmHUMctL7i0m0Ofx9wv7he/E0B26+bpNyLRp
         EkT6a4FMkj5BKxgLtPinkFF4jZl88m2X8+3acFoDhKQdFiP/IfosuMC6/fGLcuuDablW
         Nlb6FCR+IE/aOvnQSBVdgpyq35OilOjJQbduU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kNtuB840A1q3OEONvZZSgOOnkUcYtuWuq+G8qAKrj5A=;
        b=tNbOry1FbsW8815oaz5dppuZN6vuSq3kFianZ7xNTIJ1nfpG+wjonqKhl35a0BwknV
         BVCN7mUGX2zKyZUc4P3GGA/aWJBGhgNaB0qY51JU1MF/4SepqFhDZZzaUtipC6QT+F70
         rBILHZqlFGktm3O7cdBlHUtKMatEEqYaBDg2RSd9h2bILoQe7dx4uOYtbYtGdkfNZwkM
         28dLRQst1eQpdL1RJCGUcX+vybvbdQIx58KRli4xgzDfloFuAVVmtbzjqO2gbi/GSOVy
         ZrfrGsTMQrW5Ze/xhKMnY1vBGElIsfsJ/N/KPO7g43R69iJbJoeAG9/MxHq/EaTtnazG
         rIGQ==
X-Gm-Message-State: AOAM5325TsTrC2WjivttDF6NzaV8QUHOEeO+Hu4VLTGYxdqD295sYxvS
        0fkNCPdX/WmZUfwYjEUzK/IlKg==
X-Google-Smtp-Source: ABdhPJzwGrsjJ7DYpbm/S3lJ4MxlWN/pogwg1wixchK7IkXIlj7XbhGDsW+3B9oczPekcFPg3c/90g==
X-Received: by 2002:a63:5415:0:b0:3fb:971:460a with SMTP id i21-20020a635415000000b003fb0971460amr3226121pgb.86.1653564114093;
        Thu, 26 May 2022 04:21:54 -0700 (PDT)
Received: from localhost (174.71.80.34.bc.googleusercontent.com. [34.80.71.174])
        by smtp.gmail.com with UTF8SMTPSA id y20-20020a170903011400b0015e8d4eb22fsm1229917plc.121.2022.05.26.04.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 04:21:53 -0700 (PDT)
From:   Joseph Hwang <josephsih@chromium.org>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        luiz.dentz@gmail.com, pali@kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org, josephsih@google.com,
        Joseph Hwang <josephsih@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v6 3/5] Bluetooth: hci_event: Add vendor functions to handle vendor events
Date:   Thu, 26 May 2022 19:21:32 +0800
Message-Id: <20220526192047.v6.3.I63681490281b2392aa1ac05dff91a126394ab649@changeid>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
In-Reply-To: <20220526112135.2486883-1-josephsih@chromium.org>
References: <20220526112135.2486883-1-josephsih@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds vendor_get_prefix and vendor_evt in the evt_prefixes
table so that any vendor driver can set up the functions to handle
particular vendor events.

The hci_vendor_evt function checks if a vendor event matches
the vendor prefix returned by vendor_get_prefix. If yes, the
event is pushed down to the driver's vendor_evt function to handle.
The driver function will call hdev->hci_recv_quality_report to
pass data through mgmt if needed.

Signed-off-by: Joseph Hwang <josephsih@chromium.org>
Reviewed-by: Archie Pusaka <apusaka@chromium.org>
---

(no changes since v5)

Changes in v5:
- Use vendor_get_ext_prefix and vendor_evt to invoke callbacks from
  drivers to handle vendor events.
- Use hdev->hci_recv_quality_report to pass vendor event data
  from drivers back to the kernel. The mgmt_quality_report is then
  used to surface the data through the mgmt socket.
- Remove the unnecessary "void *data" portion from vendor_evt.
- The Intel specifics are pushed down to the driver and are
  implemented in a separate subsequent patch.

Changes in v3:
- Move intel_vendor_evt() from hci_event.c to the btintel driver.

Changes in v2:
- Drop the pull_quality_report_data function from hci_dev.
  Do not bother hci_dev with it. Do not bleed the details
  into the core.

 include/net/bluetooth/hci_core.h |  5 +++++
 net/bluetooth/hci_core.c         |  1 +
 net/bluetooth/hci_event.c        | 19 +++++++++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index f89738c6b973..9e48d606591e 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -642,6 +642,11 @@ struct hci_dev {
 	void (*cmd_timeout)(struct hci_dev *hdev);
 	bool (*wakeup)(struct hci_dev *hdev);
 	int (*set_quality_report)(struct hci_dev *hdev, bool enable);
+	struct ext_vendor_prefix *(*vendor_get_ext_prefix)(
+							struct hci_dev *hdev);
+	void (*vendor_evt)(struct hci_dev *hdev, struct sk_buff *skb);
+	int (*hci_recv_quality_report)(struct hci_dev *hdev, void *data,
+				       u32 data_len, u8 quality_spec);
 	int (*get_data_path_id)(struct hci_dev *hdev, __u8 *data_path);
 	int (*get_codec_config_data)(struct hci_dev *hdev, __u8 type,
 				     struct bt_codec *codec, __u8 *vnd_len,
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index ad4f4ab0afca..3e22b4b452f1 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2650,6 +2650,7 @@ int hci_register_dev(struct hci_dev *hdev)
 
 	idr_init(&hdev->adv_monitors_idr);
 	msft_register(hdev);
+	hdev->hci_recv_quality_report = mgmt_quality_report;
 
 	return id;
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 8398971eddf4..85c205ea9c59 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -4260,6 +4260,20 @@ static void hci_num_comp_blocks_evt(struct hci_dev *hdev, void *data,
 	queue_work(hdev->workqueue, &hdev->tx_work);
 }
 
+static struct ext_vendor_prefix *vendor_get_ext_prefix(struct hci_dev *hdev)
+{
+	if (hdev->vendor_get_ext_prefix)
+		return hdev->vendor_get_ext_prefix(hdev);
+
+	return NULL;
+}
+
+static void vendor_evt(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	if (hdev->vendor_evt)
+		hdev->vendor_evt(hdev, skb);
+}
+
 /* Every distinct vendor specification must have a well-defined vendor
  * event prefix to determine if a vendor event meets the specification.
  * Some vendor prefixes are fixed values while some other vendor prefixes
@@ -4276,6 +4290,11 @@ static struct ext_vendor_event_prefix {
 	{ aosp_get_ext_prefix, aosp_vendor_evt },
 	{ msft_get_ext_prefix, msft_vendor_evt },
 
+	/* Any vendor driver that handles particular vendor events should set
+	 * up hdev->vendor_get_prefix and hdev->vendor_evt callbacks in driver.
+	 */
+	{ vendor_get_ext_prefix, vendor_evt },
+
 	/* end with a null entry */
 	{},
 };
-- 
2.36.1.124.g0e6072fb45-goog

