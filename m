Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606442D3D30
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 09:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgLIIQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 03:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgLIIQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 03:16:49 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA58CC061793;
        Wed,  9 Dec 2020 00:16:09 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id w6so534291pfu.1;
        Wed, 09 Dec 2020 00:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fixlBjRW2kL0YWNC9K96DmtICObU9iPBUY8f82+kwnQ=;
        b=TrReyXGijHi4qX1gffQA287sRLgrEyWVqW6+UeQsOJNt69VPFiKTjwJAOuJHL+XdPF
         6OxxV/MAPyLN23bwoYNL6A4JVCRlo2oWv4RVfYrT2Ug3EZMslV00XwXeN8xyp1pDcMdM
         UIyb9GBUSZYgqAGwukI82h7pPhkfr0xRlAaQ1cYUqHR0Ap3+SfAE+1wmbc2b+Fbf3bQv
         GqhbxUzwTPx1D6zA6vOZcn0U2CqIlQ0ZHIZnWyxa3TGqQVzBydDyAh+vgriWOCMHfmJT
         qHnDOmaeOkpewzL6bVp7yB53160hOewXhV94eaFBkbDDI+sZACXo825ckKZYKAKhP590
         Go4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fixlBjRW2kL0YWNC9K96DmtICObU9iPBUY8f82+kwnQ=;
        b=Ah6EyqZp/4BMSJ0oy2hcPEvBSxd98X2BM1IJyD+C4iE2BGaBd1dFZmeSTPiPkXaLe7
         H1b95cOrTbOpHzyzbkMKvGy0XGzxLYtdFBUNngEehYXjamcGDMQ+/hkn0KMQ0AmaA667
         wRKpeskYP12EgmJOvTEzcv3N2XLICLvNENi66iZUQpAJop0+P32fpz7PUkkajakQui57
         Oqx9kfWsvT6us8KekazOQOaEEwiCtSiW77kGGrj0nmakAeKo4IybRVOfpk1DKe1Tk5S7
         EOHomaRQf3yVbdomZ6g7a1gEfYQdsEaSfJo2g9SCJGGJDkHRY4lxgjnjGvk9wDrQXtZH
         OiSA==
X-Gm-Message-State: AOAM531xf4JZWC2qaN0i7SZBneQF3U4oJ/fUnzsy8ZHtb8IWIIRoKotf
        F0Uk5oDwIdlP2gvUMp2YLLOzxbgAE04=
X-Google-Smtp-Source: ABdhPJxLaN0OtY1x/XUZLanliKgvcwNVRf4J3ol/EVWF75A/NBasJvrUvm7AGWl5/yvT8U2Ol1TXPQ==
X-Received: by 2002:a63:e94f:: with SMTP id q15mr951518pgj.401.1607501769313;
        Wed, 09 Dec 2020 00:16:09 -0800 (PST)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:ac46:48a7:8096:18f5])
        by smtp.gmail.com with ESMTPSA id f21sm1389206pgk.18.2020.12.09.00.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 00:16:08 -0800 (PST)
From:   Xie He <xie.he.0141@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net-next] net: x25: Fix handling of Restart Request and Restart Confirmation
Date:   Wed,  9 Dec 2020 00:16:04 -0800
Message-Id: <20201209081604.464084-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. When the x25 module gets loaded, layer 2 may already be running and
connected. In this case, although we are in X25_LINK_STATE_0, we still
need to handle the Restart Request received, rather than ignore it.

2. When we are in X25_LINK_STATE_2, we have already sent a Restart Request
and is waiting for the Restart Confirmation with t20timer. t20timer will
restart itself repeatedly forever so it will always be there, as long as we
are in State 2. So we don't need to check x25_t20timer_pending again.

Fixes: d023b2b9ccc2 ("net/x25: fix restart request/confirm handling")
Cc: Martin Schiller <ms@dev.tdt.de>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 net/x25/x25_link.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index f92073f3cb11..57a81100c5da 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -58,11 +58,6 @@ static inline void x25_stop_t20timer(struct x25_neigh *nb)
 	del_timer(&nb->t20timer);
 }
 
-static inline int x25_t20timer_pending(struct x25_neigh *nb)
-{
-	return timer_pending(&nb->t20timer);
-}
-
 /*
  *	This handles all restart and diagnostic frames.
  */
@@ -70,17 +65,20 @@ void x25_link_control(struct sk_buff *skb, struct x25_neigh *nb,
 		      unsigned short frametype)
 {
 	struct sk_buff *skbn;
-	int confirm;
 
 	switch (frametype) {
 	case X25_RESTART_REQUEST:
 		switch (nb->state) {
+		case X25_LINK_STATE_0:
+			/* This can happen when the x25 module just gets loaded
+			 * and doesn't know layer 2 has already connected
+			 */
+			nb->state = X25_LINK_STATE_3;
+			x25_transmit_restart_confirmation(nb);
+			break;
 		case X25_LINK_STATE_2:
-			confirm = !x25_t20timer_pending(nb);
 			x25_stop_t20timer(nb);
 			nb->state = X25_LINK_STATE_3;
-			if (confirm)
-				x25_transmit_restart_confirmation(nb);
 			break;
 		case X25_LINK_STATE_3:
 			/* clear existing virtual calls */
@@ -94,13 +92,8 @@ void x25_link_control(struct sk_buff *skb, struct x25_neigh *nb,
 	case X25_RESTART_CONFIRMATION:
 		switch (nb->state) {
 		case X25_LINK_STATE_2:
-			if (x25_t20timer_pending(nb)) {
-				x25_stop_t20timer(nb);
-				nb->state = X25_LINK_STATE_3;
-			} else {
-				x25_transmit_restart_request(nb);
-				x25_start_t20timer(nb);
-			}
+			x25_stop_t20timer(nb);
+			nb->state = X25_LINK_STATE_3;
 			break;
 		case X25_LINK_STATE_3:
 			/* clear existing virtual calls */
-- 
2.27.0

