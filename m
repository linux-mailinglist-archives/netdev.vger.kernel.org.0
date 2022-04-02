Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4D84F0162
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 14:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242228AbiDBMR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 08:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242153AbiDBMRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 08:17:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 848641905AA
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 05:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648901732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xZCY9WwfUJ1wQ7ihdlt+WF3BvYNQQqJJlaiT88Q2K8g=;
        b=YYOUxYYmlUWu8nNmEyD+NEEG6sVbKWt3HGyiwYKIxIvz1r6z7uH2kLXNiMEks8by1xGFv4
        hz75H0b9s4cAbyaujCkRS23mMSJYRX2HMCKvIXnI9iFiFy1KlTfaI/ctglq4chieUI3uw2
        hsXbRKWOZQM39Yva1jHnajqcOi/UTx4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-504-aFXUewVuMEGCcnX50x0buQ-1; Sat, 02 Apr 2022 08:15:31 -0400
X-MC-Unique: aFXUewVuMEGCcnX50x0buQ-1
Received: by mail-qk1-f200.google.com with SMTP id w200-20020a3762d1000000b0067d2149318dso3421596qkb.1
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 05:15:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xZCY9WwfUJ1wQ7ihdlt+WF3BvYNQQqJJlaiT88Q2K8g=;
        b=P6CwcflALXK8yq0/hEK8g1N/QNL4MEgypTO01a3duWiwKpce2IXIdTZ39SAO2+9FxS
         bjQaHusr7Keoz6jcxwWvPRJgrp0thhIk9mm/+TcvI6AQ8iEHRHoj4hkIL0nKxUghhfmj
         eaN3urKRDYcX3VGnh/D7Gn8GnFp2COkZ4mtBTkml9RXf5oKR8PIJeK6MK7C+1h1ZOy/t
         ox3Ot7l/kn8VAZbjIV0G1dPmmUay/ihhlLCttROigHUUFdpf5rlEM+zKtXv7zdVtRsy8
         8YZaEvXSi70dhhk7GpYLHt/fGGP35GGvWEhzJH9XhX3X0tb4Sy5jQX4G8v2oXjVmt/a1
         Wa/w==
X-Gm-Message-State: AOAM532pO0wpT+I/V8pRNsS81OTviQ/sy2dyV6gXJZMxSgsWUQyDJCcV
        2RsqCsmZAa33rax3ZTow13mBkwezkVNibxRKCwBCtiF3MAbnc9b1+MjdnHNYpZtBHcsn+hNKXgV
        Ekq2cIcDTLtpgd3CN
X-Received: by 2002:a37:b984:0:b0:67f:64a2:313e with SMTP id j126-20020a37b984000000b0067f64a2313emr9005737qkf.3.1648901730797;
        Sat, 02 Apr 2022 05:15:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLoYD71R5m6A8TNCdkEbRY7fG54F4nQY8FDR42H5wwtz/WpIZY5yf5K/GUNQ6h3p03DP/F1g==
X-Received: by 2002:a37:b984:0:b0:67f:64a2:313e with SMTP id j126-20020a37b984000000b0067f64a2313emr9005725qkf.3.1648901730578;
        Sat, 02 Apr 2022 05:15:30 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id g21-20020ac85815000000b002e06e2623a7sm3776791qtg.0.2022.04.02.05.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Apr 2022 05:15:29 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] mlxsw: spectrum_router: simplify list unwinding
Date:   Sat,  2 Apr 2022 08:15:16 -0400
Message-Id: <20220402121516.2750284-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The setting of i here
err_nexthop6_group_get:
	i = nrt6;
Is redundant, i is already nrt6.  So remove
this statement.

The for loop for the unwinding
err_rt6_create:
	for (i--; i >= 0; i--) {
Is equivelent to
	for (; i > 0; i--) {

Two consecutive labels can be reduced to one.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 20 ++++++++-----------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 79deb19e3a19..79fd486e29e3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -7010,7 +7010,7 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt_arr[i]);
 		if (IS_ERR(mlxsw_sp_rt6)) {
 			err = PTR_ERR(mlxsw_sp_rt6);
-			goto err_rt6_create;
+			goto err_rt6_unwind;
 		}
 
 		list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
@@ -7019,14 +7019,12 @@ mlxsw_sp_fib6_entry_nexthop_add(struct mlxsw_sp *mlxsw_sp,
 
 	err = mlxsw_sp_nexthop6_group_update(mlxsw_sp, op_ctx, fib6_entry);
 	if (err)
-		goto err_nexthop6_group_update;
+		goto err_rt6_unwind;
 
 	return 0;
 
-err_nexthop6_group_update:
-	i = nrt6;
-err_rt6_create:
-	for (i--; i >= 0; i--) {
+err_rt6_unwind:
+	for (; i > 0; i--) {
 		fib6_entry->nrt6--;
 		mlxsw_sp_rt6 = list_last_entry(&fib6_entry->rt6_list,
 					       struct mlxsw_sp_rt6, list);
@@ -7154,7 +7152,7 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_rt6 = mlxsw_sp_rt6_create(rt_arr[i]);
 		if (IS_ERR(mlxsw_sp_rt6)) {
 			err = PTR_ERR(mlxsw_sp_rt6);
-			goto err_rt6_create;
+			goto err_rt6_unwind;
 		}
 		list_add_tail(&mlxsw_sp_rt6->list, &fib6_entry->rt6_list);
 		fib6_entry->nrt6++;
@@ -7162,7 +7160,7 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 
 	err = mlxsw_sp_nexthop6_group_get(mlxsw_sp, fib6_entry);
 	if (err)
-		goto err_nexthop6_group_get;
+		goto err_rt6_unwind;
 
 	err = mlxsw_sp_nexthop_group_vr_link(fib_entry->nh_group,
 					     fib_node->fib);
@@ -7181,10 +7179,8 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop_group_vr_unlink(fib_entry->nh_group, fib_node->fib);
 err_nexthop_group_vr_link:
 	mlxsw_sp_nexthop6_group_put(mlxsw_sp, fib_entry);
-err_nexthop6_group_get:
-	i = nrt6;
-err_rt6_create:
-	for (i--; i >= 0; i--) {
+err_rt6_unwind:
+	for (; i > 0; i--) {
 		fib6_entry->nrt6--;
 		mlxsw_sp_rt6 = list_last_entry(&fib6_entry->rt6_list,
 					       struct mlxsw_sp_rt6, list);
-- 
2.27.0

