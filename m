Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BF751156B
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 13:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbiD0LAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 07:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiD0LAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 07:00:11 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AF43C763F
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 03:37:54 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id j4so2351078lfh.8
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 03:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=jRN8XksCdAf0+x8Uj8a/DButwn5KzLonnaobSsBfglg=;
        b=DK23ya2EJ5weoMmh1t7kx/QodejkNkn8M5NyBLC6YNDDq/iyYjlsNadZ2EHYSJ5Fqg
         v6gIuXZexBcUPt7oHC2h4qRgCgC/5A3dmpZmQsJ+8GqVCb1x/lOqbf91P7uw5Ww0uqKD
         uyHVfyKv/F1Mc0YNVKPWcoHW3ohxieUlWta8+KHFA8/SQJvfuKwbBS+TFPT4bO6XlV24
         H/uUZxi93xoDkhBCqfXOOKQhO/48gVdV2wprUxrQeRwT2K32euRbJz7E7YXAoFNXApwv
         SLu4nXXcpWgbpsAiiuxu+zsOGeWaGuKPZ7cmgu84GIuIDg25iFm84RkrJJ73rKF+8/gg
         IwGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:content-language:content-transfer-encoding;
        bh=jRN8XksCdAf0+x8Uj8a/DButwn5KzLonnaobSsBfglg=;
        b=XY4hDEA5kwEy84w2Rabv/9KpacsqxZPtwrmtYF1L3nKfiuQi9a2cp1Ray6ifcoOvWE
         vIyqjy/Ihrk/KqLAbEXeRVU+sFmtRgBpqlPoFTfYHzFh9OQiSHYTZi3N/rz2D8pIjS3B
         OgbQWiqxOMWyR7ioyyASqBwaFJhfZqbTVBi2byxurdwlnWTRbMzkgHjYJu9EBuxSS7yd
         TVLSsnSflHit5hZhsOgzHxTuHsZNCHk4XXfcTZXNuHThYKAbnMehyQZumrBKxDUQAAgn
         OgpN4DpvBY8VcZn8CM40Byd47CyNiq2tCM9TaQUZM5rvbexuUaKsfOD0iFMSBRaPyBrs
         bOXw==
X-Gm-Message-State: AOAM533kKkNO0/m4bA/MC4kle7FX6Cckrj3YMGEluAYc8dlSI/xDkbD8
        2Ce6TPWamSQwRJankixyJtHvMA==
X-Google-Smtp-Source: ABdhPJydThKNwg1fAKcAA4XC9MwiqCQDBZ2EHrvqh41Hwk2uoGINd3w/CMeX10Khz/ZzztPAo5aBuw==
X-Received: by 2002:a05:6512:400a:b0:46b:8cd9:1af8 with SMTP id br10-20020a056512400a00b0046b8cd91af8mr20687452lfb.545.1651055872441;
        Wed, 27 Apr 2022 03:37:52 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id m4-20020a197104000000b00471ebfc7a0bsm1840776lfc.191.2022.04.27.03.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 03:37:51 -0700 (PDT)
Message-ID: <7e867cb0-89d6-402c-33d2-9b9ba0ba1523@openvz.org>
Date:   Wed, 27 Apr 2022 13:37:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Vasily Averin <vvs@openvz.org>
Subject: [PATCH] memcg: accounting for objects allocated for new netdevice
To:     Roman Gushchin <roman.gushchin@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeelb@google.com>
Cc:     kernel@openvz.org, Florian Westphal <fw@strlen.de>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tejun Heo <tj@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        linux-fsdevel@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Creating a new netdevice allocates at least ~50Kb of memory for various
kernel objects, but only ~5Kb of them are accounted to memcg. As a result,
creating an unlimited number of netdevice inside a memcg-limited container
does not fall within memcg restrictions, consumes a significant part
of the host's memory, can cause global OOM and lead to random kills of
host processes.

The main consumers of non-accounted memory are:
 ~10Kb   80+ kernfs nodes
 ~6Kb    ipv6_add_dev() allocations
  6Kb    __register_sysctl_table() allocations
  4Kb    neigh_sysctl_register() allocations
  4Kb    __devinet_sysctl_register() allocations
  4Kb    __addrconf_sysctl_register() allocations

Accounting of these objects allows to increase the share of memcg-related
memory up to 60-70% (~38Kb accounted vs ~54Kb total for dummy netdevice
on typical VM with default Fedora 35 kernel) and this should be enough
to somehow protect the host from misuse inside container.

