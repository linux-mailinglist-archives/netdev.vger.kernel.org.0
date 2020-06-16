Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5731FB5F4
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 17:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729843AbgFPPT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 11:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729785AbgFPPTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 11:19:51 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62363C061573;
        Tue, 16 Jun 2020 08:19:51 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id p20so21886093ejd.13;
        Tue, 16 Jun 2020 08:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O+Qp+3HuZBNd4+rOPsruTP6zIrS2t1sCafqeC3vV5/s=;
        b=CZXp6Du1KY5swCBkAn+XpSZRFpX/MArliX3iwA3xey0f/6OFnS/Mws0l4CFknczwsd
         X5AUoqKflMT/qYeGfA2F1HSgRf+djMzax2swcw/talTsXrwrkMyYzeEiIz1AeVSVhJQE
         D5gsXtX5yOWI3IwkwBAEdaP0j73sI9+FFsYUoWD82nyOMgfUftWDQ1Ucn5L8d99SUlp9
         BfSYjjTM/kVIvmPNbhnumpDOeKRFS9l1eAmpGE9wf1OSj9RBTwVOyo8Swe+bZQ0Mr/Jp
         Xlqi4mmzSzyFZ+nCPnDrBp+79yUfz4V0mKEb5th49VtLGpm6+D1iitdG5BJuBK3WE6rY
         ZfBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O+Qp+3HuZBNd4+rOPsruTP6zIrS2t1sCafqeC3vV5/s=;
        b=NAtSzd7wTk6PFAfwxHgC9S2hVH9SG8i1XjosERLHbgE6AM5+4RI1pwMo4KN5e2fZmM
         yxuEvlg2E7bEdKctq+dL3GKOKMVTrgVf6chjo+kcp1bh8GpOqWPoXKAgXoaACS2h+lfS
         WN9WzCVGa8G74aAV8H6om2VGjzM1TZwq4wGUJi1LIsPeioQ4R6hUKxhd4YIufacJJTns
         t6EmLYu6YmIYxsQY1mPw4Vlr7g2U0Klww+QIyZKe5oqRczc2saOD6BV4+qgUQQ+vwIYJ
         YwpecOk/oQzjF+8VVb1e567L+cwPgBPWs5P4KqsoPDZIvRjfQsvyi7elQr0mlMsIK459
         k0VA==
X-Gm-Message-State: AOAM530MNX4W8kZk2t6pRT6ASKWjLqzcm0XP6S09hfuMArwP384Fb7qW
        DRu/AvnJg3UwftCK4f/L262kOkT8
X-Google-Smtp-Source: ABdhPJzhMcnjUVaVofpxT9BmFn/yAtcnKKKFwP9QprhSfERaUycQy7N7MPzXptJq+mYQmquIm7dU/w==
X-Received: by 2002:a17:906:6410:: with SMTP id d16mr3446430ejm.376.1592320790104;
        Tue, 16 Jun 2020 08:19:50 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id ce23sm11368587ejc.53.2020.06.16.08.19.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 08:19:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, joakim.tjernlund@infinera.com,
        madalin.bucur@oss.nxp.com, fido_max@inbox.ru,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net 2/2] dpaa_eth: fix usage as DSA master, try 4
Date:   Tue, 16 Jun 2020 18:19:10 +0300
Message-Id: <20200616151910.3908882-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200616151910.3908882-1-olteanv@gmail.com>
References: <20200616151910.3908882-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The dpaa-eth driver probes on compatible string for the MAC node, and
the fman/mac.c driver allocates a dpaa-ethernet platform device that
triggers the probing of the dpaa-eth net device driver.

All of this is fine, but the problem is that the struct device of the
dpaa_eth net_device is 2 parents away from the MAC which can be
referenced via of_node. So of_find_net_device_by_node can't find it, and
DSA switches won't be able to probe on top of FMan ports.

It would be a bit silly to modify a core function
(of_find_net_device_by_node) to look for dev->parent->parent->of_node
just for one driver. We're just 1 step away from implementing full
recursion.

On T1040, the /sys/class/net/eth0 symlink currently points to:

/sys/devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/dpaa-ethernet.0/net/eth0

which pretty much illustrates the problem. The closest of_node we've got
is the "fsl,fman-memac" at /soc@ffe000000/fman@400000/ethernet@e6000,
which is what we'd like to be able to reference from DSA as host port.

For of_find_net_device_by_node to find the eth0 port, we would need the
parent of the eth0 net_device to not be the "dpaa-ethernet" platform
device, but to point 1 level higher, aka the "fsl,fman-memac" node
directly. The new sysfs path would look like this:

/sys/devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0

Actually this has worked before, through the SET_NETDEV_DEV mechanism,
which sets the parent of the net_device as the parent of the platform
device. But the device which was set as sysfs parent was inadvertently
changed through commit 060ad66f9795 ("dpaa_eth: change DMA device"),
which did not take into consideration the effect it would have upon
of_find_net_device_by_node. So restore the old sysfs parent to make that
work correctly.

Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Corrected the reversed sysfs paths in the commit description
(thanks Jocke!)

 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index c4416a5f8816..2972244e6eb0 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2914,7 +2914,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 	}
 
 	/* Do this here, so we can be verbose early */
-	SET_NETDEV_DEV(net_dev, dev);
+	SET_NETDEV_DEV(net_dev, dev->parent);
 	dev_set_drvdata(dev, net_dev);
 
 	priv = netdev_priv(net_dev);
-- 
2.25.1

