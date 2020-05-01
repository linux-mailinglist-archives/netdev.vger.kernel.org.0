Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCBA1C0B71
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 03:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgEABC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 21:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbgEABC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 21:02:57 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDADC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 18:02:56 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id d3so3844643pgj.6
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 18:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bFJ+q9IjKGecslG1qDK71M0vDFY5kNC4rpIMHRo3bPc=;
        b=N0+sunNoh+nK5BrWLIEK4mn4ds2TCYdgSQRyse8skA98BXXXUAhM+FVPAQQopNibfb
         InqXDO1JFEpSaC0PgCxArSEJgr7i2Aqb07DZGidmC3PYMrvTL7EhbtRU5H9Ol8n8mO35
         yAlB/xG/SSMx4Porh6W548nLoKh0/+wqy/wa0AnnYb7FDsRrJbLKCz92q2ZDHqDOmmBg
         dpsSysXVpSIxG8YYZCiMyYkxHaNxT3DH+TV8Kd8ZjhHgqClLKG5shMTMXjg7Wee1uq9G
         9P4tbNPAbJp6TwRRfNhHUkT670kHYhQLGP0pM64DTZzU69kU32+YSmsiCh6sJo2XD1Le
         gzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bFJ+q9IjKGecslG1qDK71M0vDFY5kNC4rpIMHRo3bPc=;
        b=EESAX5nTeZUn/GNSXL8zoaRP+AleXhtX/Bo3mlxEHWfJ6fH0TgKpMzG4EXp5f6S7Ge
         e13HlM4RSF9UPPyXA4lPEvQ9MMATFIM2zvN4LtzKxXFRz7UysEUbdytlwqaZJgSSRJ7m
         FMYRkYxqsK1mWvFujAb3Ooa/mVF1WPpbJ3E1PKJ/wW4T5C/+kXvL+GbkC4qi0rY/9KKQ
         jR/oPcEoM8p+BzamgaN16ce0fL1V96OoJFk5WwrdS5pRMy7Yl+hrhDWacfR1bY/DXUTZ
         h86WqLb8QZAo+uoWkPeJEq4R9PJUNAeWW5vYgdOV+X3ACbGVcVu50Ev/MheusiZ9dP9z
         WGmw==
X-Gm-Message-State: AGi0PuZpaj441W45YMj/RP9HYVe8IU3JgaOgxLnKInG4ck2yvXCE2PO6
        /qfr655WkPX6VfWjJp8sUkVzjj2SzGY=
X-Google-Smtp-Source: APiQypLMxpfkN2w9CDHxSckFX+X2V8dMg6N0NUmIZ4eKC4AuR/CXyK08wmwlpyAVCSnt+h4z21nBKg==
X-Received: by 2002:a63:e643:: with SMTP id p3mr1759412pgj.332.1588294975331;
        Thu, 30 Apr 2020 18:02:55 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id 67sm829937pfx.108.2020.04.30.18.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 18:02:54 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: fix tcm_parent in tc filter dump
Date:   Thu, 30 Apr 2020 18:02:48 -0700
Message-Id: <20200501010248.21269-1-xiyou.wangcong@gmail.com>
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
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_api.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 55bd1429678f..80e93c96d2b2 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2612,12 +2612,10 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -2633,6 +2631,7 @@ static int tc_dump_tfilter(struct sk_buff *skb, struct netlink_callback *cb)
 		block = cops->tcf_block(q, cl, NULL);
 		if (!block)
 			goto out;
+		parent = block->q->handle;
 		if (tcf_block_shared(block))
 			q = NULL;
 	}
-- 
2.26.1

