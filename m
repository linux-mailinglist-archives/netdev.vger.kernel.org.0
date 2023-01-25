Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CF467B407
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbjAYOPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:15:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbjAYOOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:14:48 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB98159541
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:34 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ud5so48024981ejc.4
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rd1TFhrPWc5Cixe/mLDGedQycM+s5omKyq+tErE3Q9M=;
        b=GJqxgF1NyCe+DmSiHr+2WPqM4MMBnrUKd9vNGzB0aTdxUynepWQo0lcVPbpDrSbbfk
         HjYCHNk9+FLPJtidgIuw634Ya+viPKQ31RFnWHkrUlWkckKftcKdEiCvn+CtHLHbr5zE
         KnS83usJx1+Ndxli8mrTUydR+Db9A9RhbdC5shIXbxDLVOBzHvjPtTHpD5w2eUy1Vp5s
         z5ocxHs5laejAf+5IWLiplbar96u2yYt7AxVLWa6ARvcGMndJvqN27mU2W4JxXxa4lmW
         zUAUxKonm+6sUBfzBf+qjaWevzUlj0lHcNksJtTzG0V2STL5hLq/VJFUU78g4xLvrsNu
         EiEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rd1TFhrPWc5Cixe/mLDGedQycM+s5omKyq+tErE3Q9M=;
        b=LBH1IHijQftUlOxR6rQUtVTk315PCuMSd6G0Fw82/6hz3es9vuh+nKFm57bUdywf+F
         J68tZiPWP4bpj/FMm5L9eIE3c4qtGvkBTn9SGIv0mDiRNsRASAcGxE9i+PvFZ28VGwhJ
         udJS5L5QS/e70auFprGKEI/Y6HuL3JNlq42hVxfbVcx3X63ZRXpeRi4wBittrViEycaF
         b0gLDrE5XU5BUUZcfTCd/tR+pZLc0oj8bFumozHXhRemtUZuXMKVOghbg4Nz7/u3UldV
         FDpIaVtj0lp7aOnkgqabxdvoaAPzZUMJE3PZxzhKFNrJwl3wDzjTSo3LcdRLo46tWj1x
         YnvQ==
X-Gm-Message-State: AFqh2kq6AkP++a2J/hFl+PMPFnbA6dpmO2P/nyvMTxsDDB2iCUy89cAM
        T/WRkNBfXdhTXmI/2nvoQGAqJGGRy7i7TR7CLj0=
X-Google-Smtp-Source: AMrXdXvktJqWqI5t7tVKXN+fcdie5lYrNQBIsgXn4hf2DlplxrNFV3ZFaTwbEccQyX7nPitJ881RXw==
X-Received: by 2002:a17:906:3bd8:b0:7c0:b3a3:9b70 with SMTP id v24-20020a1709063bd800b007c0b3a39b70mr35555849ejf.62.1674656073038;
        Wed, 25 Jan 2023 06:14:33 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id xa4-20020a170907b9c400b008762e2b7004sm2374156ejc.208.2023.01.25.06.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:32 -0800 (PST)
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
Subject: [patch net-next 08/12] devlink: put couple of WARN_ONs in devlink_param_driverinit_value_get()
Date:   Wed, 25 Jan 2023 15:14:08 +0100
Message-Id: <20230125141412.1592256-9-jiri@resnulli.us>
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

Put couple of WARN_ONs in devlink_param_driverinit_value_get() function
to clearly indicate, that it is a driver bug if used without reload
support or for non-driverinit param.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/leftover.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 693470af548f..512ed4ccbdc7 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -10898,16 +10898,18 @@ int devlink_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 {
 	struct devlink_param_item *param_item;
 
-	if (!devlink_reload_supported(devlink->ops))
+	if (WARN_ON(!devlink_reload_supported(devlink->ops)))
 		return -EOPNOTSUPP;
 
 	param_item = devlink_param_find_by_id(&devlink->param_list, param_id);
 	if (!param_item)
 		return -EINVAL;
 
-	if (!param_item->driverinit_value_valid ||
-	    !devlink_param_cmode_is_supported(param_item->param,
-					      DEVLINK_PARAM_CMODE_DRIVERINIT))
+	if (!param_item->driverinit_value_valid)
+		return -EOPNOTSUPP;
+
+	if (WARN_ON(!devlink_param_cmode_is_supported(param_item->param,
+						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
 		return -EOPNOTSUPP;
 
 	if (param_item->param->type == DEVLINK_PARAM_TYPE_STRING)
-- 
2.39.0

