Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC6D245FD4
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgHQIZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgHQIZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:25:42 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD99C061388;
        Mon, 17 Aug 2020 01:25:42 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id kr4so7457565pjb.2;
        Mon, 17 Aug 2020 01:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=39RvJQz8ipypvoPM9UBQxK34sqwXBw2fpRHeH1750N4=;
        b=InxMEUwYzhx+GnG4B1eM3y4duNRfyx1CZB/Ws7HUtFocxH7jTVin6brUpn0347NKxY
         G2vDtc6Jn/U+dIZO/rs8meMl8+D5kFk0pTu+Kq8iKPzEQX6z2YVKdlxtJGEdNAEfX4gs
         HzG5sxEy9yHpH9i/XYP/zjlfTFVttJpEeuCBLjoMmzrtbLpjW8/3H8wGNJLZJLWaX2ZL
         GRS+u1RdIHn/f/qA2wjdhyEjO3m2RbZX3lxe9fGOEVpBO6OpU5T6MjohvX+6vnKmyZwA
         CV1bKneiCat0Wl7RPi6Q7NLdBUFgwZJupvGI6vmFPrpDARH658prdsAMmX5pzSXVradm
         FHVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=39RvJQz8ipypvoPM9UBQxK34sqwXBw2fpRHeH1750N4=;
        b=E5GF4UyazdeOOrb7ieQs1EVpUwZWmr2wtaZxOgt+kb3DThwQ/AaihHHppIxx2JDm6E
         PX0ZRgX/kA2b/GXwK1t1DF+wj53e07QQpTe0MAu5dh9noPWjOcFM5NIXCwWBYfCDjdzy
         DN3Z9c4OXXMkhh7i0hsUMzWCpfm4kWRCBCsMaTgEVNKLB+dWp+wLfVMr9fqC/ob7N46f
         1DqnkE/Wioz+YXh5fLwSTxfnPzPbTUDSgV74S9bnsd//bBL6FVRcfBX8UrK0L0UkDW1B
         /AjUnhnw0jmn0e2i5LJH/ovNKX1T6g5vQ7bjzRCJ351fpUIT9NznXeBfsD4oqsF0G3L7
         cicQ==
X-Gm-Message-State: AOAM532XJorQoueLY+cFaBfIQVvg3NWtLrdK1VpGbOY5S+t64kbLOVY5
        BRnTbvzMtJTxKBV5jQVm4N4=
X-Google-Smtp-Source: ABdhPJwv5/9VRVYulpBw4/bIATV1JwJ7vrwdzGannOz/rXuZqIamAy8BJXZR+zXTAlce5mRSmFRAtg==
X-Received: by 2002:a17:90b:100e:: with SMTP id gm14mr11408110pjb.39.1597652741860;
        Mon, 17 Aug 2020 01:25:41 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:25:41 -0700 (PDT)
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
Subject: [PATCH 08/20] ethernet: hinic: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:22 +0530
Message-Id: <20200817082434.21176-10-allen.lkml@gmail.com>
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
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
index ca8cb68a8d20..f304a5b16d75 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c
@@ -370,9 +370,9 @@ static void eq_irq_work(struct work_struct *work)
  * ceq_tasklet - the tasklet of the EQ that received the event
  * @ceq_data: the eq
  **/
-static void ceq_tasklet(unsigned long ceq_data)
+static void ceq_tasklet(struct tasklet_struct *t)
 {
-	struct hinic_eq *ceq = (struct hinic_eq *)ceq_data;
+	struct hinic_eq *ceq = from_tasklet(ceq, t, ceq_tasklet);
 
 	eq_irq_handler(ceq);
 }
@@ -782,8 +782,7 @@ static int init_eq(struct hinic_eq *eq, struct hinic_hwif *hwif,
 
 		INIT_WORK(&aeq_work->work, eq_irq_work);
 	} else if (type == HINIC_CEQ) {
-		tasklet_init(&eq->ceq_tasklet, ceq_tasklet,
-			     (unsigned long)eq);
+		tasklet_setup(&eq->ceq_tasklet, ceq_tasklet);
 	}
 
 	/* set the attributes of the msix entry */
-- 
2.17.1

