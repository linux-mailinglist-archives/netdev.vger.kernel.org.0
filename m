Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AABAF67C53F
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235906AbjAZH65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:58:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235766AbjAZH6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:58:52 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C300759B47
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:47 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id q10so885978wrm.4
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tHB5/8VGIX3qSvl2MGF3+N7cMFhAvrj6B/ZQMhNtBUI=;
        b=EfmosHI4rOVeVOEuI69XCxbztKpLixmcWsnWa1ZvgxjWVQWyGM+ZRs+HLkby9L6vD1
         pj+zCf5s8sPbEE6BtaQupILuZzo2kg3os8epSpNBE3MkgpjIpniJ4u1CjuvM/0fE7q08
         +dXinKckEc1z+mnXGtQ/YzeUy8U7UVn9iSH4Kp7ykXsgEbN0AZLnLxWtei3H8xzuei0+
         tIhN1u1wICEzFQcByEApw5HEX1+CDm5HGxrKys5zp87xuNcU9/nzPJ1xstSeL/5k5O4u
         UNpL61SFVbAvMTORnmB+kQaCacu5U3EebPVWILDREiRGUkDsi32x+tpNtGrAXuHaP1ua
         a47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tHB5/8VGIX3qSvl2MGF3+N7cMFhAvrj6B/ZQMhNtBUI=;
        b=zYhKEBhiikV2uxSiZGBIdi7FTbLNEjnjS//c/uRS/4F+u0V67jgPB/8NjnRxSoSBQF
         YbOFm8wYedXZCeXSn4zeqFvolvmB6xFlg/07JNZaQc2+DvqUXm4mcys2DvGLiqalBNJQ
         4JRhb5U3QQkKbTV/W+DXO6AsR3eNECaFWmDuSX04vKQKNX4DclGVHGHK2fcl+Q+7oIKi
         3LnJ7fzhlSL9iqVeObVnbwZGJfNva0rT/8J0836PE3auRpc7flXvtWddFkQMcdxYaSfI
         wXPt78MQPAq9szryo3Bzec3Ueal/POqjaunAx1emYtOrn2Y2MBQJwVlsiFZwchDR9+HQ
         h73g==
X-Gm-Message-State: AFqh2koLjzDFk0OVXh2uey6rYESNWJDU7Dx22ehdTHGQeiADaQi4dhHo
        LKs3uX+3qUcbSti12DmBxPk0MTuD4RzzExrSOBNmWg==
X-Google-Smtp-Source: AMrXdXsEO3K5PpnUVx9sTn9/edGXEQfZ/aZluk9pMsf+IQ5ZeWtPHsIxQdPvjTL3cu2Fg3I9ewIzVQ==
X-Received: by 2002:adf:f4ca:0:b0:250:779a:7391 with SMTP id h10-20020adff4ca000000b00250779a7391mr30464133wrp.47.1674719926346;
        Wed, 25 Jan 2023 23:58:46 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g11-20020a5d488b000000b002be5bdbe40csm677638wrq.27.2023.01.25.23.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:45 -0800 (PST)
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
Subject: [patch net-next v2 04/12] devlink: don't work with possible NULL pointer in devlink_param_unregister()
Date:   Thu, 26 Jan 2023 08:58:30 +0100
Message-Id: <20230126075838.1643665-5-jiri@resnulli.us>
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

There is a WARN_ON checking the param_item for being NULL when the param
is not inserted in the list. That indicates a driver BUG. Instead of
continuing to work with NULL pointer with its consequences, return.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
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

