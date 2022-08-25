Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922F65A0AF7
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239077AbiHYIEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239176AbiHYIE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:04:29 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C4581B16
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:04:24 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z8so4429259edb.0
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=qr1Znbfq6RYmCpWCpKuFbckFkpdkU947UID6SIUX69A=;
        b=ZYhYOhhIfO0TuE29zXcfDvI7l/SdVwiz/eHYi4eh/l/axj1j4o3R5hGwMp/6xntXgW
         tXYKOL1zaLz9NHS0RceHKnDEtHsXqPnkZI8S78sRgrHM0X56l8i2/SVl3wh0Hbsdu4zQ
         q8vLInZKZCH35ZIePD0YXD/u7k3ddfR77iZ2qA7cf0szwvvH1E+QKGghWmeBhve48Zvx
         w0oelBs8OC+8LvjUZHBRkDbd1V/d8FlRWz2nilZlW2szzFl46hMfi4Mx4kMx1VRH6KNb
         4ZVsfOHDC+5liDZojxhQbMjC0xOpx6erTXjm8iZGp+ivs9J8h9sHrx7hOjJgUvfHxpCL
         aJOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=qr1Znbfq6RYmCpWCpKuFbckFkpdkU947UID6SIUX69A=;
        b=jtzJ3Ecm4ci9dF+/LM9qEzfrXXmZk6QMih4MaNuCj/+azaqZrd3Ue1c547wM6I14CF
         /Xl1u73GPC55DEqVSR1Dx5iCogUa+YOyY8JtCEQiNVDFfROzmtPSSBoOrH648dSEDPeG
         eXUA8Xfik2GOuFSxj/3YZQASnMKew0tVQJ/WVSxSXMdClxziSAZztOn8QBr4BWWsArBx
         t7KWkqpKjkXkdF86CV1D/klB+xwufPUIaS74gJ+M7jXSm7Vcuk1/TtvWE7co6WiXCYcX
         p3LlE64EqFqXt/llnYql/UfKwB4LfmMIpzbSoWzkX/xM7dguZr2hmyjgaKc/H+yi4NDK
         Q0fQ==
X-Gm-Message-State: ACgBeo1n1bBxb3Dfa/Pi004qQZHIZdwcpn1zeXxi/yhlAitEP1iLOx77
        w11XCZspafci+kNnfUEnHP+K3US8xfZODanV
X-Google-Smtp-Source: AA6agR5zmp0BCIkQajyL000B6MhGqDC2lwwlS9U5NS5UZ2L43irWbqpZq3WklbrAWDl59mzLPFowow==
X-Received: by 2002:a05:6402:514f:b0:445:e158:9eb7 with SMTP id n15-20020a056402514f00b00445e1589eb7mr2177283edd.322.1661414663418;
        Thu, 25 Aug 2022 01:04:23 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g18-20020a17090604d200b0073c80d008d5sm2051825eja.122.2022.08.25.01.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 01:04:22 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com,
        vikas.gupta@broadcom.com, jacob.e.keller@intel.com,
        kuba@kernel.org, moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch iproute2-next 1/2] devlink: load port-ifname map on demand
Date:   Thu, 25 Aug 2022 10:04:19 +0200
Message-Id: <20220825080420.1282569-2-jiri@resnulli.us>
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
index b69c89778804..b2439aef4d10 100644
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
@@ -817,13 +818,15 @@ static void ifname_map_fini(struct dl *dl)
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
@@ -841,7 +844,16 @@ static int ifname_map_lookup(struct dl *dl, const char *ifname,
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
@@ -9622,17 +9634,10 @@ static int dl_init(struct dl *dl)
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

