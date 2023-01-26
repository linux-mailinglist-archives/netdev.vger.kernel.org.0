Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4022667C53D
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236123AbjAZH6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbjAZH6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:58:52 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5832E5A810
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:49 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id l8so552200wms.3
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jgr2uXayQJxRJa20dxF0grN+/2udFkr7x09lNd9e6p4=;
        b=zhUhkEjSgkENmYpFqQFUX//SWj2opZx7pPuQ+tULCt9ZdM+OSMW3UCW9BeHR5S7Rgn
         p/JdzuLvZKwR3y4QckOrBNh5dF6xnXlYPyEDO7BniHhEd/QZn16PtyOM4Tvo/79sdzDc
         Reo4+p/i/Qy3NUeAndNk0FFuh4ld9G4p/XAsPHT0qEVOIyjU7QWQ7ERwa/WsdyWRxWj7
         37J3hOKDvkmTsumdgylNiMq6YVORcqGCyL3Bw2YuyUVEAs36GCOjc6gfUH6Skm4x1onV
         omdRv3VEK8WrU9/PkzwbvphGpWBFW34iPIurbJFSxXj7SZH5HhlqvOAgtp+2BaBcLMMJ
         Eq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jgr2uXayQJxRJa20dxF0grN+/2udFkr7x09lNd9e6p4=;
        b=RKSxCFxvZrkmhzYo6mkWYbG91+/z8McotnaIHQTa2UTWHO+eB6PB/wfBPgP+w6ym6B
         fc/03MqrC+wiQjKsh2PVQR4zyT6oKhjtUJc2Y+uZIuhWg+fZWy5It1LVCKkylKc+fpdV
         sTpQrzEl5CeTewStf0f1CfPJewXgNjgI7F8zHwuIn2LOCCbv5iNKxGCN8d9Y/TKr5OOO
         WvtiEEY6NrBTpUNEyyPqEctSMxTKo9pvgldOKj0B34CSljnBclK8k4Ohvn/oxz21qEaZ
         d06QBgqMGyP5MsKzSE6ScoFxEsAW1wxATI1j3ZgbwqLr0jQ6TP7RaHoZ1TIwd0XMx2Q+
         slTA==
X-Gm-Message-State: AFqh2kow8KblmRlh/XGLhhgsr6LW4SJtRfyxXiOiPBupxlsKDItPS6EW
        tHkjhR8nbpvGotck4ERCV+I47QqwvtXZH/b/E8BQ5g==
X-Google-Smtp-Source: AMrXdXtGx313XgK/UqyhWw3Kg0lBUOnb71WTm5zwACDHVNYtRVEhntCprIIOulq6Abidi8ievd1SJA==
X-Received: by 2002:a05:600c:34d0:b0:3db:2647:a012 with SMTP id d16-20020a05600c34d000b003db2647a012mr25922040wmq.40.1674719927851;
        Wed, 25 Jan 2023 23:58:47 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h17-20020a05600c415100b003da2932bde0sm892032wmm.23.2023.01.25.23.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:47 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        aelior@marvell.com, manishc@marvell.com, jacob.e.keller@intel.com,
        gal@nvidia.com, yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: [patch net-next v2 05/12] ice: remove pointless calls to devlink_param_driverinit_value_set()
Date:   Thu, 26 Jan 2023 08:58:31 +0100
Message-Id: <20230126075838.1643665-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230126075838.1643665-1-jiri@resnulli.us>
References: <20230126075838.1643665-1-jiri@resnulli.us>
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

devlink_param_driverinit_value_set() call makes sense only for
"driverinit" params. However here, both params are "runtime".
devlink_param_driverinit_value_set() returns -EOPNOTSUPP in such case
and does not do anything. So remove the pointless calls to
devlink_param_driverinit_value_set() entirely.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_devlink.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index 8286e47b4bae..ce753d23aba9 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -1411,25 +1411,9 @@ ice_devlink_set_switch_id(struct ice_pf *pf, struct netdev_phys_item_id *ppid)
 int ice_devlink_register_params(struct ice_pf *pf)
 {
 	struct devlink *devlink = priv_to_devlink(pf);
-	union devlink_param_value value;
-	int err;
-
-	err = devlink_params_register(devlink, ice_devlink_params,
-				      ARRAY_SIZE(ice_devlink_params));
-	if (err)
-		return err;
 
-	value.vbool = false;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_ENABLE_IWARP,
-					   value);
-
-	value.vbool = test_bit(ICE_FLAG_RDMA_ENA, pf->flags) ? true : false;
-	devlink_param_driverinit_value_set(devlink,
-					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
-					   value);
-
-	return 0;
+	return devlink_params_register(devlink, ice_devlink_params,
+				       ARRAY_SIZE(ice_devlink_params));
 }
 
 void ice_devlink_unregister_params(struct ice_pf *pf)
-- 
2.39.0

