Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828B94D38D4
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbiCISaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 13:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiCISaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 13:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A42DB847
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 10:29:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 966A0B8232C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 18:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0574AC36AE2;
        Wed,  9 Mar 2022 18:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646850558;
        bh=Aim+MHI8QV1nKtaGMntTtndD5hRsioW1A/hcP8VrZdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VHs1DQ50tN+TuiVQsAproszuR5KRXpOqcIF4RMjv6+Q+wyQMlsdhb+mYDfKMpZBPs
         N/3Jm0Bsw2ffZhoKk7V11wiee6Zlgp8TvNqa3/X5SrGLsBwUetFERzAbOSkLMsShdH
         zAEKg7ZEFHCHoOn5frx6lhmIm7ZfCf2d8cLiVY3jJ7QGTV1gdgzBGqZ9uldiD/eTV7
         CujQ1JI0jEydzyL68Jtaob7o1fhH042Oi4N4kQpoHnoM9BYr1+UoVr6eIYK/WiKZNq
         CqKxjC5nysjZzh05clWvKywPEH5uAaen+1pawPZ2Bv56Zp28eUOcoeih+fWTYcDlwl
         GwrKfukXyOf+w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>,
        George Shuklin <george.shuklin@gmail.com>
Subject: [PATCH net-next 1/2] net: account alternate interface name memory
Date:   Wed,  9 Mar 2022 10:29:13 -0800
Message-Id: <20220309182914.423834-2-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220309182914.423834-1-kuba@kernel.org>
References: <20220309182914.423834-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

George reports that altnames can eat up kernel memory.
We should charge that memory appropriately.

Reported-by: George Shuklin <george.shuklin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a759f9e0a847..aa05e89cc47c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3658,7 +3658,7 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
 	if (err)
 		return err;
 
-	alt_ifname = nla_strdup(attr, GFP_KERNEL);
+	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (!alt_ifname)
 		return -ENOMEM;
 
-- 
2.34.1

