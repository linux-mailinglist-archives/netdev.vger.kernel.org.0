Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03D45A0AF5
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239098AbiHYIEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239195AbiHYIEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:04:30 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664DA564D5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:04:26 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id cu2so50775ejb.0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=srxGrVO76ra49mHxsKyT1OyGD8d3uD48+elNlBPQTyU=;
        b=Tvgn854lFD8CvFhPUY27B/D6iJqV68JRvIQ+idFUIhA3MBQZJxxSman3XD6W4S89zJ
         Rogj8go063VLJkURqcDwOFCzmxfC22pvfzW6qz4Z+RWUpFqgsrjTnTJOeEqt0Trq2V29
         u+jExPKdwae4Eg+gZ1e53M9phozlpOPYhh/yiIkQrDNCw2HFuvdMY3/iIy7BEvRSUyKm
         6ALRbxDMNO/IyAOem/JqgwBc6cGDOwrc8IKAkJES8X01YIb+ahk5D0++fYG6im1sz4Q2
         z3cvG4ORJaUBrJlm1cRS9tqL+8tzEQJKT4dSTj766cSpQ8aSHCvBPu+tNMBCmA9Ovcfn
         SyeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=srxGrVO76ra49mHxsKyT1OyGD8d3uD48+elNlBPQTyU=;
        b=n0xXVgDR74X+GpINcY5ZtdmeZtD7Px7phcLS7Mdh2gGgny/ewZK/CptTYtCIQntCIq
         PdxHbQGRztQv5HnGnXaDURhGrRbPAH3n9+bNbLQAhiWgaRoXf6TJgYjAXdI+CoXnEope
         iuRj78H+t6C6TjwDa1nambh+LfNOWMgs2ISqg5VRsGvDQq52/Wy7X9qVvt4xZykyu9yA
         zOw9XDJe5O5DfY4dLciOA6tKYwcb3f21L2zWELQUstF8hjL8orXqRaLyyotyis0Jp7VP
         fjGYV8IM1Zq9cp5z9kzNYjvEgYsYHJQ7FyT+DIKdIzH5O5eUn6Pty+NJ+FC0H/FW0edL
         t1YQ==
X-Gm-Message-State: ACgBeo21kBSzPGMM3lzOO/bgcEkvR1SZka3bS1FE9+YHMDJq/qGsMoWX
        jeAFoWPYjWo4XR453p90Ty4qd5LYAnRASbvp
X-Google-Smtp-Source: AA6agR7V01PpkXVdx7UXuaN6cKd1xf0BXO+SwemZM/J1hlKdDMBuczp7p154gOC0FJCZZPLEXi2N6g==
X-Received: by 2002:a17:907:2c67:b0:73d:c0fe:254b with SMTP id ib7-20020a1709072c6700b0073dc0fe254bmr1687078ejc.271.1661414664929;
        Thu, 25 Aug 2022 01:04:24 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bi1-20020a170906a24100b0073cc17cdb92sm2107433ejb.106.2022.08.25.01.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 01:04:24 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com,
        vikas.gupta@broadcom.com, jacob.e.keller@intel.com,
        kuba@kernel.org, moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch iproute2-next 2/2] devlink: fix parallel flash notifications processing
Date:   Thu, 25 Aug 2022 10:04:20 +0200
Message-Id: <20220825080420.1282569-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220825080420.1282569-1-jiri@resnulli.us>
References: <20220825080420.1282569-1-jiri@resnulli.us>
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

Now that it is possible to flash multiple devlink instances in parallel,
the notification processing callback needs to count in the fact that it
receives message that belongs to different devlink instance. So handle
the it gracefully and don't error out.

Reported-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index b2439aef4d10..4f77e42f2d48 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -3812,12 +3812,12 @@ static int cmd_dev_flash_status_cb(const struct nlmsghdr *nlh, void *data)
 
 	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
 	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
-		return MNL_CB_ERROR;
+		return MNL_CB_STOP;
 	bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
 	dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
 	if (strcmp(bus_name, opts->bus_name) ||
 	    strcmp(dev_name, opts->dev_name))
-		return MNL_CB_ERROR;
+		return MNL_CB_STOP;
 
 	if (genl->cmd == DEVLINK_CMD_FLASH_UPDATE_END) {
 		pr_out("\n");
-- 
2.37.1

