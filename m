Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C27C933CBA6
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 03:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhCPC6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 22:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbhCPC5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 22:57:46 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4939AC06174A;
        Mon, 15 Mar 2021 19:57:46 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so607952pjh.1;
        Mon, 15 Mar 2021 19:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WEHoIRiJ11MpAQNvXLOQqj2IeasLWQWx6RaJGGQ14sQ=;
        b=JSPjtVlpCpI0dCCa8/oW29iTkFQIu1O43j1vVCIB8kaha0hzojXMjzJs+HGinXswtd
         T2mE0Ib4PXJAJD12LN0SxZdgkySfwYr/Gy+8etYQvIlKikPr1G+STn9RUalRJEk6Nr00
         TJYUsk6AXR/6P3L4opINLVULICkYCowmgQTa/TihL446iYB22gSZNz5FE9CfR1GLNUhZ
         6ZbaHbUlPWCjGMQXhmab7/ppgH+LpZWkfA1xlYdnLLSzxGFJGGuQj9tYL6SXdC1sr8bI
         ZutaO8idXanegQN0NB68v7Pt4nBurUF2S+cH6foQVIZysDJdN5yRbFxckP8Sn+s/XPMe
         EhIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WEHoIRiJ11MpAQNvXLOQqj2IeasLWQWx6RaJGGQ14sQ=;
        b=qkTjsJGroYHTQmF/qiJKyj7s4zoH2BW3ReNHKm6u4vDpL3jC/Uhtl2Bcq8giOhqcI5
         E9i+vY//xRH15MqHt1nEqw3DrdLfYaN5F81ixFpt+oU+Z/SdJQI0iZQKLsldUHrjnedJ
         d6I6uwrkBbjoLLhVzFDII8LpYpES6S86vk4eBhZmR0wpEIyeN6tSKjXbvgiOCFlL0Wb4
         zRa4IBc38QN/QEQdHPAgLRZeGv9/9Ru2M4JxoSRCxsbNhT/qK+lw7a0w2f5KMsiYxTBG
         VhqTzoQPQPPpfsUL1DVwvze+Cl797n5AKv4w4qBiEg8qNXQvyuGtzF4lzKPUOu48KJgd
         dVcQ==
X-Gm-Message-State: AOAM5309SSM5HIJ5O/tz/kQ1VYyegTK/3cYqwkGfrIgXN+1z3FrjQKGq
        j+YHAlyniDNCXYjZcIumUqA=
X-Google-Smtp-Source: ABdhPJyOHrPE6aPPD/v3slF7vISGg/YK1yVjlckn5CQh1Zteo+YYCcWhk0E/Kefz+iCEc7DePsXzoA==
X-Received: by 2002:a17:90a:868c:: with SMTP id p12mr2331569pjn.82.1615863465931;
        Mon, 15 Mar 2021 19:57:45 -0700 (PDT)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id m3sm13871869pgk.47.2021.03.15.19.57.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Mar 2021 19:57:45 -0700 (PDT)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yejune.deng@gmail.com
Subject: [PATCH] net: ipv4: route.c: simplify procfs code
Date:   Tue, 16 Mar 2021 10:57:36 +0800
Message-Id: <20210316025736.37254-1-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

proc_creat_seq() that directly take a struct seq_operations,
and deal with network namespaces in ->open.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/ipv4/route.c | 34 ++++------------------------------
 1 file changed, 4 insertions(+), 30 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 80bed4242d40..fa68c2612252 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -234,19 +234,6 @@ static const struct seq_operations rt_cache_seq_ops = {
 	.show   = rt_cache_seq_show,
 };
 
-static int rt_cache_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &rt_cache_seq_ops);
-}
-
-static const struct proc_ops rt_cache_proc_ops = {
-	.proc_open	= rt_cache_seq_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
-};
-
-
 static void *rt_cpu_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	int cpu;
@@ -324,19 +311,6 @@ static const struct seq_operations rt_cpu_seq_ops = {
 	.show   = rt_cpu_seq_show,
 };
 
-
-static int rt_cpu_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &rt_cpu_seq_ops);
-}
-
-static const struct proc_ops rt_cpu_proc_ops = {
-	.proc_open	= rt_cpu_seq_open,
-	.proc_read	= seq_read,
-	.proc_lseek	= seq_lseek,
-	.proc_release	= seq_release,
-};
-
 #ifdef CONFIG_IP_ROUTE_CLASSID
 static int rt_acct_proc_show(struct seq_file *m, void *v)
 {
@@ -367,13 +341,13 @@ static int __net_init ip_rt_do_proc_init(struct net *net)
 {
 	struct proc_dir_entry *pde;
 
-	pde = proc_create("rt_cache", 0444, net->proc_net,
-			  &rt_cache_proc_ops);
+	pde = proc_create_seq("rt_cache", 0444, net->proc_net,
+			      &rt_cache_seq_ops);
 	if (!pde)
 		goto err1;
 
-	pde = proc_create("rt_cache", 0444,
-			  net->proc_net_stat, &rt_cpu_proc_ops);
+	pde = proc_create_seq("rt_cache", 0444, net->proc_net_stat,
+			      &rt_cpu_seq_ops);
 	if (!pde)
 		goto err2;
 
-- 
2.29.0

