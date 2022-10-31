Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96C3B6136A8
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiJaMm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiJaMmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:42:54 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E76BD2EB
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:42:53 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h9so15851005wrt.0
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 05:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X1MyJqO1mdXn8/laNFPE2bRj0/yLyArfqMTcNfqAWXY=;
        b=SLR60ghMYie6Vs+r/G1It/O2Z7bArsuQRxCSm/w7gE8qnbfJuCfC2ZhYvW5ImiW752
         N+6XL+xL3bS1ILL9b4ZUEuN4wrpNBSWzfkJwp70gb67j8kfF/jaLo85kNH7R5WxEEA2s
         xne36lsFlTrf1mHOLtyPKMaAaJ/u/15lddYPhGDhL/o+PL14T5AXEic/1tZi/Me1xcPI
         1pzadaibGerToXpxRjRkbFirgqCf5HRhDyN4L3jMabc3Kc5QL4aWdTiunPZ1gEoLTvk+
         wJGID1OjoUhVPkk4T9QE8dpqNGL3vcizV9fTXVU57MxH31u1zWqMyJS7T6M5uCmEYOUB
         RMeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X1MyJqO1mdXn8/laNFPE2bRj0/yLyArfqMTcNfqAWXY=;
        b=AEBXGiPMDVRmjgV+5y5hujAkC5ohR9Uvy/U5+CL3stX7OJQqYfLANSkRdPGcS1ent3
         yvyyAdSv6vF8jhV+v4Q/a1T2R9N3Wvl43lKEKWKFiZQQ2OxhjmTJeH8Dpac+WjM5sYSp
         7SVx3QeoHn8UgHwdP6Adfljz+S/lgQHKwYBRvOa2a/0Q7X8/lglvmUczUZwt5iLSn2/a
         6JVOcqnBe1J7PpGwv+5NbTyoGh5o7lWEiWTcIsZPBW+mUcJQqv2wGlEiCzpEGh5GtaOM
         oXcu0B+1RrtOpblWVdX0b47isTaVQDeMeQK4C6lCHZoFp7Hkxc4k5JgExG+wM8BhS1nv
         X5zQ==
X-Gm-Message-State: ACrzQf0MSYSmULHzGpGXLkf/4jiU0/o/ZgrpuPL/Ugf2KCn5q9+0yke7
        KEOBsDDbUZtinUUu0zEAWRHm6uZbXbwHNgo4
X-Google-Smtp-Source: AMsMyM5afFyftqxpdysLx287f/wH1jZNrSVwvSZypRniM9Q0QBrshV+hwA8GiPyp7dvP2kgKMD+mHg==
X-Received: by 2002:a5d:544a:0:b0:236:77f4:6e15 with SMTP id w10-20020a5d544a000000b0023677f46e15mr7978214wrv.117.1667220172012;
        Mon, 31 Oct 2022 05:42:52 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id m24-20020a7bca58000000b003cf47fdead5sm7089985wml.30.2022.10.31.05.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:42:51 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v3 02/13] net: devlink: move port_type_warn_schedule() call to __devlink_port_type_set()
Date:   Mon, 31 Oct 2022 13:42:37 +0100
Message-Id: <20221031124248.484405-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031124248.484405-1-jiri@resnulli.us>
References: <20221031124248.484405-1-jiri@resnulli.us>
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

As __devlink_port_type_set() is going to be called directly from netdevice
notifier event handle in one of the follow-up patches, move the
port_type_warn_schedule() call there.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 868d04c2164f..3ba3435e2cd5 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10000,7 +10000,11 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 {
 	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
 
-	devlink_port_type_warn_cancel(devlink_port);
+	if (type == DEVLINK_PORT_TYPE_NOTSET)
+		devlink_port_type_warn_schedule(devlink_port);
+	else
+		devlink_port_type_warn_cancel(devlink_port);
+
 	spin_lock_bh(&devlink_port->type_lock);
 	devlink_port->type = type;
 	switch (type) {
@@ -10095,7 +10099,6 @@ EXPORT_SYMBOL_GPL(devlink_port_type_ib_set);
 void devlink_port_type_clear(struct devlink_port *devlink_port)
 {
 	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET, NULL);
-	devlink_port_type_warn_schedule(devlink_port);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
-- 
2.37.3

