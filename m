Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5216D4B9629
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbiBQC5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:57:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiBQC5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:57:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97646C117F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 18:57:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BADEB820E0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65219C004E1;
        Thu, 17 Feb 2022 02:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645066637;
        bh=iRiOHhzwXc0EhNJb+xtIR9zAisrJqxV2/ZbTsgZRrQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NbZSlx88GCCjJHafW6QzFob3ChER+bk6CRcReI0K50Hh5WxYwSf2PqTdnZy+BhFgF
         OMW92qYhj6W0EHvpgvh374PdQ6VvvBeqDx02iZOTxsVeVzRG5p5VuZ8c6s27V0ZYOK
         joEWeG8SESgR3oLTm5X6acdhcIoDSoaHuyE0fBZUvgTV/HBCh9iDksmSBudOuIz5Zg
         LN0t5U1a8fJ5TU7TvCzNB4ehldXiea3cNkrIckaJnVpfOluGM/yF5DpNvRH3Er3bQ9
         yliZmxrUdV41m3YqrDDqGtPxqAqmbwzTw86QI4IXZj1RtKhG5dmqDv1wRe1/ol5Huo
         6i8ncWYl0ycyA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, parav@nvidia.com, jiri@nvidia.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 3/4] devlink: Remove strtouint16_t in favor of get_u16
Date:   Wed, 16 Feb 2022 19:57:10 -0700
Message-Id: <20220217025711.9369-4-dsahern@kernel.org>
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

strtouint16_t duplicates get_u16; remove it.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 devlink/devlink.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 4a5f7f7a0ba1..54570df94b7f 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -857,20 +857,6 @@ static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
 	return -ENOENT;
 }
 
-static int strtouint16_t(const char *str, uint16_t *p_val)
-{
-	char *endptr;
-	unsigned long int val;
-
-	val = strtoul(str, &endptr, 10);
-	if (endptr == str || *endptr != '\0')
-		return -EINVAL;
-	if (val > USHRT_MAX)
-		return -ERANGE;
-	*p_val = val;
-	return 0;
-}
-
 static int strtouint8_t(const char *str, uint8_t *p_val)
 {
 	char *endptr;
@@ -1191,7 +1177,7 @@ static int dl_argv_uint16_t(struct dl *dl, uint16_t *p_val)
 		return -EINVAL;
 	}
 
-	err = strtouint16_t(str, p_val);
+	err = get_u16(p_val, str, 10);
 	if (err) {
 		pr_err("\"%s\" is not a number or not within range\n", str);
 		return err;
@@ -3154,7 +3140,7 @@ static int cmd_dev_param_set(struct dl *dl)
 						      &val_u32);
 			val_u16 = val_u32;
 		} else {
-			err = strtouint16_t(dl->opts.param_value, &val_u16);
+			err = get_u16(&val_u16, dl->opts.param_value, 10);
 		}
 		if (err)
 			goto err_param_value_parse;
@@ -4416,7 +4402,7 @@ static int cmd_port_param_set(struct dl *dl)
 						      &val_u32);
 			val_u16 = val_u32;
 		} else {
-			err = strtouint16_t(dl->opts.param_value, &val_u16);
+			err = get_u16(&val_u16, dl->opts.param_value, 10);
 		}
 		if (err)
 			goto err_param_value_parse;
-- 
2.24.3 (Apple Git-128)

