Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EB967C541
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbjAZH7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235993AbjAZH6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:58:53 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181A061D60
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:51 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id q8so545752wmo.5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lj7KarjuxPadhr9CQIWx51afE00/MSL/XrxMtdZLvSk=;
        b=V2xcq3OIEzasBVkS40FmRwxylv4TceRjWpCqIcKSNUKaVQONytdfG/fHlSpv6DIO7B
         nGPzPn+P2UffTL8oYBXIH/Wtqc7qkOmJP+obdH3fuPJOgtKQdkz2EHN+2wjwYAy5zysq
         N68pvFu96/t1BPpP3oMnIO1D6x6oiNDoIKERdcavOLoNx9kqx9JvI7mdRiVYkW6CR6O5
         NZQQUTqaP4TFf/VKDN+SVvCd7aRd2RJtv2DHc1GzTMp35g6+lsTkMdB03DGFiko+91UO
         c4GzGfZR17GKHZ/l4JZWN4SD3XTm9TQCFPIMA923s+1MCSM+2/BkZkTiqaqv+T9ixIdC
         +nWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lj7KarjuxPadhr9CQIWx51afE00/MSL/XrxMtdZLvSk=;
        b=rWXHoDq8b7kigxUaKF6Ka6EP4WJtNr4sZtCsLyoNUG3PwOLB/A6meLngM2V8TvS8Ob
         s7uaA6nZiCZXHsl6SpdWP0dgb3JtUE/hDKzkNpbAbW9AEpgfeRJByLh4W0e/r2XfREa3
         d1dQBJRKb/SeTb33ehyc5jBnDO/fjsdd8FG0yO8/K9PU99uCsP6meAZudZ0BcnXpoH03
         j6z4jup8cnWyLKhghkcFV/wrq94IoRImmHHKPkuqWkxjJfWDTv+hlFXyiKLGlzFoOuRF
         LhKhWp+UFWrlNl0FpBnIShYh1OPbtsbyTG0CXb2efg3DGYBx24ntjeLRgexJh8FOrnkF
         9YFg==
X-Gm-Message-State: AFqh2kpZs5lcuhgjj9mKFvUAL0cUS1xoY4lPQ3DhM79TovI2sWeGIeua
        JrI7FVTWR3KkVqCYUZtJfso36JWAuWqNu3ZXMQyChg==
X-Google-Smtp-Source: AMrXdXsQCkbcnP54jnOA/fDai+GkegWEWICpQvm6G2fsCsmx+9ukMp/sanodpT2CrRCY6/QAtJT8hg==
X-Received: by 2002:a05:600c:540d:b0:3d9:fb59:c16b with SMTP id he13-20020a05600c540d00b003d9fb59c16bmr31462566wmb.36.1674719929485;
        Wed, 25 Jan 2023 23:58:49 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id i21-20020a1c5415000000b003dc23574bf4sm727957wmb.7.2023.01.25.23.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 23:58:48 -0800 (PST)
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
Subject: [patch net-next v2 06/12] qed: remove pointless call to devlink_param_driverinit_value_set()
Date:   Thu, 26 Jan 2023 08:58:32 +0100
Message-Id: <20230126075838.1643665-7-jiri@resnulli.us>
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

devlink_param_driverinit_value_set() call makes sense only for "
driverinit" params. However here, the param is "runtime".
devlink_param_driverinit_value_set() returns -EOPNOTSUPP in such case
and does not do anything. So remove the pointless call to
devlink_param_driverinit_value_set() entirely.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
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

