Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892196528E2
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 23:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbiLTWVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 17:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbiLTWU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 17:20:56 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A337DD4
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 14:20:51 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id o8-20020a6548c8000000b0047927da1501so7853976pgs.18
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 14:20:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1ansIL1FRceEaunvjXWkRml8VwJxoztX53tFJV02UIM=;
        b=nZPyP6eghnLsL3cHnT5phCwQAWoEeXv50rN1953ECPYOLu62c9Es/WNqaliQRtOq6W
         U4IDLaWkwt+Eo2JlbBsBoZU9LhMUJQMIns5LQKsa0qJUoYceD0eVFh2g24b9234ArQ5E
         V5MJPDtRENWt6xMFfeX69PggqXOtzgyMoHWXMAQHfUZs/PQqTyOkmQ7/siKKmVcbxCFg
         MJwSkLnkaAVeS40fxDG7LfDxK+0hv6vYZ6kXvT1LLtfOuH0D8trT4Zcm62S/xfpYF0sa
         pXR2EZJcQlPnrN2ABiFBNo+F2whxen4W0G74FK3LNLxP+/RNKvP1foBCd1H48GwpiuEb
         JORA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1ansIL1FRceEaunvjXWkRml8VwJxoztX53tFJV02UIM=;
        b=dsnpaXb5Jbm84SzgB04BQYnx73oNF5wX/4a3lfWSV4tkAwM9C2mVnrqDxpPbcAO2x0
         qTo2nQ5xIQpmshHel4g36TRTMGCUsZIdAjPPvmBdXLsCvuBcCRzR14mMPWDEaYonoBeQ
         LCImNKIoO6WZJYx97RZnzA39Iu9IWuS54YJjcCPspiFQCqqQTb3Q2ou3WJzDOTiUr0nF
         GjguWDfyWYAA0VqmwcwfuVNbtXuhTqo0xsuEOkmL8q42neF7GCfF1B+Bwxl6Lz4XOYN/
         kx6s7Wh9IM3bkakF9fb5DMlcN/tzcbVXSrX94afqmVEauDsUZLQcsLWXQPvjxSueFDdc
         0xeg==
X-Gm-Message-State: ANoB5pmnOr056a2JEHnJD/I8L1tSbz2wWLYDrhfgkpBIhTKGlVdluw7z
        mlV0xIu/ychhoQrwnd/cHEb9Tng=
X-Google-Smtp-Source: AA0mqf7DpHAbO99wZ4lDlUEBNVYC9QB4S33u2/k25knHa2xibKe+tWCLGxQNIck6RlK6ZMWrbgath6g=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a63:481e:0:b0:46b:27b0:c245 with SMTP id
 v30-20020a63481e000000b0046b27b0c245mr70566944pga.611.1671574850829; Tue, 20
 Dec 2022 14:20:50 -0800 (PST)
Date:   Tue, 20 Dec 2022 14:20:29 -0800
In-Reply-To: <20221220222043.3348718-1-sdf@google.com>
Mime-Version: 1.0
References: <20221220222043.3348718-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220222043.3348718-4-sdf@google.com>
Subject: [PATCH bpf-next v5 03/17] bpf: Move offload initialization into late_initcall
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

