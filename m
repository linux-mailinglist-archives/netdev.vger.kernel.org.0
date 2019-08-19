Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94A26925CE
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 16:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbfHSODZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 10:03:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34783 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfHSODY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 10:03:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so1295669pgc.1;
        Mon, 19 Aug 2019 07:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=SjamFk2CxAqOx3EFs9eqNhlrLUeRDX56N1XDOre1+yo=;
        b=IwWdVoHfHDGQ/UQWqVaCs8pbs+58XulU1qJRzNZ3ryIB2pXMNGtGSutnuB9Fi00Ja3
         Ps+DfblgeMkskeSFHRp1jfL2Wd6hlGJZUtD1+Gw/4OruBEF+lBvzgUmkvOlBTMv3QVsb
         T+HEWoG0YArFkY1uc0YWQ5OQhU9tAm3535hWUC3znuAAHRH3AgjUK2fBuRbBHRYXjWYy
         szZBIohhg2Qt0x5TxblkHqjfEdckOOqIxCZsbbAnm2kIq3nnOYkSBPW7L+wE1meH9OmI
         dPNOb/hi5veMPWO3NrJHWiBuE2BCDbGZTrFzXpNW1htcDwwruyAIZ2rcPmrLTOt8Gw3W
         bwjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=SjamFk2CxAqOx3EFs9eqNhlrLUeRDX56N1XDOre1+yo=;
        b=huG30vH7pzKaryO6lb6KmbvgVoiE9PeSO5h0wefl5a3m+pm5KJEaOOq5bqaUoN8DTe
         5BlPLjfpQdep6J01PDkyLwB4Mqg41MXVHf+S5AeIPzx1qcDU53UxtuQSaB/vJJQqmTU7
         CBQVqSLNx4Muz/YPp4yCzUY43r+2hQY5/YbEbzI8PCpxTcZa1zL6NSmJN3ITMeIgPcIA
         WcO7UEjk4aFwXF2GzjHPp5CqXseHSylCOaLJ6FwfzNfSkwglA0bYFqd+ebxjVKqJBLPZ
         yPYz1IqGIrOB+d2lxMuyhF/zUHykKjaU784+dhZHHMmSMjUezf3rL/EbSzpSQpUsZzxx
         n6Ug==
X-Gm-Message-State: APjAAAUiuK94euboWcSm49LXUNdYccikv5hL3luMIG9K4QNIQi1jSr8n
        hq3syul1l5tYtk+Lpy+4jNsLxkq29bk=
X-Google-Smtp-Source: APXvYqzlKbg3JZ7z0ZUFKjA38F0ZOeSpoS+Sk3hl//CKpQSPO2qwK621oY1g3aWLc1MWCHSpM2dHYw==
X-Received: by 2002:a17:90a:b395:: with SMTP id e21mr20808244pjr.76.1566223403952;
        Mon, 19 Aug 2019 07:03:23 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c2sm6933761pjs.13.2019.08.19.07.03.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 07:03:23 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net
Subject: [PATCH net-next 3/8] sctp: check asoc peer.asconf_capable before processing asconf
Date:   Mon, 19 Aug 2019 22:02:45 +0800
Message-Id: <b868cd2896190a99a8553d0cfd372e72f3dbb1b7.1566223325.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
 <4c4682aab70fc11be7a505b11939dd998b9b21f5.1566223325.git.lucien.xin@gmail.com>
 <04b2de14df6de243e9faacc3a3de091adff45d52.1566223325.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1566223325.git.lucien.xin@gmail.com>
References: <cover.1566223325.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

asconf chunks should be dropped when the asoc doesn't support
asconf feature.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 2c244b2..0c21c52 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -3721,7 +3721,8 @@ enum sctp_disposition sctp_sf_do_asconf(struct net *net,
 	 * is received unauthenticated it MUST be silently discarded as
 	 * described in [I-D.ietf-tsvwg-sctp-auth].
 	 */
-	if (!net->sctp.addip_noauth && !chunk->auth)
+	if (!asoc->peer.asconf_capable ||
+	    (!net->sctp.addip_noauth && !chunk->auth))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
 					     commands);
 
@@ -3863,7 +3864,8 @@ enum sctp_disposition sctp_sf_do_asconf_ack(struct net *net,
 	 * is received unauthenticated it MUST be silently discarded as
 	 * described in [I-D.ietf-tsvwg-sctp-auth].
 	 */
-	if (!net->sctp.addip_noauth && !asconf_ack->auth)
+	if (!asoc->peer.asconf_capable ||
+	    (!net->sctp.addip_noauth && !asconf_ack->auth))
 		return sctp_sf_discard_chunk(net, ep, asoc, type, arg,
 					     commands);
 
-- 
2.1.0

