Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943FA6B7083
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 08:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjCMHzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 03:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCMHzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 03:55:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72F7521C1
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 00:53:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 206-20020a2504d7000000b00b3511d10748so6314249ybe.20
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 00:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678694029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/wBOPA3Q8ilgbG6yOMVccHt3Hm5RVGWPaaDgr3zdzIk=;
        b=E6Lrvxhucgdotl/t25Cegx7vyMG3rE6VZaYVERbwQ7YrdQlsW7JOpK/unNfdWlKjK2
         Q+YQNcmZ+hbiXTXqzpEPMghgLl22k0m6nCsxYtkhyk4QTfogTNmbYRLIttpWzy3Bljj/
         IyMEtC4Quuo+nH7q7Q00OAncQhMnhFXTctzDjLK0ApZSajsJn5gpG5ul2/hs0Miiwsjf
         urbdR5unFDxRRXYSweTyfTQguTPsut/tYk4AdiMd8J5JPPMQY9ASrjBJpy8JXMoeZXCA
         0pneYdZ/MGZ0mi+kgC+xjLSyanRDvV9cIMKO1E1aym+VoVmeyw9bElNbJElJ11/GpqcO
         ee+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678694029;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/wBOPA3Q8ilgbG6yOMVccHt3Hm5RVGWPaaDgr3zdzIk=;
        b=vILF99z1MLlpP6cV0D9FJDCPuFlrge4B6aIB6UM+MMcTRdNOHTvZwW+6IuHbfSy/OU
         UsVHDqNRg2ni0W2iFICGxIhk7+D7WpBy9OwIACt9LQjlsEGP1WZ3o1H7FVaPOR/iy3mi
         aLUX83Rst7FHkgCNhHQixwZUbbkhJX1YakJcdPrQPgrSX8etVJgppNbMgXLoZ5RYDjS6
         5hS3yYbz2MPHKL1WYfH+xsK7iqQcHU5ifxMvzb6YXAce13upsU3lvFxCyLBwMqasVtAB
         r2CoHU+9BbCRHSWcemvNh/m/XkKMJotLpSQpTAG/NVzvBe2ltEhrzhjlJlP/JYjgjVDv
         dX1Q==
X-Gm-Message-State: AO0yUKUIOAJLI1IhfpF53sgqDxUVh8gnokAVwptIsOz4E/MuFOmAw4PK
        3KuzSwnPgb2O3AkPAwP+psKpoEIDFr8=
X-Google-Smtp-Source: AK7set8FGlwdXByY76mnuB7PfDUWwR1c2wuiw+/xTe0Q9McomCsx0ZMYDITf/RGV+urLbgcvInrCfJOxFBs=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a25:9702:0:b0:a36:3875:56be with SMTP id
 d2-20020a259702000000b00a36387556bemr20544264ybo.10.1678694029819; Mon, 13
 Mar 2023 00:53:49 -0700 (PDT)
Date:   Mon, 13 Mar 2023 07:53:25 +0000
In-Reply-To: <20230313075326.3594869-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230313075326.3594869-1-jaewan@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313075326.3594869-5-jaewan@google.com>
Subject: [PATCH v9 4/5] mac80211_hwsim: add PMSR abort support via virtio
From:   Jaewan Kim <jaewan@google.com>
To:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PMSR (a.k.a. peer measurement) is generalized measurement between two
devices with Wi-Fi support. And currently FTM (a.k.a. fine time
measurement or flight time measurement) is the one and only measurement.

Add necessary functionalities for mac80211_hwsim to abort previous PMSR
request. The abortion request is sent to the wmedium where the PMSR request
is actually handled.

In detail, add new mac80211_hwsim command HWSIM_CMD_ABORT_PMSR. When
mac80211_hwsim receives the PMSR abortion request via
ieee80211_ops.abort_pmsr, the received cfg80211_pmsr_request is resent to
the wmediumd with command HWSIM_CMD_ABORT_PMSR and attribute
HWSIM_ATTR_PMSR_REQUEST. The attribute is formatted as the same way as
nl80211_pmsr_start() expects.

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
V7 -> V8: Rewrote commit msg
V7: Initial commit (split from previously large patch)
---
 drivers/net/wireless/mac80211_hwsim.c | 61 +++++++++++++++++++++++++++
 drivers/net/wireless/mac80211_hwsim.h |  2 +
 2 files changed, 63 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index a692d9c95566..8f699dfab77a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3343,6 +3343,66 @@ static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
 	return err;
 }
 
+static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct cfg80211_pmsr_request *request)
+{
+	struct mac80211_hwsim_data *data = hw->priv;
+	u32 _portid = READ_ONCE(data->wmediumd);
+	struct sk_buff *skb = NULL;
+	int err = 0;
+	void *msg_head;
+	struct nlattr *pmsr;
+
+	if (!_portid && !hwsim_virtio_enabled)
+		return;
+
+	mutex_lock(&data->mutex);
+
+	if (data->pmsr_request != request) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	if (err)
+		return;
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb)
+		return;
+
+	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0, HWSIM_CMD_ABORT_PMSR);
+
+	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER, ETH_ALEN, data->addresses[1].addr))
+		goto out_err;
+
+	pmsr = nla_nest_start(skb, HWSIM_ATTR_PMSR_REQUEST);
+	if (!pmsr) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	err = mac80211_hwsim_send_pmsr_request(skb, request);
+	if (err)
+		goto out_err;
+
+	err = nla_nest_end(skb, pmsr);
+	if (err)
+		goto out_err;
+
+	genlmsg_end(skb, msg_head);
+	if (hwsim_virtio_enabled)
+		hwsim_tx_virtio(data, skb);
+	else
+		hwsim_unicast_netgroup(data, skb, _portid);
+
+out_err:
+	if (err && skb)
+		nlmsg_free(skb);
+
+	mutex_unlock(&data->mutex);
+}
+
 #define HWSIM_COMMON_OPS					\
 	.tx = mac80211_hwsim_tx,				\
 	.wake_tx_queue = ieee80211_handle_wake_tx_queue,	\
@@ -3367,6 +3427,7 @@ static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
 	.get_et_stats = mac80211_hwsim_get_et_stats,		\
 	.get_et_strings = mac80211_hwsim_get_et_strings,	\
 	.start_pmsr = mac80211_hwsim_start_pmsr,		\
+	.abort_pmsr = mac80211_hwsim_abort_pmsr,
 
 #define HWSIM_NON_MLO_OPS					\
 	.sta_add = mac80211_hwsim_sta_add,			\
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 98e586a56582..383f3e39c911 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -83,6 +83,7 @@ enum hwsim_tx_control_flags {
  *	are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
  * @HWSIM_CMD_START_PMSR: request to start peer measurement with the
  *	%HWSIM_ATTR_PMSR_REQUEST.
+ * @HWSIM_CMD_ABORT_PMSR: abort previously sent peer measurement
  * @__HWSIM_CMD_MAX: enum limit
  */
 enum {
@@ -96,6 +97,7 @@ enum {
 	HWSIM_CMD_ADD_MAC_ADDR,
 	HWSIM_CMD_DEL_MAC_ADDR,
 	HWSIM_CMD_START_PMSR,
+	HWSIM_CMD_ABORT_PMSR,
 	__HWSIM_CMD_MAX,
 };
 #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
-- 
2.40.0.rc1.284.g88254d51c5-goog

