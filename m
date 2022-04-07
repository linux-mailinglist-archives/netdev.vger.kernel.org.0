Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20E334F8888
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 22:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiDGUap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 16:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiDGUa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 16:30:28 -0400
Received: from relay5.hostedemail.com (relay5.hostedemail.com [64.99.140.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6B748AB23
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 13:14:48 -0700 (PDT)
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay10.hostedemail.com (Postfix) with ESMTP id DE0032FA6;
        Thu,  7 Apr 2022 20:14:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf20.hostedemail.com (Postfix) with ESMTPA id 6ABB020029;
        Thu,  7 Apr 2022 20:14:45 +0000 (UTC)
Message-ID: <2fd88e6119f62b968477ef9781abb1832d399fd6.camel@perches.com>
Subject: [PATCH] rtw89: rtw89_ser: add const to struct state_ent and
 event_ent
From:   Joe Perches <joe@perches.com>
To:     Ping-Ke Shih <pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date:   Thu, 07 Apr 2022 13:14:44 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 6ABB020029
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Stat-Signature: caq8wo8cxjieg5swcm8b8jhioa6nxfnj
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19bwPQLqVZELSCoodEWphNBTv2jJE9vPKo=
X-HE-Tag: 1649362485-65274
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change the struct and the uses to const to reduce data.

$ size drivers/net/wireless/realtek/rtw89/ser.o* (x86-64 defconfig w/ rtw89)
   text	   data	    bss	    dec	    hex	filename
   3741	      8	      0	   3749	    ea5	drivers/net/wireless/realtek/rtw89/ser.o.new
   3437	    312	      0	   3749	    ea5	drivers/net/wireless/realtek/rtw89/ser.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/realtek/rtw89/core.h | 4 ++--
 drivers/net/wireless/realtek/rtw89/ser.c  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 771722132c53b..9bf56ce5ab43f 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -2853,8 +2853,8 @@ struct rtw89_ser {
 
 	struct work_struct ser_hdl_work;
 	struct delayed_work ser_alarm_work;
-	struct state_ent *st_tbl;
-	struct event_ent *ev_tbl;
+	const struct state_ent *st_tbl;
+	const struct event_ent *ev_tbl;
 	struct list_head msg_q;
 	spinlock_t msg_q_lock; /* lock when read/write ser msg */
 	DECLARE_BITMAP(flags, RTW89_NUM_OF_SER_FLAGS);
diff --git a/drivers/net/wireless/realtek/rtw89/ser.c b/drivers/net/wireless/realtek/rtw89/ser.c
index 837cdc366a61a..7fbda7ef96bbb 100644
--- a/drivers/net/wireless/realtek/rtw89/ser.c
+++ b/drivers/net/wireless/realtek/rtw89/ser.c
@@ -396,7 +396,7 @@ static void ser_l2_reset_st_hdl(struct rtw89_ser *ser, u8 evt)
 	}
 }
 
-static struct event_ent ser_ev_tbl[] = {
+static const struct event_ent ser_ev_tbl[] = {
 	{SER_EV_NONE, "SER_EV_NONE"},
 	{SER_EV_STATE_IN, "SER_EV_STATE_IN"},
 	{SER_EV_STATE_OUT, "SER_EV_STATE_OUT"},
@@ -412,7 +412,7 @@ static struct event_ent ser_ev_tbl[] = {
 	{SER_EV_MAXX, "SER_EV_MAX"}
 };
 
-static struct state_ent ser_st_tbl[] = {
+static const struct state_ent ser_st_tbl[] = {
 	{SER_IDLE_ST, "SER_IDLE_ST", ser_idle_st_hdl},
 	{SER_RESET_TRX_ST, "SER_RESET_TRX_ST", ser_reset_trx_st_hdl},
 	{SER_DO_HCI_ST, "SER_DO_HCI_ST", ser_do_hci_st_hdl},


