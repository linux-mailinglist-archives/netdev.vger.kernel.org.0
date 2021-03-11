Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAD23369C4
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 02:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbhCKBgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 20:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhCKBfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 20:35:53 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DFE8C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:53 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id j6so9419823plx.6
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 17:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=gjUKyxfRSZ9KQb0GApNYBSrbkiY1WDSvI3WYH/8KsxA=;
        b=u8cC+tH2OdI23NPwMUfM9q8AtQwkzyfBrjw/U5ZR+DyCtlCTM8RGpEXrj+Tzc9Gl/H
         BajYX7k/hg8P2P3gOfnqmw4FJ9iGMbOU3TlUGJS4dcmSPmXuISyq4ncwTjW66hHvzXmn
         BNqwWzVOmoBsTzgyxCaKANwAO/dgLFb9Jy2UxwhYMptaG/7KyuIr3NLWSCNauVmVr7+N
         PjNcgbdX/qrEsl3L7f271EL9/W/EEq4GrcFikvkfDe4kBzhxwLF0lqQS4ptMQhTh/ovG
         xFkXZOobFv4iES5CEhwc2u7Uv+c5cRyi6BU40BkC1T4HUOy5E3zfOvKEKwxo8cp30LYC
         ktXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=gjUKyxfRSZ9KQb0GApNYBSrbkiY1WDSvI3WYH/8KsxA=;
        b=uCpJnpIm7Noxq5UffxeVffiHcJ+xljV1e3ioEap/PqoWbfiUpbluLc3t/yD7dM1Wz+
         NsFFkRiTWgyLnaTsAjSKnAyxrFndjaGM+Dx3pLi7UhZTnhxAet16HsFZi7aBYEPRTr67
         IXdXzuIs8M6bxWd6ID1q4d7owCsw5qrZeIO9VSJHmKz4O+CUrv27+1/q0nAh8kSJFMLm
         /qMOGAdaVHKL50jc/1MsVPbwL+/5ZmZR7Cf+DUjk58DxxkdeBfhUIXKLmaleGuD1FlJB
         Vy7cZysZz8DNLIURIu31AkZZz13Wa3JQ/42NiuJrY6aQWFJUXLEqmFSi32XvxdPGHpeM
         2n/g==
X-Gm-Message-State: AOAM531BDmNEhnCf7d5xgdufPtNzWW/P8GwQneM4UNXjoNz/R6/q7JpI
        tb/frWv0nperhMVtaCoHBNY=
X-Google-Smtp-Source: ABdhPJzsaBtuYws+WbFc5ViRYd7HYPi/Jf+g7NHj24gJJRj+48fgZ6uhjjM1HaD18w9JcyXgU+j2wA==
X-Received: by 2002:a17:902:8306:b029:e6:125c:1a3a with SMTP id bd6-20020a1709028306b02900e6125c1a3amr5836539plb.65.1615426553036;
        Wed, 10 Mar 2021 17:35:53 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id u17sm602970pgl.80.2021.03.10.17.35.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 17:35:52 -0800 (PST)
Subject: [RFC PATCH 06/10] netvsc: Update driver to use ethtool_gsprintf
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kuba@kernel.org
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
        alexanderduyck@fb.com
Date:   Wed, 10 Mar 2021 17:35:51 -0800
Message-ID: <161542655182.13546.1667822428160833259.stgit@localhost.localdomain>
In-Reply-To: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
References: <161542634192.13546.4185974647834631704.stgit@localhost.localdomain>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Duyck <alexanderduyck@fb.com>

Replace instances of sprintf or memcpy with a pointer update with
ethtool_gsprintf.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
---
 drivers/net/hyperv/netvsc_drv.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 15f262b70489..4e8446a81c0b 100644
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
+			ethtool_gsprintf(&p, netvsc_stats[i].name);
 
-		for (i = 0; i < ARRAY_SIZE(vf_stats); i++) {
-			memcpy(p, vf_stats[i].name, ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
+		for (i = 0; i < ARRAY_SIZE(vf_stats); i++)
+			ethtool_gsprintf(&p, vf_stats[i].name);
 
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
+			ethtool_gsprintf(&p, "tx_queue_%u_packets", i);
+			ethtool_gsprintf(&p, "tx_queue_%u_bytes", i);
+			ethtool_gsprintf(&p, "rx_queue_%u_packets", i);
+			ethtool_gsprintf(&p, "rx_queue_%u_bytes", i);
+			ethtool_gsprintf(&p, "rx_queue_%u_xdp_drop", i);
 		}
 
 		for_each_present_cpu(cpu) {
-			for (i = 0; i < ARRAY_SIZE(pcpu_stats); i++) {
-				sprintf(p, pcpu_stats[i].name, cpu);
-				p += ETH_GSTRING_LEN;
-			}
+			for (i = 0; i < ARRAY_SIZE(pcpu_stats); i++)
+				ethtool_gsprintf(&p, pcpu_stats[i].name, cpu);
 		}
 
 		break;


