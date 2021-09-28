Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2D941B78B
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 21:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242491AbhI1T2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 15:28:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237134AbhI1T2p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 15:28:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA0B660EFF;
        Tue, 28 Sep 2021 19:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632857225;
        bh=oCBbl8iyvvFuyp7pTuxm/BITtl36CdytkTW4MqCGb/k=;
        h=Date:From:To:Cc:Subject:From;
        b=rM9pR8eZiIKWWK1u0jAbzGhkG9T841zlHUHom9g9KmEzcfPA6ukthnvNxtOPDPCFf
         tiFtDSCp3L/3XPoNKMmqFUV966AzHTKdEbklcmFdNR1flRDM1xV1hlXYauXchBqdFr
         O4qcAE7movxqfhGBzJMte4iEhQBtWCI+cY/YrcoruFdY0cDj4gYuG3VV2QV5mUT7nh
         GXb1JF44xzs96Ag+RxyPf6BZdjt5DX14kF0hlbm6Yn421zSYEjZhZxsBF90JD6VvMO
         GDfDemnYOgXveuxXGXW4ehhwLxNG4UtoJW9aAVMrGicgsBCucKAaio8LG1kPHQlX2w
         dl+MLWyvRefkA==
Date:   Tue, 28 Sep 2021 14:31:07 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2][net-next] net_sched: Use struct_size() and
 flex_array_size() helpers
Message-ID: <20210928193107.GA262595@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the struct_size() and flex_array_size() helpers instead of
an open-coded version, in order to avoid any potential type mistakes
or integer overflows that, in the worse scenario, could lead to heap
overflows.

Link: https://github.com/KSPP/linux/issues/160
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Changes in v2:
 - Rebase on top of net-next/master.

 net/sched/sch_api.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 5e90e9b160e3..e1a40d3b1ed0 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -507,20 +507,21 @@ static struct qdisc_size_table *qdisc_get_stab(struct nlattr *opt,
 	list_for_each_entry(stab, &qdisc_stab_list, list) {
 		if (memcmp(&stab->szopts, s, sizeof(*s)))
 			continue;
-		if (tsize > 0 && memcmp(stab->data, tab, tsize * sizeof(u16)))
+		if (tsize > 0 &&
+		    memcmp(stab->data, tab, flex_array_size(stab, data, tsize)))
 			continue;
 		stab->refcnt++;
 		return stab;
 	}
 
-	stab = kmalloc(sizeof(*stab) + tsize * sizeof(u16), GFP_KERNEL);
+	stab = kmalloc(struct_size(stab, data, tsize), GFP_KERNEL);
 	if (!stab)
 		return ERR_PTR(-ENOMEM);
 
 	stab->refcnt = 1;
 	stab->szopts = *s;
 	if (tsize > 0)
-		memcpy(stab->data, tab, tsize * sizeof(u16));
+		memcpy(stab->data, tab, flex_array_size(stab, data, tsize));
 
 	list_add_tail(&stab->list, &qdisc_stab_list);
 
-- 
2.27.0

