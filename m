Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF1167B403
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235426AbjAYOOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbjAYOOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:14:30 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0DD59276
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:25 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id qx13so47900896ejb.13
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q2KjxD4zgmaIUNc6/aI3TN30o2cK6AphaOMggV5OpJM=;
        b=mn6SBGM2uZnu4otiRDIUrz+nJ1GCQ+r+m3xQMUr43iB1UBiRAnHQbT9VdGuWXvqSfd
         WkGmm7Bpd/5JyPPbK1VZgj54Nr92gd6uIxuc7HwcRiAYjBsSHq7MLpuSWVrszHImIKMe
         OC0O8jfUbcbfTL2S70lG5E//H1uJe7xw00t4U5obJjVscwat3SroBwPM/0VsPQzCwA1+
         TF9RGIdDcwlki882sJU3ip1Ia36Cu+bk0pw6pamZkaE7i1I8Uq6GpG+vqtZbGhZV7NbR
         zmZ19ih8EwXOe1xlFP14Ij6j+x5ixwJlWENKPB6kzeTG6sFYFVBLDkXRp3gkpT0tjhIn
         1CRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q2KjxD4zgmaIUNc6/aI3TN30o2cK6AphaOMggV5OpJM=;
        b=IkKolGcDqGQ5QhoC/eZyh70xiy42v/V+pa8c2GPcHsoq3FrJKAXo98386p3QVbckGH
         dIoVmvhnjC+W5qY3x02QP5+Zk4aJ3XzOvpS7XV36uXrYC0YxRhOoj66S0++J4CSCoJzx
         M9mAHMAC1F82q6Czpy3SojHo8LRj1PbswVXO6YV8Gjf7yfwhJsQhnBn+3FMjYYo5RsYG
         D2HoEwXc7DKhdL8hbOMUDh9O0IbccymDzKtYOLiL3CmhN1Sy0xhTkTT3ikwudcpy1268
         urvUEG72vQnAInQOpsYm+wxURFQ4OUgT8DdMpWC6NmIB2nmlr1YdqS+7gozj65mGdWWT
         0BNQ==
X-Gm-Message-State: AFqh2kq8+jdNZ9CrCzxy3isY9jZPI8/xCmip7qKbvCZ1fLwOdFzZmIm5
        tnEFKE03IZHmOapdxbW5QqpTcFvjvxR+GXPBc6s=
X-Google-Smtp-Source: AMrXdXtF7r2UlytSL3oUvMpAVTcuR5wiLVs07S73W71VVitP8M7xDdd5JXBpXIYTajvCk1br6+vReg==
X-Received: by 2002:a17:907:62a8:b0:86a:d385:81df with SMTP id nd40-20020a17090762a800b0086ad38581dfmr46994350ejc.3.1674656064584;
        Wed, 25 Jan 2023 06:14:24 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id az24-20020a170907905800b0086eb30fb618sm2366478ejc.183.2023.01.25.06.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 06:14:23 -0800 (PST)
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
Subject: [patch net-next 04/12] devlink: don't work with possible NULL pointer in devlink_param_unregister()
Date:   Wed, 25 Jan 2023 15:14:04 +0100
Message-Id: <20230125141412.1592256-5-jiri@resnulli.us>
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

There is a WARN_ON checking the param_item for being NULL when the param
is not inserted in the list. That indicates a driver BUG. Instead of
continuing to work with NULL pointer with its consequences, return.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/leftover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index b1216b8f0acc..fca2b6661362 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -10824,7 +10824,8 @@ static void devlink_param_unregister(struct devlink *devlink,
 
 	param_item =
 		devlink_param_find_by_name(&devlink->param_list, param->name);
-	WARN_ON(!param_item);
+	if (WARN_ON(!param_item))
+		return;
 	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_DEL);
 	list_del(&param_item->list);
 	kfree(param_item);
-- 
2.39.0

