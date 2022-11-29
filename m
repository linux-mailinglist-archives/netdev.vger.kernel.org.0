Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F2E63BA89
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 08:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiK2H0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 02:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiK2H0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 02:26:38 -0500
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE9A3F041;
        Mon, 28 Nov 2022 23:26:37 -0800 (PST)
Received: from myt6-23a5e62c0090.qloud-c.yandex.net (myt6-23a5e62c0090.qloud-c.yandex.net [IPv6:2a02:6b8:c12:1da3:0:640:23a5:e62c])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 582505FCCA;
        Tue, 29 Nov 2022 10:26:25 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:b439::1:13])
        by myt6-23a5e62c0090.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id LQK9P90QiiE1-30JiTpIk;
        Tue, 29 Nov 2022 10:26:24 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1669706784; bh=95WBhUqQuWLuJqbtsgIW1Evy4AsD29l5Ce6uiLn3sZY=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=LOPYmdjGnfNtZBVOKMQJMEE0WmS4RpUQkrygKxfVeRIrpIH5bPJXAzWdS9kUDkG3r
         /d1v1XCACNwLwdXlwUQVNiYrM8j4q59aI2guH8DijITKywEDbvLJQB2P2K9h+uZYDo
         bzktjPGgJAlxmMR56hrjfYY/reDB9StmgubNQRnI=
Authentication-Results: myt6-23a5e62c0090.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v1] drivers/net/bonding/bond_3ad: return when there's no aggregator
Date:   Tue, 29 Nov 2022 10:26:17 +0300
Message-Id: <20221129072617.439074-1-d-tatianin@yandex-team.ru>
X-Mailer: git-send-email 2.25.1
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

Otherwise we would dereference a NULL aggregator pointer when calling
__set_agg_ports_ready on the line below.

Found by Linux Verification Center (linuxtesting.org) with the SVACE
static analysis tool.

Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
 drivers/net/bonding/bond_3ad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3ad.c
index acb6ff0be5ff..320e5461853f 100644
--- a/drivers/net/bonding/bond_3ad.c
+++ b/drivers/net/bonding/bond_3ad.c
@@ -1520,6 +1520,7 @@ static void ad_port_selection_logic(struct port *port, bool *update_slave_arr)
 			slave_err(bond->dev, port->slave->dev,
 				  "Port %d did not find a suitable aggregator\n",
 				  port->actor_port_number);
+			return;
 		}
 	}
 	/* if all aggregator's ports are READY_N == TRUE, set ready=TRUE
-- 
2.25.1

