Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149E65168FB
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 02:10:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378463AbiEBAOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 20:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiEBAOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 20:14:06 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F45DE9D
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 17:10:36 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id q14so16668116ljc.12
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 17:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=hd0y1OR/b4IeCBpDcty8eQdPQFVx3QSyhq2QmkPNM2U=;
        b=69H2sZp3OJ0LOKrRShXopodHHx0OU2Q0oQ9nk2IPizjQ/AESBps1VdJ5Oq3dfBorHr
         0Jpr+Ii0XIGAC9b027CE9SenODK76DnAoIWWvlqEW49Gu+29PZg2IyeJlFBM/wh5nMS5
         yXq0RGQ8lNdwBpZIn0z/YqxF4Irp+B7lqzBA+PLV0/1eB6yiziFT4L+VbngWvp7+pT9j
         i5zbmCEXZ3SaVNtPgvOS97VSGcHt1obphxpMqauFcLOizuZT94JuFThr6wCUy4EfD65Z
         2sgiTD7dDr5lf7+AyxpsELyBBnmxFl4tKJ8AlhaZ0bV6G0MyHZoodMaXa13o7wi3NjNn
         rbtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=hd0y1OR/b4IeCBpDcty8eQdPQFVx3QSyhq2QmkPNM2U=;
        b=qLXRBaaeCEInRTB2URGZU8wcGvp8j6u41sRpx4pNHOTqtIg6N1l+v61NRg6IHH7Dxb
         HRWcNCkDmf5gmmuukYiGZ6nuoZnX0ExNkGrmNVhpkd9k0JB+RAX6LOMrvsaDGehwjivS
         KsVI1OW6CaypPpT+6eHDSVRk30GHTqs1G6MVaProqFMh9uuCNUeLFTdkP33lrUNJERn9
         j6JWQ8y935iFMpHn1fZWVf7bLexjI7MdaZZizetrdQ2ccY6s2c+Bk/2rCJEEu4Q9PN1C
         DlrcNjp3b+XDnUFaXNqakdtCBq5BQdgJIWz+iJjtUvUUuyajr5VaJISLZEkdWsyI6JAy
         Q4Cg==
X-Gm-Message-State: AOAM533pyxKMc72/yeuNoKs4XGik7WciJbsOEnDfQuZtrYg01vy3XasH
        OP196a1FdhWwvOAVV7UmGaqQ7hRwie2cZA==
X-Google-Smtp-Source: ABdhPJyz51F6s5TmukXjz8wMZrd2FYEXvb+rgt8PgukAcQ8O50QW9Uc9Pvf8CjBk2FqnN6M0JowK3w==
X-Received: by 2002:a05:651c:505:b0:24f:5248:3018 with SMTP id o5-20020a05651c050500b0024f52483018mr3429236ljp.45.1651450234628;
        Sun, 01 May 2022 17:10:34 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id c5-20020ac25305000000b0047255d211d1sm561008lfh.256.2022.05.01.17.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 17:10:34 -0700 (PDT)
Message-ID: <0ccfe7a4-c178-0b66-d481-2326c85a8ffb@openvz.org>
Date:   Mon, 2 May 2022 03:10:32 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Vasily Averin <vvs@openvz.org>
Subject: [PATCH memcg v5] net: set proper memcg for net_init hooks allocations
To:     Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>
Cc:     kernel@openvz.org, Florian Westphal <fw@strlen.de>,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <CALvZod5HugCO2G3+Av3pXC6s2sy0zKW_HRaRyhOO9GOOWV1SsQ@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CALvZod5HugCO2G3+Av3pXC6s2sy0zKW_HRaRyhOO9GOOWV1SsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__register_pernet_operations() executes init hook of registered
pernet_operation structure in all existing net namespaces.

Typically, these hooks are called by a process associated with
the specified net namespace, and all __GFP_ACCOUNT marked
allocation are accounted for corresponding container/memcg.

However __register_pernet_operations() calls the hooks in the same
context, and as a result all marked allocations are accounted
to one memcg for all processed net namespaces.

