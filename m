Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8483D7E34
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 21:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbhG0TAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 15:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbhG0TAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 15:00:44 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6233C061764
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 12:00:43 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id u25so519952oiv.5
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 12:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fYGKLH2SgAMa80yTiG4bFU3GsKrGRgA34J7Dev7x+rU=;
        b=xL62K6dOLLMIwoHIp2G0bPmyrqI+lDkDfv3po0DiDXcxRBxfSuUC8lDq6X9VsJeCF9
         QuEXb76Vr2ZG0D3mdtxDF2Eyt+egoqaB4mxP3DsFen5lP+TZ5MGkULtTM4QBa8Kdb3zE
         AcFdjBpFb/ZhWl49yo9eUXp4O/evaiqSx3jCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fYGKLH2SgAMa80yTiG4bFU3GsKrGRgA34J7Dev7x+rU=;
        b=Hl1gAjtHbepBGWITjRW5W5MS3xqNFdTEqb7KuheTjlPR4TeRaWpYYu3eNjxacYMyM9
         jbffmtyKhy9yNAMG78tyCc8zrEWzKY1ZQV4D/Btp7XeflZHOZuvj3QHsKS86Wre3yfaT
         QhlOL0xz3jERx91Q135K56iT8aTxxQjGI4SniuDYNLvAUHUHTAfYQmmDKi8Ng9eX6JST
         u+ElZnmpyUFAdVYY3OzyMHBdDVdMqRabwMKvSA3s6s2sCKCdZe38YOlSsCKjuuaV5RWR
         7WU3tCBSFMENhxutQNiZbjeO6/3Eyuj4R8YwQDGTsswP34TglJRpgjXjS4E/eZEM0HSI
         wBAw==
X-Gm-Message-State: AOAM532DSImc8LxayU0vRuU5WLjxo28ybOrl88ChDHQM4GMd7yflMtv9
        p5ljZRw+YSM0+hHocPzaZAfuBw==
X-Google-Smtp-Source: ABdhPJxqdOOz+tMCEb/1DbeyMqlSCbF3DyI1dSE0BciIltK+55JRRLTNF7EIpB2R64w+UZNzw9tVeA==
X-Received: by 2002:aca:accf:: with SMTP id v198mr15948296oie.14.1627412441833;
        Tue, 27 Jul 2021 12:00:41 -0700 (PDT)
Received: from localhost.localdomain (65-36-81-87.static.grandenetworks.net. [65.36.81.87])
        by smtp.gmail.com with ESMTPSA id i10sm248897ood.48.2021.07.27.12.00.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 12:00:41 -0700 (PDT)
From:   Kyle Bowman <kbowman@cloudflare.com>
Cc:     kernel-team@cloudflare.com, Alex Forster <aforster@cloudflare.com>,
        Kyle Bowman <kbowman@cloudflare.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] netfilter: xt_NFLOG: allow 128 character log prefixes
Date:   Tue, 27 Jul 2021 14:00:00 -0500
Message-Id: <20210727190001.914-1-kbowman@cloudflare.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Forster <aforster@cloudflare.com>

nftables defines NF_LOG_PREFIXLEN as 128 characters, while iptables
limits the NFLOG prefix to 64 characters. In order to eventually make
the two consistent, introduce a v1 target revision of xt_NFLOG that
allows userspace to provide a 128 character NFLOG prefix.

Signed-off-by: Alex Forster <aforster@cloudflare.com>
Signed-off-by: Kyle Bowman <kbowman@cloudflare.com>
---
 include/uapi/linux/netfilter/xt_NFLOG.h | 11 ++++
 net/netfilter/xt_NFLOG.c                | 73 +++++++++++++++++++++----
 2 files changed, 73 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_NFLOG.h b/include/uapi/linux/netfilter/xt_NFLOG.h
index 517809771909..3f1119a2e522 100644
--- a/include/uapi/linux/netfilter/xt_NFLOG.h
+++ b/include/uapi/linux/netfilter/xt_NFLOG.h
@@ -3,6 +3,7 @@
 #define _XT_NFLOG_TARGET

 #include <linux/types.h>
+#include <linux/netfilter/nf_log.h>

 #define XT_NFLOG_DEFAULT_GROUP		0x1
 #define XT_NFLOG_DEFAULT_THRESHOLD	0
