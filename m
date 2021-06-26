Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083EC3B4C06
	for <lists+netdev@lfdr.de>; Sat, 26 Jun 2021 04:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhFZCn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 22:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFZCnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 22:43:25 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D01FC061574;
        Fri, 25 Jun 2021 19:41:02 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id u11so12698496wrw.11;
        Fri, 25 Jun 2021 19:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UU6DtDGiyA1vWHeojTVbBhsXsciQ4zbhSh2JaptoGlM=;
        b=F8zwdD98RmyMrdOnZJfAllkLtp9ONn2LICEEp4xTbn9dJ0FAf6G10O/Y6xaShcbdH4
         fowt8s4SgFTJy9sYysQ9D7/DnLsSn1FFfX1QaVgazX6oWuh3lk0B/kkjA/LGLHmSUNFM
         DfNIuoIy+mdi+eq3j27J0gDAhaO42Sl44VGEdgeL2kpDCmR2JZWzxFAsMDB9k1KJqtLJ
         OLqDDtCXqoVSybXalKkRiA1+1+8fdThftGMZpuaySWDju8ct00kqCqZ/OkQXHy7FxNhQ
         vDSYwNrk6NSD2DSmwDRgAHFDvNT4JvR1s+ByXB8ZHP3USWn21ga6OEcmE/dg7lSf1NP7
         z9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UU6DtDGiyA1vWHeojTVbBhsXsciQ4zbhSh2JaptoGlM=;
        b=gQCRiMeSs2d5I0g6QGO0tgDabdWjBXhxSL7JqCyVEdgwN/oswxjYHqZbjT71XUmoMc
         jVlZ+umVuE7GHP1AMGjIfBAHafDjZ6E75Y+IyMF1Tftsuz8GOu4dBwWTuX0ftbncfq7F
         Ofl28iEy/d1K09IbhRxCXO0Gn20kD0FcdqVwosrQZ0GKdpM7kuxHuQSDXSv8zCruEew8
         pqH5pdHz/Jj86nmp245rOe7sgHcbCno38E+0vVStEbdxwXc/8bsNtBUVGEWsjIXf2gmd
         uZjRdlCo760iMZukK67MCXIQHCq5l5DrdZcrNqP2jfuSGJaR8jzm/2uKORPJdR/xlctw
         5/2A==
X-Gm-Message-State: AOAM532Z8cinLiaQn51TkM84FUTG04fb8W5vPkinnDCZvIacSfMVhR7a
        uqYZF4sQVuNlw6yQMwRQSeszCCoJXhv+lQ==
X-Google-Smtp-Source: ABdhPJwTbufVLCPjPBiMAKL+ikWjTS2sfT7BYhtccZQzg0Xqa4Xg6LecFRSjMlHv2mI7ghmtqcPahg==
X-Received: by 2002:a5d:42c2:: with SMTP id t2mr15150866wrr.382.1624675261145;
        Fri, 25 Jun 2021 19:41:01 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p13sm6005425wrx.30.2021.06.25.19.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 19:41:00 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Cc:     David Laight <david.laight@aculab.com>
Subject: [PATCHv2 net-next 2/2] sctp: send the next probe immediately once the last one is acked
Date:   Fri, 25 Jun 2021 22:40:55 -0400
Message-Id: <8b14c16d4300761026bf694cc2384b49d0d94c5b.1624675179.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624675179.git.lucien.xin@gmail.com>
References: <cover.1624675179.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These is no need to wait for 'interval' period for the next probe
if the last probe is already acked in search state. The 'interval'
period waiting should be only for probe failure timeout and the
current pmtu check when it's in search complete state.

This change will shorten the probe time a lot in search state, and
also fix the document accordingly.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 Documentation/networking/ip-sysctl.rst | 12 ++++++++----
 net/sctp/sm_statefuns.c                |  5 ++++-
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 8bff728b3a1e..b3fa522e4cd9 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2835,10 +2835,14 @@ encap_port - INTEGER
 	Default: 0
 
 plpmtud_probe_interval - INTEGER
-        The time interval (in milliseconds) for sending PLPMTUD probe chunks.
-        These chunks are sent at the specified interval with a variable size
-        to probe the mtu of a given path between 2 endpoints. PLPMTUD will
-        be disabled when 0 is set, and other values for it must be >= 5000.
+        The time interval (in milliseconds) for the PLPMTUD probe timer,
+        which is configured to expire after this period to receive an
+        acknowledgment to a probe packet. This is also the time interval
+        between the probes for the current pmtu when the probe search
+        is done.
+
+        PLPMTUD will be disabled when 0 is set, and other values for it
+        must be >= 5000.
 
 	Default: 0
 
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index d29b579da904..09a8f23ec709 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -1275,7 +1275,10 @@ enum sctp_disposition sctp_sf_backbeat_8_3(struct net *net,
 			return SCTP_DISPOSITION_DISCARD;
 
 		sctp_transport_pl_recv(link);
-		return SCTP_DISPOSITION_CONSUME;
+		if (link->pl.state == SCTP_PL_COMPLETE)
+			return SCTP_DISPOSITION_CONSUME;
+
+		return sctp_sf_send_probe(net, ep, asoc, type, link, commands);
 	}
 
 	max_interval = link->hbinterval + link->rto;
-- 
2.27.0

