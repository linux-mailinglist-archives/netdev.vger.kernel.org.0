Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD6D3D4A08
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 23:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhGXUbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 16:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhGXUbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 16:31:34 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE7FC061575;
        Sat, 24 Jul 2021 14:12:04 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id y34so8217689lfa.8;
        Sat, 24 Jul 2021 14:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=akz4WOvbrA3cuPXF2MwZWYXXSucqau7Y/gPfBrEyArQ=;
        b=Oo/pi0szYoOooKidy/toS6SrMwYGmuimGttHsHkR+Benn8/38jxqT23LWa8MR+PP32
         TFVJOQEOcuxd/dXm2vox5sDhjkqb1Hi6ShTn55jc7t2QT2jpckxgE6+YE+ypVGINOOeI
         2/fUOZB15wRpuq6Xf4FIc01Wm13bZJYgTmzOMr4aAXs7Gxf6SCUd3Iu28Vr8b/NnhUxu
         jMo4IBQVmmvU+EtabRj2O5N0byuvECFct1oh/8qbBUKADjw+0Kfczo/jKMh9wI1vi0vk
         sYNbtjwQmota+HJpCtTzgR0MjKnfnFIIvn5S2ohximboAVMHhQMGBl9acHX71QrTmsKE
         mHgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=akz4WOvbrA3cuPXF2MwZWYXXSucqau7Y/gPfBrEyArQ=;
        b=e9yQLE0DiS+3o4yYse/1mBAM2Nyk3SJNkID7bIagV8tT0iZrK+MAcI5/spuHtx0YE7
         4eB39xL9/L+W1qbn6xm2jWSADpV41AD+GXSNl1UUH0Rc1h1qSv1a+dWXqlinwA1txpmf
         4bZqAaf6I1nZgHfTK7GUy8EEGGGJGEwibEPX6V/jRWK59bhuZ4lWL7VimM6xvpS/PUvG
         O6NoRfLg4nLJKMcWrm3ryAFqJwpYIv4QnQnf6b2YPUV405n6xEWv8lJl5pvBXoUg9vQl
         wjhpzfFlojysjdJA+Svp4qRnafZLMR2+M9YQLPoj0dDvhDFTpCSKdnMYc/TRU8q6w/1N
         I1rQ==
X-Gm-Message-State: AOAM53124FIaEGyqONlsc57gSWfVSbbf/hRvLyApl/1hdeAR1F8TD0hp
        7h38WVSAwRcSDyy5yTzfOuM=
X-Google-Smtp-Source: ABdhPJwbOTrgW234nWycPTjuaAUQvh6KLZSBYPqhw7kqXWjzPn0mVZswoFfnAG+9jFA39XM6V99E9g==
X-Received: by 2002:a05:6512:2152:: with SMTP id s18mr7246783lfr.124.1627161121193;
        Sat, 24 Jul 2021 14:12:01 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id 68sm3605649ljf.103.2021.07.24.14.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jul 2021 14:12:00 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, matthieu.baerts@tessares.net,
        stefan@datenfreihafen.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+5e5a981ad7cc54c4b2b4@syzkaller.appspotmail.com
Subject: [PATCH] net: llc: fix skb_over_panic
Date:   Sun, 25 Jul 2021 00:11:59 +0300
Message-Id: <20210724211159.32108-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported skb_over_panic() in llc_pdu_init_as_xid_cmd(). The
problem was in wrong LCC header manipulations.

Syzbot's reproducer tries to send XID packet. llc_ui_sendmsg() is
doing following steps:

	1. skb allocation with size = len + header size
		len is passed from userpace and header size
		is 3 since addr->sllc_xid is set.

	2. skb_reserve() for header_len = 3
	3. filling all other space with memcpy_from_msg()

Ok, at this moment we have fully loaded skb, only headers needs to be
filled.

Then code comes to llc_sap_action_send_xid_c(). This function pushes 3
bytes for LLC PDU header and initializes it. Then comes
llc_pdu_init_as_xid_cmd(). It initalizes next 3 bytes *AFTER* LLC PDU
header and call skb_push(skb, 3). This looks wrong for 2 reasons:

	1. Bytes rigth after LLC header are user data, so this function
	   was overwriting payload.

	2. skb_push(skb, 3) call can cause skb_over_panic() since
	   all free space was filled in llc_ui_sendmsg(). (This can
	   happen is user passed 686 len: 686 + 14 (eth header) + 3 (LLC
	   header) = 703. SKB_DATA_ALIGN(703) = 704)

So, in this patch I added 2 new private constansts: LLC_PDU_TYPE_U_XID
and LLC_PDU_LEN_U_XID. LLC_PDU_LEN_U_XID is used to correctly reserve
header size to handle LLC + XID case. LLC_PDU_TYPE_U_XID is used by
llc_pdu_header_init() function to push 6 bytes instead of 3. And finally
I removed skb_push() call from llc_pdu_init_as_xid_cmd().

This changes should not affect other parts of LLC, since after
all steps we just transmit buffer.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-and-tested-by: syzbot+5e5a981ad7cc54c4b2b4@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Hi, net developers!

I didn't find any LLC related tests, and, I guess, there isn't any since
LLC (802.2) has "Odd fixes" status in MAINTAINERS file. I guess, my
patch won't break something, since patch does not touch any core code,
only XID cmd path. At least, patch was tested by syzbot... I look forward to
receiving your views on this code.


With regards,
Pavel Skripkin

