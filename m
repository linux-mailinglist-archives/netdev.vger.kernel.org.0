Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4580B691C2D
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbjBJKCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231889AbjBJKCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:02:03 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA957B17F
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:45 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id o18so4497407wrj.3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vqeMYLZK1D3XltelOB+dJlBhY1FHZDMpdLZyMtZbIVU=;
        b=79KsGadBwRm5l3m5KB+C795fr2bduXsQW/T/BSwvgJY4NSG1ljOF/sqf5xs+CHkNZ6
         4utti30aGqSMALoq+a5h7Z1YbEbYqx72QFGTT1mhm/vEP4iAjP9tMquejxx5QwF9zrFv
         sPEb009/6ZDTJTNflmgTwzQPHL2rxc3CFp1sm0andLWgIkScjy707xCLXb1AILHKGbT1
         w9pjKU+FA4gb4AJJ2AHaPcKoT9vbnPlUG24eWvGfpIExJltY3IhcpTTo+u1FSltMu1ML
         hYMxweLFoPRAAl6UKADdBvOXcsTBMD2wyLBG+3Gj9tRnI/LMreKU8mIUUutpu6NBe2C6
         hCJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vqeMYLZK1D3XltelOB+dJlBhY1FHZDMpdLZyMtZbIVU=;
        b=jkf2llzXy0h7/LWys7qGEHBbPuccaftcVM3YgFHlVEiEqckFDKhv4VaA/gnvDPbDpU
         AKf8YMfEg0pnkZKcmQTpdP7Fvj/LJMPFiM4oH1CEpXGpP4ooEmPasiLgUIn+4rMdolN8
         tCjGoUNTsgQiwPtz+9moPu1Uo4KBnNT+ThxFHWfVv6qRXHBAK15y9c6dN0Dyc+CY2TPB
         Vr2SAIiNWVDQ7i2qJpVCUSbhiFanePJGqOymHnOFUP7XDYl2V3Cc1UDAa1BqYatRCbzX
         QWJXaG9cGUhCi015WVuYiA9wo5x41dTTB+jhnYrcJmlrCrIRzpn14y7T0bdz4IwNcKQ0
         pHtg==
X-Gm-Message-State: AO0yUKWzN1tpkfhSW659jyGfNhosEYSCNGYjjpP72TGKkKCPa/zggg/q
        hHONpEXyHTOHGiPh/uddGvJhmrYHBlPvH6j8jjY=
X-Google-Smtp-Source: AK7set/cNCssZRCPFUI9K0x40KVvj1NtwucE0F8P2KH5d8S+oigPmcxFSSHzd8GUhpoH4xqur9GO8g==
X-Received: by 2002:adf:d0c2:0:b0:2c3:e7f5:be8c with SMTP id z2-20020adfd0c2000000b002c3e7f5be8cmr13908281wrh.26.1676023304039;
        Fri, 10 Feb 2023 02:01:44 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c13-20020adfef4d000000b002c3db0eec5fsm3185225wrp.62.2023.02.10.02.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 02:01:43 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com, simon.horman@corigine.com, idosch@nvidia.com
Subject: [patch net-next v2 7/7] devlink: add forgotten devlink instance lock assertion to devl_param_driverinit_value_set()
Date:   Fri, 10 Feb 2023 11:01:31 +0100
Message-Id: <20230210100131.3088240-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230210100131.3088240-1-jiri@resnulli.us>
References: <20230210100131.3088240-1-jiri@resnulli.us>
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

Driver calling devl_param_driverinit_value_set() has to hold devlink
instance lock while doing that. Put an assertion there.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 9f0256c2c323..38cdbc2039dd 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -9682,6 +9682,8 @@ void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 {
 	struct devlink_param_item *param_item;
 
+	devl_assert_locked(devlink);
+
 	param_item = devlink_param_find_by_id(&devlink->params, param_id);
 	if (WARN_ON(!param_item))
 		return;
-- 
2.39.0

