Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60D1A33E2BA
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbhCQAbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhCQAbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:31:33 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75159C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:33 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id l132so37263734qke.7
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=pMHuuoPdVt7eusZdxl42EjH4STYGN/5gPWejCROpebg=;
        b=Hrc+hGjAz6aOUlVQQuwvdyPy/ZzCtegJZvy6WNRD+wnlKf77jCyqqgND/NSEhh5AlH
         +GvRx+32atGDYR5WSaIWC5aS1e0qYFEohtrYc/YULFmO9JzaC9M3B5GVYEoKk3WPeW0z
         XVaShYNuiz0GDAqlH89mVapzPiDJnceT6OsUmYTosWrFZrNv/5MoeNL8bHSJhIIJQFlh
         EqWVp3TOPu3pT2PYQtHOCWM/HPd9YuYtKE3ZdipwRrEYZ+ZJhDYI0GC7S/2uu3QSvFTh
         mP62etzpy/8UoGSzLyRFyB/3w6gbxnLEH2TrtgQ1tTsK4rrdL2Qh7YdjXw0rWrK1atbK
         EXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=pMHuuoPdVt7eusZdxl42EjH4STYGN/5gPWejCROpebg=;
        b=NtmHHXtI/WVWcMGyqGS978VxKPKWYvvJ8v2sB7RN6Ry5MLlz5Dtr4o7Zpmdr9gvL/V
         nvVjUxYjZmUlJL+JlANbfigMgYIX3hYsZ13Xx1UCyrLJDVidcdIuusjbGMrTzZ/+nXAE
         E/kKbxPpH8l7YAl5m1s0Yc2VpLzciy932KkNdxYxdoM4MStwN07v5fIVSunwCkefdk2a
         c74sFwMF9dkq9Mr6WTg3rzc3NyK4z2ooLrFEcR2H8y28QCAR4WNjC8MgjRsTQ9K+bArZ
         KLsPQNzuQBNGhOZWvw68VrkfIzlPXoO22l2H/t7Km2EzXBtzjnha4T8X+fS96TjRjk/K
         cKaw==
X-Gm-Message-State: AOAM533N33x56pBalWttQ3p4kd/V3VtBh1vJvMyjfzODZCrZ9Yj5JGLo
        mgDIt1+sdqrpONLpGBuvuJI=
X-Google-Smtp-Source: ABdhPJw+/5BrF05tXPPyi1gQMX/ztIF6kLrY9sOqKnozyf8Wu82yWstyraPG/nAN+MhEelTCTuTuVw==
X-Received: by 2002:a37:8206:: with SMTP id e6mr1898164qkd.169.1615941092656;
        Tue, 16 Mar 2021 17:31:32 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id l6sm16860274qke.34.2021.03.16.17.31.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:31:32 -0700 (PDT)
Subject: [net-next PATCH v2 07/10] virtio_net: Update driver to use
 ethtool_sprintf
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, intel-wired-lan@lists.osuosl.org,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        drivers@pensando.io, snelson@pensando.io, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, saeedb@amazon.com,
        GR-Linux-NIC-Dev@marvell.com, skalluru@marvell.com,
        rmody@marvell.com, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, mst@redhat.com,
        jasowang@redhat.com, pv-drivers@vmware.com, doshir@vmware.com,
        alexanderduyck@fb.com, Kernel-team@fb.com
Date:   Tue, 16 Mar 2021 17:31:29 -0700
Message-ID: <161594108914.5644.2813119476748144220.stgit@localhost.localdomain>
In-Reply-To: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
References: <161594093708.5644.11391417312031401152.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Update the code to replace instances of snprintf and a pointer update with
just calling ethtool_sprintf.

Also replace the char pointer with a u8 pointer to avoid having to recast
the pointer type.

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/virtio_net.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index e97288dd6e5a..77ba8e2fc11c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2138,25 +2138,21 @@ static int virtnet_set_channels(struct net_device *dev,
 static void virtnet_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
-	char *p = (char *)data;
 	unsigned int i, j;
+	u8 *p = data;
 
 	switch (stringset) {
 	case ETH_SS_STATS:
 		for (i = 0; i < vi->curr_queue_pairs; i++) {
-			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++) {
-				snprintf(p, ETH_GSTRING_LEN, "rx_queue_%u_%s",
-					 i, virtnet_rq_stats_desc[j].desc);
-				p += ETH_GSTRING_LEN;
-			}
+			for (j = 0; j < VIRTNET_RQ_STATS_LEN; j++)
+				ethtool_sprintf(&p, "rx_queue_%u_%s", i,
+						virtnet_rq_stats_desc[j].desc);
 		}
 
 		for (i = 0; i < vi->curr_queue_pairs; i++) {
-			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++) {
-				snprintf(p, ETH_GSTRING_LEN, "tx_queue_%u_%s",
-					 i, virtnet_sq_stats_desc[j].desc);
-				p += ETH_GSTRING_LEN;
-			}
+			for (j = 0; j < VIRTNET_SQ_STATS_LEN; j++)
+				ethtool_sprintf(&p, "tx_queue_%u_%s", i,
+						virtnet_sq_stats_desc[j].desc);
 		}
 		break;
 	}


