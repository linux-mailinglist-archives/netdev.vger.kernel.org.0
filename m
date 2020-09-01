Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A805258FEE
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgIANPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 09:15:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41586 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgIANFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 09:05:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id w186so644337pgb.8;
        Tue, 01 Sep 2020 06:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YhdpWHRpwdvRmhQjnUWEZYNd+fMg7VoLNQC21qKbNIc=;
        b=ck8B76O87Xh+xpFoVTit4X75YwHr/XB/lrY69rCIn2adx9CHP23HQ5fJn52wt8S3cl
         dbfjXT3BF6vKm+UXVx891peSGs3/Cg8aAzCQkjrQRAf5gm3SuecksdbfVxy5EKBEpeth
         BkFEW7FIaq2w8g5v88HnJRqdqfazbzMCGBldll7VxXfyi35C3s2ZVD9MOwkAq0qJh5+Z
         bWjUHmg7eEG9rx7Z8BB1aktHM/no0cFg0dL1vPW2i9Nddqz2GqZ+nRXwYewLaI4Z++7e
         kZRWYixUbqtGKTQ6IsVfJ64EoOg3vBUFp4u3pt91G8xuCKPH+/i7KKdwl2sLgh6bZXhA
         Vyzg==
X-Gm-Message-State: AOAM531rJ+dMAhmoNdPQxkd4ENLwZDnjj3gFvFzDSg6wT/MPOIYvi5g+
        rJYBEJwIb99tx3e3r2MD5UQ=
X-Google-Smtp-Source: ABdhPJwQvcNXGjwwhXUoU4KG7YSJwDcOLe8KqYgppSWAxzzD0ZIJqTRzDeyHSjupyYMYSLHUBPSLqQ==
X-Received: by 2002:a63:5d66:: with SMTP id o38mr1401695pgm.366.1598965506787;
        Tue, 01 Sep 2020 06:05:06 -0700 (PDT)
Received: from localhost.localdomain ([49.236.93.204])
        by smtp.gmail.com with ESMTPSA id x12sm1581751pjq.43.2020.09.01.06.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 06:05:06 -0700 (PDT)
From:   Leesoo Ahn <dev@ooseel.net>
To:     dev@ooseel.net
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Lukas Wunner <lukas@wunner.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Niu Xilei <niu_xilei@163.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pktgen: fix error message with wrong function name
Date:   Tue,  1 Sep 2020 22:04:47 +0900
Message-Id: <20200901130449.15422-1-dev@ooseel.net>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Error on calling kthread_create_on_node prints wrong function name,
kernel_thread.

Signed-off-by: Leesoo Ahn <dev@ooseel.net>
---
 net/core/pktgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 95f4c6b8f51a..44fdbb9c6e53 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3699,7 +3699,7 @@ static int __net_init pktgen_create_thread(int cpu, struct pktgen_net *pn)
 				   cpu_to_node(cpu),
 				   "kpktgend_%d", cpu);
 	if (IS_ERR(p)) {
-		pr_err("kernel_thread() failed for cpu %d\n", t->cpu);
+		pr_err("kthread_create_on_node() failed for cpu %d\n", t->cpu);
 		list_del(&t->th_list);
 		kfree(t);
 		return PTR_ERR(p);
-- 
2.25.4

