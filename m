Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07DFE68D1D2
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 09:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjBGIyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 03:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbjBGIyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 03:54:23 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298571CAF7
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 00:54:22 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id s8-20020a25aa08000000b0088fdf6f199aso5763152ybi.9
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 00:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Af5se+Ji/yeKhTyDIHlIiCpAHk2SwNYY0+NfyiAWsDU=;
        b=p9ocZvuxDLSBqA5xDcgKUSzZxfZ0BfWCD1FL9oLOBQVz2EebSs9xGH6ZZe5hY9doNm
         iOmuJN1pv7aWeqZMwxyHhtnvnr0MGOws7Dcy2PiSeZV/wKrHhox7pH67YHVyAom+4SRV
         /V+n1XszgmQvX+8xX+7FDNiCy1qDMgb7pRUwOZBw0gKrsUUL/ut8PesDMXxp+/bgP6SZ
         8bpElpVoPHuK99em3tfLfH89lI8D64S13EE3BCh9rHsdNU42LN8qPW7RTs8eRJhjLVNM
         SBPtjYblp3lK47s2ojmZQmIMu/U0F3NtG27DTq3zHjUwcgisu2qgzGbq7ePg98NZt1IB
         4FcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Af5se+Ji/yeKhTyDIHlIiCpAHk2SwNYY0+NfyiAWsDU=;
        b=q89mQJGFCn9Bsqzn8xYP4aI9FXRG2ZrbskLxeS+1ovna3kZsv4/9T6k+9614mCToH1
         Tv3oTMDlRDWmUv+RDk1/L3nHfo56/5iLLrUkoBt+77PQNyzK/CQHzaiSCguKLgkt+vaz
         jIvFMpEKaAmZw2iWZPK95fTkP25rHVR5xAUOuIhU6G1tSNHrhojWVtYuDnRRhZpR5JBA
         tYIPx2ZSmtyOBGSvSR1il23mzWI6uDKh3xmr6NGnkY8UxchGmOfJZqlwH+u8T2AWmqhy
         J6iztUlYmlEQvJVFuYm6inEKaELenCHCmfisxOpSaTnwaKALHvFjXdI5lihZwNqhJKYo
         1ScA==
X-Gm-Message-State: AO0yUKVh9K8AkddF/j2CAGkc0rjdi3oRe2Z+rS7DUa8pVve02H32Yhi9
        iZPnaE3Sb+p8RvwHhAdqqupcarVyy/s=
X-Google-Smtp-Source: AK7set+thSB/PCW3cB265ivevXzJwAT9ghG1JEQ9fi1NN/p+0E4gq+3fyXwgdB5MN4wpjTW+0o/Jc1UKYiU=
X-Received: from jaewan1.c.googlers.com ([fda3:e722:ac3:cc00:3:22c1:c0a8:e59])
 (user=jaewan job=sendgmr) by 2002:a5b:a08:0:b0:80b:4f92:1623 with SMTP id
 k8-20020a5b0a08000000b0080b4f921623mr329400ybq.370.1675760061488; Tue, 07 Feb
 2023 00:54:21 -0800 (PST)
Date:   Tue,  7 Feb 2023 08:53:59 +0000
In-Reply-To: <20230207085400.2232544-1-jaewan@google.com>
Mime-Version: 1.0
References: <20230207085400.2232544-1-jaewan@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230207085400.2232544-4-jaewan@google.com>
Subject: [PATCH v7 3/4] mac80211_hwsim: add PMSR abort support via virtio
From:   Jaewan Kim <jaewan@google.com>
To:     gregkh@linuxfoundation.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com,
        Jaewan Kim <jaewan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

This change allows mac80211_hwsim to abort previous PMSR request. The
abortion request is sent to the wmedium where the PMSR request is
actually handled.

This change adds HWSIM_CMD_ABORT_PMSR. When mac80211_hwsim receives the
PMSR abortion request via ieee80211_ops.abort_pmsr, the received
cfg80211_pmsr_request is resent to the wmediumd with command
HWSIM_CMD_ABORT_PMSR and attribute HWSIM_ATTR_PMSR_REQUEST. The
attribute is formatted as the same way as nl80211_pmsr_start() expects.

Signed-off-by: Jaewan Kim <jaewan@google.com>
---
V1: Initial commit (split from previously large patch)
---
 drivers/net/wireless/mac80211_hwsim.c | 61 +++++++++++++++++++++++++++
 drivers/net/wireless/mac80211_hwsim.h |  2 +
 2 files changed, 63 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 331772ff5d45..874c768e73e7 100644
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
index 4af237cef904..39911cc9533d 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -82,6 +82,7 @@ enum hwsim_tx_control_flags {
  * @HWSIM_CMD_DEL_MAC_ADDR: remove the MAC address again, the attributes
  *	are the same as to @HWSIM_CMD_ADD_MAC_ADDR.
  * @HWSIM_CMD_START_PMSR: start PMSR
+ * @HWSIM_CMD_ABORT_PMSR: abort PMSR
  * @__HWSIM_CMD_MAX: enum limit
  */
 enum {
@@ -95,6 +96,7 @@ enum {
 	HWSIM_CMD_ADD_MAC_ADDR,
 	HWSIM_CMD_DEL_MAC_ADDR,
 	HWSIM_CMD_START_PMSR,
+	HWSIM_CMD_ABORT_PMSR,
 	__HWSIM_CMD_MAX,
 };
 #define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
-- 
2.39.1.519.gcb327c4b5f-goog

