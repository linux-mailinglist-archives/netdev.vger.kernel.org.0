Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A6113159
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfECPkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:40:17 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:40950 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfECPkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:40:16 -0400
Received: by mail-lj1-f194.google.com with SMTP id d15so5596153ljc.7;
        Fri, 03 May 2019 08:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DBmxCUfFoKl+kHOI3VC4aTCDEpWEDp+GAoA7DhSFB7w=;
        b=UWmSMG76VWCHJPYCD+tlWicPv431jotFH1CAaZljKdutE4MLVauu/RUihN1FOe+MP5
         anqGeK43+tKcYUfj56BF5tQVAWhXKkeJ0sLB/Sb9BUkGvIAyWRA6BBwqTo2Kfqzve8bi
         lFh6B7ZESQ3GH9OCduAA9SNjdF2qH1/xOR4P/gAvdDc3mNUDvw2wLwywogZvZu64QZeq
         1hR9Al7TejaWUmc4X62MI+DC/hVWt9e5aF6Q/Gi9xO41gdvE/rBqd9uEmfIUS0BzJhS6
         giQctfj4+CX5sppkv5JBmBXiHStCfB4XKcsIly4KOmfpl0Sm81WmnmOZMlVkupzxWRd3
         /zgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DBmxCUfFoKl+kHOI3VC4aTCDEpWEDp+GAoA7DhSFB7w=;
        b=OV/BjqEsuOgVZJn7rf60HzhYNabEedRC7xFbQqvMO6JyNbLd9r+D4Wn9blc8msH7lI
         i6LtJ5QzL8G/cB8WjI+PkHKC23Arl1yGzQ4JpedHzRaTH7767ibUKFqf+0hbByCYYVE0
         F2lY8qeK6CjHTvdg29YkUGfBPoR7pBS3pD8YocvDaQ3f93lxh/GLFJBoQUsm6+xEi89s
         IohMMxR+NA2LRx2VHgEUCBXddkxkF1YHA7HO+dJ+VKFEYOSJ94rTk8DtBpT6x10XAAe4
         OyDwkJw6pnuYemRoq3Cw4q1/Pdk1Jhzig10lLwbUMAQw9ECMOr6cgeA2hHa0utJtKg4Y
         GS8Q==
X-Gm-Message-State: APjAAAV3EaI2RmycJv6J0D2IyrJUVupY3QLoxriR6J6x6xGSe/zrsQBj
        8QTBSIurIHV07/7Jq8ZuV/KrZASfEH4=
X-Google-Smtp-Source: APXvYqwIl8fSCM2CNQAOVfmpKI5vgM/VzZyLQyJGKSytp0qRNow9Fx61orqDKPZah5trLzRzYysSiw==
X-Received: by 2002:a2e:86c7:: with SMTP id n7mr5271904ljj.44.1556898014184;
        Fri, 03 May 2019 08:40:14 -0700 (PDT)
Received: from kristrev-XPS-15-9570.lan ([193.213.155.210])
        by smtp.gmail.com with ESMTPSA id t17sm484557lfp.82.2019.05.03.08.40.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 08:40:13 -0700 (PDT)
From:   Kristian Evensen <kristian.evensen@gmail.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH] netfilter: ctnetlink: Resolve conntrack L3-protocol flush regression
Date:   Fri,  3 May 2019 17:40:07 +0200
Message-Id: <20190503154007.32495-1-kristian.evensen@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 59c08c69c278 ("netfilter: ctnetlink: Support L3 protocol-filter
on flush") introduced a user-space regression when flushing connection
track entries. Before this commit, the nfgen_family field was not used
by the kernel and all entries were removed. Since this commit,
nfgen_family is used to filter out entries that should not be removed.
One example a broken tool is conntrack. conntrack always sets
nfgen_family to AF_INET, so after 59c08c69c278 only IPv4 entries were
removed with the -F parameter.

Pablo Neira Ayuso suggested using nfgenmsg->version to resolve the
regression, and this commit implements his suggestion. nfgenmsg->version
is so far set to zero, so it is well-suited to be used as a flag for
selecting old or new flush behavior. If version is 0, nfgen_family is
ignored and all entries are used. If user-space sets the version to one
(or any other value than 0), then the new behavior is used. As version
only can have two valid values, I chose not to add a new
NFNETLINK_VERSION-constant.

Fixes: 59c08c69c278 ("netfilter: ctnetlink: Support L3 protocol-filter
on flush")

Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 8dcc064d518d..7db79c1b8084 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1256,7 +1256,7 @@ static int ctnetlink_del_conntrack(struct net *net, struct sock *ctnl,
 	struct nf_conntrack_tuple tuple;
 	struct nf_conn *ct;
 	struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	u_int8_t u3 = nfmsg->nfgen_family;
+	u_int8_t u3 = nfmsg->version ? nfmsg->nfgen_family : AF_UNSPEC;
 	struct nf_conntrack_zone zone;
 	int err;
 
-- 
2.19.1

