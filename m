Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26E144E884
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 15:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhKLOXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 09:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbhKLOXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 09:23:05 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBEBC061766;
        Fri, 12 Nov 2021 06:20:14 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id np3so6883763pjb.4;
        Fri, 12 Nov 2021 06:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tKyWJgE04HxRAjq5nb7ERjx0vGYGSgiBeT5zkfHPsnw=;
        b=c6tbwnM8EEdXQbXjZ6TBKu/GDieGFFzpHqyAv/x9gtsV7u9AbwnmumGLMO0/EiCoGN
         Yf5qCS4fIkHQGwoyoL4ywdKyumfkWOKyjqw9Ct2rv2+6bZv53d/FbafgVZFrMTIvTt5D
         eA/10d3nD6C+OXYQFt04R4CsZKRFYGumYpPBcd0kA0KkCHJQqztNuFVtkubP0ozjtChk
         BzZ1QUnBwMBOcg41FLNlXK2oM+wpBHHGJxrNrVy//gB9kI7KQGphRKUzKziLBwjktIbz
         3yfQyasiBzLSaitwbu4fR+QK+p8qI3zUzDDqkXL4GRpNe7PjG6B0XMXkYVuz+q/qHVq5
         gvnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tKyWJgE04HxRAjq5nb7ERjx0vGYGSgiBeT5zkfHPsnw=;
        b=hJlKLhsOJaQA+oe7go2nMLbXzmWOewvLBKKdUD61cP/DdaHk4al04IgAZe6F43JW0z
         +GI0DbtpHIdKysTmgjRGqBKn89Fv3/du1pSq9aRm/G5HCbniIU9VpptfauH9mMeljsUY
         mofvPb3fnfDaQeknaQiPxzL5s9loTKMvjPT7Om74/6enpF7ob/9R/6mnIYcDZzcrbMdV
         QayN4LWJkYefVTCnI9riybxkFNsY2fsWnccFP1nkcr0rQxFzPJPhr+6DIvbXKWWdYXNf
         1oDOGqHOdJdNBEgzkVCje6HgtqTaYRvUFMEWqjh3tjEfJ3jys8neEW0MbJKwgvH6QaPm
         0UPA==
X-Gm-Message-State: AOAM5304mVtMxlteT76+yTjnISYBXocg0lFlu6RXjmZ8nMrSHXKvXIPS
        YlDTV3HJXU+bjKd5a7Nclaw=
X-Google-Smtp-Source: ABdhPJwg92vrA9JI16k61zQqU2yfIiV/eDCJUm5tXXj6752EumHyQSBUbrIuJGcQ45rvBBQI07OUlQ==
X-Received: by 2002:a17:902:8a93:b0:142:30fe:dd20 with SMTP id p19-20020a1709028a9300b0014230fedd20mr8309699plo.29.1636726813724;
        Fri, 12 Nov 2021 06:20:13 -0800 (PST)
Received: from fanta-arch.localdomain ([148.163.172.142])
        by smtp.gmail.com with ESMTPSA id i2sm6409532pfe.70.2021.11.12.06.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 06:20:13 -0800 (PST)
From:   Letu Ren <fantasquex@gmail.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Letu Ren <fantasquex@gmail.com>,
        Zheyu Ma <zheyuma97@gmail.com>
Subject: [PATCH] net: igbvf: fix double free in `igbvf_probe`
Date:   Fri, 12 Nov 2021 22:20:02 +0800
Message-Id: <20211112142002.23156-1-fantasquex@gmail.com>
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

Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
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

