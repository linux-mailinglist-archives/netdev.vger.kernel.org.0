Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2281520CA
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 20:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgBDTK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 14:10:29 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45768 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbgBDTK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 14:10:29 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so10106245pgk.12
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 11:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5rGBD/7nlOeZOq7npQwDNZSKuNJ0QYdSUw/HttXA9BI=;
        b=q6tGcNjP0Jiur4ViIRWqXs4DISEQbgbXHbhSyuykb1QVlm+aDbYjMmSplmHFyHlzUf
         mfU6E/jqo4dqj2nd0zk3SFxsXbw1ePaV9XZq3ICjXCJ+2mfatooXuVn4xAycDUB9nqiy
         KEKEPgfXELQ13jFqrw+aXpl14Df2ee6bS97YxIqRIRegxKQFBIfIS31Ry26zhB9CLhpy
         T+T+9MQhkZx76HzfgLggsHTmODwy8oNlPQRxnuzOM5048T+iZgclXlCgu0Co44kyoiXz
         9Oc1SQYxDBom2oWtmoZf+/eDAcUVYd2sgezmkFF79/GMPz6P6y+lx0BubiUytdz1dxN6
         GQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5rGBD/7nlOeZOq7npQwDNZSKuNJ0QYdSUw/HttXA9BI=;
        b=nktZsh4ELGYKC5JZNpO1JT5MbdcmjqF9o3HogN4O0G5QxAKVzMQ72FlmNwiU8WVIiM
         KftQlKFV6/4qXf/Y66jMGUP2B12q56RMbW0J/+JAja6sRFEs3wX7+w7LZcvez3yq/6OX
         b6o6W5yFR5mJ4sRbUoFzljRidhTAinUtko9OZwfhPYdXv+7bERW8XxxC3UpcJaHkWykR
         Y3qr2/486dW7TK0ql3kIC7JiUP/7y31lrv6bPlPFciZ+tFtKIdApxbV+fio2/NtAV5MX
         l8YQQiZ/DKQFFGexUrfgdRQSboXwLunwyYnkP2qBPVXEoZcCrc3UkiR1ah+jVIhuw7c9
         zlbw==
X-Gm-Message-State: APjAAAX44b9MZkXxJpkcCSAebZE5PdYgqsKtJ6dmPc8zRZmiXlQZCdom
        hw9B3vZvpVF7SH/AtYkQmzAtO651
X-Google-Smtp-Source: APXvYqzda4BRnQbH2H6syGj9JQThgw6OfdW3qMNAG5XQYAzKtuPk0DMQdpzglVc6X2ojRbgcn9m1aQ==
X-Received: by 2002:a63:f94b:: with SMTP id q11mr2729778pgk.161.1580843428871;
        Tue, 04 Feb 2020 11:10:28 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id b3sm24376101pft.73.2020.02.04.11.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 11:10:28 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: fix a resource leak in tcindex_set_parms()
Date:   Tue,  4 Feb 2020 11:10:12 -0800
Message-Id: <20200204191012.22501-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub noticed there is a potential resource leak in
tcindex_set_parms(): when tcindex_filter_result_init() fails
and it jumps to 'errout1' which doesn't release the memory
and resources allocated by tcindex_alloc_perfect_hash().

We should just jump to 'errout_alloc' which calls
tcindex_free_perfect_hash().

Fixes: b9a24bb76bf6 ("net_sched: properly handle failure case of tcf_exts_init()")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_tcindex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 0323aee03de7..09b7dc5fe7e0 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -365,7 +365,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 
 	err = tcindex_filter_result_init(&new_filter_result, net);
 	if (err < 0)
-		goto errout1;
+		goto errout_alloc;
 	if (old_r)
 		cr = r->res;
 
@@ -484,7 +484,6 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		tcindex_free_perfect_hash(cp);
 	else if (balloc == 2)
 		kfree(cp->h);
-errout1:
 	tcf_exts_destroy(&new_filter_result.exts);
 errout:
 	kfree(cp);
-- 
2.21.1

