Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CA033957C
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhCLRst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbhCLRsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:48:42 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AFAC061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:41 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id x29so16340107pgk.6
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 09:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=4qWCqVImBqiNGcbpNgH2D2d40R+2Q4rCGcHOmfmqK94=;
        b=Q7bhkpUXoCab7U+2m98tzWUgp56FMZaE/YyV/LTLRLIY5BVu2l5v8lf4TrfaGUj9vL
         4Yh3uyU6l++NdFOGY0Zxc8l815ipVRPJGijHQsEGp+QBKqHCQvRefAM3MhmvshYjdY9q
         WNThQbtYpjGuwaewHmZz+EQG6d3/I6UwsnYe2i/HDzb8cNoOcGPzIMm+0euXr77UQ7/1
         c2EqLy6o8CjkkuBkrX7bjg3ITsDCIjaWWXSy6CH4pMOY0Tta64+VDPWe4G9o7Hhn4p6L
         fsPfpnuTghrRGiTDlmhUKV9oyEy5gNTgMRrFKwCH/0lhok7NRYnLcH0AKbb6z5HnV5+B
         Tmgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4qWCqVImBqiNGcbpNgH2D2d40R+2Q4rCGcHOmfmqK94=;
        b=e7pRnry6IRLw6iPt5KFO4EmkCplMkA0d9cZ4OBiSPZh2U5SX8qBaW2bL7TUeJtmO0Z
         31W2fWbcsctm7BEQDlnNsi67Hendfbf23j2o1EZYusYRZgqqnd0WVvyrynbkghh9+oRv
         jKiGpcDIA9dIKa+hNXQ32JX13ES5qf2okXGTl+6ibjeO8Q5y3EiCJDABJU0SHNoIF3gq
         0RonX3VHQVweSjWRKZrJ1xwvWnZx7oyWDUqfXVURTj2uim9lJb9oE73/KScY4X1P5ufo
         OAg+LTUEQCi7eCrJkksu06r1IyqN1FndbdY1BoyLGmS7OueMyJnreO+yzGhi/u+C070O
         qbjw==
X-Gm-Message-State: AOAM531wj96gU/9Nl6Qp9CRs0szxiEU0lmPBAjJuLjZs8IGobQVTenJf
        5a2L8pUYClRHfuZjTiFVt9g=
X-Google-Smtp-Source: ABdhPJyB/d6hdhjkxAW+mdM7m9Pn5Wvf7ve6yPVAWGA2p55VpunVj1zlW0ToQjc1gYoT2V2ZmU57TA==
X-Received: by 2002:a63:ea51:: with SMTP id l17mr7678511pgk.117.1615571321362;
        Fri, 12 Mar 2021 09:48:41 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 186sm6660653pfb.143.2021.03.12.09.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:48:41 -0800 (PST)
Subject: [net-next PATCH 06/10] netvsc: Update driver to use ethtool_sprintf
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
Date:   Fri, 12 Mar 2021 09:48:40 -0800
Message-ID: <161557132005.10304.543531678348828381.stgit@localhost.localdomain>
In-Reply-To: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
References: <161557111604.10304.1798900949114188676.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Replace instances of sprintf or memcpy with a pointer update with
ethtool_sprintf.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/hyperv/netvsc_drv.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 15f262b70489..97b5c9b60503 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1612,34 +1612,23 @@ static void netvsc_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 
 	switch (stringset) {
 	case ETH_SS_STATS:
-		for (i = 0; i < ARRAY_SIZE(netvsc_stats); i++) {
-			memcpy(p, netvsc_stats[i].name, ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
+		for (i = 0; i < ARRAY_SIZE(netvsc_stats); i++)
+			ethtool_sprintf(&p, netvsc_stats[i].name);
 
-		for (i = 0; i < ARRAY_SIZE(vf_stats); i++) {
-			memcpy(p, vf_stats[i].name, ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
+		for (i = 0; i < ARRAY_SIZE(vf_stats); i++)
+			ethtool_sprintf(&p, vf_stats[i].name);
 
 		for (i = 0; i < nvdev->num_chn; i++) {
-			sprintf(p, "tx_queue_%u_packets", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "tx_queue_%u_bytes", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_packets", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_bytes", i);
-			p += ETH_GSTRING_LEN;
-			sprintf(p, "rx_queue_%u_xdp_drop", i);
-			p += ETH_GSTRING_LEN;
+			ethtool_sprintf(&p, "tx_queue_%u_packets", i);
+			ethtool_sprintf(&p, "tx_queue_%u_bytes", i);
+			ethtool_sprintf(&p, "rx_queue_%u_packets", i);
+			ethtool_sprintf(&p, "rx_queue_%u_bytes", i);
+			ethtool_sprintf(&p, "rx_queue_%u_xdp_drop", i);
 		}
 
 		for_each_present_cpu(cpu) {
-			for (i = 0; i < ARRAY_SIZE(pcpu_stats); i++) {
-				sprintf(p, pcpu_stats[i].name, cpu);
-				p += ETH_GSTRING_LEN;
-			}
+			for (i = 0; i < ARRAY_SIZE(pcpu_stats); i++)
+				ethtool_sprintf(&p, pcpu_stats[i].name, cpu);
 		}
 
 		break;


