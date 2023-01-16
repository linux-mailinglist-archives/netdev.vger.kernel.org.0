Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1C666C431
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjAPPoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbjAPPn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:43:59 -0500
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:df01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BE21C33D;
        Mon, 16 Jan 2023 07:43:58 -0800 (PST)
Received: from sas1-7470331623bb.qloud-c.yandex.net (sas1-7470331623bb.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd1e:0:640:7470:3316])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 2841B5DC24;
        Mon, 16 Jan 2023 18:21:14 +0300 (MSK)
Received: from davydov-max-nux.yandex.net (unknown [2a02:6b8:0:107:fa75:a4ff:fe7d:8480])
        by sas1-7470331623bb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 0LllA20WE0U1-UPo9vtdS;
        Mon, 16 Jan 2023 18:21:13 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1673882473; bh=Zji24U9iJ0v7SHNqSmcwo+z7LPA1SbzRkaEn/QxyL8Q=;
        h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
        b=FAkHzwaZVzPp7bzrRNxMpyadVP3E7E7DhJJXSPl2OXvXLxxcGp9st7IVnXOAxEwSJ
         0ldgMjI/gjFqygnjbsl26u5QA5bq2wMMF4seQEkY221Uwo4bSihbHUnHVi1YEEoSdl
         wtuxBgFytpDHNZk7vXs7PYq+pnUlP4JU28xbxAOg=
Authentication-Results: sas1-7470331623bb.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Maksim Davydov <davydov-max@yandex-team.ru>
To:     rajur@chelsio.com
Cc:     davydov-max@yandex-team.ru, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        anish@chelsio.com, hariprasad@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net/ethernet/chelsio: fix cxgb4_getpgtccfg wrong memory access
Date:   Mon, 16 Jan 2023 18:20:59 +0300
Message-Id: <20230116152100.30094-2-davydov-max@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230116152100.30094-1-davydov-max@yandex-team.ru>
References: <20230116152100.30094-1-davydov-max@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

*pgid can be in range 0 to 0xF (bitmask 0xF) but valid values for PGID
are between 0 and 7. Also the size of pgrate is 8. Thus, we are needed
additional check to make sure that this code doesn't have access to tsa.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: 76bcb31efc06 ("cxgb4 : Add DCBx support codebase and dcbnl_ops")
Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
index 7d5204834ee2..3aa65f0f335e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c
@@ -471,7 +471,10 @@ static void cxgb4_getpgtccfg(struct net_device *dev, int tc,
 		return;
 	}
 
-	*bw_per = pcmd.u.dcb.pgrate.pgrate[*pgid];
+	/* Valid values are: 0-7 */
+	if (*pgid <= 7)
+		*bw_per = pcmd.u.dcb.pgrate.pgrate[*pgid];
+
 	*up_tc_map = (1 << tc);
 
 	/* prio_type is link strict */
-- 
2.25.1

