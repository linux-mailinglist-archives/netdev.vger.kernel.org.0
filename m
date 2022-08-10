Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0480A58E4A9
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 03:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiHJBqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 21:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbiHJBqW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 21:46:22 -0400
Received: from m12-17.163.com (m12-17.163.com [220.181.12.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C99871BD3;
        Tue,  9 Aug 2022 18:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=8MRYF
        ldPybwLhKaNKSgBUpNJSUoLCQgtJ23xLo7LXjE=; b=pCP/FnQqlZW+ilvbm5f5c
        6hZKAr+AeYS04BEHgvUxiMFP3fL82P1+vD63sobfJ+QBTFjrLPT+eR1tnjk0DVb/
        aANviXuINk8qv6ON6FCV9cJhwJrm38cVpzzEIAVeFSODQIOWjO/clOaERA+VVKyv
        9OBiQtCG20vRT0IgLCgIOg=
Received: from localhost.localdomain (unknown [223.160.228.216])
        by smtp13 (Coremail) with SMTP id EcCowAB3WDq0DfNi2tD4Tg--.21550S2;
        Wed, 10 Aug 2022 09:45:26 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     bjorn@mork.no, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] net: usb: qmi_wwan: Add support for Cinterion MV32
Date:   Wed, 10 Aug 2022 09:45:21 +0800
Message-Id: <20220810014521.9383-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowAB3WDq0DfNi2tD4Tg--.21550S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zr4DCF18GFyrWr4UWw4fAFb_yoW5JFyfp3
        yjkr12yF18XF4jvFyDAF1furWFv3ZIg3sFka47Aan7WFWIyrn2grW3tFWxZ3Z7Kr4fKF4j
        qFs0q347Jas5JFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUbAwcUUUUU=
X-Originating-IP: [223.160.228.216]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiGRdZZFyPd27UAAAAst
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 models for MV32 serials. MV32-W-A is designed
based on Qualcomm SDX62 chip, and MV32-W-B is designed based
on Qualcomm SDX65 chip. So we use 2 different PID to separate it.

Test evidence as below:
T:  Bus=03 Lev=01 Prnt=01 Port=02 Cnt=03 Dev#=  3 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1e2d ProdID=00f3 Rev=05.04
S:  Manufacturer=Cinterion
S:  Product=Cinterion PID 0x00F3 USB Mobile Broadband
S:  SerialNumber=d7b4be8d
C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option

T:  Bus=03 Lev=01 Prnt=01 Port=02 Cnt=03 Dev#= 10 Spd=480 MxCh= 0
D:  Ver= 2.10 Cls=ef(misc ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
P:  Vendor=1e2d ProdID=00f4 Rev=05.04
S:  Manufacturer=Cinterion
S:  Product=Cinterion PID 0x00F4 USB Mobile Broadband
S:  SerialNumber=d095087d
C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=500mA
I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=50 Driver=qmi_wwan
I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=40 Driver=option
I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
 drivers/net/usb/qmi_wwan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 571a399c195d..709e3c59e340 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1390,6 +1390,8 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1e2d, 0x00b0, 4)},	/* Cinterion CLS8 */
 	{QMI_FIXED_INTF(0x1e2d, 0x00b7, 0)},	/* Cinterion MV31 RmNet */
 	{QMI_FIXED_INTF(0x1e2d, 0x00b9, 0)},	/* Cinterion MV31 RmNet based on new baseline */
+	{QMI_FIXED_INTF(0x1e2d, 0x00f3, 0)},	/* Cinterion MV32-W-A RmNet */
+	{QMI_FIXED_INTF(0x1e2d, 0x00f4, 0)},	/* Cinterion MV32-W-B RmNet */
 	{QMI_FIXED_INTF(0x413c, 0x81a2, 8)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a3, 8)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{QMI_FIXED_INTF(0x413c, 0x81a4, 8)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
-- 
2.25.1

