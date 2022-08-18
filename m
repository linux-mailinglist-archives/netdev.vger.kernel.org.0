Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3DC95983AC
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:04:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244627AbiHRNA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244864AbiHRNAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:00:52 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC3574BB1
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:00:51 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id y13so3053995ejp.13
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=rkpsaBkB9p4iPG3YdyRDOTbtXlIb/IwRVf73wz/63iQ=;
        b=GUIu6ExWtv/BdFIeuBJz52vBIRjWCyKD8xI6K7nuOE3r17ZsLUnefpVxErXIJvzHap
         mdkGad7oZ79yG7eeKhdLMqbokxNJHPXrU3s5ck8hKzLkNY7ylK1vVmfb7CeYUgtp/Eeu
         0P2y+/jvk3TShRWSXWXKgmkQd8zQmueXgiSNmwEJx9b8cdJXlMnozuTYmWZGhhMJxt6z
         4Ovmt+TN001SsgROJQLnZ7oQDAnXxTlcoIlWbcaiohs6WptsxN89JeW8F6zSpFcRifXi
         u8YjNsbsiQwTgZ5cWn42ttXa3vcvyGaLk2TKKN/GSaOagICnNj6FeTsqhrCpjM1djxrW
         xCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=rkpsaBkB9p4iPG3YdyRDOTbtXlIb/IwRVf73wz/63iQ=;
        b=0DaDnnz3TEqBllQIub5ORnhmQP3A3QF8vpTHj29dN0Ce0kolcJjik3c7KXk9fk3AJ9
         jLLMfFD7G2Q0m7bodH7jrv1BO6hS03NGwS7npw1rwdAGGZq+D/b10cxKDX7ypVfU8wQm
         gdcdS7KttXvClDfxw8QUZeW3/LZUcFemOLKrpO8XINoIFSwrvSUnkiwDNFSXNfYjjuJo
         s1OQa02wPnG3lcBMsYJxP4biVL58CUgR8O3l460l9B5jCkGXmx1/TvyYc5C+9GEffyzv
         4QEhcNhpxiBYJodwHufh5NvSgb96QSwq1kW2sSTPFhm+HF5KrYKjhJepo5IuEZoV6W7O
         bLAw==
X-Gm-Message-State: ACgBeo0ZEyOO0pp8W5lZ/DF33kf/Jk5sbfdPKaSdZD8AxvVt23ws7Zn2
        wx7PVYOmSMzwbds2axdcGndff54D1NRX8qjs
X-Google-Smtp-Source: AA6agR4XJOe/rTs+2NXL+Ehba0PfXhNDRFfpqWaKHaYnp4brO3y0XNw083JnGPOtS1NeHBLeqZZsVg==
X-Received: by 2002:a17:906:98c9:b0:73c:5d9b:3425 with SMTP id zd9-20020a17090698c900b0073c5d9b3425mr340204ejb.77.1660827649519;
        Thu, 18 Aug 2022 06:00:49 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id c9-20020a17090618a900b007313a25e56esm807987ejf.29.2022.08.18.06.00.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 06:00:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: [patch net-next 4/4] net: devlink: expose default flash update target
Date:   Thu, 18 Aug 2022 15:00:42 +0200
Message-Id: <20220818130042.535762-5-jiri@resnulli.us>
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

Allow driver to mark certain version obtained by info_get() op as
"flash update default". Expose this information to user which allows him
to understand what version is going to be affected if he does flash
update without specifying the component. Implement this in netdevsim.

Example:

$ devlink dev info
netdevsim/netdevsim10:
  driver netdevsim
versions:
  running:
    fw.mgmt 10.20.30
    fw 11.22.33
    flash_components:
      fw.mgmt
  flash_update_default fw

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c  |  3 ++-
 include/net/devlink.h        |  3 +++
 include/uapi/linux/devlink.h |  1 +
 net/core/devlink.c           | 12 ++++++++++++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 97281b6aa41f..f999b9477a26 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -995,7 +995,8 @@ static int nsim_dev_info_get(struct devlink *devlink,
 	if (err)
 		return err;
 
-	return devlink_info_version_running_put(req, "fw", "11.22.33");
+	return devlink_info_version_running_put_ext(req, "fw", "11.22.33",
+						    DEVLINK_INFO_VERSION_TYPE_FLASH_UPDATE_DEFAULT);
 }
 
 #define NSIM_DEV_FLASH_SIZE 500000
diff --git a/include/net/devlink.h b/include/net/devlink.h
index 9bf4f03feca6..bfe988a56067 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1719,6 +1719,9 @@ enum devlink_info_version_type {
 	DEVLINK_INFO_VERSION_TYPE_COMPONENT, /* May be used as flash update
 					      * component by name.
 					      */
+	DEVLINK_INFO_VERSION_TYPE_FLASH_UPDATE_DEFAULT, /* Is default flash
+							 * update target.
+							 */
 };
 
 int devlink_info_version_fixed_put(struct devlink_info_req *req,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 7f2874189188..01e348177f60 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -608,6 +608,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_SELFTESTS,			/* nested */
 
 	DEVLINK_ATTR_INFO_VERSION_IS_COMPONENT,	/* u8 0 or 1 */
+	DEVLINK_ATTR_INFO_VERSION_IS_FLASH_UPDATE_DEFAULT,	/* u8 0 or 1 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 23a5fd92ecaa..de583fb2ed12 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4748,6 +4748,7 @@ struct devlink_info_req {
 			   enum devlink_info_version_type version_type,
 			   void *version_cb_priv);
 	void *version_cb_priv;
+	unsigned int flash_update_default_count;
 };
 
 struct devlink_flash_component_lookup_ctx {
@@ -6656,6 +6657,12 @@ static int devlink_info_version_put(struct devlink_info_req *req, int attr,
 	if (!req->msg)
 		return 0;
 
+	if (version_type == DEVLINK_INFO_VERSION_TYPE_FLASH_UPDATE_DEFAULT) {
+		if (WARN_ON(req->flash_update_default_count++))
+			/* Max one flash update default is allowed. */
+			return -EINVAL;
+	}
+
 	nest = nla_nest_start_noflag(req->msg, attr);
 	if (!nest)
 		return -EMSGSIZE;
@@ -6675,6 +6682,11 @@ static int devlink_info_version_put(struct devlink_info_req *req, int attr,
 	if (err)
 		goto nla_put_failure;
 
+	err = nla_put_u8(req->msg, DEVLINK_ATTR_INFO_VERSION_IS_FLASH_UPDATE_DEFAULT,
+			 version_type == DEVLINK_INFO_VERSION_TYPE_FLASH_UPDATE_DEFAULT);
+	if (err)
+		goto nla_put_failure;
+
 	nla_nest_end(req->msg, nest);
 
 	return 0;
-- 
2.37.1

