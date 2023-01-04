Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F105365DF69
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 23:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240418AbjADWAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 17:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbjADV75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 16:59:57 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16F4395D5
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 13:59:56 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id x17-20020a170902ec9100b0019294547b06so14456321plg.12
        for <netdev@vger.kernel.org>; Wed, 04 Jan 2023 13:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ansIL1FRceEaunvjXWkRml8VwJxoztX53tFJV02UIM=;
        b=tVhJH3b3MWTv3KljFpYn8H1uYdkXluisI51Ap8tz1Cv1eXu8w4BewFmDGRZ7LZvVqL
         BfDe97U2Dbjs1qghwW2hYNWKsEUhCVz+23Lr9czDlODhjjxvOAAVlis92/TBc7loicBc
         6TiavvpNn7iJa6M6S+Uk7totrPl/uKiHVGvuISsxKlW0xWNGfv4hvdL11LLE9fdBZgq3
         5qsMOPHfUppZh5BwT89zwtL5xyDm5eJ9YuNTcMoqEnviz91htLegvvHqTQq+JH7zomGu
         mVXlkMmvTXnZMmmqUBEKv5b8xezkT0CtuHtJ1kRoPOWhrNdt0Dtl9YTpNc1C9RINg2QK
         Ja9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ansIL1FRceEaunvjXWkRml8VwJxoztX53tFJV02UIM=;
        b=UjdJVJb13xWD6kXtyWxMf4Q+KjLbZBfux2n54lUFcVIUliIsUFTv9zntck5ZWmEk7g
         WuG6kjdheEZ0Pb6o2KkEqY0H0OipdY/ntNch+OA7vWAVCE9T42dYiq/L24Cc37KbT4Of
         Wu5uJsxJunsTOcf4PXJrU0ze21U2pPNEky9XGjHDuYYVYCChTj+CeqgUGUaELa0EGaW0
         KpQJTz6vq+Ls5FmjWEvdsYPF6Q8Y9wB+rWhBqssjZxUXgeES29Nr+gB+YgURVcwbIgkS
         mKvxZudKZiSLalgdn+yOo4MPNPvQzgPeRVGLqDmA1gz/dFLS0rVWyHKkHiBclcc7Kfy2
         /q3A==
X-Gm-Message-State: AFqh2kp/231zL9CDqno1O0wASDQs6YiQMZokAUOpI3kc8UqciFPM/WVV
        F0ktoxDyV+BkI0YtAsdOElCDtV8=
X-Google-Smtp-Source: AMrXdXsphQrP+A052VnUY+seXfpTSpIGePvYTnhxqKInmgWysHvqVj5RqrxOL91i4CO930GTfRPsTKo=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:364a:b0:226:9046:953 with SMTP id
 nh10-20020a17090b364a00b0022690460953mr901613pjb.160.1672869596160; Wed, 04
 Jan 2023 13:59:56 -0800 (PST)
Date:   Wed,  4 Jan 2023 13:59:35 -0800
In-Reply-To: <20230104215949.529093-1-sdf@google.com>
Mime-Version: 1.0
References: <20230104215949.529093-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230104215949.529093-4-sdf@google.com>
Subject: [PATCH bpf-next v6 03/17] bpf: Move offload initialization into late_initcall
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So we don't have to initialize it manually from several paths.

Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/offload.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/kernel/bpf/offload.c b/kernel/bpf/offload.c
index f5769a8ecbee..621e8738f304 100644
--- a/kernel/bpf/offload.c
+++ b/kernel/bpf/offload.c
@@ -56,7 +56,6 @@ static const struct rhashtable_params offdevs_params = {
 };
 
 static struct rhashtable offdevs;
-static bool offdevs_inited;
 
 static int bpf_dev_offload_check(struct net_device *netdev)
 {
@@ -72,8 +71,6 @@ bpf_offload_find_netdev(struct net_device *netdev)
 {
 	lockdep_assert_held(&bpf_devs_lock);
 
-	if (!offdevs_inited)
-		return NULL;
 	return rhashtable_lookup_fast(&offdevs, &netdev, offdevs_params);
 }
 
@@ -673,18 +670,6 @@ struct bpf_offload_dev *
 bpf_offload_dev_create(const struct bpf_prog_offload_ops *ops, void *priv)
 {
 	struct bpf_offload_dev *offdev;
-	int err;
-
-	down_write(&bpf_devs_lock);
-	if (!offdevs_inited) {
-		err = rhashtable_init(&offdevs, &offdevs_params);
-		if (err) {
-			up_write(&bpf_devs_lock);
-			return ERR_PTR(err);
-		}
-		offdevs_inited = true;
-	}
-	up_write(&bpf_devs_lock);
 
 	offdev = kzalloc(sizeof(*offdev), GFP_KERNEL);
 	if (!offdev)
@@ -710,3 +695,10 @@ void *bpf_offload_dev_priv(struct bpf_offload_dev *offdev)
 	return offdev->priv;
 }
 EXPORT_SYMBOL_GPL(bpf_offload_dev_priv);
+
+static int __init bpf_offload_init(void)
+{
+	return rhashtable_init(&offdevs, &offdevs_params);
+}
+
+late_initcall(bpf_offload_init);
-- 
2.39.0.314.g84b9a713c41-goog

