Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D4F6C4B8C
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjCVNTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbjCVNT2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:19:28 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FFB5FEAC
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:27 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-541a39df9f4so188808797b3.20
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679491167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mvNz0PRN3QACJ8KM//mk9E2O/etnxfFimmzN+LqeHfQ=;
        b=DOt6uX9FEAPCYrXsae5wJo++rIMuNgrEu27olaM2FodLwSOPHTUI+EvLNZDN0jbGHb
         uRf7i+3SUCKkP/auBj9DG9o7qf4D8zbegc5fObSxPrB438+iWjuPIuMW0QMSFkZI2874
         lvaRudj6bY8P41Q7UW96LneLaoAV3n8HZILMLEbDYPNGO4ANCBGglOIsW3vAbXGpmDFc
         Yma1jlqBwDvhEb2RrFb4HMguwOJkp7VaJ8iHLaDuaVqWOR/P5qxusuOymqfiYUvT1Wuy
         ZzvcZzaPMfrzN5avsiYNUbQ29CWevRGEOBsZouLcKvMBdCP7z5aFqakeD5VBC2rruqmQ
         xpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679491167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mvNz0PRN3QACJ8KM//mk9E2O/etnxfFimmzN+LqeHfQ=;
        b=EQSvmMyIHRoigcpbNaQP7jhOUfEkCqNzrQw1bacOhn1pCtXmlBk+3hwhV69Il3eg32
         Ch+EjMXtHoIqLfyDOR5Zt48lGmSTh95M+tlDwvOw+w+Pls22q6dKEtzcXbXsQgOXdKQA
         vmA7m2RWXmXfk+T6CiZKvMRcDiigu7T4c98g3XqIQjLDDvPRV4gDTx8kR9SsMElYsu4K
         nlzG124CRHCBkiWoLhL0Tgz1tDALHRSDOO80m5wvF3+eEjNmEypGFKciiFHBcDst7XvL
         Z4OpMY7VSIU18eiocuBFVkR7uFzL3R0w0Bq1cewHKD4Wol7PKYLle6KOJzMPj+QQCjbS
         CcHw==
X-Gm-Message-State: AAQBX9c6VlK2jjmB4EZyThV5QpN+FQmU6fijAanC/M0JGlD83PAo7JtN
        ZmFDktfG1Viff+/LvHDe33cWqsOI0ZE=
X-Google-Smtp-Source: AKy350a01zyTDZu/tUEi1E7sbg9vzYAnIfJ1Lq2eQnYAKnV2c4/OztvcyqKlfSXeXbdD8xg7EUwMHtU0PUk=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a25:8c89:0:b0:b6c:2d28:b3e7 with SMTP id
 m9-20020a258c89000000b00b6c2d28b3e7mr3663062ybl.9.1679491167315; Wed, 22 Mar
 2023 06:19:27 -0700 (PDT)
Date:   Wed, 22 Mar 2023 13:16:36 +0000
In-Reply-To: <20230322131637.2633968-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230322131637.2633968-1-jaewan@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230322131637.2633968-5-jaewan@google.com>
Subject: [PATCH v10 4/5] mac80211_hwsim: add PMSR abort support via virtio
From:   Jaewan Kim <jaewan@google.com>
To:     michal.kubiak@intel.com, gregkh@linuxfoundation.org,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
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
V8 -> V10: Applied reverse xmas tree style (a.k.a. RCS).
           Fixed returning without mutex_unlock().
V7 -> V8: Rewrote commit msg
V7: Initial commit (split from previously large patch)
---
 drivers/net/wireless/mac80211_hwsim.c | 62 +++++++++++++++++++++++++++
 drivers/net/wireless/mac80211_hwsim.h |  2 +
 2 files changed, 64 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 84f47b532d4b..91696642264f 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3346,6 +3346,67 @@ static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
 	return err;
 }
 
+static void mac80211_hwsim_abort_pmsr(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct cfg80211_pmsr_request *request)
+{
+	struct mac80211_hwsim_data *data;
+	struct sk_buff *skb = NULL;
+	struct nlattr *pmsr;
+	void *msg_head;
+	u32 _portid;
+	int err = 0;
+
+	data = hw->priv;
+	_portid = READ_ONCE(data->wmediumd);
+	if (!_portid && !hwsim_virtio_enabled)
+		return;
+
+	mutex_lock(&data->mutex);
+
+	if (data->pmsr_request != request) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	skb = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!skb) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0, HWSIM_CMD_ABORT_PMSR);
+
+	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER, ETH_ALEN, data->addresses[1].addr))
+		goto out;
+
+	pmsr = nla_nest_start(skb, HWSIM_ATTR_PMSR_REQUEST);
+	if (!pmsr) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = mac80211_hwsim_send_pmsr_request(skb, request);
+	if (err)
+		goto out;
+
+	err = nla_nest_end(skb, pmsr);
+	if (err)
+		goto out;
+
+	genlmsg_end(skb, msg_head);
+	if (hwsim_virtio_enabled)
+		hwsim_tx_virtio(data, skb);
+	else
+		hwsim_unicast_netgroup(data, skb, _portid);
+
+out:
+	if (err && skb)
+		nlmsg_free(skb);
+
+	mutex_unlock(&data->mutex);
+}
+
 #define HWSIM_COMMON_OPS					\
 	.tx = mac80211_hwsim_tx,				\
 	.wake_tx_queue = ieee80211_handle_wake_tx_queue,	\
@@ -3370,6 +3431,7 @@ static int mac80211_hwsim_start_pmsr(struct ieee80211_hw *hw,
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

