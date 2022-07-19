Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B242579373
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbiGSGtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbiGSGs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:48:58 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5C628720
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:57 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id w12so18245991edd.13
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gEkTtJMh1B+UgToO48NeKJwfaZs0BPB59HhPklxhzys=;
        b=w686WnM2Kkfpy46VJkGkZUn/+eqD5O7ZeUprzKBU/1ZUDje0wJ0XpXpuCMLr6UKxrG
         rZgU5CtKxuELQ6k3mZnnwCQ6joXasga2cFt/R0SD5oG2niS1veRgMsopo5FjKkdX2tlY
         TUSkRQP/c6nc3UG09kGQGjnWjDmi1aHshyw1rO/g2U9SlPHF1dQDoXOjDfS2yDb+4tFI
         vr1xC1K/m3unqazkPlc3O6guaJYZj0Meu5yFO87LQ2bcg5GyD94nGy8BgZP5H7y+Qghk
         L2LP7FJd2yZOtgpjhZZTWNAbnH+Fg77q0oHiBhM/Nfk1ioUIZpLZSra92DkebQ9hVAhQ
         xCeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gEkTtJMh1B+UgToO48NeKJwfaZs0BPB59HhPklxhzys=;
        b=whFCdRrwcZjuBUSTSVtoecrWj84huaKwwABO9iGVE5EBc3AvjzMDb9H8IxwzzQnfNI
         hZvYAaGvl5S+RUWX+B2Rs9SEOE7Lb8ThBuhrgk6YDsln0FdcPhE4Ve0e+dNsN3B0f8DV
         POm2KTLQ5a/mPJkXoxXnl23yoCfuWEn7f9JXRVXiSgZ6gjkRLDoGRFkXAfvJgsTnVB6V
         jjmryKXQNZ2vAFP0RlFmg7DTceY8sHyRHRS8iBtdS+o9xn47V54bOfNZ7ECacWqnkW3H
         1JjsS/cHKKxlHPBUVRLXwIm1IbLdXoE8M38LijALNLmGRorrlsaxCSJgHaHp8rY2XiX/
         s0vw==
X-Gm-Message-State: AJIora+xa+uwWC6QVXX7KbZiFY/tslAnufFZBgg+vuiXcFcWMPIifQcf
        Sluw8b98hssIPDU0d88s/P7+S98gkQI70dL8BAk=
X-Google-Smtp-Source: AGRyM1u7Dlf0zduuWndctQ0wFX3PhzbPfuESHZpzx5yHbjjEG1gJUi5VVAe5f2E1rMehMWbWzaYdKg==
X-Received: by 2002:a05:6402:280b:b0:43b:5d75:fcfa with SMTP id h11-20020a056402280b00b0043b5d75fcfamr14592655ede.114.1658213334557;
        Mon, 18 Jul 2022 23:48:54 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id le20-20020a170906ae1400b00724261b592esm6242654ejb.186.2022.07.18.23.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jul 2022 23:48:54 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: [patch net-next v2 04/12] mlxsw: core_linecard_dev: Set nested devlink relationship for a line card
Date:   Tue, 19 Jul 2022 08:48:39 +0200
Message-Id: <20220719064847.3688226-5-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220719064847.3688226-1-jiri@resnulli.us>
References: <20220719064847.3688226-1-jiri@resnulli.us>
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

For newly created line card device devlink instance, set the
relationship with the parent line card object.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
index bb6068b62df0..f41662936a2b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
@@ -105,6 +105,7 @@ static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
 {
 	struct mlxsw_linecard_bdev *linecard_bdev =
 			container_of(adev, struct mlxsw_linecard_bdev, adev);
+	struct mlxsw_linecard *linecard = linecard_bdev->linecard;
 	struct mlxsw_linecard_dev *linecard_dev;
 	struct devlink *devlink;
 
@@ -117,6 +118,7 @@ static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
 	linecard_bdev->linecard_dev = linecard_dev;
 
 	devlink_register(devlink);
+	devlink_linecard_nested_dl_set(linecard->devlink_linecard, devlink);
 	return 0;
 }
 
@@ -125,7 +127,9 @@ static void mlxsw_linecard_bdev_remove(struct auxiliary_device *adev)
 	struct mlxsw_linecard_bdev *linecard_bdev =
 			container_of(adev, struct mlxsw_linecard_bdev, adev);
 	struct devlink *devlink = priv_to_devlink(linecard_bdev->linecard_dev);
+	struct mlxsw_linecard *linecard = linecard_bdev->linecard;
 
+	devlink_linecard_nested_dl_set(linecard->devlink_linecard, NULL);
 	devlink_unregister(devlink);
 	devlink_free(devlink);
 }
-- 
2.35.3

