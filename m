Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03CE34B9628
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiBQC5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:57:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbiBQC5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:57:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1080B12F3
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 18:57:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79682B820E3
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8FDC340F1;
        Thu, 17 Feb 2022 02:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645066637;
        bh=RwMlQ/J0b+vyDvDGMxa12nHz7CmdiN5sSmM0Lhfrd8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FaJAhWJkMyTZBjQbl50jNvxFxY7mpgZ56oKKhe0pGXSgF87xXDNmqEll0NT2B6DSp
         mt1qRtDZCFlz17cP9vw/CIfhKE5uK6FMdYRZ0feV8BF5UakJzEHfDXPKIkYBSlZsjl
         NoOZb+9A54DgJlxwgT5bFw4bDH6cctrPLXOTjbrwZgwFUIJxyBr3ZzwNAowJmzVNHm
         CSWfWJo++P45wHB7jKUJ7DSQPMz4On+6V1xkpEB5OZ/smsASM9gmY1F8GOdnnGnFkx
         y+tUx2is4LEB9m1LIWwAUgrYcyXVGgRILaQ5Dnor8MSDBII4G7wfqOfycG0W5a2iev
         vV3M3UMjPNHug==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, parav@nvidia.com, jiri@nvidia.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 2/4] devlink: Remove strtouint32_t in favor of get_u32
Date:   Wed, 16 Feb 2022 19:57:09 -0700
Message-Id: <20220217025711.9369-3-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20220217025711.9369-1-dsahern@kernel.org>
References: <20220217025711.9369-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

strtouint32_t duplicates get_u32; remove it.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 devlink/devlink.c | 24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 4e2dc6e09682..4a5f7f7a0ba1 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -857,20 +857,6 @@ static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
 	return -ENOENT;
 }
 
-static int strtouint32_t(const char *str, uint32_t *p_val)
-{
-	char *endptr;
-	unsigned long int val;
-
-	val = strtoul(str, &endptr, 10);
-	if (endptr == str || *endptr != '\0')
-		return -EINVAL;
-	if (val > UINT_MAX)
-		return -ERANGE;
-	*p_val = val;
-	return 0;
-}
-
 static int strtouint16_t(const char *str, uint16_t *p_val)
 {
 	char *endptr;
@@ -966,7 +952,7 @@ static int __dl_argv_handle_port(char *str,
 		pr_err("Port identification \"%s\" is invalid\n", str);
 		return err;
 	}
-	err = strtouint32_t(portstr, p_port_index);
+	err = get_u32(p_port_index, portstr, 10);
 	if (err) {
 		pr_err("Port index \"%s\" is not a number or not within range\n",
 		       portstr);
@@ -1145,7 +1131,7 @@ static int dl_argv_handle_rate(struct dl *dl, char **p_bus_name,
 	}
 
 	if (strspn(identifier, "0123456789") == strlen(identifier)) {
-		err = strtouint32_t(identifier, p_port_index);
+		err = get_u32(p_port_index, identifier, 10);
 		if (err) {
 			pr_err("Port index \"%s\" is not a number"
 			       " or not within range\n", identifier);
@@ -1187,7 +1173,7 @@ static int dl_argv_uint32_t(struct dl *dl, uint32_t *p_val)
 		return -EINVAL;
 	}
 
-	err = strtouint32_t(str, p_val);
+	err = get_u32(p_val, str, 10);
 	if (err) {
 		pr_err("\"%s\" is not a number or not within range\n", str);
 		return err;
@@ -3184,7 +3170,7 @@ static int cmd_dev_param_set(struct dl *dl)
 						      dl->opts.param_value,
 						      &val_u32);
 		else
-			err = strtouint32_t(dl->opts.param_value, &val_u32);
+			err = get_u32(&val_u32, dl->opts.param_value, 10);
 		if (err)
 			goto err_param_value_parse;
 		if (val_u32 == ctx.value.vu32)
@@ -4446,7 +4432,7 @@ static int cmd_port_param_set(struct dl *dl)
 						      dl->opts.param_value,
 						      &val_u32);
 		else
-			err = strtouint32_t(dl->opts.param_value, &val_u32);
+			err = get_u32(&val_u32, dl->opts.param_value, 10);
 		if (err)
 			goto err_param_value_parse;
 		if (val_u32 == ctx.value.vu32)
-- 
2.24.3 (Apple Git-128)

