Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50AD89FA19
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfH1F5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:57:16 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36836 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfH1F5P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 01:57:15 -0400
Received: by mail-ed1-f66.google.com with SMTP id g24so1608180edu.3
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 22:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5JwYHxHWxbiAqHWd0T8Qn03XO/g5rzqeZR4TZt6sC38=;
        b=B5AonbcreHBqc9E15mT2JcTs9NixKZVHMunk3pMwfreF+yJou7WnBEtailLg+h093V
         aBnSb+2QACkLKccFQOe3E2MI6u0/De0L/kCCFS/wf8XZFvnRA8FRQPCyUlJkwVt5nurE
         3+0eYFd22Jjy9EqfjcXJbXiYEaCUInOj9U/r1dvJsu2QdJG8FG6hJ+QR2Hd0qHPK+iNO
         hE30D/wdtk/m9JcFbqj2ZsdsD8OtT2vSR7cZ8WFEkDHy3SZnCE8ZgyTn6tUG/PIIy3Bw
         kjDitA1WgYGaZKd7WHZp76P1pYdxUkL0u/uvfyk0KFAg+cM62hQfeXZl6F5S2UqN3Zdi
         5uYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5JwYHxHWxbiAqHWd0T8Qn03XO/g5rzqeZR4TZt6sC38=;
        b=MzH8qapR6FKba2WNqLnZ4h9gIZi9+kzrKKWkXgeJU/P3glCyz0EWQcqXMsKtlhYdhk
         yXB1E/yWjHB0gs/eO/2G8+549uSrPxT7MdFafP2mXYUdSIOp9gYcOkAWBvu9ErAbkPJ2
         JUa7l25fT1wPG6sxYKYzTWGeDVuVMco4EHIV1p7SxvnRvXzVrEZHdUnwLALfDJHnnSjc
         yZXzNAh9yOhviAmsBoTc95X3HmnoiHK015gInNQYJm4UntGYIlQruBRLUflradlF4LuO
         OuvkytZilMjo+IuhRZR/wUfaLQU8Tz+3wGMpXR213gDwsrp+UmTd+xJluH1NvkRnEG+w
         zilg==
X-Gm-Message-State: APjAAAV3ky/VxZ3GaVlUvdNiZjzAXxVHqk+yXOxZIYIRft7AygYqmMvj
        7X2rbZlIM+L0pzTp2wCCDnAqadWNWGc=
X-Google-Smtp-Source: APXvYqwYvUcJXhVodk0kx+PsYFv6UBe9O7PsSmireoOh6YtEBsmMq5g5SoOxOIq2g7GPndr6/2IDdQ==
X-Received: by 2002:a17:907:217c:: with SMTP id rl28mr1621985ejb.183.1566971833970;
        Tue, 27 Aug 2019 22:57:13 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z2sm222202ejn.18.2019.08.27.22.57.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 22:57:13 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 1/2] nfp: flower: prevent ingress block binds on internal ports
Date:   Tue, 27 Aug 2019 22:56:29 -0700
Message-Id: <20190828055630.17331-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828055630.17331-1-jakub.kicinski@netronome.com>
References: <20190828055630.17331-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>

Internal port TC offload is implemented through user-space applications
(such as OvS) by adding filters at egress via TC clsact qdiscs. Indirect
block offload support in the NFP driver accepts both ingress qdisc binds
and egress binds if the device is an internal port. However, clsact sends
bind notification for both ingress and egress block binds which can lead
to the driver registering multiple callbacks and receiving multiple
notifications of new filters.

Fix this by rejecting ingress block bind callbacks when the port is
internal and only adding filter callbacks for egress binds.

Fixes: 4d12ba42787b ("nfp: flower: allow offloading of matches on 'internal' ports")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 9917d64694c6..457bdc60f3ee 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1409,9 +1409,10 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 	struct nfp_flower_priv *priv = app->priv;
 	struct flow_block_cb *block_cb;
 
-	if (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
-	    !(f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
-	      nfp_flower_internal_port_can_offload(app, netdev)))
+	if ((f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
+	     !nfp_flower_internal_port_can_offload(app, netdev)) ||
+	    (f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
+	     nfp_flower_internal_port_can_offload(app, netdev)))
 		return -EOPNOTSUPP;
 
 	switch (f->command) {
-- 
2.21.0

