Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DAA5046DD
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 08:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbiDQGmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 02:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiDQGmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 02:42:15 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF922C107
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 23:39:41 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id o2so19930316lfu.13
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 23:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=bT5KP076LNXAkBuT6bxsWqWs6Rnf/a89eLMuVK8//BE=;
        b=ncW0cuAMb8hBdKsyH8A3kwzpFlf5AjHuKNEWWaWOGkn5vtR0OwYflZ/UOyblXqRhoX
         kbsctJzKaEA9bWHOVkTV9KuCRQcRcOgvcUf41KIzu3vHK2W9CC4bp4s9AHaibfLLOQjS
         bT1e05vF0QYw5pL8iOoteYlboX9TqJwxMFp/G4XDGLWUN1+Kmy6fQdP8Kl/4NuFsySkn
         HzOuRVfYzz0kv3CUSF1d0XcVL91nMfwKTE/4x0Inr2clsZHHMcHM8uhguc3zAzvEA9cl
         WWfK9ozD2CGno/6VT0O3Ng+LCRT/WPIh/FlwpOJ46w4aohgfKTn2GFxLEpSzV5i7vrat
         rK0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=bT5KP076LNXAkBuT6bxsWqWs6Rnf/a89eLMuVK8//BE=;
        b=siIoqdPoap9Dib8gd+LeTjismnkS0r2KQfPDbiDVUU87KFlAHtf+TptX1KKUDuGJUY
         QajOEcdF69vegyJv/eM+GsiDVHFB7+q3SnXuggv3t22bFe/j6554/obEFR1BZrY0+M7f
         c9faVRHfqPRkoEq2BPCOb6917RHJTlOQ5ZV8tQTZLdqBykSXGyl9dAmpECl1B23wOYRI
         saRPV9zJj4aubwLCa0aEOzUEcRq5f5GN7B47vbV5tyAoS0mMosXKXNNXYFJzJ3diszES
         JJ5oFapWmIeDhFfmG24TBlhsd6F4AbmvSJk0vyTaIkPHL/vIVOjFRFgRvCYZ4VgopJvC
         etJw==
X-Gm-Message-State: AOAM5327O5IOZG9Ui+tj6xhl0+MJDLUTb5XQeXBi0gGWP+XWGBq+uvOn
        oLlDDmWjkb/YyUWDWGyEHycwEw==
X-Google-Smtp-Source: ABdhPJyDayD1yzsslV7LgR6+8/ExlagCq2BG2TF0dic2T/PuIDSyOXUYXztnIZD0s2fB6srWdeqxNQ==
X-Received: by 2002:a05:6512:1326:b0:45a:3a4:f25a with SMTP id x38-20020a056512132600b0045a03a4f25amr4319176lfu.575.1650177579195;
        Sat, 16 Apr 2022 23:39:39 -0700 (PDT)
Received: from [192.168.1.65] ([46.188.121.177])
        by smtp.gmail.com with ESMTPSA id x40-20020a056512132800b004489691436esm872040lfu.146.2022.04.16.23.39.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 23:39:38 -0700 (PDT)
Message-ID: <55605876-d05a-8be3-a6ae-ec26de9ee178@openvz.org>
Date:   Sun, 17 Apr 2022 09:39:37 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
From:   Vasily Averin <vvs@openvz.org>
Subject: [PATCH memcg RFC] net: set proper memcg for net_init hooks
 allocations
To:     Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>
Cc:     kernel@openvz.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, cgroups@vger.kernel.org,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <46c1c59e-1368-620d-e57a-f35c2c82084d@linux.dev>
Content-Language: en-US
In-Reply-To: <46c1c59e-1368-620d-e57a-f35c2c82084d@linux.dev>
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
the specified net namespace, and all __GFP_ACCOUNTING marked
allocation are accounted for corresponding container/memcg.

However __register_pernet_operations() calls the hooks in the same
context, and as a result all marked allocations are accounted
to one memcg for all processed net namespaces.

This patch adjusts active memcg for each net namespace and helps
to account memory allocated inside ops_init() into the proper memcg.

Signed-off-by: Vasily Averin <vvs@openvz.org>
---
Dear Vlastimil, Roman,
I'm not sure that memcg is used correctly here, 
is it perhaps some additional locking required?
---
 net/core/net_namespace.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a5b5bb99c644..171c6e0b2337 100644
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
+			struct mem_cgroup *old, *memcg = NULL;
+#ifdef CONFIG_MEMCG
+			memcg = (net == &init_net) ? root_mem_cgroup : mem_cgroup_from_obj(net);
+#endif
+			old = set_active_memcg(memcg);
 			error = ops_init(ops, net);
+			set_active_memcg(old);
 			if (error)
 				goto out_undo;
 			list_add_tail(&net->exit_list, &net_exit_list);
-- 
2.31.1

