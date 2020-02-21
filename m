Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB84167A05
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgBUJ5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:57:03 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40091 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728508AbgBUJ5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:57:01 -0500
Received: by mail-wr1-f66.google.com with SMTP id t3so1256704wru.7
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x9ugDelf9ILezj4JchLRArpERPDI7+E1OFzbng22fkY=;
        b=Kg4ZTzJiwR9desqPCE7SDj2dgzkgxOwYEeLRDIiL/7tSrpr+fjzK3i/xDVXmBPYTuU
         Pnm9iER317lQljwnoJhMXXo0rjwW8XTX+9n0srAPfRw3pwzcbO6KKIXUM5FId0NCVSPr
         Ji0TUuagpzmCO6qo6pfY3IfBLxuHPAXCeEJaYa3R5/j3eeKRjLVfAhv6rglYJUOd8Qdw
         v3ViE3N1bxZQu8by5gWoLfC2laRygER5++Y0gW3ZxWx0VwAV9GOF6X/pcK4zgksxYNuv
         2XbnwrAM5YKPdpJ4+S/FUwfdUk7XU4tJ6Fresp6scgP1UKIyBkTIeE727Kvl6LP+UfRb
         DoNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x9ugDelf9ILezj4JchLRArpERPDI7+E1OFzbng22fkY=;
        b=EOMMXbYCmdkJpjSxqV0+mppPuzXK9m9hgf7uuFAPlag/n2JiHPzDlzjvy5QoDMwEO7
         lItz9hae/2vNIqoRjr3hj8uMMGrGLUFDQHFwXQQbqiFEUaVNUdYwuJBEgprqUs94fJfV
         DqT/X8jI8HCAZz5q9OKJhuZJ9oflG39m3s1/lOfVB7yyz+4AeAEFQlUlUNuwVIHWSRqY
         gz7Zhg7UELBILiWhI5RSBvuGWrrplkAgxDv98ilTLcsjFP7aBEmLgMAVGjFjqzSo8UUN
         6Yb24RgmAqWyr6Kc+4e7Z4QbAeH3kWKLDsVnaHrdPaTn65KLt7KDw4/ZN4whey89KsZ/
         5zjw==
X-Gm-Message-State: APjAAAUH6CR3A6vjIXYlRyuOKC89l++30LFSn0bY6D90iAZDViK8+kND
        /Mhx8KNtI7RJP6/CiF1jb7gUUxnp0a4=
X-Google-Smtp-Source: APXvYqwm84AMfCdSlajedk00wroBSL8RPy085EQa2b195GxkNzncO05B7oXVBuKilic8DecCV+Mp8Q==
X-Received: by 2002:a5d:5452:: with SMTP id w18mr45504582wrv.333.1582279017361;
        Fri, 21 Feb 2020 01:56:57 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id s1sm3190325wro.66.2020.02.21.01.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:56:56 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: [patch net-next 10/10] sched: cls_flower: allow user to specify type of HW stats for a filter
Date:   Fri, 21 Feb 2020 10:56:43 +0100
Message-Id: <20200221095643.6642-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200221095643.6642-1-jiri@resnulli.us>
References: <20200221095643.6642-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Currently, user who is adding a filter expects HW report stats, however
it does not have exact expectations about the stats types. That is
aligned with TCA_CLS_HW_STATS_TYPE_ANY.

Allow user to specify type of HW stats for a filter and require a type.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/pkt_cls.h        | 28 ++++++++++++++++++++++++++++
 include/uapi/linux/pkt_cls.h | 27 +++++++++++++++++++++++++++
 net/sched/cls_flower.c       | 12 ++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index d3d90f714a66..18044ea7c246 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -631,6 +631,34 @@ static inline bool tc_in_hw(u32 flags)
 	return (flags & TCA_CLS_FLAGS_IN_HW) ? true : false;
 }
 
