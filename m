Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF8368A6ED
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 00:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbjBCXbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 18:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjBCXbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 18:31:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACAEA42A0;
        Fri,  3 Feb 2023 15:31:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01D436203E;
        Fri,  3 Feb 2023 23:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C98DC433D2;
        Fri,  3 Feb 2023 23:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675467094;
        bh=SEQiN1FXnyRmTAzODDJiAbEbmAR87JugLAgVlHlTLHo=;
        h=From:To:Cc:Subject:Date:From;
        b=qRZw/n2dwl7bKxjh1eW7SudjQchV6bYN7Ikq6OtCcDTYgQqL5YWggBuxXtSsfa23d
         791buxLOr+jVu6VtcCjp2TbL5BrqeLskaOK6/AaFcyRsRmU/Q7Hi0El/7MmriRS5ir
         RJkeQexSO5H+RJ1HYk62meA7HbXFHaietuBZGMsgteOdZvuknmSS76FHuBIhivUhYO
         iGRPucy7IByscMpMGKqREQJ9qtB1QAk0l0gYz35zbmfvDQ8+b2ipcHpA2Vtvks/0CL
         f6CPlvfGbwFahL0mfJfftmHeaS2GrV4P8Jzq/E7gm2aJ0UATTjW1cX+wjiOFCqcE8L
         VkWEm9K+ZSFNA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mchehab@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        hverkuil@xs4all.nl, gregkh@linuxfoundation.org,
        linux-media@vger.kernel.org, linux-staging@lists.linux.dev
Subject: [PATCH] media: drop unnecessary networking includes
Date:   Fri,  3 Feb 2023 15:31:29 -0800
Message-Id: <20230203233129.3413367-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dvb_net.h includes a bunch of core networking headers which increases
the number of objects rebuilt when we touch them. They are unnecessary
for the header itself and only one driver has an indirect dependency.

tveeprom.h includes if_packet to gain access to ETH_ALEN. This
is a bit of an overkill because if_packet.h pulls in skbuff.h.
The definition of ETH_ALEN is in the uAPI header, which is
very rarely touched, so switch to including that.

This results in roughly 250 fewer objects built when skbuff.h
is touched (6028 -> 5788).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: mchehab@kernel.org
CC: hverkuil@xs4all.nl
CC: gregkh@linuxfoundation.org
CC: linux-media@vger.kernel.org
CC: linux-staging@lists.linux.dev
---
 drivers/media/usb/dvb-usb/pctv452e.c                       | 2 ++
 drivers/staging/media/deprecated/saa7146/ttpci/budget-av.c | 1 +
 include/media/dvb_net.h                                    | 6 ++----
 include/media/tveeprom.h                                   | 2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/pctv452e.c b/drivers/media/usb/dvb-usb/pctv452e.c
index f0794c68c622..da42c989e071 100644
--- a/drivers/media/usb/dvb-usb/pctv452e.c
+++ b/drivers/media/usb/dvb-usb/pctv452e.c
@@ -26,6 +26,8 @@
 #include <media/dvb_ca_en50221.h>
 #include "ttpci-eeprom.h"
 
+#include <linux/etherdevice.h>
+
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
diff --git a/drivers/staging/media/deprecated/saa7146/ttpci/budget-av.c b/drivers/staging/media/deprecated/saa7146/ttpci/budget-av.c
index 0c61a2dec221..3cc762100498 100644
--- a/drivers/staging/media/deprecated/saa7146/ttpci/budget-av.c
+++ b/drivers/staging/media/deprecated/saa7146/ttpci/budget-av.c
@@ -31,6 +31,7 @@
 #include "dvb-pll.h"
 #include "../common/saa7146_vv.h"
 #include <linux/module.h>
+#include <linux/etherdevice.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
diff --git a/include/media/dvb_net.h b/include/media/dvb_net.h
index 5e31d37f25fa..9980b1dd750b 100644
--- a/include/media/dvb_net.h
+++ b/include/media/dvb_net.h
@@ -19,13 +19,11 @@
 #define _DVB_NET_H_
 
 #include <linux/module.h>
-#include <linux/netdevice.h>
-#include <linux/inetdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/skbuff.h>
 
 #include <media/dvbdev.h>
 
+struct net_device;
+
 #define DVB_NET_DEVICES_MAX 10
 
 #ifdef CONFIG_DVB_NET
diff --git a/include/media/tveeprom.h b/include/media/tveeprom.h
index b56eaee82aa5..f37c9b15ffdb 100644
--- a/include/media/tveeprom.h
+++ b/include/media/tveeprom.h
@@ -5,7 +5,7 @@
  *	      eeproms.
  */
 
-#include <linux/if_ether.h>
+#include <uapi/linux/if_ether.h>
 
 /**
  * enum tveeprom_audio_processor - Specifies the type of audio processor
-- 
2.39.1

