Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC38E182888
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 06:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387842AbgCLFmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 01:42:55 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:36698 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387758AbgCLFmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 01:42:54 -0400
Received: by mail-pj1-f67.google.com with SMTP id l41so2164745pjb.1
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 22:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2HriTZz0nhNeq2PnVfA0Rzv2TuFnRAmbi55BNCU9OZ0=;
        b=mcPMX4uMJ6CJ40ndQc1nIn7pbHaY2Pl2HJ0+Rk5wDjvCYAwUe8pOXtboerZ3Hb0hBm
         dDgJuIe/kuY0JBmkS2Sde0N+BzI9WfNufO/5nPqpNQtxDU3NM9OWH4sXSLB/cQCOQgje
         cIZk+rnuDYRwIcnRvSWqmCusyAPo4s9VcuihzRm+Mi+DIo5M9R46wPtHQWwNKL8WQMtk
         LHLLqdqIxUv0TppXXGqM0pb9L/5O8MnJci4Kh5tXHWp7maH5krjh8R6waLCeHgLG50IG
         jqTi0lVn8iwN+tGROHGU/rTGhmClTooBUb4oEqoP//YNb7U/d93nCf0n9HcLRGiscc7X
         ShYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2HriTZz0nhNeq2PnVfA0Rzv2TuFnRAmbi55BNCU9OZ0=;
        b=X3JhZHwCkYcIxLfik5TbmmAgbgitXzqrgGRflDaObwbp4IoNdFQFJ82DFygxAGC7kK
         d9ErfoNd8FJtYm2emz0v+gmrrVLK3o3jtMCPTErInqKR+L607xhStfyR7P3qw31XcOjp
         GFd+LECjuNq+7rqoLvm4AefflptmELYZ2MIwoTO4DT+ZJql8jVOT9nCIg6GFOmnXw9jA
         oQ1Rttm4Dxkm+eQJcP0ZWMms6TWphhV0mzYTNPKLjjpWnK57NXF2Ef1qEMFKBsdR9ROi
         1gPJtBaRJsGuJLw7YH5c0lHe0HvfQ/571L/vAoJNB2am3M5MmcEhP/dTDKxaSuyMfDXH
         /xZg==
X-Gm-Message-State: ANhLgQ379Mr/69wukpM8ThBhcS6wcbJ+/jlFknXGRKiVJ/l3LYFtU+aO
        SjSM1SUJXQFy2936CMEPmXTB7GzThZw=
X-Google-Smtp-Source: ADFU+vsDHwGtuRllsMUfJHxuAnNo6wgKGlipfbxLprF8gUY8zXyc50rDF/Skxyle1hL6dzUYoo7Ifw==
X-Received: by 2002:a17:902:c282:: with SMTP id i2mr6268887pld.24.1583991773264;
        Wed, 11 Mar 2020 22:42:53 -0700 (PDT)
Received: from tw-172-25-31-169.office.twttr.net ([8.25.197.25])
        by smtp.gmail.com with ESMTPSA id q21sm55226439pff.105.2020.03.11.22.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 22:42:52 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com,
        syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: keep alloc_hash updated after hash allocation
Date:   Wed, 11 Mar 2020 22:42:28 -0700
Message-Id: <20200312054228.29688-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200312054228.29688-1-xiyou.wangcong@gmail.com>
References: <20200312054228.29688-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")
I moved cp->hash calculation before the first
tcindex_alloc_perfect_hash(), but cp->alloc_hash is left untouched.
This difference could lead to another out of bound access.

cp->alloc_hash should always be the size allocated, we should
update it after this tcindex_alloc_perfect_hash().

Reported-and-tested-by: syzbot+dcc34d54d68ef7d2d53d@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+c72da7b9ed57cde6fca2@syzkaller.appspotmail.com
Fixes: 599be01ee567 ("net_sched: fix an OOB access in cls_tcindex")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_tcindex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index f2cb24b6f0cf..9904299424a1 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -359,6 +359,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 
 		if (tcindex_alloc_perfect_hash(net, cp) < 0)
 			goto errout;
+		cp->alloc_hash = cp->hash;
 		for (i = 0; i < min(cp->hash, p->hash); i++)
 			cp->perfect[i].res = p->perfect[i].res;
 		balloc = 1;
-- 
2.21.1

