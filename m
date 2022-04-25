Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A6750DE54
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbiDYK7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236870AbiDYK7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:59:11 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DBF83032
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 03:56:06 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id w1so25432207lfa.4
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 03:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=T8bwaMzGPgoQcIyr+n6koMGrG7fm/Z4/AiIVbk5FTRE=;
        b=PHxpIopHnjSfjS/SVHNS9Ad2fDgAC87mv4w+6ga4qbdW0Q2DTzaYmHRN3FR9hnZOCy
         6xHdBZqPo+eR6dnxjdmLPyDBqPd9zII1ImpopMWmMb93yF0N8tm+cUmIT5jrtOL4N/4v
         XixhnibyCcGYMbLesUH9fox8gdn0Zo0vLs70tveEs+TVVtOicDv7XzpKK+lCL7Svz8Lj
         GZMLt9aTLZIYCm/IcFYiEyN9C17/I/NuJ8YIv2YRMMdH1cS5JDNQB8rXKBscDJ3JiUNc
         UpHURClLwRUW/qmDhx/2kWlIj9Ntv/iBjic6ui24tNOoA8UmKZVBg0Y/Y35+pkBgxAMI
         0zRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=T8bwaMzGPgoQcIyr+n6koMGrG7fm/Z4/AiIVbk5FTRE=;
        b=eHFAO54rq6g+6Qx6U/91QjNzNRjo093YjB6bU5KGV6H6WRTjHtR2oct+xv1SC/e+2l
         zlifiqu2TlhLABMFOqFtTk9Mp51OFpyLmrKzAh251xaW1zMQSlnAEAPR+tetn9+X9ocr
         AkfpXhbucb2mJu0vNj8jhj8xhQygY24W8mcx1tJnoDTFvstxmoajxaWE2JMlNiyjdvBM
         8tbFBM3M3N5Vq/qUzqPpx//jfhEv4Z/qLOboZO+FwCYkhs/b9v9W2xjbUtSdsxVOyJOc
         1zlhMX5giUG6AM2CyXVxmbbV6DS63ntECo3Y5U4pVi2ZbVMD3hnucHTrBhwDC/aM2+89
         xDbQ==
X-Gm-Message-State: AOAM530zMtg8hpLqx885XRlfCjUyQLxc/wB8xrsWvnXUY6w7h4sI2xX7
        ealr6xszf6r1mikLGhkmhLfNxA==
X-Google-Smtp-Source: ABdhPJyLPYmyB6rQIhq9qCyC4P5Ohn4e0bSOMU0jVjfByl4Sdt9vHdoQEKEN1WyZbQ2/A3sI9KAGxw==
X-Received: by 2002:ac2:410b:0:b0:448:58a8:3e8a with SMTP id b11-20020ac2410b000000b0044858a83e8amr12549809lfi.258.1650884164338;
        Mon, 25 Apr 2022 03:56:04 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id u29-20020ac25bdd000000b004720c866dd0sm213357lfn.87.2022.04.25.03.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 03:56:03 -0700 (PDT)
Message-ID: <c2f0139a-62e2-5985-34e9-d42faac81960@openvz.org>
Date:   Mon, 25 Apr 2022 13:56:02 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Vasily Averin <vvs@openvz.org>
Subject: [PATCH memcg v3] net: set proper memcg for net_init hooks allocations
To:     Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeelb@google.com>
Cc:     kernel@openvz.org, Florian Westphal <fw@strlen.de>,
        linux-kernel@vger.kernel.org,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220424144627.GB13403@xsang-OptiPlex-9020>
Content-Language: en-US
In-Reply-To: <20220424144627.GB13403@xsang-OptiPlex-9020>
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

__register_pernet_operations() executes init hook of registered
pernet_operation structure in all existing net namespaces.

Typically, these hooks are called by a process associated with
the specified net namespace, and all __GFP_ACCOUNTING marked
allocation are accounted for corresponding container/memcg.

However __register_pernet_operations() calls the hooks in the same
context, and as a result all marked allocations are accounted
to one memcg for all processed net namespaces.

This patch adjusts active memcg for each net namespace and helps
to account memory allocated inside ops_init() into the proper memcg.

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
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
 include/linux/memcontrol.h | 29 ++++++++++++++++++++++++++++-
 net/core/net_namespace.c   |  7 +++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0abbd685703b..cfb68a3f7015 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1714,6 +1714,29 @@ static inline int memcg_cache_id(struct mem_cgroup *memcg)
 
 struct mem_cgroup *mem_cgroup_from_obj(void *p);
 
+static inline struct mem_cgroup *get_mem_cgroup_from_kmem(void *p)
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
+static inline struct mem_cgroup *get_net_memcg(void *p)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = get_mem_cgroup_from_kmem(p);
+
+	if (!memcg)
+		memcg = root_mem_cgroup;
+
+	return memcg;
+}
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1763,9 +1786,13 @@ static inline void memcg_put_cache_ids(void)
 
 static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
 {
-       return NULL;
+	return NULL;
 }
 
+static inline struct mem_cgroup *get_net_memcg(void *p)
+{
+	return NULL;
+}
 #endif /* CONFIG_MEMCG_KMEM */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a5b5bb99c644..3093b4d5b2b9 100644
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
+			memcg = get_net_memcg(net);
+			old = set_active_memcg(memcg);
 			error = ops_init(ops, net);
+			set_active_memcg(old);
+			mem_cgroup_put(memcg);
 			if (error)
 				goto out_undo;
 			list_add_tail(&net->exit_list, &net_exit_list);
-- 
2.31.1

