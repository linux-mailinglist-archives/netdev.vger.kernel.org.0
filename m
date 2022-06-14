Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B23ED54B154
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237862AbiFNMhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355067AbiFNMfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:35:46 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B46594E39A
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:33 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id n28so11412874edb.9
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0AmakWZbTt3nB/c2JUTedko0ApXUplS/tp6O1froRbU=;
        b=kAbeV/gHG00msae3ZICHrofYF+kasw9U42zUWregdA0rjaW+Zh3WFegCB6C2Jg6C/p
         lWLO1Icj+3J3q9yQpK3gfIBIRr5Tb2Otvff4t5EXHH6l1tB/xyPAua1mlPjW0+LsG/dT
         Q69M8ZKH6vLD1H/SojfQp3/uka22bzwSTqpANGXR3UW2lazcNpcFIWrcaaKNtXvpOPek
         VY44X4RXMmu2QD+zD3suA6lAvFsBOe0uGcI9B25SE4ccXW5GkxxpzF2f80y0BQSskBuy
         mvNkG5kZg4ew+VAtFKRxfL73tJlsiDuIfgfBYr4LXbrksdjvuyjha1xvCBy62VloLX97
         isAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0AmakWZbTt3nB/c2JUTedko0ApXUplS/tp6O1froRbU=;
        b=twuiElibmVzz8wfI65h2/j43FnqezGbv2I72fwer8dJ5WCgrOFTy6R7loEYpxnSSYV
         qTBGJdGgMpiw/7ygTW9dht/XtBJapvlRbVpf85kPhN0+DvWiUBG0Ana7tqhO2PTIMNLt
         5bQ4M3wz14ltIjwdj5V0kY/XkEtFR5OjNnLliuNpV61vvU887VKYSdKf2PcTxq/+yoDC
         yRHX8w6rLPTRuiRJxCLMeusz2zdqZUbXOHbzKhXm5iiwJsw4runImBI64IptY2vVBOvM
         qDxfugFesHHexRjINzTuQLS7l6na9/wHK6Lk5f+wlMqphkPBlD7ms/kOuXkbsJm+qc7V
         Do9Q==
X-Gm-Message-State: AJIora8b7sEAnhTU/01QYE5VGl+TXTEC0EaHQ5xGQQZl0w+wjTxHUM/g
        LtlcDs+wdeDf4BFCS/LYK3ls3qpdvRGG2OVBCRg=
X-Google-Smtp-Source: ABdhPJym/vzD7vXC0586/8mVS2A5YpJ9K0umq9n3a1L//Vd03QgvM5U2QtXffp8TczSvz9tNI/+wdg==
X-Received: by 2002:a05:6402:56:b0:431:6f7b:533 with SMTP id f22-20020a056402005600b004316f7b0533mr5786864edu.333.1655210012326;
        Tue, 14 Jun 2022 05:33:32 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id p23-20020a170907911700b007121295f08csm4899953ejq.219.2022.06.14.05.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:33:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: [patch net-next 03/11] mlxsw: core_linecard_dev: Set nested devlink relationship for a line card
Date:   Tue, 14 Jun 2022 14:33:18 +0200
Message-Id: <20220614123326.69745-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220614123326.69745-1-jiri@resnulli.us>
References: <20220614123326.69745-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index af70d3f7a177..d12abd935ded 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
@@ -102,6 +102,7 @@ static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
 {
 	struct mlxsw_linecard_bdev *linecard_bdev =
 			container_of(adev, struct mlxsw_linecard_bdev, adev);
+	struct mlxsw_linecard *linecard = linecard_bdev->linecard;
 	struct mlxsw_linecard_dev *linecard_dev;
 	struct devlink *devlink;
 
@@ -114,6 +115,7 @@ static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
 	linecard_bdev->linecard_dev = linecard_dev;
 
 	devlink_register(devlink);
+	devlink_linecard_nested_dl_set(linecard->devlink_linecard, devlink);
 	return 0;
 }
 
@@ -122,7 +124,9 @@ static void mlxsw_linecard_bdev_remove(struct auxiliary_device *adev)
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

