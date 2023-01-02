Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3339665AF13
	for <lists+netdev@lfdr.de>; Mon,  2 Jan 2023 10:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjABJxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 04:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjABJxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 04:53:47 -0500
Received: from forwardcorp1b.mail.yandex.net (forwardcorp1b.mail.yandex.net [178.154.239.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDE997;
        Mon,  2 Jan 2023 01:53:43 -0800 (PST)
Received: from iva8-3a65cceff156.qloud-c.yandex.net (iva8-3a65cceff156.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2d80:0:640:3a65:ccef])
        by forwardcorp1b.mail.yandex.net (Yandex) with ESMTP id 539D95FC74;
        Mon,  2 Jan 2023 12:53:39 +0300 (MSK)
Received: from d-tatianin-nix.yandex-team.ru (unknown [2a02:6b8:b081:b5b0::1:24])
        by iva8-3a65cceff156.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id ZrRZJ61QeqM1-lKOQdv3c;
        Mon, 02 Jan 2023 12:53:38 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1672653218; bh=OSlF1FBWmkQTxMIdjkbxUlju+doziQNLf7JrpXASqbc=;
        h=Message-Id:Date:Cc:Subject:To:From;
        b=LyiSZrvSa+tfY9OMVqJhxhL9NYKAnJVi8LKwzb1RDWBPoiNxAnuK4HNew46qojdla
         M1MbO7KFtHWV1rNxGScUPZPFGFUWAPEtsvHG9oDGIoV0KMDT8dYruHrudG5potoWGW
         b9S3wbfAG6bRSsJMl/CKNEJ2lJWj3FUEMQf5HcHo=
Authentication-Results: iva8-3a65cceff156.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
From:   Daniil Tatianin <d-tatianin@yandex-team.ru>
To:     netdev@vger.kernel.org
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net v2] drivers/net/bonding/bond_3ad: return when there's no aggregator
Date:   Mon,  2 Jan 2023 12:53:35 +0300
Message-Id: <20230102095335.94249-1-d-tatianin@yandex-team.ru>
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

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
---
Changes since v1:
- Added a fixes tag
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

