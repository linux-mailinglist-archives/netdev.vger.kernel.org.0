Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE5A0660DAB
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 11:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236537AbjAGKMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 05:12:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbjAGKMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 05:12:23 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FCA7FECD
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 02:12:22 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id d3so4258938plr.10
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 02:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OyrMFYMpDwJrP4wZGU94xNWhMaXJyPqmR+ydD4RxfFo=;
        b=PL2DDQe7aw7xKXtDaEt8+ScIs+oRBYPv2Sa0IGR2e3iqfxLIldG7j073wJGszSvq6M
         jdaNu2NZqIbJqcZ4hofy0Z66CQPRmET/17BJepFMuCNtxVegqzgBGFAWRaJg11WNT/ol
         iNlOrWmrIuHsVo8tJa2fJrL/NzBl2k+7h8owa9J1fQHo8nuuBVTj44XTjPikKU9cgV2h
         TihEWiepgl3l6mYWVm71rCVJEAhSLzTFQt/vW0RoYGCN0QC5L2EAWvswrbF9wDeRYZ1c
         RM16Gg7gND1B+TQ8Eg7lrQtwZ3hK5wRRDOoKTbjmMMSr0/gzqBxZV3kJNn2/3Z97Q4fT
         THjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OyrMFYMpDwJrP4wZGU94xNWhMaXJyPqmR+ydD4RxfFo=;
        b=2a4hsUm27MI4y40W4HiZd9bkCKVF18n1CkwNesgdFlRvVdyaZSgnKHnuvEoQV95jcS
         BnTEMCmhekQ1wOYYbnjfowY++xnqNV63j/wGU78PHIVR1np+7yQslKQZT2a+Fm+j3gNV
         HxM5qe1FgeL/ETggeZSEnhvvMYA5fVyq3M7g0afPYmVWWPeuC13DnLN/1Z3KK9RfIcA2
         QsPlzxD0m1W0XZBTdPl7x9cewj058LC4FTPIjqXexjXz7tpDbPx0pLi69Y3w00znvO0P
         qBT2LzRNPWJGn45JfB7fcDZZBCQHjhml3LMue+qsY2BtFeueST00xoiV6mbjSODIZIAO
         7cmw==
X-Gm-Message-State: AFqh2koD2NDA0ztMu2i3d7afR7S17TjibKXQBqjkOC5l74Ltv3JT74Jd
        N2rMN8fZaBELFrTzyt4ZzdzuD0JCP6Fm4dUNX1d/HQ==
X-Google-Smtp-Source: AMrXdXsInmztBnVCcAj6ktKUGKMTt2Q7yVyFw5ORzcRs9M8sAVXjEnbhfu/EYamYgqZ6/U+N8zQceA==
X-Received: by 2002:a17:902:e889:b0:18f:6cb:22ca with SMTP id w9-20020a170902e88900b0018f06cb22camr79614805plg.67.1673086342039;
        Sat, 07 Jan 2023 02:12:22 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id b18-20020a170902d51200b00174f61a7d09sm2339382plg.247.2023.01.07.02.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 02:12:21 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: [patch net-next 8/8] devlink: add instance lock assertion in devl_is_registered()
Date:   Sat,  7 Jan 2023 11:11:49 +0100
Message-Id: <20230107101151.532611-9-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230107101151.532611-1-jiri@resnulli.us>
References: <20230107101151.532611-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

After region and linecard lock removals, this helper is always supposed
to be called with instance lock held. So put the assertion here and
remove the comment which is no longer accurate.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/devl_internal.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 2b0e119e7b84..09fc4d60fefb 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -83,9 +83,7 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp);
 
 static inline bool devl_is_registered(struct devlink *devlink)
 {
-	/* To prevent races the caller must hold the instance lock
-	 * or another lock taken during unregistration.
-	 */
+	devl_assert_locked(devlink);
 	return xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED);
 }
 
-- 
2.39.0

