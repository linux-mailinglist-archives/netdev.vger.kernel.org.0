Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B925F968A
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 03:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbiJJBTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 21:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiJJBSz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 21:18:55 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EAF30F46;
        Sun,  9 Oct 2022 18:18:53 -0700 (PDT)
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 65E0F504E54;
        Mon, 10 Oct 2022 04:14:55 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 65E0F504E54
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1665364496; bh=FsVkCsqxnKVxj6zdLWSSwLUhMTznP9XeXVsfc6pdzqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VU91bOV+Cycf3B79zE4xI89AxaQTnM06LqpSrtX5ZQn/6PHvBRYMCZqa4xy3XmbCj
         nA0tEXQXn+igdDKp0qzJAhFmJomBfyW6j99voqdE3An970R/DNhThXVWQU7Cis1GXi
         dYFGW2cFgzZs9BrI7YBNNJp6WFyrBoTHrcqEbAHg=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: [RFC PATCH v3 4/6] dpll: get source/output name
Date:   Mon, 10 Oct 2022 04:18:02 +0300
Message-Id: <20221010011804.23716-5-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20221010011804.23716-1-vfedorenko@novek.ru>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

Dump names of sources and outputs in response to DPLL_CMD_DEVICE_GET dump
request.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 drivers/dpll/dpll_netlink.c | 24 ++++++++++++++++++++++++
 include/linux/dpll.h        |  2 ++
 include/uapi/linux/dpll.h   |  2 ++
 3 files changed, 28 insertions(+)

diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index a5779871537a..e3604c10b59e 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -31,12 +31,16 @@ static const struct nla_policy dpll_genl_set_source_policy[] = {
 	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
 	[DPLLA_SOURCE_ID]	= { .type = NLA_U32 },
 	[DPLLA_SOURCE_TYPE]	= { .type = NLA_U32 },
+	[DPLLA_SOURCE_NAME]	= { .type = NLA_STRING,
+				    .len = DPLL_NAME_LENGTH },
 };
 
 static const struct nla_policy dpll_genl_set_output_policy[] = {
 	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
 	[DPLLA_OUTPUT_ID]	= { .type = NLA_U32 },
 	[DPLLA_OUTPUT_TYPE]	= { .type = NLA_U32 },
+	[DPLLA_OUTPUT_NAME]	= { .type = NLA_STRING,
+				    .len = DPLL_NAME_LENGTH },
 };
 
 static const struct nla_policy dpll_genl_set_src_select_mode_policy[] = {
@@ -100,6 +104,7 @@ static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
 {
 	int i, ret = 0, type, prio;
 	struct nlattr *src_attr;
+	const char *name;
 
 	for (i = 0; i < dpll->sources_count; i++) {
 		src_attr = nla_nest_start(msg, DPLLA_SOURCE);
@@ -132,6 +137,15 @@ static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
 				break;
 			}
 		}
+		if (dpll->ops->get_source_name) {
+			name = dpll->ops->get_source_name(dpll, i);
+			if (name && nla_put_string(msg, DPLLA_SOURCE_NAME,
+						   name)) {
+				nla_nest_cancel(msg, src_attr);
+				ret = -EMSGSIZE;
+				break;
+			}
+		}
 		nla_nest_end(msg, src_attr);
 	}
 
@@ -143,6 +157,7 @@ static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
 {
 	struct nlattr *out_attr;
 	int i, ret = 0, type;
+	const char *name;
 
 	for (i = 0; i < dpll->outputs_count; i++) {
 		out_attr = nla_nest_start(msg, DPLLA_OUTPUT);
@@ -167,6 +182,15 @@ static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
 			}
 			ret = 0;
 		}
+		if (dpll->ops->get_output_name) {
+			name = dpll->ops->get_output_name(dpll, i);
+			if (name && nla_put_string(msg, DPLLA_OUTPUT_NAME,
+						   name)) {
+				nla_nest_cancel(msg, out_attr);
+				ret = -EMSGSIZE;
+				break;
+			}
+		}
 		nla_nest_end(msg, out_attr);
 	}
 
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 3fe957a06b90..2f4964dc28f0 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -23,6 +23,8 @@ struct dpll_device_ops {
 	int (*set_output_type)(struct dpll_device *dpll, int id, int val);
 	int (*set_source_select_mode)(struct dpll_device *dpll, int mode);
 	int (*set_source_prio)(struct dpll_device *dpll, int id, int prio);
+	const char *(*get_source_name)(struct dpll_device *dpll, int id);
+	const char *(*get_output_name)(struct dpll_device *dpll, int id);
 };
 
 struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, const char *name,
diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
index f6b674e5cf01..8782d3425aae 100644
--- a/include/uapi/linux/dpll.h
+++ b/include/uapi/linux/dpll.h
@@ -26,11 +26,13 @@ enum dpll_genl_attr {
 	DPLLA_SOURCE,
 	DPLLA_SOURCE_ID,
 	DPLLA_SOURCE_TYPE,
+	DPLLA_SOURCE_NAME,
 	DPLLA_SOURCE_SUPPORTED,
 	DPLLA_SOURCE_PRIO,
 	DPLLA_OUTPUT,
 	DPLLA_OUTPUT_ID,
 	DPLLA_OUTPUT_TYPE,
+	DPLLA_OUTPUT_NAME,
 	DPLLA_OUTPUT_SUPPORTED,
 	DPLLA_STATUS,
 	DPLLA_TEMP,
-- 
2.27.0

