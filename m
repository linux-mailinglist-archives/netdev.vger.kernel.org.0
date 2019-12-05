Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF87114551
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 18:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfLERD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 12:03:57 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50745 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfLERD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 12:03:56 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so4734627wmg.0
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 09:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q4UshksYPt6fg122pwhcfpb/H7dWjaT2ofzSdWgtSzo=;
        b=OIdWFL4VAz2ZeZgxZ08hSIaFqyxYOUJme4IHn4lJDzr/TjmkdrRcuTnXjmynRIsr4d
         iyQV3J9veJS1c5VmC5r4XCrQ9xVf84Y56d2AnDgl5jXkwinJFQB6G+q6Aqub4jVUpMbz
         O7S+hRzzycG5mnLTJca2YTbgrr7TpY8IvOKJBIsAcrE8cblGmZGzcb7JON2i7AXbd4gC
         T03YAYJEmuXZGM7b8zB4VkB/ixWKpj+8p6IE6eYH7LyE+gnaQ4riA86BQ5jMd1IYJZ8q
         sODU8VP9Kamt6r6hcUXgcvoRpdk5o2KedrllQiD/UNl3V1KojVLlwxslA/4KyuXcyP1t
         RLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q4UshksYPt6fg122pwhcfpb/H7dWjaT2ofzSdWgtSzo=;
        b=QH9Y54076NwYpqayHLkEbxz7qKVntKV5LGRzzZXviOlwM9irbIj5jcq5hEYKrjwXSI
         uTi0wSUygkR3/2s9HDWYMLUeDefDekBY3GrIqrhnyZiXjETzbod43ipguF6eJNEpvoKe
         DaFRyE30ndKeqieBOP/j3/iMKK9/gyIKvY5diZLGOIk3e85tczNwWzkpif6xbXEM4Jzm
         XuP5BlesqVnr9NTcYVfgwlB0dXeVSpdpj2+5ALwS5Xc4p+o9akqP2hozYKiGh+FAcb5L
         urwXZPbICoJ54+z6qtXe/5IZr3zpMs4fYlCzjyACDvYR441hlO2cfE5Jub2jVKoV9AjM
         Ik8A==
X-Gm-Message-State: APjAAAWICe+wwd1/6Hs9EXU5mhDk9nyBFQURL8CljgqqSjsQJg2BVSI9
        A0xiLAHkfIhzOMHI/eJ6VpAs1bEZ54RzQOk/NJJnVdzNGFhoz/8Iz9F/SRoS0c1osePWELDsazt
        OUZVa2kXc9eAuh1AKB+oTFN+S37bNcsMePrkyzPW+Njq0Mae5ZUG1ehYNHhIv24IqFndphbCE5A
        ==
X-Google-Smtp-Source: APXvYqxxbPF+MsYIqRDlf7mEIylZtcAb9DWojLxk2ORx3fx0zrkfdllf+Jahd4ud0xD1qjZhVgkFRA==
X-Received: by 2002:a7b:cd05:: with SMTP id f5mr6452826wmj.11.1575565434691;
        Thu, 05 Dec 2019 09:03:54 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id b2sm13004971wrr.76.2019.12.05.09.03.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 05 Dec 2019 09:03:53 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net 2/2] net: sched: allow indirect blocks to bind to clsact in TC
Date:   Thu,  5 Dec 2019 17:03:35 +0000
Message-Id: <1575565415-22942-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575565415-22942-1-git-send-email-john.hurley@netronome.com>
References: <1575565415-22942-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a device is bound to a clsact qdisc, bind events are triggered to
registered drivers for both ingress and egress. However, if a driver
registers to such a device using the indirect block routines then it is
assumed that it is only interested in ingress offload and so only replays
ingress bind/unbind messages.

The NFP driver supports the offload of some egress filters when
registering to a block with qdisc of type clsact. However, on unregister,
if the block is still active, it will not receive an unbind egress
notification which can prevent proper cleanup of other registered
callbacks.

Modify the indirect block callback command in TC to send messages of
ingress and/or egress bind depending on the qdisc in use. NFP currently
supports egress offload for TC flower offload so the changes are only
added to TC.

