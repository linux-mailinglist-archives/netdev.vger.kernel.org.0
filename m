Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6670B50C03
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbfFXN3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:29:31 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36152 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbfFXN3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:29:30 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so12734104wrs.3
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 06:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=11Pv9Z5s19Zp78uuJj22ZvE45uxJPM0y1Jwb+Rtnf2Q=;
        b=ausNJ9qPVHfSlWc7AO4tZT1/2mqSZc363wbHLhcQa6Es6sK4HPxresxuh408Hmpwws
         g4vz6DueaV+gB6ChXtQVP1MhOXU0Gdev5xoAnv/WX9D9OaRPrqUJwNFu6GP+56ED8pDQ
         loqJo9A+XXlslbd0e55r6dDkR+4ELqDBmNU7sZgTdxzyV+FvQZ4K/xJJKOWNbm/x7FRb
         m73JbfKtM2JYF3VnU2UPdiQ3ao+AgGURf1knJiY64ooM99lDq5EMKZLKWDt8sW9KduEv
         /X/siXujC2KFB5yoEBwkcMTvJjHDrWMkrwPfGQC4Elmnv+7ZQZ1stwmYsvdh1qpypipy
         c5ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=11Pv9Z5s19Zp78uuJj22ZvE45uxJPM0y1Jwb+Rtnf2Q=;
        b=MTLH3DjiRR7Ust6b/YRR156dyRuNgV1iopwPvNqH0ztMdiayzq1Hks3hsBaE/ix/R5
         ijDAU5kmbeFVtOmJOUKdH+l3o6hvP0cHjGEA/E259G7uZlyC4m3hYvXV8aL8eD33Thm9
         c+m2xIPEJQm/DhguC1qACcnZKD37MEKcsGom0KGZ5QRzvA+mP+ztE88CRTtqGpdWdukR
         fbfe105ngFkB3F2Z+TdWiSbsHJRb2s02neez0k/6VL1R0xVcvwKOJcVsj0W3FhDiaGzU
         JdvONfqYPl/dBv46+tVt7R6fNwxaEFQ+jxl3PLIZ34JvJsV8XF9jUApak3Z6oSePqLfd
         mtdw==
X-Gm-Message-State: APjAAAUujEZMzaW5szSfeyZ9QTDHhL2HMr8qe6pRE2bNrw8FEWzU/bdF
        b/kr6wW2FUoRkFJCSJLRITZ2MraD5+65sw==
X-Google-Smtp-Source: APXvYqzfbC+Y53cjWnbaVA0/kzG+I9yhSNyZvY7bcKLozH3pD5SObocC0xd9C0soFuVVaehhsBksEg==
X-Received: by 2002:a5d:5448:: with SMTP id w8mr77224907wrv.180.1561382968454;
        Mon, 24 Jun 2019 06:29:28 -0700 (PDT)
Received: from localhost.localdomain ([212.91.227.56])
        by smtp.gmail.com with ESMTPSA id s63sm7842418wme.17.2019.06.24.06.29.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 24 Jun 2019 06:29:27 -0700 (PDT)
From:   Christian Brauner <christian@brauner.io>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>
Subject: [PATCH net-next] ipv4: enable route flushing in network namespaces
Date:   Mon, 24 Jun 2019 15:29:23 +0200
Message-Id: <20190624132923.16792-1-christian@brauner.io>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tools such as vpnc try to flush routes when run inside network
namespaces by writing 1 into /proc/sys/net/ipv4/route/flush. This
currently does not work because flush is not enabled in non-initial
network namespaces.
Since routes are per network namespace it is safe to enable
/proc/sys/net/ipv4/route/flush in there.

Link: https://github.com/lxc/lxd/issues/4257
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 net/ipv4/route.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6cb7cff22db9..41726e26cd5f 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3197,9 +3197,11 @@ static struct ctl_table ipv4_route_table[] = {
 	{ }
 };
 
+static const char ipv4_route_flush_procname[] = "flush";
+
 static struct ctl_table ipv4_route_flush_table[] = {
 	{
-		.procname	= "flush",
+		.procname	= ipv4_route_flush_procname,
 		.maxlen		= sizeof(int),
 		.mode		= 0200,
 		.proc_handler	= ipv4_sysctl_rtcache_flush,
@@ -3217,9 +3219,11 @@ static __net_init int sysctl_route_net_init(struct net *net)
 		if (!tbl)
 			goto err_dup;
 
-		/* Don't export sysctls to unprivileged users */
-		if (net->user_ns != &init_user_ns)
-			tbl[0].procname = NULL;
+		/* Don't export non-whitelisted sysctls to unprivileged users */
+		if (net->user_ns != &init_user_ns) {
+			if (tbl[0].procname != ipv4_route_flush_procname)
+				tbl[0].procname = NULL;
+		}
 	}
 	tbl[0].extra1 = net;
 
-- 
2.22.0

