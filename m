Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F32B4731FE
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240936AbhLMQkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240928AbhLMQkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:40:08 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D21C06173F;
        Mon, 13 Dec 2021 08:40:08 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x131so15373914pfc.12;
        Mon, 13 Dec 2021 08:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dRRexe2kuoBv0Y2m9PN9mpB/UFD4YUanEyofcXNpoew=;
        b=Iwkjo1XS88e5vWIVAtU889jEf+umB8ztxpHnp4p43LVbZ5A3GSFMUN/dgU0F8Oqgzl
         uociatJU+Uj/I+HgFnXY/n0n3gksaRtLlsKduJqP/pIw+8h9fsCXlaDtjU+b0JS0bNhn
         7QzhXJiypPL1KUf56JZ6AIquEN7Onha2m9Gq1/GzhN837gQHs8BRCoho+2Pu+uy6Y6p2
         BiWTJGPNhHaHlTscaHUOQzsky+XgInaIRk34WTWNmybI3R7EMP+XBkYNp0UAw5GwzJQp
         vW25quxW05oGzUGcW4ehTySG91XvED99p521vXsaopGCjYYig3AgaBS2GWPNOLhKKQBI
         5oRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dRRexe2kuoBv0Y2m9PN9mpB/UFD4YUanEyofcXNpoew=;
        b=kSOma//YfrL3cMJIdLzfVAJnWnTkpfcnTjfvExlLsQTa4lvsKhJfhHVrVJBRKF8YtK
         oXpo1ZDZhWI+UbX4SLaxkpGWzTp5u7ItPXgqtscDqljZZtFsg6NRvDLPpVnD7oYKaWnj
         lq4acxK+liGi3WoNR5NQMoEfc0RHpoaoCdLXxCJSrw766JrJqS/RbkA/6G7+QFrN5vfm
         t++19HvvBFNf0v+Ij+3LZJYGOI/pVTue09CBngN7E9Wp+WkFVRASc0afFn9BhpAPy5hI
         Cjj7BCShaWjW2jM5RrnLaaMS2l2R1sz3kvPF5OXafxe97ii6o4DHQ44GwgTqwu9J6VY/
         34Ew==
X-Gm-Message-State: AOAM53380lrDL/FzgugTcKcvS4L73jbSAYIfbWlguDpDKKg2BQxq7OV5
        /pgkqhmQTptb+zRQNtFD0rxmN1kLyxd98w==
X-Google-Smtp-Source: ABdhPJx/RsSqWhYBDbljOA4qI6XMHTKT8SPVyEPu30XndeOXdfiudCok5hRgYwh+QX/XqsqcA2Nzbg==
X-Received: by 2002:a65:6819:: with SMTP id l25mr11463268pgt.506.1639413607703;
        Mon, 13 Dec 2021 08:40:07 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:84ea:43e5:6ccb:fc65])
        by smtp.gmail.com with ESMTPSA id 78sm1556239pgg.85.2021.12.13.08.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 08:40:07 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/2] netfilter: nf_nat_masquerade: add netns refcount tracker to masq_dev_work
Date:   Mon, 13 Dec 2021 08:40:00 -0800
Message-Id: <20211213164000.3241266-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
In-Reply-To: <20211213164000.3241266-1-eric.dumazet@gmail.com>
References: <20211213164000.3241266-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

If compiled with CONFIG_NET_NS_REFCNT_TRACKER=y,
using put_net_track() in iterate_cleanup_work()
and netns_tracker_alloc() in nf_nat_masq_schedule()
might help us finding netns refcount imbalances.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/netfilter/nf_nat_masquerade.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_masquerade.c b/net/netfilter/nf_nat_masquerade.c
index acd73f717a0883d791fc351851a98bac4144705f..e32fac374608576d6237f80b1bff558e9453585a 100644
--- a/net/netfilter/nf_nat_masquerade.c
+++ b/net/netfilter/nf_nat_masquerade.c
@@ -12,6 +12,7 @@
 struct masq_dev_work {
 	struct work_struct work;
 	struct net *net;
+	netns_tracker ns_tracker;
 	union nf_inet_addr addr;
 	int ifindex;
 	int (*iter)(struct nf_conn *i, void *data);
@@ -82,7 +83,7 @@ static void iterate_cleanup_work(struct work_struct *work)
 
 	nf_ct_iterate_cleanup_net(w->net, w->iter, (void *)w, 0, 0);
 
-	put_net(w->net);
+	put_net_track(w->net, &w->ns_tracker);
 	kfree(w);
 	atomic_dec(&masq_worker_count);
 	module_put(THIS_MODULE);
@@ -119,6 +120,7 @@ static void nf_nat_masq_schedule(struct net *net, union nf_inet_addr *addr,
 		INIT_WORK(&w->work, iterate_cleanup_work);
 		w->ifindex = ifindex;
 		w->net = net;
+		netns_tracker_alloc(net, &w->ns_tracker, gfp_flags);
 		w->iter = iter;
 		if (addr)
 			w->addr = *addr;
-- 
2.34.1.173.g76aa8bc2d0-goog

