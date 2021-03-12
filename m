Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0F8338F78
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhCLOJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhCLOIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 09:08:44 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F048C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:08:44 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id u4so8109854edv.9
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ea9f7FgwIcFHsrqakEU92ypI0wLo3hgAOgrnMz1Dm5o=;
        b=YophHEtJuM7Zrxx+yzDpfJC5uhVjqO3EWlVWXTkPAWZc5NkbvHURpYpSXbU+kiySEc
         J42nzeL3lEOfyCzUtO9a1/1UG3T7wSMt4Nb74eF2roqsUEY0BXTxRmo4w7GjurWhT098
         sOunM0voE0Hk41yTfOGNjKs0J9rEfIgDllHRlcXVta3pEaN8zZKZbIgc5Dma50KSi9CM
         Xsw6tbEjmSuYBaRJGV34U9CyJN41u3yGObgyIj14IIIZ4H/b7fN9DeVgg3uOz1s49Bie
         8V8KgMJPqbXsmCFIfou5udDrwP/mpu0tDGAfj47J+CDaKQD/6PuN3kL9IeDcRmdaUGtR
         l/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ea9f7FgwIcFHsrqakEU92ypI0wLo3hgAOgrnMz1Dm5o=;
        b=FbP2kjK6+R1cE6mIw/Evj6gQV1RXMWA8wag5/jJxQqYCKZPQMbZq10WIDiSlWbNoqb
         mp/mN2m8yfT6rstXrpWo41WItovVpbE/qF6MO3YXSPsrlkBnUcc6dwZGHxGzkGaresM/
         STpuK3grpRoySDSd+RfJHtRi4vZ0upUenbSbtdt/uIMls3SrNZxSapVD7D8oI49rhkbW
         THcmUhIpo5+MAuNVNI/o2CcezGKr8cie3dUwiygssxycGmU34KvBSSaJruAG65tgwMiF
         pOgBKZHmSntibDlwDr6k+/E6vHWIJkEMciaBNA7zcS8swIfjVS+2y1bvbqvofVd09Ggf
         mT4Q==
X-Gm-Message-State: AOAM530y1koaGwfEFQua5/RXLa+B6aQGYdR1itqmKibeyFqj4YB1QSmJ
        giHWIyaCvxEx+JmHVrzPdBKzYQ==
X-Google-Smtp-Source: ABdhPJw11ZdMWJIW9Y/wxu4OBPo2NLmcMcWIsHXDptb2CpgWU5THScQZIa79JtrqpB1oGFmj52Ub/A==
X-Received: by 2002:a05:6402:1649:: with SMTP id s9mr14305754edx.177.1615558123279;
        Fri, 12 Mar 2021 06:08:43 -0800 (PST)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id s11sm3031673edt.27.2021.03.12.06.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 06:08:42 -0800 (PST)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Xingfeng Hu <xingfeng.hu@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH v3 net-next 1/3] flow_offload: add support for packet-per-second policing
Date:   Fri, 12 Mar 2021 15:08:29 +0100
Message-Id: <20210312140831.23346-2-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210312140831.23346-1-simon.horman@netronome.com>
References: <20210312140831.23346-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xingfeng Hu <xingfeng.hu@corigine.com>

Allow flow_offload API to configure packet-per-second policing using rate
and burst parameters.

Dummy implementations of tcf_police_rate_pkt_ps() and
tcf_police_burst_pkt() are supplied which return 0, the unconfigured state.
This is to facilitate splitting the offload, driver, and TC code portion of
this feature into separate patches with the aim of providing a logical flow
for review. And the implementation of these helpers will be filled out by a
follow-up patch.

Signed-off-by: Xingfeng Hu <xingfeng.hu@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
---
 include/net/flow_offload.h     |  2 ++
 include/net/tc_act/tc_police.h | 12 ++++++++++++
 net/sched/cls_api.c            |  3 +++
 3 files changed, 17 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index e6bd8ebf9ac3..fde025c57b4f 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -234,6 +234,8 @@ struct flow_action_entry {
 			u32			index;
 			u32			burst;
 			u64			rate_bytes_ps;
+			u64			burst_pkt;
+			u64			rate_pkt_ps;
 			u32			mtu;
 		} police;
 		struct {				/* FLOW_ACTION_CT */
diff --git a/include/net/tc_act/tc_police.h b/include/net/tc_act/tc_police.h
index 6d1e26b709b5..ae117f7937d5 100644
--- a/include/net/tc_act/tc_police.h
+++ b/include/net/tc_act/tc_police.h
@@ -97,6 +97,18 @@ static inline u32 tcf_police_burst(const struct tc_action *act)
 	return burst;
 }
 
+static inline u64 tcf_police_rate_pkt_ps(const struct tc_action *act)
+{
+	/* Not implemented */
+	return 0;
+}
+
+static inline u32 tcf_police_burst_pkt(const struct tc_action *act)
+{
+	/* Not implemented */
+	return 0;
+}
+
 static inline u32 tcf_police_tcfp_mtu(const struct tc_action *act)
 {
 	struct tcf_police *police = to_police(act);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index e37556cc37ab..ca8e177bf31b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3661,6 +3661,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			entry->police.burst = tcf_police_burst(act);
 			entry->police.rate_bytes_ps =
 				tcf_police_rate_bytes_ps(act);
+			entry->police.burst_pkt = tcf_police_burst_pkt(act);
+			entry->police.rate_pkt_ps =
+				tcf_police_rate_pkt_ps(act);
 			entry->police.mtu = tcf_police_tcfp_mtu(act);
 			entry->police.index = act->tcfa_index;
 		} else if (is_tcf_ct(act)) {
-- 
2.20.1

