Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB43167B405
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbjAYOOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:14:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbjAYOOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:14:46 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD3359550
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:30 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id qx13so47901480ejb.13
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YYxeqF3Zn5ZSlrii+Op6Svhd80/z8dsw3BGSu2pt45o=;
        b=H7C8CYFop9b9Uki9n2RVKVqWLzPVSHxUMxC0ctxcdE+8VwMfal3DYu57T66LECxzpE
         WvqbCQ7J0WL2f4rSaCgGUwbywPjitSyqjA2TgcmLeagMmFo0nUVamdsjH25Fep7YnTXb
         C5/80RVDbAjqA71kpkY0oRT58C4pAKsImstLRjFvnAEw9OE02NnvVXo9XNzCxoziVJK/
         0TP8f5tjXdGvMLwXky6QSeBdQN6aAaF+5DSFg5gacotU+Wo9ZjrAyc7cPF6+LxlDEfyP
         eNfC3wTPKENAco5rT399Ft8tZZq2bSxN2ckRsl/GHrNu7ONDaZCwoI4ON5h7S5Dv12tr
         yHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YYxeqF3Zn5ZSlrii+Op6Svhd80/z8dsw3BGSu2pt45o=;
        b=MCjE+7TcclPzvjPySyvkFaqrzRn9yZqDGYaPNbmdFPvLIjTq9NwzlGYkw9uv9XOGRB
         OliYT+QLDO4nI0mGC8xttZf/7RRU5iDQk57d+C0TQsFYrWzWemb0U/31JpuzK1pOyeM2
         NG/csa4SY7LPicslBX+gp6ef5XVdeF/vCoVFg2tbuk1eMZeeFlWSwZYF5N4XiShXYEK2
         Z/m5jNZNFasG3GWLcnkQ9yHl1k3TY7jTfgASsY/v5sYIHJxdS9ZLp/rRqIa8h5MDjWOn
         phxMfPakTIj2elU7UOY2pUjSAvJSJHxvLHtNFrzYWuDBZfF2ZkT0Mxs/3TOcABTn/+TP
         SOZg==
X-Gm-Message-State: AFqh2ko02msseRJCu8SDvUGXrYshiurMA1tz6pTdjya1+yrG7HYKNGw9
        PwjR0hCHhNZ4MSZkU9meccbNSb9lEIsnnC0o88k=
X-Google-Smtp-Source: AMrXdXtcQaGOBKXB3/rN1SgzfYeo+hA7iOlzO/6ASYOyzzro9ityTUMD3+JKcsYAaDZ4BpiNAk5QZg==
X-Received: by 2002:a17:907:a4c6:b0:86f:1283:7b1d with SMTP id vq6-20020a170907a4c600b0086f12837b1dmr23368873ejc.71.1674656068850;
        Wed, 25 Jan 2023 06:14:28 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id fx35-20020a1709069ea300b0085d6bfc6201sm2418103ejc.86.2023.01.25.06.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:28 -0800 (PST)
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
Subject: [patch net-next 06/12] qed: remove pointless call to devlink_param_driverinit_value_set()
Date:   Wed, 25 Jan 2023 15:14:06 +0100
Message-Id: <20230125141412.1592256-7-jiri@resnulli.us>
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

devlink_param_driverinit_value_set() call makes sense only for "
driverinit" params. However here, the param is "runtime".
devlink_param_driverinit_value_set() returns -EOPNOTSUPP in such case
and does not do anything. So remove the pointless call to
devlink_param_driverinit_value_set() entirely.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/qlogic/qed/qed_devlink.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_devlink.c b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
index 922c47797af6..be5cc8b79bd5 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_devlink.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_devlink.c
@@ -198,7 +198,6 @@ static const struct devlink_ops qed_dl_ops = {
 
 struct devlink *qed_devlink_register(struct qed_dev *cdev)
 {
-	union devlink_param_value value;
 	struct qed_devlink *qdevlink;
 	struct devlink *dl;
 	int rc;
@@ -216,11 +215,6 @@ struct devlink *qed_devlink_register(struct qed_dev *cdev)
 	if (rc)
 		goto err_unregister;
 
-	value.vbool = false;
-	devlink_param_driverinit_value_set(dl,
-					   QED_DEVLINK_PARAM_ID_IWARP_CMT,
-					   value);
-
 	cdev->iwarp_cmt = false;
 
 	qed_fw_reporters_create(dl);
-- 
2.39.0

