Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F7F46CBA0
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243962AbhLHDoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239374AbhLHDoX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:44:23 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0085CC061574;
        Tue,  7 Dec 2021 19:40:51 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id c4so1613510wrd.9;
        Tue, 07 Dec 2021 19:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bfWNG6AUHWduRJJMGlIKEuVIPsb4YdE6wPwV4l3X+pA=;
        b=ZPwko4342BMcTzmXZWf66O25QugNc4tpDcN/zEQ/9/60Es8AMexawSn1WBxDuWA87K
         Xd4+uu3Ti5GsCIDv/71qJksqIOZNEV4NdMqKm5v3oiLtZPmbn1WkAtMSAnYN9y22SYzH
         WlJi1jUkaKVf/qcwg9tCE7d++V3K2H0Z+g53IzDKFZqBcrh4AaycbYPw49nwRyiyYOjm
         hCazGJHe6xfJu9EmwqTvJK/9szgKueA84jMpNddQdUw1hBP09b6YCNi8wGhT70l9aRjf
         08MyqsWOUH7/fkQ8a5Z+d5SUrzN2jlfOSaonkHD6502NEwPYUtoGaGwJCWL8q5fnxjto
         crVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bfWNG6AUHWduRJJMGlIKEuVIPsb4YdE6wPwV4l3X+pA=;
        b=Vn3RwQY30R6lPtY5Uog/9xCEWfUfoRaFQ9nZL03gmUCJA8oZJcOyLSE18MyoREEfUd
         lHFNZDF+4smwT8YbBpSSyuGbkbTxIaArxQmP26/y8hmZSYN9utqlEVlXtmVvGcstta2S
         pG0NrDOGK1RoCOJXV+jKRKSSYdt4K4+ySzYMTqjtZInT/munSNqrwnSckBgQyUH2Mtsn
         wPYQYQntE+xfhhNj9K6YZxmroBHl4qSWE5z3OdIur280bZgMYxcTDTxmwhfRX1EIFvMO
         mMLbaMAvuvKUW6wlOIOvuz1J9FUAL2mTx6NjOvavz9WfzJn92KEIG4tLqBEmWHfKvJMW
         661w==
X-Gm-Message-State: AOAM533Z9IojFv7zlrelvP9lVK2AiH5WJqwob+uz+xPOfJ9uA7MICDzB
        JGLc4/abQqF1Z8ECTJZu4R1aawJsJiA=
X-Google-Smtp-Source: ABdhPJzpEm6GFcLrCtiJ1r6X/5YHRHs2ZxATdB0wBzPYT+nXthAEH6vhSpaOFeJpkxcydDCcYUwDHg==
X-Received: by 2002:a05:6000:1aca:: with SMTP id i10mr56525321wry.407.1638934850391;
        Tue, 07 Dec 2021 19:40:50 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v6sm4488944wmh.8.2021.12.07.19.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 19:40:50 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v2 1/8] net: das: Introduce support for tagger private data control
Date:   Wed,  8 Dec 2021 04:40:33 +0100
Message-Id: <20211208034040.14457-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211208034040.14457-1-ansuelsmth@gmail.com>
References: <20211208034040.14457-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce 2 new function for the tagger ops to permit the tagger to
allocate private data. This is useful for case where the tagger receive
some data that should be by the switch driver or require some special
handling for some special packet (example Ethernet mdio packet)

The tagger will use the dsa port priv to store his priv data.

connect() is used to allocate the private data. It's the tagger choice
how to allocate the data to the different ports.
disconnect() will free the priv data in the dsa port.

On switch setup the connect() ops is called.
On tagger change the disconnect() is called, the tagger will free the
priv data in dsa port and a connect() is called to allocate the new priv
data (if the new tagger requires it)

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/net/dsa.h |  3 +++
 net/dsa/dsa2.c    | 26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8ca9d50cbbc2..33391d74be5c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -82,8 +82,11 @@ enum dsa_tag_protocol {
 };
 
 struct dsa_switch;
+struct dsa_switch_tree;
 
 struct dsa_device_ops {
+	int (*connect)(struct dsa_switch_tree *dst);
+	void (*disconnect)(struct dsa_switch_tree *dst);
 	struct sk_buff *(*xmit)(struct sk_buff *skb, struct net_device *dev);
 	struct sk_buff *(*rcv)(struct sk_buff *skb, struct net_device *dev);
 	void (*flow_dissect)(const struct sk_buff *skb, __be16 *proto,
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 826957b6442b..15566c5ae8ae 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1043,6 +1043,20 @@ static void dsa_tree_teardown_lags(struct dsa_switch_tree *dst)
 	kfree(dst->lags);
 }
 
+static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst)
+{
+	const struct dsa_device_ops *tag_ops = dst->tag_ops;
+	int err;
+
+	if (tag_ops->connect) {
+		err = tag_ops->connect(dst);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int dsa_tree_setup(struct dsa_switch_tree *dst)
 {
 	bool complete;
@@ -1066,6 +1080,10 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 	if (err)
 		goto teardown_cpu_ports;
 
+	err = dsa_tree_bind_tag_proto(dst);
+	if (err)
+		goto teardown_switches;
+
 	err = dsa_tree_setup_master(dst);
 	if (err)
 		goto teardown_switches;
@@ -1155,13 +1173,21 @@ int dsa_tree_change_tag_proto(struct dsa_switch_tree *dst,
 	if (err)
 		goto out_unwind_tagger;
 
+	if (dst->tag_ops->disconnect)
+		dst->tag_ops->disconnect(dst);
+
 	dst->tag_ops = tag_ops;
 
+	err = dsa_tree_bind_tag_proto(dst);
+	if (err)
+		goto out_unwind_tagger;
+
 	rtnl_unlock();
 
 	return 0;
 
 out_unwind_tagger:
+	dst->tag_ops = old_tag_ops;
 	info.tag_ops = old_tag_ops;
 	dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO, &info);
 out_unlock:
-- 
2.32.0

