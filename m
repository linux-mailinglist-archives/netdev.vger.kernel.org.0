Return-Path: <netdev+bounces-8901-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07EC47263A0
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:03:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B738A28119B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241AD1ACC1;
	Wed,  7 Jun 2023 15:03:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196028C1D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:03:20 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256381FC4
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:03:17 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1q6ugt-0001Cy-CD; Wed, 07 Jun 2023 17:03:15 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: jhs@mojatatu.com,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net 0/3] net/sched: act_ipt bug fixes
Date: Wed,  7 Jun 2023 16:59:51 +0200
Message-Id: <20230607145954.19324-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

While checking if netfilter could be updated to replace selected
instances of NF_DROP with kfree_skb_reason+NF_STOLEN to improve
debugging info via drop monitor I found that act_ipt is incompatible
with such an approach.  Moreover, it lacks multiple sanity checks
to avoid certain code paths that make assumptions that the tc layer
doesn't meet, such as header sanity checks, availability of skb_dst,
skb_nfct() and so on.

act_ipt test in the tc selftest still pass with this applied.

I think that we should consider removal of this module, while
this should take care of all problems, its ipv4 only and I don't
think there are any netfilter targets that lack a native tc
equivalent, even when ignoring bpf.

Florian Westphal (3):
  net/sched: act_ipt: add sanity checks on table name and hook locations
  net/sched: act_ipt: add sanity checks on skb before calling target
  net/sched: act_ipt: zero skb->cb before calling target

 net/sched/act_ipt.c | 70 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 7 deletions(-)

-- 
2.39.3


