Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E2F67B404
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbjAYOOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:14:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235492AbjAYOOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:14:31 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD8159269
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:28 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id qx13so47901216ejb.13
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cCcvigqHW9b86rA8k/1atgagp1ktjzYjfZEE64VdQWY=;
        b=haplY+SLoeA28LXcx6pV7e8WAb7uioqO8VPbE93OabDo3tj3XeKyIua0Ez2qLOKCng
         S2YDlv15Vd+lBk1oyyduzT+UMWvGSPL09GM5c/dKBLWLwN3rNJgulNwaFCE46ggiEvi0
         lLgSzwz7jPeenj25ydDb3lV6oUa+aIGG2e5Jiwo9ZDWbFquaBJMmyPJ2c0MTbNgIi2Ma
         nj5ogPEq9684AP40bf/vOUQ3tODcklts+Zs8Ugp6kURYvwK7VZgIZhWcLB0Ro/EVUMZf
         TQEk8IV3P7lEs6yOFCwQPZTDVlMN1KO2YRx2NP4uFhJ/zFbNwje+Xsm/vyaoY6qprP/R
         5rvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cCcvigqHW9b86rA8k/1atgagp1ktjzYjfZEE64VdQWY=;
        b=rtGHKFgtcFS/pNUw024NOsGmctCnF80gHUOefVeQTfv4vuXkHX3A9nGZQts56JKdkv
         2Z+cm7dWIyYvh79VRY37F8rRz7+S+x84FiYJb+FVEvHQ+NUpPR0s57/XeiK9wh0BvgkN
         Hz64QOjoT34L5jw/0DQ+abHAKTvDtsCm0GefX35hs3uwYMgbLdVLxRX/i5e9yZCdqmz8
         NtuV5acrPGhbK/sklkH5d5WsLMAhewxLlleCH4lnCzA9KfV95/dpZScv0UxzaKri2ATP
         YNOJbkxnCqZEpE7GSHgHVRIR3Q6SWHeifnWt6Qe57UUjLwiXXecJSAXIkDdcifN5+NTX
         ezTw==
X-Gm-Message-State: AFqh2koqqcEKUP+Z8TvOOl3CU9pt6nn/47oNYUdWSJYWgC87WC8CwPaO
        3N+lZaFVv1/ea0F8DeWzfUSVBMRS9gUPupH8WZY=
X-Google-Smtp-Source: AMrXdXuOxsUiSvapO+0s0632uPn4B1QabFHMwKQN+yqxxJqIE9LHjO/TGVeEhknnh0l4DWCQgXrpJQ==
X-Received: by 2002:a17:907:7248:b0:872:b1d7:8028 with SMTP id ds8-20020a170907724800b00872b1d78028mr45227230ejc.3.1674656066750;
        Wed, 25 Jan 2023 06:14:26 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ks27-20020a170906f85b00b0085fc3dec567sm2444039ejb.175.2023.01.25.06.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:26 -0800 (PST)
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
Subject: [patch net-next 05/12] ice: remove pointless calls to devlink_param_driverinit_value_set()
Date:   Wed, 25 Jan 2023 15:14:05 +0100
Message-Id: <20230125141412.1592256-6-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230125141412.1592256-1-jiri@resnulli.us>
References: <20230125141412.1592256-1-jiri@resnulli.us>
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

