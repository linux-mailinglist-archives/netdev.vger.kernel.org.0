Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DA71D17EF
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 16:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389059AbgEMOwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 10:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbgEMOw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 10:52:29 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46882C061A0C;
        Wed, 13 May 2020 07:52:28 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id x18so8957868ybq.8;
        Wed, 13 May 2020 07:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Ag7d1R4oU70+Y1dGMwgHYVRH8OdiIM2rnBAshx67Csg=;
        b=NM/ixUgQ77MwmVFv32i2dIj/4IHwxgmq5ZhM4IPdxDPNFw/Xyrqmhv/4AiPJMIVHri
         bHd4lqQWVL2Fd+P9oILIYjifQsnNF5G1cce5p06vNKHKHg0qFCEw7oxP2E7Ev+BgkNpa
         onpn6Fj5kHqGbvJwXRhoHESFqrO0b21QLDOXSHIL6Q92VBuJUDMm7ciuumQyG56c+BEr
         ndmkEJ5YwHkwRg9W3x8Rtq67T+l9DEVjv5Zn6lojDZ70dhluhGwDFiPTrqBNgqsS6+bo
         dbPkeiCmQOy0Qax0+QaRnOqWevOHbh5P8NlXTv/VgguH21TdLBNf5enXG+Fc2rcD1Xmr
         D4kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Ag7d1R4oU70+Y1dGMwgHYVRH8OdiIM2rnBAshx67Csg=;
        b=Vy0+CoQwsbYzLBmY763cvyp8ICWL3u28aZgmvLL+glZok4OqS9sfUOAAtn/pwxQn9J
         z8NZCkMx9PtonXIq/P1xpqfOFL8xLS3T3hqOjIdlYI5VzlICxE/i0U8qEgWpy6YPDGGB
         Jb3ZtY/VcTvONhjMikLM39IQtCfaex66rqoyj3ty9/0ygHpA0TLV5HOOymSKVeKDfEQY
         TYzry055zMlyKVrKWUolX81uhp8j0adGUlGv9Ykcf+f4i0bHavZ25hfk6FDGs2YpdpoV
         1qPqWFAL+1TpHCFB+lg4UV6lLRX7nip9oWWEumqqt8/oW610vu9ALHM3dCIxQxoKC/98
         ShhA==
X-Gm-Message-State: AOAM530xMKOxVdK4GNaxaszkZBGPoXsqf9H/4eW8VmZf4MYeK6JOy99R
        7t3tgugpLeogqxtHrJMxLBQRqLyPnJEojfVyaMc=
X-Google-Smtp-Source: ABdhPJw1+ODS777zhwKBpaQ1DEPQH6Wiw1QS2RVxWHIW4/0lA/gYWBoN1piY+NdIWjdtMZAD/7nDVNuZ6f/ZvjCCAVY=
X-Received: by 2002:a25:2e50:: with SMTP id b16mr19372364ybn.346.1589381547494;
 Wed, 13 May 2020 07:52:27 -0700 (PDT)
MIME-Version: 1.0
From:   Jonas Falkevik <jonas.falkevik@gmail.com>
Date:   Wed, 13 May 2020 16:52:16 +0200
Message-ID: <CABUN9aCXZBTdYHSK5oSVX-HAA1wTWmyBW_ked_ydsCjsV-Ckaw@mail.gmail.com>
Subject: [PATCH] sctp: check assoc before SCTP_ADDR_{MADE_PRIM,ADDED} event
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Xin Long <lucien.xin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not generate SCTP_ADDR_{MADE_PRIM,ADDED} events for SCTP_FUTURE_ASSOC assocs.

These events are described in rfc6458#section-6.1
SCTP_PEER_ADDR_CHANGE:
This tag indicates that an address that is
part of an existing association has experienced a change of
state (e.g., a failure or return to service of the reachability
of an endpoint via a specific transport address).

Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
---
 net/sctp/associola.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 437079a4883d..0c5dd295f9b8 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -432,8 +432,10 @@ void sctp_assoc_set_primary(struct sctp_association *asoc,
         changeover = 1 ;

     asoc->peer.primary_path = transport;
-    sctp_ulpevent_nofity_peer_addr_change(transport,
-                          SCTP_ADDR_MADE_PRIM, 0);
+    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
+        sctp_ulpevent_nofity_peer_addr_change(transport,
+                              SCTP_ADDR_MADE_PRIM,
+                              0);

     /* Set a default msg_name for events. */
     memcpy(&asoc->peer.primary_addr, &transport->ipaddr,
@@ -714,7 +716,10 @@ struct sctp_transport *sctp_assoc_add_peer(struct
sctp_association *asoc,
     list_add_tail_rcu(&peer->transports, &asoc->peer.transport_addr_list);
     asoc->peer.transport_count++;

-    sctp_ulpevent_nofity_peer_addr_change(peer, SCTP_ADDR_ADDED, 0);
+    if (sctp_assoc2id(asoc) != SCTP_FUTURE_ASSOC)
+        sctp_ulpevent_nofity_peer_addr_change(peer,
+                              SCTP_ADDR_ADDED,
+                              0);

     /* If we do not yet have a primary path, set one.  */
     if (!asoc->peer.primary_path) {
--
2.25.3
