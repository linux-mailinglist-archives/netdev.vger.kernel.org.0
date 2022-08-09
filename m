Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654C858D947
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 15:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbiHINRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 09:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiHINRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 09:17:36 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455D9BE3
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 06:17:34 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id o22so15044314edc.10
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 06:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=NwYAR+0BJVjcUTPfg+kAz3aP6bkHygWnQij941h4fp4=;
        b=stBbP+YG3O8+hasEf6rln6twjBHo59GyyeSzQimu70zEA3lmzL91412P80aVoqPBo2
         Ju5h73hkEuPe7tQNFeONhaYJUX0JCTyo2U/xg6wNzWZLW2QL59g16syBoXKy0F8eBAa2
         aGpm63tosXLxH9TOAvsRrZKSzONdq7z96oKEwfeCiDseZo1j/jABtcSaaxuoMpA3hARV
         Vje3CJD1zQ5e1HdfhV0HrFL5J/KbyHe4UpqaekVoDmfvEycykiuyfi4B82OetM62whtE
         c8QcwQJICrDp3cSPT8pXJn0B5s2UtV3ZOb+ibAsFLycL7ccUDJfO/G+Skr+dbYE1LMth
         kGGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=NwYAR+0BJVjcUTPfg+kAz3aP6bkHygWnQij941h4fp4=;
        b=hHEWGPAztf/EH9GLq5YzGCCP38KVVZygAYgUPNw1E0EUcBLXlAx4W7iILSdrfnegAs
         bId/e8BRESwNOVUtGhnZwStjRHa7Ax2glN9PxwqTOTe/TO6t8gQq9zQAWc+7+yAZMWkR
         GhjAwnVWV97SDghDuOOyIUrnxoLTTfPrcDK8ZkPtpyrEsv7pnVlx0BCvE+76vId9giWn
         cXAHfS3YbuIQmqYXGMzsWFZhF8hJ+5IvpgqC68xjtAwooeTCom75THyVLdZ/7xGVx2pN
         kJnE+kyXbhlyB1aDxzs8zdoNU/WuT299yIUzZBSqAoBUR5gROs+fI8q/o0u1aAdQXhNC
         y5Uw==
X-Gm-Message-State: ACgBeo3KnFQTwDTQu8J775BI2Ou1F58Kkp5sngASWS1bVtMpVPvCXM8y
        nojNcgYbOcT9Igip+C0njt2SV5UqyNVUV+EN1E8=
X-Google-Smtp-Source: AA6agR7idNBse9AIaiwy1B4BRCv2ky7hgzR49AJDEbQAFaMgpjMfHv7jIE9E9An8QqBDs6UOcAQAWg==
X-Received: by 2002:a05:6402:500d:b0:440:9bc5:d0c1 with SMTP id p13-20020a056402500d00b004409bc5d0c1mr9839677eda.202.1660051052825;
        Tue, 09 Aug 2022 06:17:32 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id la3-20020a170907780300b00722e4bab163sm1103053ejc.200.2022.08.09.06.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 06:17:31 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     sthemmin@microsoft.com, dsahern@gmail.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Subject: [patch iproute2-next] devlink: expose nested devlink for a line card object
Date:   Tue,  9 Aug 2022 15:17:30 +0200
Message-Id: <20220809131730.2677759-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
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

If line card object contains a nested devlink, expose it.

Example:

$ devlink lc show pci/0000:01:00.0 lc 1
pci/0000:01:00.0:
  lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
    supported_types:
      16x100G
$ devlink dev show auxiliary/mlxsw_core.lc.0
auxiliary/mlxsw_core.lc.0

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 21f26246f91b..1ccb669c423b 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -703,6 +703,7 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_LINECARD_STATE] = MNL_TYPE_U8,
 	[DEVLINK_ATTR_LINECARD_TYPE] = MNL_TYPE_STRING,
 	[DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_NESTED_DEVLINK] = MNL_TYPE_NESTED,
 	[DEVLINK_ATTR_SELFTESTS] = MNL_TYPE_NESTED,
 };
 
@@ -2423,6 +2424,25 @@ static bool should_arr_last_handle_end(struct dl *dl, const char *bus_name,
 	       !cmp_arr_last_handle(dl, bus_name, dev_name);
 }
 
+static void pr_out_nested_handle(struct nlattr *nla_nested_dl)
+{
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	char buf[64];
+	int err;
+
+	err = mnl_attr_parse_nested(nla_nested_dl, attr_cb, tb);
+	if (err != MNL_CB_OK)
+		return;
+
+	if (!tb[DEVLINK_ATTR_BUS_NAME] ||
+	    !tb[DEVLINK_ATTR_DEV_NAME])
+		return;
+
+	sprintf(buf, "%s/%s", mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]),
+		mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]));
+	print_string(PRINT_ANY, "nested_devlink", " nested_devlink %s", buf);
+}
+
 static void __pr_out_handle_start(struct dl *dl, struct nlattr **tb,
 				  bool content, bool array)
 {
@@ -5278,6 +5298,9 @@ static void pr_out_linecard(struct dl *dl, struct nlattr **tb)
 	if (tb[DEVLINK_ATTR_LINECARD_TYPE])
 		print_string(PRINT_ANY, "type", " type %s",
 			     mnl_attr_get_str(tb[DEVLINK_ATTR_LINECARD_TYPE]));
+	if (tb[DEVLINK_ATTR_NESTED_DEVLINK])
+		pr_out_nested_handle(tb[DEVLINK_ATTR_NESTED_DEVLINK]);
+
 	pr_out_linecard_supported_types(dl, tb);
 	pr_out_handle_end(dl);
 }
-- 
2.35.3

