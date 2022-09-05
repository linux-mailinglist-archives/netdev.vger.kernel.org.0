Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F095AD97F
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 21:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiIETVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 15:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiIETVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 15:21:44 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A9552DEB
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 12:21:42 -0700 (PDT)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1662405701; bh=EmU8UWoOJVtYX3OK4J67jvUUj0Sf/TK1mXUtHMLbBoE=;
        h=From:To:Cc:Subject:Date:From;
        b=Q5TgHF9/XkJAF5e+CXpCavCj9qVNVK+KRXon2AwEpBOKzW0SvPsq7OI0yi0XJArfX
         uY4nkKgdqwosmTVTaeK9ffMp2PWLXHa5a4R6i/IzUJ9VREk7lEFm6D+fmQMOHhG0ZZ
         cqBcgnDdJon+gfGn38p6Owv+7WgqLVOU0tioTx8LX6BtXvd87LWLUDzbgZ3zeo+YrY
         Hf5T9vshKau+qg+ShuIEiG9zA/l1Eja2zAqGREKuloEYZ/KtzHTJIv3CWI0ege19/M
         w9+GMEJWMWyQTqhSeDPeiKBo3BfdEBynF2XH3cWtzGHXE2wZk7SwvYrNXi0cdpTUfh
         CoFBBCtHiyjSw==
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net] sch_sfb: Also store skb len before calling child enqueue
Date:   Mon,  5 Sep 2022 21:21:36 +0200
Message-Id: <20220905192137.965549-1-toke@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang noticed that the previous fix for sch_sfb accessing the queued
skb after enqueueing it to a child qdisc was incomplete: the SFB enqueue
function was also calling qdisc_qstats_backlog_inc() after enqueue, which
reads the pkt len from the skb cb field. Fix this by also storing the skb
len, and using the stored value to increment the backlog after enqueueing.

Fixes: 9efd23297cca ("sch_sfb: Don't assume the skb is still around after enqueueing to child")
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/sched/sch_sfb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 0d761f454ae8..2829455211f8 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -281,6 +281,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 {
 
 	struct sfb_sched_data *q = qdisc_priv(sch);
+	unsigned int len = qdisc_pkt_len(skb);
 	struct Qdisc *child = q->qdisc;
 	struct tcf_proto *fl;
 	struct sfb_skb_cb cb;
@@ -403,7 +404,7 @@ static int sfb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 	memcpy(&cb, sfb_skb_cb(skb), sizeof(cb));
 	ret = qdisc_enqueue(skb, child, to_free);
 	if (likely(ret == NET_XMIT_SUCCESS)) {
-		qdisc_qstats_backlog_inc(sch, skb);
+		sch->qstats.backlog += len;
 		sch->q.qlen++;
 		increment_qlen(&cb, q);
 	} else if (net_xmit_drop_count(ret)) {
-- 
2.37.2

