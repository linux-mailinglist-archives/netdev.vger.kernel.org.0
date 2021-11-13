Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9594644F113
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 04:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbhKMDpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 22:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbhKMDpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 22:45:45 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6A8C061766;
        Fri, 12 Nov 2021 19:42:53 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so9187271pjb.1;
        Fri, 12 Nov 2021 19:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ey7VzgXF+r6CB0MM7r2mh3u+lhRQ2Cx2jmHmCPqFkI0=;
        b=WFPwxEO+35l2OBZrdX6jjDMJZ0uyaEXbNSQqInGWdUebIcKE3vg3o1ncB30/a8rqbc
         7dadMkJviYB5luqmjJGTa6d5UWuaba+UZSV8iv8eAHVmDNLTvUFkzczIQ1Toxz3Fhkaw
         6aEO6Sh6vdDn3VVNEv8ac33A9WuPKhT2HsiDlE0NsizjBQjpXeJM8AVVdbyJdPy99UA+
         7/hKQdU9BE6L7JErzD20Kb8dRTJUrGjxlWRyBzqCb5mwoyQd8R/BssnqKtB9vqKjt5wM
         JAcrAjkeB9ZBMvsMbaBwcRzmSCP/swvaa83joNopH+yDkIIwjL82cFY1vQ5P7NlwZ/CO
         tcyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ey7VzgXF+r6CB0MM7r2mh3u+lhRQ2Cx2jmHmCPqFkI0=;
        b=Vs2f/17jiuovJiWUcEdYa2Hfnd4jjuSgC6ytYYzODES4kImFKunE9FZ5mxfP/WKkhH
         Gu4JEI9YFzJUc9IFN/NiwT3tsD+eCrOTKSVS/pEkR09PN//N0Mu0zCzHMhCvJX07FRtb
         eqm5pnfBFeYrCJpMltEyb620wHX58Obx4GfvPlXjjxLKGkSXRvTm03E/g35VVWf9NfiX
         R9Rqawe2oEdTwW3PEkLlSAA0xtdN0+WHoe7mgc7yTUXS6RZGSPCiqAWVgF9pA0/B2OZU
         Jh3lA8+sLeRHVO9+s09LOFU2o0U2MKLnZd+L89MJkVJV1aw0x06BQxu8dIrMl3S2RGRI
         Gr5A==
X-Gm-Message-State: AOAM532RlJhduYyBPt1IQRkZnC1SatzV3NWQOdemyL4/KZ2Tx6bGhg3U
        JDkXt7Ayz35lS/DASehh706UDhCsCqeLa1WhRH8=
X-Google-Smtp-Source: ABdhPJwb8DmjJU8Cmm3xS4cjfLlLFr0lmkXPwRHlmIgWmxscjjuDu9kaNBpudE/biRPTsnmuXckTyQ==
X-Received: by 2002:a17:90b:1c87:: with SMTP id oo7mr18342123pjb.159.1636774973489;
        Fri, 12 Nov 2021 19:42:53 -0800 (PST)
Received: from fanta-arch.tsinghua.edu.cn ([148.163.172.142])
        by smtp.gmail.com with ESMTPSA id f21sm1497000pfc.191.2021.11.12.19.42.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 19:42:52 -0800 (PST)
From:   Letu Ren <fantasquex@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Letu Ren <fantasquex@gmail.com>,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH v2] net: igbvf: fix double free in `igbvf_probe`
Date:   Sat, 13 Nov 2021 11:42:34 +0800
Message-Id: <20211113034235.8153-1-fantasquex@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In `igbvf_probe`, if register_netdev() fails, the program will go to
label err_hw_init, and then to label err_ioremap. In free_netdev() which
is just below label err_ioremap, there is `list_for_each_entry_safe` and
`netif_napi_del` which aims to delete all entries in `dev->napi_list`.
The program has added an entry `adapter->rx_ring->napi` which is added by
`netif_napi_add` in igbvf_alloc_queues(). However, adapter->rx_ring has
been freed below label err_hw_init. So this a UAF.

In terms of how to patch the problem, we can refer to igbvf_remove() and
delete the entry before `adapter->rx_ring`.

The KASAN logs are as follows:

[   35.126075] BUG: KASAN: use-after-free in free_netdev+0x1fd/0x450
[   35.127170] Read of size 8 at addr ffff88810126d990 by task modprobe/366
[   35.128360]
[   35.128643] CPU: 1 PID: 366 Comm: modprobe Not tainted 5.15.0-rc2+ #14
[   35.129789] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[   35.131749] Call Trace:
[   35.132199]  dump_stack_lvl+0x59/0x7b
[   35.132865]  print_address_description+0x7c/0x3b0
[   35.133707]  ? free_netdev+0x1fd/0x450
[   35.134378]  __kasan_report+0x160/0x1c0
[   35.135063]  ? free_netdev+0x1fd/0x450
[   35.135738]  kasan_report+0x4b/0x70
[   35.136367]  free_netdev+0x1fd/0x450
[   35.137006]  igbvf_probe+0x121d/0x1a10 [igbvf]
[   35.137808]  ? igbvf_vlan_rx_add_vid+0x100/0x100 [igbvf]
[   35.138751]  local_pci_probe+0x13c/0x1f0
[   35.139461]  pci_device_probe+0x37e/0x6c0
[   35.165526]
[   35.165806] Allocated by task 366:
[   35.166414]  ____kasan_kmalloc+0xc4/0xf0
[   35.167117]  foo_kmem_cache_alloc_trace+0x3c/0x50 [igbvf]
[   35.168078]  igbvf_probe+0x9c5/0x1a10 [igbvf]
[   35.168866]  local_pci_probe+0x13c/0x1f0
[   35.169565]  pci_device_probe+0x37e/0x6c0
[   35.179713]
[   35.179993] Freed by task 366:
[   35.180539]  kasan_set_track+0x4c/0x80
[   35.181211]  kasan_set_free_info+0x1f/0x40
[   35.181942]  ____kasan_slab_free+0x103/0x140
[   35.182703]  kfree+0xe3/0x250
[   35.183239]  igbvf_probe+0x1173/0x1a10 [igbvf]
[   35.184040]  local_pci_probe+0x13c/0x1f0

Fixes: d4e0fe01a38a0 (igbvf: add new driver to support 82576 virtual functions)
Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
---
Changes in v2:
    - Add fixes tag
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index d32e72d953c8..d051918dfdff 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2861,6 +2861,7 @@ static int igbvf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 
 err_hw_init:
+	netif_napi_del(&adapter->rx_ring->napi);
 	kfree(adapter->tx_ring);
 	kfree(adapter->rx_ring);
 err_sw_init:
-- 
2.33.1