+static inline enum tca_cls_hw_stats_type
+tc_hw_stats_type_get(struct nlattr *hw_stats_type_attr)
+{
+	/* If the user did not pass the attr, that means he does
+	 * not care about the type. Return "any" in that case.
+	 */
+	return hw_stats_type_attr ? nla_get_u8(hw_stats_type_attr) :
+				    TCA_CLS_HW_STATS_TYPE_ANY;
+}
+
+static inline enum flow_cls_hw_stats_type
+tc_flow_cls_hw_stats_type(enum tca_cls_hw_stats_type hw_stats_type)
+{
+	switch (hw_stats_type) {
+	default:
+		WARN_ON(1);
+		/* fall-through */
+	case TCA_CLS_HW_STATS_TYPE_ANY:
+		return FLOW_CLS_HW_STATS_TYPE_ANY;
+	case TCA_CLS_HW_STATS_TYPE_IMMEDIATE:
+		return FLOW_CLS_HW_STATS_TYPE_IMMEDIATE;
+	case TCA_CLS_HW_STATS_TYPE_DELAYED:
+		return FLOW_CLS_HW_STATS_TYPE_DELAYED;
+	case TCA_CLS_HW_STATS_TYPE_DISABLED:
+		return FLOW_CLS_HW_STATS_TYPE_DISABLED;
+	}
+}
+
 static inline void
 tc_cls_common_offload_init(struct flow_cls_common_offload *cls_common,
 			   const struct tcf_proto *tp, u32 flags,
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 449a63971451..7f89954c2998 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -180,6 +180,31 @@ enum {
 #define TCA_CLS_FLAGS_NOT_IN_HW (1 << 3) /* filter isn't offloaded to HW */
 #define TCA_CLS_FLAGS_VERBOSE	(1 << 4) /* verbose logging */
 
+/* tca HW stats type */
+enum tca_cls_hw_stats_type {
+	TCA_CLS_HW_STATS_TYPE_ANY, /* User does not care, it's default
+				    * when user does not pass the attr.
+				    * Instructs the driver that user does not
+				    * care if the HW stats are "immediate"
+				    * or "delayed".
+				    */
+	TCA_CLS_HW_STATS_TYPE_IMMEDIATE, /* Means that in dump, user gets
+					  * the current HW stats state from
+					  * the device queried at the dump time.
+					  */
+	TCA_CLS_HW_STATS_TYPE_DELAYED, /* Means that in dump, user gets
+					* HW stats that might be out of date
+					* for some time, maybe couple of
+					* seconds. This is the case when driver
+					* polls stats updates periodically
+					* or when it gets async stats update
+					* from the device.
+					*/
+	TCA_CLS_HW_STATS_TYPE_DISABLED, /* User is not interested in getting
+					 * any HW statistics.
+					 */
+};
+
 /* U32 filters */
 
 #define TC_U32_HTID(h) ((h)&0xFFF00000)
@@ -553,6 +578,8 @@ enum {
 	TCA_FLOWER_KEY_CT_LABELS,	/* u128 */
 	TCA_FLOWER_KEY_CT_LABELS_MASK,	/* u128 */
 
+	TCA_FLOWER_HW_STATS_TYPE,	/* u8 */
+
 	__TCA_FLOWER_MAX,
 };
 
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 726fc9c5910f..91171266ac26 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -113,6 +113,7 @@ struct cls_fl_filter {
 	u32 handle;
 	u32 flags;
 	u32 in_hw_count;
+	enum tca_cls_hw_stats_type hw_stats_type;
 	struct rcu_work rwork;
 	struct net_device *hw_dev;
 	/* Flower classifier is unlocked, which means that its reference counter
@@ -442,6 +443,8 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 		return -ENOMEM;
 
 	tc_cls_common_offload_init(&cls_flower.common, tp, f->flags, extack);
+	cls_flower.common.hw_stats_type =
+		tc_flow_cls_hw_stats_type(f->hw_stats_type);
 	cls_flower.command = FLOW_CLS_REPLACE;
 	cls_flower.cookie = (unsigned long) f;
 	cls_flower.rule->match.dissector = &f->mask->dissector;
@@ -691,6 +694,7 @@ static const struct nla_policy fl_policy[TCA_FLOWER_MAX + 1] = {
 	[TCA_FLOWER_KEY_CT_LABELS_MASK]	= { .type = NLA_BINARY,
 					    .len = 128 / BITS_PER_BYTE },
 	[TCA_FLOWER_FLAGS]		= { .type = NLA_U32 },
+	[TCA_FLOWER_HW_STATS_TYPE]	= { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -1774,6 +1778,9 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 		}
 	}
 
+	fnew->hw_stats_type =
+		tc_hw_stats_type_get(tb[TCA_FLOWER_HW_STATS_TYPE]);
+
 	err = fl_set_parms(net, tp, fnew, mask, base, tb, tca[TCA_RATE], ovr,
 			   tp->chain->tmplt_priv, rtnl_held, extack);
 	if (err)
@@ -1992,6 +1999,8 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 
 		tc_cls_common_offload_init(&cls_flower.common, tp, f->flags,
 					   extack);
+		cls_flower.common.hw_stats_type =
+			tc_flow_cls_hw_stats_type(f->hw_stats_type);
 		cls_flower.command = add ?
 			FLOW_CLS_REPLACE : FLOW_CLS_DESTROY;
 		cls_flower.cookie = (unsigned long)f;
@@ -2714,6 +2723,9 @@ static int fl_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	if (f->flags && nla_put_u32(skb, TCA_FLOWER_FLAGS, f->flags))
 		goto nla_put_failure_locked;
 
+	if (nla_put_u8(skb, TCA_FLOWER_HW_STATS_TYPE, f->hw_stats_type))
+		goto nla_put_failure_locked;
+
 	spin_unlock(&tp->lock);
 
 	if (!skip_hw)
-- 
2.21.1

