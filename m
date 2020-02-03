Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A891500F5
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 05:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgBCEbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 23:31:20 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39002 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727205AbgBCEbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 23:31:20 -0500
Received: by mail-pf1-f196.google.com with SMTP id 84so6866826pfy.6;
        Sun, 02 Feb 2020 20:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XLWBL5IGNRhI3LzF4vsrrNV/8zgR7TdSogqBMHqzKtg=;
        b=OTA4bhhTSHJIcY8e0tWOVsN/QlYLAket8wOH8mkUBesNf+1u8lf3WbqdryrX5Ls8me
         VY6zHs5T5xUAFih900h5chmUlc3IdrNSTtqMez3BERdC3I+ha4d0e/m2axN0V2zmoeik
         e1RLvmTVBxoRhIHy0+grq7sfWrxWwN73hpJzmXgCMAI9nyQRWvXZ5SBvD9acwpP+6OJu
         bSpfrvr3V7yPqQE47/OH7P6Ku7dPL2WIFUtEde64aN4enbaUszHAAu0wpBzJa+bNyndd
         5gGMXIu85HHcRMEaL+XcZJdfU2otX1N+HT6drNDEl1aR/L96kIqPmBv6Ul2I6vpx7Frd
         Cixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XLWBL5IGNRhI3LzF4vsrrNV/8zgR7TdSogqBMHqzKtg=;
        b=KND3zN9WI9FPynnEkvly/YYjf0vo6aGIryj48pR3BqEl2DMdCIGiflR0BJmWMjDyvK
         Y2fIelCYyvAvcH60Ec/s1Y0JTfKMCHfoitkinOTABaam5hl5Cyb9NbFeITMzDXogTq5a
         0RrjvrHWGG0HaoYWO08ajyYhgdHH7AbK8SuBZ89LvSfVl/NsklRhWzYlBJJk12zj5Lt9
         XCRK6eE625Gc7QuuUmgJ1qbVX2X2UuOzx5xz+ILd5lnNI04E35tFtcXxYDKdUBVswA12
         Gahg7j8g0qdpK+MHCxUlOvDHEUlN78kkiQq0c2dJQKRHs85VziI3KkL7kZ3N3TArkH6G
         o4AA==
X-Gm-Message-State: APjAAAUEg02gAHXeMt8SGmwPdwFcsu51ivdecs4uRlO3XkwVH96W2zZd
        MO9X1NJpdR4LnBkDi3oOkYNGumwcnJM=
X-Google-Smtp-Source: APXvYqwtkcdfvVS2rplAouitinKGsLrCCQ8uA7oKh+L020DnrmwTaBklEmhYS35emBFlS3ZsI4wxNQ==
X-Received: by 2002:a62:1b4f:: with SMTP id b76mr23726081pfb.163.1580704279184;
        Sun, 02 Feb 2020 20:31:19 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id z29sm17823374pgc.21.2020.02.02.20.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2020 20:31:18 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [Patch nf v2 1/3] xt_hashlimit: avoid OOM for user-controlled vmalloc
Date:   Sun,  2 Feb 2020 20:30:51 -0800
Message-Id: <20200203043053.19192-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
References: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hashtable size could be controlled by user, so use flags
GFP_USER | __GFP_NOWARN to avoid OOM warning triggered by user-space.

Also add __GFP_NORETRY to avoid retrying, as this is just a
best effort and the failure is already handled gracefully.

Reported-and-tested-by: syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/netfilter/xt_hashlimit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index bccd47cd7190..5d9943b37c42 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -293,8 +293,8 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		if (size < 16)
 			size = 16;
 	}
-	/* FIXME: don't use vmalloc() here or anywhere else -HW */
-	hinfo = vmalloc(struct_size(hinfo, hash, size));
+	hinfo = __vmalloc(struct_size(hinfo, hash, size),
+			  GFP_USER | __GFP_NOWARN | __GFP_NORETRY, PAGE_KERNEL);
 	if (hinfo == NULL)
 		return -ENOMEM;
 	*out_hinfo = hinfo;
-- 
2.21.1

