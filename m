Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C2C33E2B9
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhCQAbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhCQAbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 20:31:25 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1189C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:24 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id cx5so594617qvb.10
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 17:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=4qWCqVImBqiNGcbpNgH2D2d40R+2Q4rCGcHOmfmqK94=;
        b=ez7noJXGJLJaWb/FW9rqTRHiK60l682BKhhEFckmd8JzrWgztK0WUnSwIGIJADXjcN
         SAbB6icklzdI/5jxZ+OdBRcTT3I7tDyrp/AO486GtdaDvaRAUB7ZXcYibaW2mQ+vbY2S
         UqC0Jk0pOzQqswznXDcOZVArwipb80g+IXPZXEHdwINp5N1ysRGOI5QlaV82gecYuBRq
         GfPdHte7mUR160DX//5+f91GwdbnAA1q22vpPPiID5p9pmFoV5SV8J7PqvtZLllXttb0
         bQ3GfwpHugYU1Mfn+U4p5Mm+0mf1VbhbKMl2IAdTYjdRf2irMP4LYY9jcqK3qe1Tcejh
         jVHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=4qWCqVImBqiNGcbpNgH2D2d40R+2Q4rCGcHOmfmqK94=;
        b=hU5dU6+75xQDOEvtgQP+gP5G9XkyDDkx2y86tAEiSjFrURTPYMOG15fd+9otYQMUsa
         +cVj+BOR7jlSlaeIf55EXLNCWyTiA8hWQENN7kW+cJgXH+gk/RcDgGQjTSHP6LAULuC2
         dxEbhM2EI172QBIihYRGmKjd+8VO9TSo8erzkavsudvB2j5SNGyWKkt+BcRp9wiYuDHR
         f/S85tsR+uY8dXQbRIZtfz11dvzlQnmaYE4Qkr1mmoHfZymM9Zc/P8ZOfGQHwuCsPrHm
         yXgkgRQYZCPCzmXnwDqVa0BcS/7TuhiIhkMi/0kCFSKUQwyzwkuDhh6QCekXlT9rJEm3
         fN5A==
X-Gm-Message-State: AOAM532Oj8UBMr60oCU/I5/jlUKLXHcKWEw5YCZv3PcP4Y/O6sG13tLA
        bfLyknJ7heRhexMZoFg0p3Y=
X-Google-Smtp-Source: ABdhPJwo5n0qSL70uxUx+p6LoA0ZcSpdEs/I1UYyye2rOAKP5X7+ZD/aLf6sf4Q5A5TCyL5EXgsfKw==
X-Received: by 2002:ad4:4421:: with SMTP id e1mr2382674qvt.48.1615941083981;
        Tue, 16 Mar 2021 17:31:23 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 124sm4896002qke.107.2021.03.16.17.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 17:31:23 -0700 (PDT)
Subject: [net-next PATCH v2 06/10] netvsc: Update driver to use
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
Date:   Tue, 16 Mar 2021 17:31:20 -0700
Message-ID: <161594108034.5644.17958637318710114762.stgit@localhost.localdomain>
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