This patch adjusts active memcg for each net namespace and helps
to account memory allocated inside ops_init() into the proper memcg.

Signed-off-by: Vasily Averin <vvs@openvz.org>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeelb@google.com>

---
v5: documented get_mem_cgroup_from_obj() and for mem_cgroup_or_root()
    functions, asked by Shakeel.

v4: get_mem_cgroup_from_kmem() renamed to get_mem_cgroup_from_obj(),
    get_net_memcg() renamed to mem_cgroup_or_root(), suggested by Roman.

v3: put_net_memcg() replaced by an alreay existing mem_cgroup_put()
    It checks memcg before accessing it, this is required for
    __register_pernet_operations() called before memcg initialization.
    Additionally fixed leading whitespaces in non-memcg_kmem version
    of mem_cgroup_from_obj().

v2: introduced get/put_net_memcg(),
    new functions are moved under CONFIG_MEMCG_KMEM
    to fix compilation issues reported by Intel's kernel test robot

v1: introduced get_mem_cgroup_from_kmem(), which takes the refcount
    for the found memcg, suggested by Shakeel
---
 include/linux/memcontrol.h | 47 +++++++++++++++++++++++++++++++++++++-
 net/core/net_namespace.c   |  7 ++++++
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0abbd685703b..6405f9b8f5a8 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1714,6 +1714,42 @@ static inline int memcg_cache_id(struct mem_cgroup *memcg)
 
 struct mem_cgroup *mem_cgroup_from_obj(void *p);
 
+/**
+ * get_mem_cgroup_from_obj - get a memcg associated with passed kernel object.
+ * @p: pointer to object from which memcg should be extracted. It can be NULL.
+ *
+ * Retrieves the memory group into which the memory of the pointed kernel
+ * object is accounted. If memcg is found, its reference is taken.
+ * If a passed kernel object is uncharged, or if proper memcg cannot be found,
+ * as well as if mem_cgroup is disabled, NULL is returned.
+ *
+ * Return: valid memcg pointer with taken reference or NULL.
+ */
+static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	do {
+		memcg = mem_cgroup_from_obj(p);
+	} while (memcg && !css_tryget(&memcg->css));
+	rcu_read_unlock();
+	return memcg;
+}
+
+/**
+ * mem_cgroup_or_root - always returns a pointer to a valid memory cgroup.
+ * @memcg: pointer to a valid memory cgroup or NULL.
+ *
+ * If passed argument is not NULL, returns it without any additional checks
+ * and changes. Otherwise, root_mem_cgroup is returned.
+ *
+ * NOTE: root_mem_cgroup can be NULL during early boot.
+ */
+static inline struct mem_cgroup *mem_cgroup_or_root(struct mem_cgroup *memcg)
+{
+	return memcg ? memcg : root_mem_cgroup;
+}
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1763,9 +1799,18 @@ static inline void memcg_put_cache_ids(void)
 
 static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
 {
-       return NULL;
+	return NULL;
 }
 
+static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
+{
+	return NULL;
+}
+
+static inline struct mem_cgroup *mem_cgroup_or_root(struct mem_cgroup *memcg)
+{
+	return NULL;
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a5b5bb99c644..240f3db77dec 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -26,6 +26,7 @@
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
+#include <linux/sched/mm.h>
 /*
  *	Our network namespace constructor/destructor lists
  */
@@ -1147,7 +1148,13 @@ static int __register_pernet_operations(struct list_head *list,
 		 * setup_net() and cleanup_net() are not possible.
 		 */
 		for_each_net(net) {
+			struct mem_cgroup *old, *memcg;
+
+			memcg = mem_cgroup_or_root(get_mem_cgroup_from_obj(net));
+			old = set_active_memcg(memcg);
 			error = ops_init(ops, net);
+			set_active_memcg(old);
+			mem_cgroup_put(memcg);
 			if (error)
 				goto out_undo;
 			list_add_tail(&net->exit_list, &net_exit_list);
-- 
2.31.1

