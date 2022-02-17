Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE56C4B9625
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 03:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbiBQC5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 21:57:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbiBQC5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 21:57:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A1FB9D68
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 18:57:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09FA0B820E6
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 02:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDEEC340F3;
        Thu, 17 Feb 2022 02:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645066638;
        bh=jVTBPp8RsDkgQk4Wvqdo2x4dBO0Qj+o9lqNfff+Q60k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d8jNpgf/7MrOMqA2qfAocUHBOlOnj/Q5ZPc9bFKBpz/0OsVXWENw49toqHgcNh5vZ
         UfcJL2WT3QzTIgbNNGl1FlGY7+O+L6ZOmOxI6bdjAjvY+zPEG62bPmO3k/mMzjKn76
         rlj7FC8YharfH/Fj5y9He3/GUR+L9BnqVQXYFmtXuhRAl0Ef8HSaI9IQOnnbUMn2GG
         ytXCzEhtMsEQwxBne2bnNslDKvniVD4Yw3oiJ4exWmFnrhPrKJ82kzlcGeWcElxhGP
         usrAGIFtuqiphhCp2L+rwG9pZPKHEnThlisl3uVbx/z3HYLrt2XBniGyoj3hSrDcDw
         IhJSn4z4+OgTw==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, parav@nvidia.com, jiri@nvidia.com,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH iproute2-next 4/4] devlink: Remove strtouint8_t in favor of get_u8
Date:   Wed, 16 Feb 2022 19:57:11 -0700
Message-Id: <20220217025711.9369-5-dsahern@kernel.org>
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

strtouint8_t duplicates get_u8; remove it.

Signed-off-by: David Ahern <dsahern@kernel.org>
---
 devlink/devlink.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 54570df94b7f..da9f97788bcf 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -857,20 +857,6 @@ static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
 	return -ENOENT;
 }
 
-static int strtouint8_t(const char *str, uint8_t *p_val)
-{
-	char *endptr;
-	unsigned long int val;
-
-	val = strtoul(str, &endptr, 10);
-	if (endptr == str || *endptr != '\0')
-		return -EINVAL;
-	if (val > UCHAR_MAX)
-		return -ERANGE;
-	*p_val = val;
-	return 0;
-}
-
 static int strtobool(const char *str, bool *p_val)
 {
 	bool val;
@@ -3123,7 +3109,7 @@ static int cmd_dev_param_set(struct dl *dl)
 						      &val_u32);
 			val_u8 = val_u32;
 		} else {
-			err = strtouint8_t(dl->opts.param_value, &val_u8);
+			err = get_u8(&val_u8, dl->opts.param_value, 10);
 		}
 		if (err)
 			goto err_param_value_parse;
@@ -4385,7 +4371,7 @@ static int cmd_port_param_set(struct dl *dl)
 						      &val_u32);
 			val_u8 = val_u32;
 		} else {
-			err = strtouint8_t(dl->opts.param_value, &val_u8);
+			err = get_u8(&val_u8, dl->opts.param_value, 10);
 		}
 		if (err)
 			goto err_param_value_parse;
-- 
2.24.3 (Apple Git-128)

