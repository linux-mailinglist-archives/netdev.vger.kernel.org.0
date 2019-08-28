Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8EC19FA1A
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 07:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfH1F5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 01:57:19 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36842 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfH1F5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 01:57:18 -0400
Received: by mail-ed1-f68.google.com with SMTP id g24so1608288edu.3
        for <netdev@vger.kernel.org>; Tue, 27 Aug 2019 22:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ugH/aSIJ72DsN5lv4/8LllSgwplepZ9xmY9VgDjB0nA=;
        b=NG9eInFZqBNqmRvxt4hKJTbQ7oPkf9nTdtj5Lk3SlhF6ij0bFNZjTYDaG8EyT++vpe
         7YWJ6X+1GNWqvXMp3fJHT7QJEmMQfOVOk6z0K7exfhXJ0k95CvVLlmqMTDNoHGr0T60D
         DDTy1O/fDMZRYu5ryz+0uKw+V5zPbYODantFka223s1J/6DkBdqj3mpvVZV6ZcREr3+h
         0TsxE+iwTqVFQ/mN+1S00h9zRS4kA4xWX9eGLmtd/iJrIg8Bo3keivgxB4fFUypR5KAm
         jsDlw5zgWZplhlNtjcvN3OZRGSgsXaWVRzQzf6AtH0yV4R3DE7Z+Hg4w1a3PwWrCZ9hu
         52TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ugH/aSIJ72DsN5lv4/8LllSgwplepZ9xmY9VgDjB0nA=;
        b=m8Gzs6frfpxNH4Dvb5SbqGHGEyxfE1MttS7fNlX9fblax19dLc0s3Cq5SpF4SJQ9LW
         fjeo/d7pbgViDOMZZj/Cb1Gr8yg+rDVjFYPMRocyb534va3RHaKdRuxIct81bqgsdu/E
         SdVD+VAjcnufkQnqfUEkkMuNC18qxaMqdW+B1SPvfJoswnKiQq3TwzsGl/YedQe7Avv2
         BQIcGOAJXIgJif6PStFNRUOayYeFVX5Iu3pOdqQ24oiakiOLJhMmRGptkpJLOBnvjpXi
         wAoLMu/VdKgBomNhBb1b+RwHUdtNzJS3IcIozPjrAcL3O5Jqv2s5CUoCrIUMKBJZUq00
         P/GA==
X-Gm-Message-State: APjAAAVe6mX5buVGX95ZOAu6OMWl74ewP9imBaVX6qoNWAmWcCWLwF3x
        lMHNuWnVIq5mDb2GbXfxubO+2w==
X-Google-Smtp-Source: APXvYqyzoz6qLRBwXzszpQnRvRfdskfOolLxcEAr4rbyCSL8zQGAK1gctwpMXz0nSB16QGuT3nxo9A==
X-Received: by 2002:a50:b62b:: with SMTP id b40mr2333978ede.56.1566971836387;
        Tue, 27 Aug 2019 22:57:16 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z2sm222202ejn.18.2019.08.27.22.57.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 22:57:15 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net 2/2] nfp: flower: handle neighbour events on internal ports
Date:   Tue, 27 Aug 2019 22:56:30 -0700
Message-Id: <20190828055630.17331-3-jakub.kicinski@netronome.com>
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

Recent code changes to NFP allowed the offload of neighbour entries to FW
when the next hop device was an internal port. This allows for offload of
tunnel encap when the end-point IP address is applied to such a port.

Unfortunately, the neighbour event handler still rejects events that are
not associated with a repr dev and so the firmware neighbour table may get
out of sync for internal ports.

Fix this by allowing internal port neighbour events to be correctly
processed.

Fixes: 45756dfedab5 ("nfp: flower: allow tunnels to output to internal port")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index a7a80f4b722a..f0ee982eb1b5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -328,13 +328,13 @@ nfp_tun_neigh_event_handler(struct notifier_block *nb, unsigned long event,
 
 	flow.daddr = *(__be32 *)n->primary_key;
 
-	/* Only concerned with route changes for representors. */
-	if (!nfp_netdev_is_nfp_repr(n->dev))
-		return NOTIFY_DONE;
-
 	app_priv = container_of(nb, struct nfp_flower_priv, tun.neigh_nb);
 	app = app_priv->app;
 
+	if (!nfp_netdev_is_nfp_repr(n->dev) &&
+	    !nfp_flower_internal_port_can_offload(app, n->dev))
+		return NOTIFY_DONE;
+
 	/* Only concerned with changes to routes already added to NFP. */
 	if (!nfp_tun_has_route(app, flow.daddr))
 		return NOTIFY_DONE;
-- 
2.21.0

