Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C3F70E9C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 03:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387787AbfGWBXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 21:23:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41688 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387736AbfGWBXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 21:23:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so38072944wrm.8
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 18:23:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WZU7Jdw+Za8incNJbIujsUd2IOXhC/sdGHLUcurCpXQ=;
        b=MybXfTRRpF0uzHmflEzn2++xi7mER63Z5xaROFz4+d9L10GEi8GsivRKv6jgQtNLOg
         j09sIznpkHlqf0uDqjhSu3ANBrUoPtBXrgorebUktdVCdqdYUszfX+bBvapuewKPyvrR
         1o9KfM7Wi0ScrZ9d2kG3HtpTaj52bwTFb3FXPYa4f5oz8w7Eyny9Z4vJ2QFoVElUYpHL
         1eDHJED0ABSHbOeEozkDKIaHxkVJdjQVvgSDDO52uG70msxmvXdDWKb6SemRUmIcYddF
         bYl9Ib0WZWeMR/w62Wj29PgUad9XgUSMCft3nx0hfmckGy1PuK9w82J9nR/2Hhpfzgdu
         R3aQ==
X-Gm-Message-State: APjAAAXKR7o4nAzRHrc6/RW6dFpC+AzRL7qJQwxDqnfFjwETYt4Hk7ai
        ytAGu7oupKKk08k98CI6ag2mWeKkWHhREw==
X-Google-Smtp-Source: APXvYqw6MqaxdOJaVGoaJo1c7G78C3DB4nyV97RY1PR2+fqWaKurkxVjls7r/PsI13hDNxjqzg628w==
X-Received: by 2002:a5d:630c:: with SMTP id i12mr72191361wru.312.1563844993487;
        Mon, 22 Jul 2019 18:23:13 -0700 (PDT)
Received: from mcroce-redhat.redhat.com (host21-50-dynamic.21-87-r.retail.telecomitalia.it. [87.21.50.21])
        by smtp.gmail.com with ESMTPSA id c9sm35196753wml.41.2019.07.22.18.23.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 18:23:12 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next] netfilter: conntrack: use shared sysctl constants
Date:   Tue, 23 Jul 2019 03:23:03 +0200
Message-Id: <20190723012303.2221-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use shared sysctl variables for zero and one constants, as in commit
eec4844fae7c ("proc/sysctl: add shared variables for range check")

Fixes: 8f14c99c7eda ("netfilter: conntrack: limit sysctl setting for boolean options")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/netfilter/nf_conntrack_standalone.c | 34 ++++++++++++-------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index e0d392cb3075..d97f4ea47cf3 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -511,8 +511,6 @@ static void nf_conntrack_standalone_fini_proc(struct net *net)
 /* Log invalid packets of a given protocol */
 static int log_invalid_proto_min __read_mostly;
 static int log_invalid_proto_max __read_mostly = 255;
-static int zero;
-static int one = 1;
 
 /* size the user *wants to set */
 static unsigned int nf_conntrack_htable_size_user __read_mostly;
@@ -629,8 +627,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_LOG_INVALID] = {
 		.procname	= "nf_conntrack_log_invalid",
@@ -654,8 +652,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_HELPER] = {
 		.procname	= "nf_conntrack_helper",
@@ -663,8 +661,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	[NF_SYSCTL_CT_EVENTS] = {
@@ -673,8 +671,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #endif
 #ifdef CONFIG_NF_CONNTRACK_TIMESTAMP
@@ -684,8 +682,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #endif
 	[NF_SYSCTL_CT_PROTO_TIMEOUT_GENERIC] = {
@@ -759,16 +757,16 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_LIBERAL] = {
 		.procname       = "nf_conntrack_tcp_be_liberal",
 		.maxlen         = sizeof(int),
 		.mode           = 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 	[NF_SYSCTL_CT_PROTO_TCP_MAX_RETRANS] = {
 		.procname	= "nf_conntrack_tcp_max_retrans",
@@ -904,8 +902,8 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1 	= &zero,
-		.extra2 	= &one,
+		.extra1 	= SYSCTL_ZERO,
+		.extra2 	= SYSCTL_ONE,
 	},
 #endif
 #ifdef CONFIG_NF_CT_PROTO_GRE
-- 
2.21.0

