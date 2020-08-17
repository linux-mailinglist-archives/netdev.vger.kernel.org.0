Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F27245FCD
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgHQIZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727795AbgHQIZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:25:18 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2284C061388;
        Mon, 17 Aug 2020 01:25:18 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id d4so7337459pjx.5;
        Mon, 17 Aug 2020 01:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=T6lw+n9mQmkGn1p4WLHa0fO/vue0T8wJx0TGHG4/TuE=;
        b=GD0jFjVi/z5Qdah7xQgj1sPqFYzpZzvzuXxRK6j9Ts6HatcSx8QcxeClItWCnE9yPM
         TneoDWoc1aDFZUV/C7XdZN01xNS5gKlqaWa8qFqGwTRcLQpFjGLZtoeDgvTAsU3Tu2H4
         HxKcwnAidW6Xj3zSP9sA6h3W0oJ406IcX6vPGuUID3oa18sIQ0t8Pv3JufwgJS5rDnu7
         +C3GyY+cjMGWxpQTHTFRgp/prP8LhGiZErDB+Q4h5ZMFbxgxxFxgU7oA9DwWSdQ+YGQP
         TGppYZKTVNwYSmSX7L7A6KlSmqdibrdDbNAeuEJp+t5SyfsggLkehmwHjgLPyedU7cDz
         Bx9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=T6lw+n9mQmkGn1p4WLHa0fO/vue0T8wJx0TGHG4/TuE=;
        b=Ngovg0gTz40jg98OnQ+ZOdaCBqNom9hmnSM5vDQSlcuLXLvx8m8wWra4i+yWhFCIS6
         as1nxwcCDe/S0J6v/6A5nr3Ukq3HOi3iR5mP0j/etFW+Nis2gbZ9ZapZmQXvmUgFPlKn
         oXjhSwRzv4TXvBR8wyrouDNxPypEkQX+m7HngdikWh2NAB8bb0XfRIxbBwpjF8+DiurS
         2LWE7S+3W/slO8sg+w6UpT92gBcV2p3F79+Z4zdzVpzEJNi7ZxoTGJApM8r8SDlTyTrw
         Kfe3DpfhHCNLvC9nVLt0ORWmQ5lAM3ktg/xXEBxyLuip5PS5rx3Fi+h/NeMYsz83EhWs
         9yWw==
X-Gm-Message-State: AOAM530g+zGgzSIkHnDHOeuflHGpDLmKO2oFp5jsZDHMlR3j05M4dugA
        Y1NOLQ6lnPZVFA9KoiOajEY=
X-Google-Smtp-Source: ABdhPJwDu5TYQAHATbCMVLUlf01g8fgt2E844DH0xvZjDgKdXuiUZDlH44A95OBtxXadmTX7B9NAlg==
X-Received: by 2002:a17:902:343:: with SMTP id 61mr7899243pld.274.1597652718233;
        Mon, 17 Aug 2020 01:25:18 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:25:17 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 04/20] ethernet: cadence: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:18 +0530
Message-Id: <20200817082434.21176-6-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 6761f404b8aa..830c537bc08c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1466,9 +1466,9 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static void macb_hresp_error_task(unsigned long data)
+static void macb_hresp_error_task(struct tasklet_struct *t)
 {
-	struct macb *bp = (struct macb *)data;
+	struct macb *bp = from_tasklet(bp, t, hresp_err_tasklet);
 	struct net_device *dev = bp->dev;
 	struct macb_queue *queue;
 	unsigned int q;
@@ -4560,8 +4560,7 @@ static int macb_probe(struct platform_device *pdev)
 		goto err_out_unregister_mdio;
 	}
 
-	tasklet_init(&bp->hresp_err_tasklet, macb_hresp_error_task,
-		     (unsigned long)bp);
+	tasklet_setup(&bp->hresp_err_tasklet, macb_hresp_error_task);
 
 	netdev_info(dev, "Cadence %s rev 0x%08x at 0x%08lx irq %d (%pM)\n",
 		    macb_is_gem(bp) ? "GEM" : "MACB", macb_readl(bp, MID),
-- 
2.17.1