Fixes: 4d12ba42787b ("nfp: flower: allow offloading of matches on 'internal' ports")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 net/sched/cls_api.c | 52 +++++++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 75b4808..3c335fd9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -626,15 +626,15 @@ static void tcf_chain_flush(struct tcf_chain *chain, bool rtnl_held)
 static int tcf_block_setup(struct tcf_block *block,
 			   struct flow_block_offload *bo);
 
-static void tc_indr_block_ing_cmd(struct net_device *dev,
-				  struct tcf_block *block,
-				  flow_indr_block_bind_cb_t *cb,
-				  void *cb_priv,
-				  enum flow_block_command command)
+static void tc_indr_block_cmd(struct net_device *dev, struct tcf_block *block,
+			      flow_indr_block_bind_cb_t *cb, void *cb_priv,
+			      enum flow_block_command command, bool ingress)
 {
 	struct flow_block_offload bo = {
 		.command	= command,
-		.binder_type	= FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
+		.binder_type	= ingress ?
+				  FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS :
+				  FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
 		.net		= dev_net(dev),
 		.block_shared	= tcf_block_non_null_shared(block),
 	};
@@ -652,9 +652,10 @@ static void tc_indr_block_ing_cmd(struct net_device *dev,
 	up_write(&block->cb_lock);
 }
 
-static struct tcf_block *tc_dev_ingress_block(struct net_device *dev)
+static struct tcf_block *tc_dev_block(struct net_device *dev, bool ingress)
 {
 	const struct Qdisc_class_ops *cops;
+	const struct Qdisc_ops *ops;
 	struct Qdisc *qdisc;
 
 	if (!dev_ingress_queue(dev))
@@ -664,24 +665,37 @@ static struct tcf_block *tc_dev_ingress_block(struct net_device *dev)
 	if (!qdisc)
 		return NULL;
 
-	cops = qdisc->ops->cl_ops;
+	ops = qdisc->ops;
+	if (!ops)
+		return NULL;
+
+	if (!ingress && !strcmp("ingress", ops->id))
+		return NULL;
+
+	cops = ops->cl_ops;
 	if (!cops)
 		return NULL;
 
 	if (!cops->tcf_block)
 		return NULL;
 
-	return cops->tcf_block(qdisc, TC_H_MIN_INGRESS, NULL);
+	return cops->tcf_block(qdisc,
+			       ingress ? TC_H_MIN_INGRESS : TC_H_MIN_EGRESS,
+			       NULL);
 }
 
-static void tc_indr_block_get_and_ing_cmd(struct net_device *dev,
-					  flow_indr_block_bind_cb_t *cb,
-					  void *cb_priv,
-					  enum flow_block_command command)
+static void tc_indr_block_get_and_cmd(struct net_device *dev,
+				      flow_indr_block_bind_cb_t *cb,
+				      void *cb_priv,
+				      enum flow_block_command command)
 {
-	struct tcf_block *block = tc_dev_ingress_block(dev);
+	struct tcf_block *block;
+
+	block = tc_dev_block(dev, true);
+	tc_indr_block_cmd(dev, block, cb, cb_priv, command, true);
 
-	tc_indr_block_ing_cmd(dev, block, cb, cb_priv, command);
+	block = tc_dev_block(dev, false);
+	tc_indr_block_cmd(dev, block, cb, cb_priv, command, false);
 }
 
 static void tc_indr_block_call(struct tcf_block *block,
@@ -3626,9 +3640,9 @@ static struct pernet_operations tcf_net_ops = {
 	.size = sizeof(struct tcf_net),
 };
 
-static struct flow_indr_block_entry block_ing_entry = {
-	.cb = tc_indr_block_get_and_ing_cmd,
-	.list = LIST_HEAD_INIT(block_ing_entry.list),
+static struct flow_indr_block_entry block_entry = {
+	.cb = tc_indr_block_get_and_cmd,
+	.list = LIST_HEAD_INIT(block_entry.list),
 };
 
 static int __init tc_filter_init(void)
@@ -3643,7 +3657,7 @@ static int __init tc_filter_init(void)
 	if (err)
 		goto err_register_pernet_subsys;
 
-	flow_indr_add_block_cb(&block_ing_entry);
+	flow_indr_add_block_cb(&block_entry);
 
 	rtnl_register(PF_UNSPEC, RTM_NEWTFILTER, tc_new_tfilter, NULL,
 		      RTNL_FLAG_DOIT_UNLOCKED);
-- 
2.7.4

