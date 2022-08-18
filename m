Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5386C5983AA
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244867AbiHRNAz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244859AbiHRNAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:00:48 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B3E6747A
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:00:47 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id s11so1766489edd.13
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=hE3TQw40VsNVsq40Dxz5mY7v5/vs4c2dK5Xb3FNaFbo=;
        b=VDH52EDGBrXu3+sSPlM683iuH2sZAh5WfORZfl83Vk1m0Enuun2Lx8sSGmaF1u4P7S
         IHOEZON4zescv6Y0/xvWEHhXuzetTexO/I6Dt+c0O76Z3uDyyarVfnrxx8elq7kS48mg
         S63t95goOAJ8NVvL8WZLOsGlhkVfbmts4bsc5dh1BPaWIZkscdCfwWuNWFjGf757aJSe
         IYYTYrr9yhU6SLG5NnBIYaQFfUZM3doEmNKehs0OK6deCUhwaDXrWz4ChEb20K+//C2r
         JMX1LaFf5URqKpuOrbS/RKgUcnyaDc01eaNioWy1v7d+X0RJuoVNKvCgDpFFHg3qahz1
         ut9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=hE3TQw40VsNVsq40Dxz5mY7v5/vs4c2dK5Xb3FNaFbo=;
        b=Jm98WcI9hHFn4ta0Xoh7WqWoW7Jix9qX+U1PbohvBg9qgyHng1tAS0N8jsKMy0PF0R
         CzTDUPS8YqQupOrYv0AmpJQvqo3glGyZxC+61I1uPDkgRzIEbbx5zJt01Fxs1KPNy6FC
         hGHspLOFhMx8lUU1KE7ZDNr4F0s7Iz7LKM8AmEL0MhEbuJFgN08aXvqnr6qgGcAPl+wn
         P9/zPud+VivL4d6uiEQVp/g6MNgcDk7fQYotPdSCec0Z9VEYy1kmQwNp5aBu8e1cr91+
         4d/Pww8q21SdFKCAheyOm3ZGXVQ9jUpu3oUqJIXmHMxY4nGWwkx9x/5P5HiW3f8c/PBf
         rLkQ==
X-Gm-Message-State: ACgBeo3p83onPYWacuwpR4SdSuwJgFBfk5ZRJIfdonPimz9fgo8CPH6C
        kqv0Z1c9k6TAAR0n+JjGTlDz/DlWwsLKq5M4
X-Google-Smtp-Source: AA6agR4h7TBBeLSXcrmNKJPWdZc4NMVsAyzP2Y4gieIiNvrCqx3nRyaLffY/8pZwJdqqkZtLebv+jA==
X-Received: by 2002:a05:6402:4442:b0:43b:c866:21be with SMTP id o2-20020a056402444200b0043bc86621bemr2289102edb.28.1660827646377;
        Thu, 18 Aug 2022 06:00:46 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id bj5-20020a170906b04500b007307c4c8a5dsm813290ejb.58.2022.08.18.06.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 06:00:45 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next 2/4] net: devlink: expose the info about version representing a component
Date:   Thu, 18 Aug 2022 15:00:40 +0200
Message-Id: <20220818130042.535762-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220818130042.535762-1-jiri@resnulli.us>
References: <20220818130042.535762-1-jiri@resnulli.us>
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

If certain version exposed by a driver is marked to be representing a
component, expose this info to the user.

Example:
$ devlink dev info
netdevsim/netdevsim10:
  driver netdevsim
  versions:
      running:
        fw.mgmt 10.20.30
      flash_components:
        fw.mgmt

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/uapi/linux/devlink.h | 2 ++
 net/core/devlink.c           | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 2f24b53a87a5..7f2874189188 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -607,6 +607,8 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_SELFTESTS,			/* nested */
 
+	DEVLINK_ATTR_INFO_VERSION_IS_COMPONENT,	/* u8 0 or 1 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 17b78123ad9d..23a5fd92ecaa 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6670,6 +6670,11 @@ static int devlink_info_version_put(struct devlink_info_req *req, int attr,
 	if (err)
 		goto nla_put_failure;
 
+	err = nla_put_u8(req->msg, DEVLINK_ATTR_INFO_VERSION_IS_COMPONENT,
+			 version_type == DEVLINK_INFO_VERSION_TYPE_COMPONENT);
+	if (err)
+		goto nla_put_failure;
+
 	nla_nest_end(req->msg, nest);
 
 	return 0;
-- 
2.37.1