---
 include/net/llc_pdu.h | 31 +++++++++++++++++++++++--------
 net/llc/af_llc.c      | 10 +++++++++-
 net/llc/llc_s_ac.c    |  2 +-
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/include/net/llc_pdu.h b/include/net/llc_pdu.h
index c0f0a13ed818..49aa79c7b278 100644
--- a/include/net/llc_pdu.h
+++ b/include/net/llc_pdu.h
@@ -15,9 +15,11 @@
 #include <linux/if_ether.h>
 
 /* Lengths of frame formats */
-#define LLC_PDU_LEN_I	4       /* header and 2 control bytes */
-#define LLC_PDU_LEN_S	4
-#define LLC_PDU_LEN_U	3       /* header and 1 control byte */
+#define LLC_PDU_LEN_I		4       /* header and 2 control bytes */
+#define LLC_PDU_LEN_S		4
+#define LLC_PDU_LEN_U		3       /* header and 1 control byte */
+/* header and 1 control byte and XID info */
+#define LLC_PDU_LEN_U_XID	(LLC_PDU_LEN_U + sizeof(struct llc_xid_info))
 /* Known SAP addresses */
 #define LLC_GLOBAL_SAP	0xFF
 #define LLC_NULL_SAP	0x00	/* not network-layer visible */
@@ -50,9 +52,10 @@
 #define LLC_PDU_TYPE_U_MASK    0x03	/* 8-bit control field */
 #define LLC_PDU_TYPE_MASK      0x03
 
-#define LLC_PDU_TYPE_I	0	/* first bit */
-#define LLC_PDU_TYPE_S	1	/* first two bits */
-#define LLC_PDU_TYPE_U	3	/* first two bits */
+#define LLC_PDU_TYPE_I		0	/* first bit */
+#define LLC_PDU_TYPE_S		1	/* first two bits */
+#define LLC_PDU_TYPE_U		3	/* first two bits */
+#define LLC_PDU_TYPE_U_XID	4	/* private type for detecting XID commands */
 
 #define LLC_PDU_TYPE_IS_I(pdu) \
 	((!(pdu->ctrl_1 & LLC_PDU_TYPE_I_MASK)) ? 1 : 0)
@@ -230,9 +233,18 @@ static inline struct llc_pdu_un *llc_pdu_un_hdr(struct sk_buff *skb)
 static inline void llc_pdu_header_init(struct sk_buff *skb, u8 type,
 				       u8 ssap, u8 dsap, u8 cr)
 {
-	const int hlen = type == LLC_PDU_TYPE_U ? 3 : 4;
+	int hlen = 4; /* default value for I and S types */
 	struct llc_pdu_un *pdu;
 
+	switch (type) {
+	case LLC_PDU_TYPE_U:
+		hlen = 3;
+		break;
+	case LLC_PDU_TYPE_U_XID:
+		hlen = 6;
+		break;
+	}
+
 	skb_push(skb, hlen);
 	skb_reset_network_header(skb);
 	pdu = llc_pdu_un_hdr(skb);
@@ -374,7 +386,10 @@ static inline void llc_pdu_init_as_xid_cmd(struct sk_buff *skb,
 	xid_info->fmt_id = LLC_XID_FMT_ID;	/* 0x81 */
 	xid_info->type	 = svcs_supported;
 	xid_info->rw	 = rx_window << 1;	/* size of receive window */
-	skb_put(skb, sizeof(struct llc_xid_info));
+
+	/* no need to push/put since llc_pdu_header_init() has already
+	 * pushed 3 + 3 bytes
+	 */
 }
 
 /**
diff --git a/net/llc/af_llc.c b/net/llc/af_llc.c
index 7180979114e4..ac5cadd02cfa 100644
--- a/net/llc/af_llc.c
+++ b/net/llc/af_llc.c
@@ -98,8 +98,16 @@ static inline u8 llc_ui_header_len(struct sock *sk, struct sockaddr_llc *addr)
 {
 	u8 rc = LLC_PDU_LEN_U;
 
-	if (addr->sllc_test || addr->sllc_xid)
+	if (addr->sllc_test)
 		rc = LLC_PDU_LEN_U;
+	else if (addr->sllc_xid)
+		/* We need to expand header to sizeof(struct llc_xid_info)
+		 * since llc_pdu_init_as_xid_cmd() sets 4,5,6 bytes of LLC header
+		 * as XID PDU. In llc_ui_sendmsg() we reserved header size and then
+		 * filled all other space with user data. If we won't reserve this
+		 * bytes, llc_pdu_init_as_xid_cmd() will overwrite user data
+		 */
+		rc = LLC_PDU_LEN_U_XID;
 	else if (sk->sk_type == SOCK_STREAM)
 		rc = LLC_PDU_LEN_I;
 	return rc;
diff --git a/net/llc/llc_s_ac.c b/net/llc/llc_s_ac.c
index b554f26c68ee..79d1cef8f15a 100644
--- a/net/llc/llc_s_ac.c
+++ b/net/llc/llc_s_ac.c
@@ -79,7 +79,7 @@ int llc_sap_action_send_xid_c(struct llc_sap *sap, struct sk_buff *skb)
 	struct llc_sap_state_ev *ev = llc_sap_ev(skb);
 	int rc;
 
-	llc_pdu_header_init(skb, LLC_PDU_TYPE_U, ev->saddr.lsap,
+	llc_pdu_header_init(skb, LLC_PDU_TYPE_U_XID, ev->saddr.lsap,
 			    ev->daddr.lsap, LLC_PDU_CMD);
 	llc_pdu_init_as_xid_cmd(skb, LLC_XID_NULL_CLASS_2, 0);
 	rc = llc_mac_hdr_init(skb, ev->saddr.mac, ev->daddr.mac);
-- 
2.32.0

