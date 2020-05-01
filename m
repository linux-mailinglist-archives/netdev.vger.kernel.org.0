Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9EC1C0CD3
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgEADx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEADx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:53:59 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE36BC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:53:58 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 18so1069096pfv.8
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wstimPs8eW2TIY6/NXLf2vIvVNEkzqTFyMJux8Poupg=;
        b=PcC5h25z3VKJJ/4OOTzRwYbuR6TqIEb9QsecxlRYsBBuwHHMKfTUiKclcMBHy8RMWD
         HAGlT8QDKuDqyuDhl0LZMFxs9diAhtvYrFMXLQwzh0qVT1XJCKY6EqJmtmkKRqUt5eHb
         dI+3vUNBS0YKwPldh4KJ+vD+QWvvOn64wXF0xHWq+UM3LjUZWLHmCYp+NyevV34fmvDF
         b0r3uKwmooeEL950OGZ0vrKkQyeyfyJ/E26Y2wBU+Vcvanx9guhijmmwcjBM5S3bYVSG
         gafd3Ie7rlCJf5HUDgsU8nRhfFkiQQ8h2J5UxUvPpFsFFG7F20Rj2og46BKXJz+oG1ES
         w+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wstimPs8eW2TIY6/NXLf2vIvVNEkzqTFyMJux8Poupg=;
        b=ShlS95Ds8zH+YvvsaD92eEH7Ft2SR3um+y3IqlvFn3F1i5RkTEyXCzdFBXaIgzekYI
         bsbDEmtGLMyjmAhorybtbGh6sax118y7vKtWb4fwVkr1FcLP64elVwirevjjboI70fBW
         39y31WSZKcnn3xazxLB7zz5Hx6Fe/sBgu6RHdPAND7VbqlRirhWZFzKJ4G+C5OFbXPWl
         xFClC7eP3UZX7iPc2NNxOAvF3o3mnWhZycsV3YLPkpJhu3EvcYD1kgGpR5dFNMja573C
         J2cCe44vhoi1M3MBtC+3kjqdVaTHq4MXHjZkxvjVpiiTYbb5b7jDTrOoE2BXMzWhCb1H
         FeEw==
X-Gm-Message-State: AGi0PuZ2tAPYJb3qVIrPcVzuncu4AK6tenjmSV6g/3Iv8ONOaxzXCEeI
        bBjQCi9lIlkgwdZkppZaQ9q9P9bncXE=
X-Google-Smtp-Source: APiQypKPoJllL5A7IEZCI7gjOInGoC+Da9pM+JWIKFXdrGv2mCH4BKNTgAPrCKrqARMqXjFgCWi/3Q==
X-Received: by 2002:a63:1103:: with SMTP id g3mr2271171pgl.206.1588305237945;
        Thu, 30 Apr 2020 20:53:57 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id o40sm975532pjb.18.2020.04.30.20.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 20:53:57 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net v2] net_sched: fix tcm_parent in tc filter dump
Date:   Thu, 30 Apr 2020 20:53:49 -0700
Message-Id: <20200501035349.31244-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we tell kernel to dump filters from root (ffff:ffff),
those filters on ingress (ffff:0000) are matched, but their
true parents must be dumped as they are. However, kernel
dumps just whatever we tell it, that is either ffff:ffff
or ffff:0000:

 $ nl-cls-list --dev=dummy0 --parent=root
 cls basic dev dummy0 id none parent root prio 49152 protocol ip match-all
 cls basic dev dummy0 id :1 parent root prio 49152 protocol ip match-all
 $ nl-cls-list --dev=dummy0 --parent=ffff:
 cls basic dev dummy0 id none parent ffff: prio 49152 protocol ip match-all
 cls basic dev dummy0 id :1 parent ffff: prio 49152 protocol ip match-all

This is confusing and misleading, more importantly this is
a regression since 4.15, so the old behavior must be restored.

And, when tc filters are installed on a tc class, the parent
should be the classid, rather than the qdisc handle. Commit
edf6711c9840 ("net: sched: remove classid and q fields from tcf_proto")
removed the classid we save for filters, we can just restore
this classid in tcf_block.

Steps to reproduce this:
 ip li set dev dummy0 up
 tc qd add dev dummy0 ingress
 tc filter add dev dummy0 parent ffff: protocol arp basic action pass
 tc filter show dev dummy0 root

Before this patch:
 filter protocol arp pref 49152 basic
 filter protocol arp pref 49152 basic handle 0x1
	action order 1: gact action pass
	 random type none pass val 0
	 index 1 ref 1 bind 1

After this patch:
 filter parent ffff: protocol arp pref 49152 basic
 filter parent ffff: protocol arp pref 49152 basic handle 0x1
 	action order 1: gact action pass
 	 random type none pass val 0
	 index 1 ref 1 bind 1

Fixes: a10fa20101ae ("net: sched: propagate q and parent from caller down to tcf_fill_node")
Fixes: edf6711c9840 ("net: sched: remove classid and q fields from tcf_proto")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/net/sch_generic.h | 1 +
 net/sched/cls_api.c       | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 25d2ec4c8f00..8428aa614265 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -407,6 +407,7 @@ struct tcf_block {
 	struct mutex lock;
 	struct list_head chain_list;
 	u32 index; /* block index for shared blocks */
+	u32 classid; /* which class this block belongs to */
 	refcount_t refcnt;
 	struct net *net;
 	struct Qdisc *q;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 55bd1429678f..c0e5b64b3caf 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2070,6 +2070,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		err = PTR_ERR(block);
 		goto errout;
 	}
+	block->classid = parent;
 
 	chain_index = tca[TCA_CHAIN] ? nla_get_u32(tca[TCA_CHAIN]) : 0;
 	if (chain_index > TC_ACT_EXT_VAL_MASK) {
@@ -2612,12 +2613,10 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 			return skb->len;
 
 		parent = tcm->tcm_parent;
-		if (!parent) {
+		if (!parent)
 			q = dev->qdisc;
-			parent = q->handle;
-		} else {
+		else
 			q = qdisc_lookup(dev, TC_H_MAJ(tcm->tcm_parent));
-		}
 		if (!q)
 			goto out;
 		cops = q->ops->cl_ops;
@@ -2633,6 +2632,7 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 		block = cops->tcf_block(q, cl, NULL);
 		if (!block)
 			goto out;
+		parent = block->classid;
 		if (tcf_block_shared(block))
 			q = NULL;
 	}
-- 
2.26.1

