Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645EF6A85CB
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 17:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjCBQDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 11:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjCBQDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 11:03:37 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119F023DA8
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 08:03:35 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536a4eba107so319568067b3.19
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 08:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677773014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vLoDLuc62NhKk4/mKSLF7jhQKGozjf+HOSoQc+6IDzU=;
        b=TrheORYCMREjzOi2u5PwHTnUn2UXlkZ+yA+/asKzVte9SwkC27YYX6uqmPBabFgvIB
         vPWdEVSKTGsszBIfSbEQWVsoOoJ4zfunwBhIOSRg9FbZ3KHdQEz7I/0coTX/Nb487Qui
         1KOZpYaSN5FvyljV6IW1Lf1bNbvEUi3/i9j4maMkMDRWKrPXyp6s46YDNdv+cJvfghfb
         lvvG60jYNbRU4hgOMP4u0uGwlVFcwsQVdRU9LaOzgqMbkYKy7Y70dJHsULnkufd54vwC
         C4wP+JuTKwzv5kIhZR5ZEtWxccW8368v0624lSMe/iermiSLvnCELINfJLRiru9w5BzR
         lBXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677773014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vLoDLuc62NhKk4/mKSLF7jhQKGozjf+HOSoQc+6IDzU=;
        b=sitOf6nUCsDnh9SRGQaD4IKaoLLv925AkB3ORF5FNOTORqMIv2/f+juyUVFzfJveHM
         b8sHxWR7N6+5DStf56VPR+ZVnhJPko4e1lMN71dW4/D5TJDReCLj4EvTtl5KafPdXgNp
         /5bDrHSStbkqMxYULSGw9rZUKV48Hx76u14JWBYtEGiLRYKRfPVZApGX1hMzQLxKV+az
         qNAaSCiUmK2K8+ycHX4rLXMOx4/jySjwdR61W+qdwOoNa7zPCLISx/GjhOVCbDzH4vMn
         CefKSDqWqbgGgbhjYHTO6GxNiYg4R95F6xYZXR5pm6UGQ3Sm5xdh4HW5ux7U6aFFWkL4
         EUgg==
X-Gm-Message-State: AO0yUKWBfc+6RzoRFkijrm/doKTqaPBzCD80zWLQDsfO9EeTK9ITu6mu
        4KcUq3+SOKSUqAXmFQVaP8cAO1vA8xE=
X-Google-Smtp-Source: AK7set8jMzUNvdps3utzYeykDEewPoBgaVPu3+NyW4dnW68IGpDMZVv/mtdAVb4/kiSWI8T4wiOlCAZ6rc0=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a05:6902:4b:b0:a09:314f:a3ef with SMTP id
 m11-20020a056902004b00b00a09314fa3efmr5719502ybh.12.1677773014299; Thu, 02
 Mar 2023 08:03:34 -0800 (PST)
Date:   Thu,  2 Mar 2023 16:03:09 +0000
In-Reply-To: <20230302160310.923349-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230302160310.923349-1-jaewan@google.com>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
Message-ID: <20230302160310.923349-5-jaewan@google.com>
Subject: [PATCH v8 4/5] mac80211_hwsim: add PMSR abort support via virtio
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
V7->V8: Rewrote commit msg
V7: Initial commit (split from previously large patch)
---
 drivers/net/wireless/mac80211_hwsim.c | 61 +++++++++++++++++++++++++++
 drivers/net/wireless/mac80211_hwsim.h |  2 +
 2 files changed, 63 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 691b83140d57..0d92a7e51057 100644
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
2.39.2.722.g9855ee24e9-goog

