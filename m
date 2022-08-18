Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C19598019
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 10:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240373AbiHRI3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 04:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240182AbiHRI3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 04:29:02 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE00AFAF6
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 01:28:59 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id gb36so1887899ejc.10
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 01:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Az0MFu8Yy1CIpeN9Tlq/QOqhUu7y6AuKkHJ0ZOTamz8=;
        b=dG+w95gygddwIbN+FnQx6zameUXa5oMdxTu72yrzGqFsLfVC9JuONHZos8RIS9uJlC
         l1FMfML1NBnaNM5AN4VAGWMOui+soTBzqxgrDavQGfdMlGEc1Zz1AVBh5JAxfnmBB5Or
         +QCTFvNZ22IO7YxsTko9eI0EmM0zvJZ8IyORC1kfWHkEboaBwWAPx9HTHOwbK5VsreB0
         GMo31X8M8wvPyLGgMXi/6rH3iJ3dscFgbPEBNlgGXlqWeFK91CBZpLM0ejHLb6dSaDnx
         zVcQy3oijmcz195EVsRPXg/MTKf8L82rPkAxkSY3203W0LmDDu5NX9R/JXBKIjdCcD8A
         pgBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Az0MFu8Yy1CIpeN9Tlq/QOqhUu7y6AuKkHJ0ZOTamz8=;
        b=JXabVrBHZl/w7goScl8H+V+7SvUXWPymUSus8gdQhQOoCo2odJ+6zN/2HvtU0owZCY
         xgsUMggf0MSfciAi9QGQBLHYHUGZW+KFcGJQm7f8oEPBo0XVT/oMLiPOGjBr8c+Hf4Zi
         ESzCPHBK/C8zF8b1FF56P2zWzYoSn12tdZZUHfcTA1pBeImNJwGgXp/x63eDqWWmyYPx
         O2XkERPeWrLXEKqqDfEBSR+3VN+LhGVdwWrz7lFbJXyYspHRxxASRJnYAsmm+D0LchNl
         /0WMlAfKBWO2ipWUkYZ4p+ginPNbRZkGiTCfKPUxpyXQsky6YM/ZoLP0Dwj3DH1jZ6B+
         OY6w==
X-Gm-Message-State: ACgBeo2LFFKGnL0/lXFpjjCi4DZ5zVr88cpQd7e/zlQ0hLKMBX9sT9ww
        4sUE/vGyR3hyt9TwUpsq9rIWiWcTBmE7xDPj
X-Google-Smtp-Source: AA6agR4hRMDM2mNj1w+L0MhmOY+ns+Ra+w0BF/iDml80gsbW4JbTF2pKLmUPpPMHp0IMILNf4i2RuA==
X-Received: by 2002:a17:906:9bd5:b0:730:a07d:9534 with SMTP id de21-20020a1709069bd500b00730a07d9534mr1201538ejc.747.1660811338040;
        Thu, 18 Aug 2022 01:28:58 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id ku24-20020a170907789800b00730c3923a2csm524757ejc.11.2022.08.18.01.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 01:28:57 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, moshe@nvidia.com
Subject: [patch iproute2-main] devlink: load port-ifname map on demand
Date:   Thu, 18 Aug 2022 10:28:56 +0200
Message-Id: <20220818082856.413480-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
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

So far, the port-ifname map was loaded during devlink init
no matter if actually needed or not. Port dump cmd which is utilized
for this in kernel takes lock for every devlink instance.
That may lead to unnecessary blockage of command.

Load the map only in time it is needed to lookup ifname.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 21f26246f91b..4ef5dc4a5600 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -374,6 +374,7 @@ struct dl {
 	bool verbose;
 	bool stats;
 	bool hex;
+	bool map_loaded;
 	struct {
 		bool present;
 		char *bus_name;
@@ -816,13 +817,15 @@ static void ifname_map_fini(struct dl *dl)
 	}
 }
 
-static int ifname_map_init(struct dl *dl)
+static void ifname_map_init(struct dl *dl)
 {
-	struct nlmsghdr *nlh;
-	int err;
-
 	INIT_LIST_HEAD(&dl->ifname_map_list);
+}
 
+static int ifname_map_load(struct dl *dl)
+{
+	struct nlmsghdr *nlh;
+	int err;
 
 	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET,
 			       NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP);
@@ -840,7 +843,16 @@ static int ifname_map_lookup(struct dl *dl, const char *ifname,
 			     uint32_t *p_port_index)
 {
 	struct ifname_map *ifname_map;
+	int err;
 
+	if (!dl->map_loaded) {
+		err = ifname_map_load(dl);
+		if (err) {
+			pr_err("Failed to create index map\n");
+			return err;
+		}
+		dl->map_loaded = true;
+	}
 	list_for_each_entry(ifname_map, &dl->ifname_map_list, list) {
 		if (strcmp(ifname, ifname_map->ifname) == 0) {
 			*p_bus_name = ifname_map->bus_name;
@@ -9528,17 +9540,10 @@ static int dl_init(struct dl *dl)
 		return -errno;
 	}
 
-	err = ifname_map_init(dl);
-	if (err) {
-		pr_err("Failed to create index map\n");
-		goto err_ifname_map_create;
-	}
+	ifname_map_init(dl);
+
 	new_json_obj_plain(dl->json_output);
 	return 0;
-
-err_ifname_map_create:
-	mnlu_gen_socket_close(&dl->nlg);
-	return err;
 }
 
 static void dl_fini(struct dl *dl)
-- 
2.37.1

