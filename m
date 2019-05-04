Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B95DA13987
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfEDLrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:06 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41312 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfEDLrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:05 -0400
Received: by mail-qk1-f196.google.com with SMTP id g190so1220851qkf.8
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1mfk9biFp9S/FpNoG60AhEA7qIqfszbbgEgZJMO2Oho=;
        b=S6DlCMxso7xgynoiM6LIOasUifgK21AndrfeM8ZSFxtSOEfPu+1+madSktb9Nofoyx
         gIMZfGWClJsr74icUUs5FpCFjXgzS3EOiEqXRBo1IPlDgI8XqebaJo6MozQWxIVEyk5u
         s9xCufLwpg3eVl7V78N6PDsYPeNfPIzYEFOWCDUbI79rfonEawAsbSxWgDQoWgWj/chl
         CQRErtTTdd/3dP/YcPbCjgTzRET4RCPzbjLYDfagoOJJX/fGHDWEOMQw2tka34GMXWyd
         x7Az8nvHSCjob10mC9yGREgy3Y7jXISyH0eXSNXzSfGqLSW+HfaZnDBEDH/MJecOB+cE
         2AeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1mfk9biFp9S/FpNoG60AhEA7qIqfszbbgEgZJMO2Oho=;
        b=bl9toAUmY3N61TTE2IwqrhIAcepUf2NU5paWOwsS1tXv7ByWLG3RXsVHo9ebx9rbFI
         p0FE46jQJaOunvzUVdgm1io1GmqJ8fEFLniYJfcoRbdpNtBwRvAZeU9hj12SReNzs6Xm
         wkIakAaxnHfQlZaE4C/i98PSHoadqFSnThRK6rzAfCxni6G9X8556ZORHKMFmgtBfhJs
         djmWXUVoi9mk7MHu6KKIQj2UNsA1w46h+L4ECJkZVcyjC1hgi2PxjSqg3DAWvm1iEpo+
         /pEN27prirSqbe2xMIap2Ytc5+qcjUdBpgJ2S88pPEd6I0nXCWn5TyvZmNs/qtLSKNG9
         aaFg==
X-Gm-Message-State: APjAAAXOPeqBFkZhtNE3H2zMhIM9Rw60/lkq1ftvaeu4cQbSTXmpuLNb
        rWM3uqY5ixwAZKyEKihS+RPHNA==
X-Google-Smtp-Source: APXvYqzR+4Aw4mkYhMt8HA0b3pmhI4hCfqydGWtfcDc+VHnpJ4zsB40+bKxuPFCr2ynKFErthnlvvA==
X-Received: by 2002:a37:f602:: with SMTP id y2mr7841207qkj.136.1556970424077;
        Sat, 04 May 2019 04:47:04 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:03 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 02/13] net/sched: use the hardware intermediate representation for matchall
Date:   Sat,  4 May 2019 04:46:17 -0700
Message-Id: <20190504114628.14755-3-jakub.kicinski@netronome.com>
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

Extends matchall offload to make use of the hardware intermediate
representation. More specifically, this patch moves the native TC
actions in cls_matchall offload to the newer flow_action
representation. This ultimately allows us to avoid a direct
dependency on native TC actions for matchall.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/pkt_cls.h    |  1 +
 net/sched/cls_matchall.c | 33 +++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index d5e7a1af346f..c852ed502cc6 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -789,6 +789,7 @@ enum tc_matchall_command {
 struct tc_cls_matchall_offload {
 	struct tc_cls_common_offload common;
 	enum tc_matchall_command command;
+	struct flow_rule *rule;
 	struct tcf_exts *exts;
 	unsigned long cookie;
 };
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 46982b4ea70a..8d135ecab098 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -89,12 +89,30 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 	bool skip_sw = tc_skip_sw(head->flags);
 	int err;
 
+	cls_mall.rule =	flow_rule_alloc(tcf_exts_num_actions(&head->exts));
+	if (!cls_mall.rule)
+		return -ENOMEM;
+
 	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, extack);
 	cls_mall.command = TC_CLSMATCHALL_REPLACE;
 	cls_mall.exts = &head->exts;
 	cls_mall.cookie = cookie;
 
+	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
+	if (err) {
+		kfree(cls_mall.rule);
+		mall_destroy_hw_filter(tp, head, cookie, NULL);
+		if (skip_sw)
+			NL_SET_ERR_MSG_MOD(extack, "Failed to setup flow action");
+		else
+			err = 0;
+
+		return err;
+	}
+
 	err = tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, skip_sw);
+	kfree(cls_mall.rule);
+
 	if (err < 0) {
 		mall_destroy_hw_filter(tp, head, cookie, NULL);
 		return err;
@@ -272,13 +290,28 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 	if (tc_skip_hw(head->flags))
 		return 0;
 
+	cls_mall.rule =	flow_rule_alloc(tcf_exts_num_actions(&head->exts));
+	if (!cls_mall.rule)
+		return -ENOMEM;
+
 	tc_cls_common_offload_init(&cls_mall.common, tp, head->flags, extack);
 	cls_mall.command = add ?
 		TC_CLSMATCHALL_REPLACE : TC_CLSMATCHALL_DESTROY;
 	cls_mall.exts = &head->exts;
 	cls_mall.cookie = (unsigned long)head;
 
+	err = tc_setup_flow_action(&cls_mall.rule->action, &head->exts);
+	if (err) {
+		kfree(cls_mall.rule);
+		if (add && tc_skip_sw(head->flags)) {
+			NL_SET_ERR_MSG_MOD(extack, "Failed to setup flow action");
+			return err;
+		}
+	}
+
 	err = cb(TC_SETUP_CLSMATCHALL, &cls_mall, cb_priv);
+	kfree(cls_mall.rule);
+
 	if (err) {
 		if (add && tc_skip_sw(head->flags))
 			return err;
-- 
2.21.0

