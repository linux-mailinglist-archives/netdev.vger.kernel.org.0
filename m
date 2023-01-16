Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FD466C41D
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjAPPkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjAPPkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:40:02 -0500
X-Greylist: delayed 1020 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 Jan 2023 07:39:59 PST
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [IPv6:2a02:6b8:c02:900:1:45:d181:df01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26F93C19;
        Mon, 16 Jan 2023 07:39:58 -0800 (PST)
Received: from sas1-7470331623bb.qloud-c.yandex.net (sas1-7470331623bb.qloud-c.yandex.net [IPv6:2a02:6b8:c08:bd1e:0:640:7470:3316])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id EC6585FC81;
        Mon, 16 Jan 2023 18:21:14 +0300 (MSK)
Received: from davydov-max-nux.yandex.net (unknown [2a02:6b8:0:107:fa75:a4ff:fe7d:8480])
        by sas1-7470331623bb.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 0LllA20WE0U1-k5HWBf5O;
        Mon, 16 Jan 2023 18:21:14 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1673882474; bh=Lgh+1g6KNi/hMAfFoaY+R2a0ZRoxcGA1MnVkhcWjK18=;
        h=Message-Id:Date:In-Reply-To:Cc:Subject:References:To:From;
        b=RD1nI0Z7ppPRF+y3TFbaeFSdX+aNkBYiJH5NzZYV4bR2EYYI+1K3GBgKDmLk7cFzL
         RhOV04CSClsoXuPVU/caEGA5ShBf/gv71ettgmv7d/xCEZ6Rb7tWWdDB0l1Iaq3mGJ
         JLL8wUsVoPA+SPAIsbFlECQJWOGatWPt4+IwnV+E=
Authentication-Results: sas1-7470331623bb.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Maksim Davydov <davydov-max@yandex-team.ru>
To:     rajur@chelsio.com
Cc:     davydov-max@yandex-team.ru, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        anish@chelsio.com, hariprasad@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net/ethernet/chelsio: t4_handle_fw_rpl fix NULL
Date:   Mon, 16 Jan 2023 18:21:00 +0300
Message-Id: <20230116152100.30094-3-davydov-max@yandex-team.ru>
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

After t4_hw.c:t4_prep_adapter() that is called in cxgb4_main.c:init_one()
adapter has it least 1 port for debug. Thus, for_each_port() usually has
at least 1 iteration, but this function can be called with wrong
configured adapter

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Fixes: 23853a0a9a76 ("cxgb4: Don't assume FW_PORT_CMD reply is always
port info msg")

Signed-off-by: Maksim Davydov <davydov-max@yandex-team.ru>
---
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 8d719f82854a..2f7b49473f52 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -8864,7 +8864,8 @@ int t4_handle_fw_rpl(struct adapter *adap, const __be64 *rpl)
 				break;
 		}
 
-		t4_handle_get_port_info(pi, rpl);
+		if (pi)
+			t4_handle_get_port_info(pi, rpl);
 	} else {
 		dev_warn(adap->pdev_dev, "Unknown firmware reply %d\n",
 			 opcode);
-- 
2.25.1

