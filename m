Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF004B918A
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238218AbiBPTm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:42:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238235AbiBPTmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:42:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE35810EC79
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 11:42:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 619A6CE289E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 19:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9F1C340E8;
        Wed, 16 Feb 2022 19:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645040527;
        bh=Q/EquVHeQBVhmo8+cd2ZNY2L6YcYa4qKaR3GJwG/+ZA=;
        h=From:To:Cc:Subject:Date:From;
        b=BnYIcOcBtnILV5HDarbVLqxZSK2LtWOaOdhjZZY/0R6KKpafXW0oQ7nebDJ7wxweD
         VW3fHKiKKR7Lt9kIB3NhNrQh1UEdOEBb+trLjhdIvxEYda6omwv0qrjxY35r111eFn
         EV5sQ4ABApRJXc11sd0YWh5ceZjhdl/UX/Tbw+5TtuxlnhqkRZ9ocQsFqwOl9y6uaP
         dqqwTdyCq+KxzB8WueEhKyBHgwGNkEtH5r9NvHj1LXvBh40IalAWhVOuX0bgUHqVZH
         xdYG4t+BTvfYoDRxCraSb2qf+qFoSqu1a5A6SOQP8oce6O7VEblyUzB7V+xpmYLMiO
         NXf8IJAF1ozHw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     dsahern@gmail.com, stephen@networkplumber.org, gnault@redhat.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC iproute2] tos: interpret ToS in natural numeral system
Date:   Wed, 16 Feb 2022 11:42:05 -0800
Message-Id: <20220216194205.3780848-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
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

Silently forcing a base numeral system is very painful for users.
ip currently interprets tos 10 as 0x10. Imagine user's bash script
does:

  .. tos $((TOS * 2)) ..

or any numerical operation on the ToS.

This patch breaks existing scripts if they expect 10 to be 0x10.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
I get the feeling this was discussed in the past.

Also there's more:

devlink/devlink.c:	val = strtoull(str, &endptr, 10);
devlink/devlink.c:	val = strtoul(str, &endptr, 10);
devlink/devlink.c:	val = strtoul(str, &endptr, 10);
devlink/devlink.c:	val = strtoul(str, &endptr, 10);
lib/utils.c:	res = strtoul(arg, &ptr, base);
lib/utils.c:		n = strtoul(cp, &endp, 16);
lib/utils.c:		tmp = strtoul(tmpstr, &endptr, 16);
lib/utils.c:		tmp = strtoul(arg + i * 3, &endptr, 16);
misc/lnstat_util.c:			unsigned long f = strtoul(ptr, &ptr, 16);
tc/f_u32.c:	htid = strtoul(str, &tmp, 16);
tc/f_u32.c:		hash = strtoul(str, &tmp, 16);
tc/f_u32.c:			nodeid = strtoul(str, &tmp, 16);
tc/tc_util.c:	maj = strtoul(str, &p, 16);
tc/tc_util.c:	maj = strtoul(str, &p, 16);
tc/tc_util.c:		min = strtoul(str, &p, 16);
---
 lib/rt_names.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/rt_names.c b/lib/rt_names.c
index b976471d7979..7eb63dad7d4d 100644
--- a/lib/rt_names.c
+++ b/lib/rt_names.c
@@ -531,7 +531,7 @@ int rtnl_dsfield_a2n(__u32 *id, const char *arg)
 		}
 	}
 
-	res = strtoul(arg, &end, 16);
+	res = strtoul(arg, &end, 0);
 	if (!end || end == arg || *end || res > 255)
 		return -1;
 	*id = res;
-- 
2.34.1

