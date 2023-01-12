Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAEE76667A8
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 01:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234200AbjALAct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 19:32:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbjALAci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 19:32:38 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E76F13BE98
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:32:37 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id l15-20020a170903244f00b001927c3a0055so11485353pls.6
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 16:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ansIL1FRceEaunvjXWkRml8VwJxoztX53tFJV02UIM=;
        b=Upysjoe2IprVdxnQ4udI09iqKOiEsIN9sZA6n/jDnNvdBUdCmAtmjIe5Fc+Kv0L4ae
         um5dT8+nQPm/++n5ny4+tsQlTCYhTPB6XUsgEarK+aXnOW1lMwcGhDAWxunNvITQGDd4
         wJlzIhTQ5h4W3TTpK3CtkmurZQzjFXLkOvHlfQ2SLTfqYnpvBEwLqzqZhVBu3LOPB1dR
         my7eYId3oKV4i+FugjIwAL7Va2aGqaW1vjOorm4T2M1z8H1/wZE2VhQdeSUKmjiViICD
         pJRaSvRk1iG12/7YIrEdJcqrsDVvKF8wGjNeRcSgd6vb13KSipk7/AEQHHB1s7AO6F6I
         wfhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ansIL1FRceEaunvjXWkRml8VwJxoztX53tFJV02UIM=;
        b=Py/ShuKdS8CowTFPqgxfDjzO5u0UTX/bscOAz7qeU7cbf4ioV3iWmYTv2iphIvntqy
         Q7m8E+0omRN3VS7U7Pr4HNAQhH74cN8h0XaQJ43apkVgIoZewOYsiZMq7SrlZznI+hty
         FFJAC/TjZ9YID3uVEOi6z7SSwo98YBv5tUrdXR+il1XwgjLy+woJH/vrKjcGl94ShwvF
         mZpRoMJVuXpal9xdBKjOPCTQEuMND4iwmgsr5CQMhUjW/dLTBMwwtEdZWxD0O6N5W/HK
         ofdbz08EwWDDPKeQf8AXZ82XoSXU0si9lO7+e1UcYcHRekKTnKDhDlMxaWknq0EhRcCr
         SSjA==
X-Gm-Message-State: AFqh2kq0WQ+LjZ9ubILUuksjRBBPu4Xs56WjPZfqml8fL8gJgWMYHWlY
        /vO2TdS4U5Z9wa5o/wGmsqnafPc=
X-Google-Smtp-Source: AMrXdXvh9Zorlo93uTqVkZCydoCFGUn0nJc05QwoJ9sWxPeB+akdy9slAYbqo0kbqvxDpblvB7x+2cc=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:206:b0:226:9980:67f3 with SMTP id
 c6-20020a17090a020600b00226998067f3mr77503pjc.1.1673483556804; Wed, 11 Jan
 2023 16:32:36 -0800 (PST)
Date:   Wed, 11 Jan 2023 16:32:16 -0800
In-Reply-To: <20230112003230.3779451-1-sdf@google.com>
Mime-Version: 1.0
References: <20230112003230.3779451-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230112003230.3779451-4-sdf@google.com>
Subject: [PATCH bpf-next v7 03/17] bpf: Move offload initialization into late_initcall
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

