Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AB25EC378
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiI0NCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiI0NCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:02:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D42AB18C;
        Tue, 27 Sep 2022 06:02:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C79AB81BE1;
        Tue, 27 Sep 2022 13:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291BCC433D6;
        Tue, 27 Sep 2022 13:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664283739;
        bh=xvoJ+OW9l4BhVywumi/8ss3JCeIzNvyx47l4j80wEpY=;
        h=From:To:Cc:Subject:Date:From;
        b=hu/ZGjZUx+YKxna8QJPq9YEtENFVjxiyumA+BXZQ34qJyuIThGup+w9noHq4TNd+k
         7bcOWKNbRFlH9bKbSWtakhRbWWU9IhoE80gikToBJa8/cj4kJhMlNolOihdlycBJ24
         bWlrleSmKmG8lk3H8/qZ5sR4ZsrvglHzdqesgunxKt7pKRZZywDEvAl4/t+Rv9NWva
         wO7PAP+VOY3oIvuOUWHOhLRveJL3aqhGCcc1WjeRCNC6PjsxzBipM9mqTOOs20Y8lt
         7H+FPTbvogYL1mXMLRnd17upd8wui/YMEL50MNnKKURoNzuTXulqxrzV6xZTRvl0N6
         qBLtBkPNVMRaA==
From:   broonie@kernel.org
To:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Wolfram Sang <wsa@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: linux-next: manual merge of the net-next tree with the i2c tree
Date:   Tue, 27 Sep 2022 14:02:06 +0100
Message-Id: <20220927130206.368099-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Today's linux-next merge of the net-next tree got conflicts in:

  drivers/net/dsa/lan9303_i2c.c
  drivers/net/dsa/microchip/ksz9477_i2c.c
  drivers/net/dsa/xrs700x/xrs700x_i2c.c

between commit:

  ed5c2f5fd10dd ("i2c: Make remove callback return void")

from the i2c tree and commits:

  db5d451c4640a ("net: dsa: lan9303: remove unnecessary i2c_set_clientdata()")
  008971adb95d3 ("net: dsa: microchip: ksz9477: remove unnecessary i2c_set_clientdata()")
  6387bf7c390a1 ("net: dsa: xrs700x: remove unnecessary i2c_set_clientdata()")

from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc drivers/net/dsa/lan9303_i2c.c
index b25e91b26d991,79be5fc044bd4..0000000000000
--- a/drivers/net/dsa/lan9303_i2c.c
+++ b/drivers/net/dsa/lan9303_i2c.c
@@@ -70,11 -70,11 +70,9 @@@ static void lan9303_i2c_remove(struct i
  	struct lan9303_i2c *sw_dev = i2c_get_clientdata(client);
  
  	if (!sw_dev)
 -		return 0;
 +		return;
  
  	lan9303_remove(&sw_dev->chip);
--
- 	i2c_set_clientdata(client, NULL);
 -	return 0;
  }
  
  static void lan9303_i2c_shutdown(struct i2c_client *client)
diff --cc drivers/net/dsa/microchip/ksz9477_i2c.c
index 4a719ab8aa89c,e111756f64735..0000000000000
--- a/drivers/net/dsa/microchip/ksz9477_i2c.c
+++ b/drivers/net/dsa/microchip/ksz9477_i2c.c
@@@ -58,8 -58,8 +58,6 @@@ static void ksz9477_i2c_remove(struct i
  
  	if (dev)
  		ksz_switch_remove(dev);
--
- 	i2c_set_clientdata(i2c, NULL);
 -	return 0;
  }
  
  static void ksz9477_i2c_shutdown(struct i2c_client *i2c)
diff --cc drivers/net/dsa/xrs700x/xrs700x_i2c.c
index bbaf5a3fbf000,cd533b9e17eca..0000000000000
--- a/drivers/net/dsa/xrs700x/xrs700x_i2c.c
+++ b/drivers/net/dsa/xrs700x/xrs700x_i2c.c
@@@ -110,11 -110,11 +110,9 @@@ static void xrs700x_i2c_remove(struct i
  	struct xrs700x *priv = i2c_get_clientdata(i2c);
  
  	if (!priv)
 -		return 0;
 +		return;
  
  	xrs700x_switch_remove(priv);
--
- 	i2c_set_clientdata(i2c, NULL);
 -	return 0;
  }
  
  static void xrs700x_i2c_shutdown(struct i2c_client *i2c)
