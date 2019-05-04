Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44DBA13986
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbfEDLrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:03 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43847 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfEDLrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:02 -0400
Received: by mail-qk1-f194.google.com with SMTP id p19so1630022qkm.10
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nwWm6dwWhjDb05Wpt2OnSSMU0j3GznEQDYYoJuAP2BA=;
        b=ABzmjCoL009RbXGtNYTOlalciQ+Bmr8JBpGSFnzhK+bahHoS3m17zBgyLQbQUw76nX
         EYbeB48EQ06Wz5v9IG5yPFDQsERAm7b0D7hGy8e0wIgS7r6m3UbBrWcwR3kF8iaXWfP3
         Fzk4pNNgln/f2guCk434qbfJmGWTTzISQPoB/P38jwh81Z1kDq3UGxD9YoouD9Sa4Ngj
         3F5KcTiFIe/Fn5+Cdfu0PyXZ+dnVrp8W5Hjvpnja/8GLvW+rFV1iAwH16+XdXW0wnocu
         bZuR5OwaPWfloT8NCB965KMtYqpWy4OAP9WMBBSzjNgbGq10aOszM2npnd+bRdCwSQf9
         wd4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nwWm6dwWhjDb05Wpt2OnSSMU0j3GznEQDYYoJuAP2BA=;
        b=PsoZrKotCrkY9SH80pC9D5Uk5IlU2oJ5hcyQhH+hgluIk7af00dkLsCDCVopNMWKkY
         KSpKfv3OQNANo5zWYwQjMsyXCKiy5fsKfGDzN7N3eBEzOTVhu2i3S57Le9/+Df7YHWjs
         NUuXqyiLIU/HcpSY4HDpkFk5Z1nBmp5jTFfWS5d8nHiSqrRJpMRIa9n01vDUoETfytem
         bcMy+WScReWh8L0LQQ6Y1XvCS5mPNpr25GfOCgcuKG57reExBTYjL8Y0ObZIQr5at/Ke
         dz4I1HgYTkySVEAlE9sNBlAlCaHdIO8Y42dhfYmfBGmqrLtBFKzWUpEOGHO+2bQY47SK
         cGCg==
X-Gm-Message-State: APjAAAUINO5vynqEHzFYEJW4chOpXUpqyLy3PryQOnNddCSMsosxcyjd
        jiGFIuB1SxIWoIfM75CtMWs4kA==
X-Google-Smtp-Source: APXvYqzez5dxXLSEzv9PS7C8SM+FqGmhQWKYFTyefrJBHnhTVnmOdSsTqqWq1P1umIkI6sZ+iuBAfg==
X-Received: by 2002:a05:620a:1030:: with SMTP id a16mr11899998qkk.38.1556970421930;
        Sat, 04 May 2019 04:47:01 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.46.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:01 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 01/13] net/sched: add sample action to the hardware intermediate representation
Date:   Sat,  4 May 2019 04:46:16 -0700
Message-Id: <20190504114628.14755-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Add sample action to the hardware intermediate representation model which
would subsequently allow it to be used by drivers for offload.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/flow_offload.h | 7 +++++++
 net/sched/cls_api.c        | 8 ++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index d035183c8d03..9a6c89b2c2bb 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -118,6 +118,7 @@ enum flow_action_id {
 	FLOW_ACTION_MARK,
 	FLOW_ACTION_WAKE,
 	FLOW_ACTION_QUEUE,
+	FLOW_ACTION_SAMPLE,
 };
 
 /* This is mirroring enum pedit_header_type definition for easy mapping between
@@ -157,6 +158,12 @@ struct flow_action_entry {
 			u32		index;
 			u8		vf;
 		} queue;
+		struct {				/* FLOW_ACTION_SAMPLE */
+			struct psample_group	*psample_group;
+			u32			rate;
+			u32			trunc_size;
+			bool			truncate;
+		} sample;
 	};
 };
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 263c2ec082c9..f8ee2d78654a 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -37,6 +37,7 @@
 #include <net/tc_act/tc_tunnel_key.h>
 #include <net/tc_act/tc_csum.h>
 #include <net/tc_act/tc_gact.h>
+#include <net/tc_act/tc_sample.h>
 #include <net/tc_act/tc_skbedit.h>
 
 extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
@@ -3257,6 +3258,13 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		} else if (is_tcf_skbedit_mark(act)) {
 			entry->id = FLOW_ACTION_MARK;
 			entry->mark = tcf_skbedit_mark(act);
+		} else if (is_tcf_sample(act)) {
+			entry->id = FLOW_ACTION_SAMPLE;
+			entry->sample.psample_group =
+				tcf_sample_psample_group(act);
+			entry->sample.trunc_size = tcf_sample_trunc_size(act);
+			entry->sample.truncate = tcf_sample_truncate(act);
+			entry->sample.rate = tcf_sample_rate(act);
 		} else {
 			goto err_out;
 		}
-- 
2.21.0