Other related objects are quite small and may not be taken into account
to minimize the expected performance degradation.

It should be separately mentonied ~300 bytes of percpu allocation
of struct ipstats_mib in snmp6_alloc_dev(), on huge multi-cpu nodes
it can become the main consumer of memory.

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
RFC was discussed here:
https://lore.kernel.org/all/a5e09e93-106d-0527-5b1e-48dbf3b48b4e@virtuozzo.com/
---
 fs/kernfs/mount.c     | 2 +-
 fs/proc/proc_sysctl.c | 2 +-
 net/core/neighbour.c  | 2 +-
 net/ipv4/devinet.c    | 2 +-
 net/ipv6/addrconf.c   | 8 ++++----
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index cfa79715fc1a..2881aeeaa880 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -391,7 +391,7 @@ void __init kernfs_init(void)
 {
 	kernfs_node_cache = kmem_cache_create("kernfs_node_cache",
 					      sizeof(struct kernfs_node),
-					      0, SLAB_PANIC, NULL);
+					      0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	/* Creates slab cache for kernfs inode attributes */
 	kernfs_iattrs_cache  = kmem_cache_create("kernfs_iattrs_cache",
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 7d9cfc730bd4..df4604fea4f8 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1333,7 +1333,7 @@ struct ctl_table_header *__register_sysctl_table(
 		nr_entries++;
 
 	header = kzalloc(sizeof(struct ctl_table_header) +
-			 sizeof(struct ctl_node)*nr_entries, GFP_KERNEL);
+			 sizeof(struct ctl_node)*nr_entries, GFP_KERNEL_ACCOUNT);
 	if (!header)
 		return NULL;
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ec0bf737b076..3dcda2a54f86 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3728,7 +3728,7 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
 	char neigh_path[ sizeof("net//neigh/") + IFNAMSIZ + IFNAMSIZ ];
 	char *p_name;
 
-	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL_ACCOUNT);
 	if (!t)
 		goto err;
 
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index fba2bffd65f7..47523fe5b891 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2566,7 +2566,7 @@ static int __devinet_sysctl_register(struct net *net, char *dev_name,
 	struct devinet_sysctl_table *t;
 	char path[sizeof("net/ipv4/conf/") + IFNAMSIZ];
 
-	t = kmemdup(&devinet_sysctl, sizeof(*t), GFP_KERNEL);
+	t = kmemdup(&devinet_sysctl, sizeof(*t), GFP_KERNEL_ACCOUNT);
 	if (!t)
 		goto out;
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f908e2fd30b2..e79621ee4a0a 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -342,7 +342,7 @@ static int snmp6_alloc_dev(struct inet6_dev *idev)
 {
 	int i;
 
-	idev->stats.ipv6 = alloc_percpu(struct ipstats_mib);
+	idev->stats.ipv6 = alloc_percpu_gfp(struct ipstats_mib, GFP_KERNEL_ACCOUNT);
 	if (!idev->stats.ipv6)
 		goto err_ip;
 
@@ -358,7 +358,7 @@ static int snmp6_alloc_dev(struct inet6_dev *idev)
 	if (!idev->stats.icmpv6dev)
 		goto err_icmp;
 	idev->stats.icmpv6msgdev = kzalloc(sizeof(struct icmpv6msg_mib_device),
-					   GFP_KERNEL);
+					   GFP_KERNEL_ACCOUNT);
 	if (!idev->stats.icmpv6msgdev)
 		goto err_icmpmsg;
 
@@ -382,7 +382,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	if (dev->mtu < IPV6_MIN_MTU)
 		return ERR_PTR(-EINVAL);
 
-	ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL);
+	ndev = kzalloc(sizeof(struct inet6_dev), GFP_KERNEL_ACCOUNT);
 	if (!ndev)
 		return ERR_PTR(err);
 
@@ -7029,7 +7029,7 @@ static int __addrconf_sysctl_register(struct net *net, char *dev_name,
 	struct ctl_table *table;
 	char path[sizeof("net/ipv6/conf/") + IFNAMSIZ];
 
-	table = kmemdup(addrconf_sysctl, sizeof(addrconf_sysctl), GFP_KERNEL);
+	table = kmemdup(addrconf_sysctl, sizeof(addrconf_sysctl), GFP_KERNEL_ACCOUNT);
 	if (!table)
 		goto out;
 
-- 
2.31.1

