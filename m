Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8151476B2
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 02:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgAXB1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 20:27:36 -0500
Received: from mail-pg1-f178.google.com ([209.85.215.178]:35454 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728655AbgAXB1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 20:27:36 -0500
Received: by mail-pg1-f178.google.com with SMTP id l24so174645pgk.2
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 17:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MLd0TngETuF+k/i9ZKsW3IlnygR78+Xw8lqSEx/L63Q=;
        b=F6LZH8Ub49A1BjDrsxvRLck8sBZiM7EO2iFvdZvZWahz+sADdn2nZnF8BhrnrFyS9P
         0i5WLqrYL78ej7r00Aii3DwtvHLzjvfWZ8NdVHgONFBO4a5FYydq2vijR1X9uoctXlu6
         apuwBiP1bmEU0A7nkRhNxHW/PcV2rdhNuvgw0nQbKGB36zvJ54Zf/aYfbTb4LyAgQODq
         IAwI2aJWS5QYlMLdzl7npyzSbWR5ZPSV84S1aOz78NHk5dEoDu3DOBCEPWhI0+vcpq28
         rRbETCvkWD+ZigcyNF19ORRQtqYnGW+KyVkktTUYzgRFf32YS/DVqon6delfeP8YXGIm
         W3uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MLd0TngETuF+k/i9ZKsW3IlnygR78+Xw8lqSEx/L63Q=;
        b=hYq8rkRON5g2WB+5ZpxXFfedoPRub6jo1Vnglzbr/tpdNZ9nX5dm8flfF4M3GK5u3V
         C0bD9LKjl3VnL8WLoasdBrf8TRXcjCjhfGaIm7zHx7Om212/tM1Ie9xf9bghmz6V9SH6
         hngnC0tHYaxRdxCaY9n7ziW75TxzMnqNTTOi8AUvPL3e6zNQNQgL3f8P8qB3YPuz9NTR
         AfV8Wr0YVeKXeL9NvQA0ocZadlUWaK8/Csv0DCYxfLQJym2DeqeTMGat3HapQzAdRyMY
         B5/4TXp7gpuaeMDoa6eAwJZIbScwaeyE8Jxqt0CePfPAXmVlclhQGnHqAino52CUZgJ8
         VOLw==
X-Gm-Message-State: APjAAAX4ckNKlWydPO+ig0AAZmCSKQYeIDGQpJ/6pOctssvwIbYdPXqg
        nLd2woWREgdL26XLDCmiWkGuLkxsvTg=
X-Google-Smtp-Source: APXvYqxPp4Mzr8CMy3SMjx7c9s0XrgtM880j/A1omLke/t0fKXVSAcGfwmoeJoutVQBSEcp4M0poiA==
X-Received: by 2002:a65:4d0b:: with SMTP id i11mr1392901pgt.340.1579829255418;
        Thu, 23 Jan 2020 17:27:35 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id a1sm3996361pfo.68.2020.01.23.17.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 17:27:34 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: walk through all child classes in tc_bind_tclass()
Date:   Thu, 23 Jan 2020 17:27:08 -0800
Message-Id: <20200124012708.29366-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a complex TC class hierarchy like this:

tc qdisc add dev eth0 root handle 1:0 cbq bandwidth 100Mbit         \
  avpkt 1000 cell 8
tc class add dev eth0 parent 1:0 classid 1:1 cbq bandwidth 100Mbit  \
  rate 6Mbit weight 0.6Mbit prio 8 allot 1514 cell 8 maxburst 20      \
  avpkt 1000 bounded

tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip \
  sport 80 0xffff flowid 1:3
tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip \
  sport 25 0xffff flowid 1:4

tc class add dev eth0 parent 1:1 classid 1:3 cbq bandwidth 100Mbit  \
  rate 5Mbit weight 0.5Mbit prio 5 allot 1514 cell 8 maxburst 20      \
  avpkt 1000
tc class add dev eth0 parent 1:1 classid 1:4 cbq bandwidth 100Mbit  \
  rate 3Mbit weight 0.3Mbit prio 5 allot 1514 cell 8 maxburst 20      \
  avpkt 1000

where filters are installed on qdisc 1:0, so we can't merely
search from class 1:1 when creating class 1:3 and class 1:4. We have
to walk through all the child classes of the direct parent qdisc.
Otherwise we would miss filters those need reverse binding.

Fixes: 07d79fc7d94e ("net_sched: add reverse binding for tc class")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_api.c | 41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 943ad3425380..50794125bf02 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1910,22 +1910,24 @@ static int tcf_node_bind(struct tcf_proto *tp, void *n, struct tcf_walker *arg)
 	return 0;
 }
 
-static void tc_bind_tclass(struct Qdisc *q, u32 portid, u32 clid,
-			   unsigned long new_cl)
+struct tc_bind_class_args {
+	struct qdisc_walker w;
+	unsigned long new_cl;
+	u32 portid;
+	u32 clid;
+};
+
+static int tc_bind_class_walker(struct Qdisc *q, unsigned long cl,
+				struct qdisc_walker *w)
 {
+	struct tc_bind_class_args *a = (struct tc_bind_class_args *)w;
 	const struct Qdisc_class_ops *cops = q->ops->cl_ops;
 	struct tcf_block *block;
 	struct tcf_chain *chain;
-	unsigned long cl;
 
-	cl = cops->find(q, portid);
-	if (!cl)
-		return;
-	if (!cops->tcf_block)
-		return;
 	block = cops->tcf_block(q, cl, NULL);
 	if (!block)
-		return;
+		return 0;
 	for (chain = tcf_get_next_chain(block, NULL);
 	     chain;
 	     chain = tcf_get_next_chain(block, chain)) {
@@ -1936,12 +1938,29 @@ static void tc_bind_tclass(struct Qdisc *q, u32 portid, u32 clid,
 			struct tcf_bind_args arg = {};
 
 			arg.w.fn = tcf_node_bind;
-			arg.classid = clid;
+			arg.classid = a->clid;
 			arg.base = cl;
-			arg.cl = new_cl;
+			arg.cl = a->new_cl;
 			tp->ops->walk(tp, &arg.w, true);
 		}
 	}
+
+	return 0;
+}
+
+static void tc_bind_tclass(struct Qdisc *q, u32 portid, u32 clid,
+			   unsigned long new_cl)
+{
+	const struct Qdisc_class_ops *cops = q->ops->cl_ops;
+	struct tc_bind_class_args args = {};
+
+	if (!cops->tcf_block)
+		return;
+	args.portid = portid;
+	args.clid = clid;
+	args.new_cl = new_cl;
+	args.w.fn = tc_bind_class_walker;
+	q->ops->cl_ops->walk(q, &args.w);
 }
 
 #else
-- 
2.21.1

