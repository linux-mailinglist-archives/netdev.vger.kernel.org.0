Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31AA80B5F
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfHDPKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:10:31 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51005 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfHDPKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:10:30 -0400
Received: by mail-wm1-f67.google.com with SMTP id v15so72459801wml.0
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+LaznjCnVsU17aAS+1MsieE+rq+exC7uT/k3Eq1bSsA=;
        b=a8ZW3ali7hfsTOWYPH/ZIwMgdBsZVNbGBXSw4IdJCnv0Gj1eQIaCdmWUQAOau3YaMD
         PAbTMjmj2sqzHKxFu4Z3gBpkBUF+6pVywX5FfMfjjvl3LH90MrbK/3hjXy+oyYchKMzD
         qdtNSSwdTZSLWV/6cm8EEIVahDyhmQUBXnsNb+oN/36s9O9FCy0m0QwHBmffVv8h7wi9
         7uNebC6K6IdQ1MUh4mytL5vCi71nziW+xk2NADZ7ayqmCUGMPcis8VoiVBxcYy68cZpv
         52Cx11gGusT5HHoU7a6sew+DMvLDLa7deBAsnCVh7szFfficow3fl7UtXIH32iH3a8v/
         trLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+LaznjCnVsU17aAS+1MsieE+rq+exC7uT/k3Eq1bSsA=;
        b=UOxPayPLYC1BlIhn3iDC+TDlqOBXz1T4HN6VIgIqP1RYzPe3iMQ7j8EA9LkkXF39jY
         an/2evkBNFt/t/XgKkTga0WEEGy2Z6CGZJIUSU4sYtZndu2H+B0RuhL1J2p2xETtz3Ge
         EuiktZAVHovKSoceJxY8xk9o5PnvbbEAa6eCULkv7642+ro8upjy724wyWiajTNeRRpW
         /fH7xhgiRfeobKwv9JVOPIfCLpc959Pi88XbtZeY7lwQ5CPP4RrMxed+twfpdXlLVFwG
         bfgMOx6mArGvpQqPfAZ5gF6U+KgjA2HMSw4Jh3SdFZLmKZnVac2GMzCtLjaMtqaFNRDH
         7bcg==
X-Gm-Message-State: APjAAAXagPakLd2d3o53Kccyca/Y6gutbfkkr1+PQgsaSk+bNrJX8Vmi
        /YLDpA+soHFdKX7BNoa2bQJboyCoZFE=
X-Google-Smtp-Source: APXvYqwpHJJ0ZfSm75Pmh8gTRv4aWDTC/Db3Itl/FOLSEb2P8J3UeuSGXucCeK4/31t4rwsomGYofA==
X-Received: by 2002:a1c:a848:: with SMTP id r69mr13764771wme.12.1564931427820;
        Sun, 04 Aug 2019 08:10:27 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm63769441wmh.36.2019.08.04.08.10.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 08:10:27 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 04/10] net: sched: add ingress mirred action to hardware IR
Date:   Sun,  4 Aug 2019 16:09:06 +0100
Message-Id: <1564931351-1036-5-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
References: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TC mirred actions (redirect and mirred) can send to egress or ingress of a
device. Currently only egress is used for hw offload rules.

Modify the intermediate representation for hw offload to include mirred
actions that go to ingress. This gives drivers access to such rules and
can decide whether or not to offload them.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/flow_offload.h | 2 ++
 net/sched/cls_api.c        | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 04c29f5..d3b12bc 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -117,6 +117,8 @@ enum flow_action_id {
 	FLOW_ACTION_GOTO,
 	FLOW_ACTION_REDIRECT,
 	FLOW_ACTION_MIRRED,
+	FLOW_ACTION_REDIRECT_INGRESS,
+	FLOW_ACTION_MIRRED_INGRESS,
 	FLOW_ACTION_VLAN_PUSH,
 	FLOW_ACTION_VLAN_POP,
 	FLOW_ACTION_VLAN_MANGLE,
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ae73d37..9d85d32 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3205,6 +3205,12 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 		} else if (is_tcf_mirred_egress_mirror(act)) {
 			entry->id = FLOW_ACTION_MIRRED;
 			entry->dev = tcf_mirred_dev(act);
+		} else if (is_tcf_mirred_ingress_redirect(act)) {
+			entry->id = FLOW_ACTION_REDIRECT_INGRESS;
+			entry->dev = tcf_mirred_dev(act);
+		} else if (is_tcf_mirred_ingress_mirror(act)) {
+			entry->id = FLOW_ACTION_MIRRED_INGRESS;
+			entry->dev = tcf_mirred_dev(act);
 		} else if (is_tcf_vlan(act)) {
 			switch (tcf_vlan_action(act)) {
 			case TCA_VLAN_ACT_PUSH:
-- 
2.7.4

