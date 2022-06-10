Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7C4545A00
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 04:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbiFJCQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 22:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiFJCQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 22:16:26 -0400
Received: from qq.com (smtpbg465.qq.com [59.36.132.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76162CD3;
        Thu,  9 Jun 2022 19:16:22 -0700 (PDT)
X-QQ-mid: bizesmtp74t1654827294t2xerqow
Received: from jianhao-PC.epfl.ch ( [128.178.122.135])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 10 Jun 2022 10:14:49 +0800 (CST)
X-QQ-SSF: 01400000000000D0K000000A0000000
X-QQ-FEAT: 0Eq+cbWb7RweksxJbjIcBPlRoOn9zEogU0m1O4YgteBGLYlCdBB51N97DA011
        YtCajeqiDMvwTC8UtxMVEv8n5kGYejWx+h8FKN975awu0jX3HYMMiopGXxz0NbDcBg+o3VZ
        dpkyvE9RwUy5KT1vLOnu5O0uPqE810kc4G1HUmukpjIs278MGWDtWZI4YWlWxykVRtTMbzF
        zPFGbeO/sNTvzejZ+K/DCfYlSP5Lxc2E1j2chSSZ6OX5fB1TThCE+7hMWytpdKm0Opw62oq
        S4Ffc8U+ONPcxkESA36VBk8oISXNUxdAeII9UraqpjUHEEAAqzkLEb247CLPRrLWrS2KTuz
        YA3zf9uhw9jpQ2AURw=
X-QQ-GoodBg: 1
From:   Jianhao Xu <jianhao_xu@smail.nju.edu.cn>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jianhao Xu <jianhao_xu@smail.nju.edu.cn>
Subject: [PATCH] net: sched: fix potential null pointer deref
Date:   Fri, 10 Jun 2022 04:14:45 +0200
Message-Id: <20220610021445.2441579-1-jianhao_xu@smail.nju.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:smail.nju.edu.cn:qybgforeign:qybgforeign4
X-QQ-Bgrelay: 1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mq_queue_get() may return NULL, a check is needed to avoid using
the NULL pointer.

Signed-off-by: Jianhao Xu <jianhao_xu@smail.nju.edu.cn>
---
 net/sched/sch_mq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sched/sch_mq.c b/net/sched/sch_mq.c
index 83d2e54bf303..9aca4ca82947 100644
--- a/net/sched/sch_mq.c
+++ b/net/sched/sch_mq.c
@@ -201,6 +201,8 @@ static int mq_graft(struct Qdisc *sch, unsigned long cl, struct Qdisc *new,
 static struct Qdisc *mq_leaf(struct Qdisc *sch, unsigned long cl)
 {
 	struct netdev_queue *dev_queue = mq_queue_get(sch, cl);
+	if (!dev_queue)
+		return NULL;
 
 	return dev_queue->qdisc_sleeping;
 }
@@ -218,6 +220,8 @@ static int mq_dump_class(struct Qdisc *sch, unsigned long cl,
 			 struct sk_buff *skb, struct tcmsg *tcm)
 {
 	struct netdev_queue *dev_queue = mq_queue_get(sch, cl);
+	if (!dev_queue)
+		return -1;
 
 	tcm->tcm_parent = TC_H_ROOT;
 	tcm->tcm_handle |= TC_H_MIN(cl);
@@ -229,6 +233,8 @@ static int mq_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 			       struct gnet_dump *d)
 {
 	struct netdev_queue *dev_queue = mq_queue_get(sch, cl);
+	if (!dev_queue)
+		return -1;
 
 	sch = dev_queue->qdisc_sleeping;
 	if (gnet_stats_copy_basic(d, sch->cpu_bstats, &sch->bstats, true) < 0 ||
-- 
2.25.1



