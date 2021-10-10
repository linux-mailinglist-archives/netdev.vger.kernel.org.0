Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341D3427EA7
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 06:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbhJJEFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 00:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhJJEFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 00:05:39 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC3DC061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 21:03:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id oa12-20020a17090b1bcc00b0019f715462a8so10814961pjb.3
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 21:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=r9qA2tT2vzIUHr2uHA+7WtiQ6dQNNtcGeDw6aPM6FH0=;
        b=ZIcFMrjusZMub0YOmtOr0tt+gbFLEisUoI/bXvtum88BBe4F6PbtM+llTWr6dobhyE
         AubghA8B6oQejXC9y5fJBpCEdVeb4r3tJLSetFp5I7MaPKn4c/4PR2aeqHPN31GZXDo9
         SF7RhgaSx7FoAfX8X7YN2becvKkFxdet/EOq+5XBWvt6/5dcTzPzIAz44VhK7u2vmZ6y
         8YdE2zTXuylVhY/OWsxLUHBDJqtuemjzG6c0mrUJ5U50SNj8ghFD8J9H4QoRxPRGkkyS
         pcVBFwu9ej+CIPrvZiW/83CY9FN4Ha7QzXL7znrdpE6qlRjEs+fvwbxFmYt1zezRFJV7
         g/TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r9qA2tT2vzIUHr2uHA+7WtiQ6dQNNtcGeDw6aPM6FH0=;
        b=HVMpc2GCZaK8h3rkS1whA8nLUhHOA+nOVb/MYbi3HawEOImGrwDK/kq8LzIURfHEWI
         qN9E2ufk1sYuwmuER1A9lGu4OJ5i+OLr9K90VsjJCgujausx4izgx0KNhcAfdX2hR6TE
         DFliGBct12lNCWnm5M8QXY2EhZccL7wopeGg5xheVSjWD6xQ6Bxh3dMJ/Mx65XQnPHVF
         3EzVQfvZwzRUb5OlwQ5/eHvIWpUIwOqjj7VRrqLN1XWDnKj7ciNGXaUX8B0ThZ6o5pQw
         aCQIBTWvkI/Z4mU1hIaI/aW+9BYj7uTyC/yzj2fsrXBiOK9ZgYzUemEJvWf0ZSp2PzAV
         GizQ==
X-Gm-Message-State: AOAM533A/1Z/ROMgBcHfjy9AeSU5whXb1eIDVtP8aOngB46PgEfIGt/q
        0bZK3xAL/s21uqd9f55oUII=
X-Google-Smtp-Source: ABdhPJx5PptOQHw1z9LqfNPGle8GYmsnqip39FdZA+F6y6lWLvlgLE5VwIuFxhuY0ngrDAOwzZ6PyQ==
X-Received: by 2002:a17:902:a3c1:b0:13a:47a:1c5a with SMTP id q1-20020a170902a3c100b0013a047a1c5amr17532250plb.13.1633838620624;
        Sat, 09 Oct 2021 21:03:40 -0700 (PDT)
Received: from localhost.localdomain ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id m6sm3507763pff.189.2021.10.09.21.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 21:03:40 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     michael.chan@broadcom.com, davem@davemloft.net, kuba@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] bnxt: use netif_is_rxfh_configured instead of open code
Date:   Sun, 10 Oct 2021 13:03:27 +0900
Message-Id: <20211010040329.1078-2-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211010040329.1078-1-claudiajkang@gmail.com>
References: <20211010040329.1078-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The open code which is dev->priv_flags & IFF_RXFH_CONFIGURED is defined as
a helper function on netdevice.h. So use netif_is_rxfh_configured() 
function instead of open code. This patch doesn't change logic.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 62f84cc91e4d..b5d92e2d3887 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6366,7 +6366,7 @@ static int __bnxt_reserve_rings(struct bnxt *bp)
 	if (rx_rings != bp->rx_nr_rings) {
 		netdev_warn(bp->dev, "Able to reserve only %d out of %d requested RX rings\n",
 			    rx_rings, bp->rx_nr_rings);
-		if ((bp->dev->priv_flags & IFF_RXFH_CONFIGURED) &&
+		if (netif_is_rxfh_configured(bp->dev) &&
 		    (bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings) !=
 		     bnxt_get_nr_rss_ctxs(bp, rx_rings) ||
 		     bnxt_get_max_rss_ring(bp) >= rx_rings)) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 7260910e75fb..fbb56b1f70fd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -909,7 +909,7 @@ static int bnxt_set_channels(struct net_device *dev,
 
 	if (bnxt_get_nr_rss_ctxs(bp, req_rx_rings) !=
 	    bnxt_get_nr_rss_ctxs(bp, bp->rx_nr_rings) &&
-	    (dev->priv_flags & IFF_RXFH_CONFIGURED)) {
+	    netif_is_rxfh_configured(dev)) {
 		netdev_warn(dev, "RSS table size change required, RSS table entries must be default to proceed\n");
 		return -EINVAL;
 	}
-- 
2.25.1