@@ -22,4 +23,14 @@ struct xt_nflog_info {
 	char		prefix[64];
 };

+struct xt_nflog_info_v1 {
+	/* 'len' will be used iff you set XT_NFLOG_F_COPY_LEN in flags */
+	__u32	len;
+	__u16	group;
+	__u16	threshold;
+	__u16	flags;
+	__u16	pad;
+	char	prefix[NF_LOG_PREFIXLEN];
+};
+
 #endif /* _XT_NFLOG_TARGET */
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index fb5793208059..82279a6be0ff 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -39,6 +39,28 @@ nflog_tg(struct sk_buff *skb, const struct xt_action_param *par)
 	return XT_CONTINUE;
 }

+static unsigned int
+nflog_tg_v1(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_nflog_info_v1 *info = par->targinfo;
+	struct net *net = xt_net(par);
+	struct nf_loginfo li;
+
+	li.type		     = NF_LOG_TYPE_ULOG;
+	li.u.ulog.copy_len   = info->len;
+	li.u.ulog.group	     = info->group;
+	li.u.ulog.qthreshold = info->threshold;
+	li.u.ulog.flags	     = 0;
+
+	if (info->flags & XT_NFLOG_F_COPY_LEN)
+		li.u.ulog.flags |= NF_LOG_F_COPY_LEN;
+
+	nf_log_packet(net, xt_family(par), xt_hooknum(par), skb, xt_in(par),
+		      xt_out(par), &li, "%s", info->prefix);
+
+	return XT_CONTINUE;
+}
+
 static int nflog_tg_check(const struct xt_tgchk_param *par)
 {
 	const struct xt_nflog_info *info = par->targinfo;
@@ -51,30 +73,59 @@ static int nflog_tg_check(const struct xt_tgchk_param *par)
 	return nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
 }

+static int nflog_tg_check_v1(const struct xt_tgchk_param *par)
+{
+	const struct xt_nflog_info_v1 *info = par->targinfo;
+
+	if (info->flags & ~XT_NFLOG_MASK)
+		return -EINVAL;
+	if (info->prefix[sizeof(info->prefix) - 1] != '\0')
+		return -EINVAL;
+
+	return nf_logger_find_get(par->family, NF_LOG_TYPE_ULOG);
+}
+
 static void nflog_tg_destroy(const struct xt_tgdtor_param *par)
 {
 	nf_logger_put(par->family, NF_LOG_TYPE_ULOG);
 }

-static struct xt_target nflog_tg_reg __read_mostly = {
-	.name       = "NFLOG",
-	.revision   = 0,
-	.family     = NFPROTO_UNSPEC,
-	.checkentry = nflog_tg_check,
-	.destroy    = nflog_tg_destroy,
-	.target     = nflog_tg,
-	.targetsize = sizeof(struct xt_nflog_info),
-	.me         = THIS_MODULE,
+static void nflog_tg_destroy_v1(const struct xt_tgdtor_param *par)
+{
+	nf_logger_put(par->family, NF_LOG_TYPE_ULOG);
+}
+
+static struct xt_target nflog_tg_reg[] __read_mostly = {
+	{
+		.name       = "NFLOG",
+		.revision   = 0,
+		.family     = NFPROTO_UNSPEC,
+		.checkentry = nflog_tg_check,
+		.destroy    = nflog_tg_destroy,
+		.target     = nflog_tg,
+		.targetsize = sizeof(struct xt_nflog_info),
+		.me         = THIS_MODULE,
+	},
+	{
+		.name       = "NFLOG",
+		.revision   = 1,
+		.family     = NFPROTO_UNSPEC,
+		.checkentry = nflog_tg_check_v1,
+		.destroy    = nflog_tg_destroy_v1,
+		.target     = nflog_tg_v1,
+		.targetsize = sizeof(struct xt_nflog_info_v1),
+		.me         = THIS_MODULE,
+	}
 };

 static int __init nflog_tg_init(void)
 {
-	return xt_register_target(&nflog_tg_reg);
+	return xt_register_targets(nflog_tg_reg, ARRAY_SIZE(nflog_tg_reg));
 }

 static void __exit nflog_tg_exit(void)
 {
-	xt_unregister_target(&nflog_tg_reg);
+	xt_unregister_targets(nflog_tg_reg, ARRAY_SIZE(nflog_tg_reg));
 }

 module_init(nflog_tg_init);
--
2.32.0
