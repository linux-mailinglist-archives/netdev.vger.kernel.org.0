Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9DF44F64F
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 04:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234673AbhKND1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 22:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbhKND1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Nov 2021 22:27:41 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B93C061714;
        Sat, 13 Nov 2021 19:24:48 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id v2so8931671qve.11;
        Sat, 13 Nov 2021 19:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=4ge+2NHH9JufrVRNeL90eQ7Qt84+3AXBtx69q6pXD+U=;
        b=gkIgWHqWi3Z7TSGoUEWTuoDDNtC95mMxGu2TQT2uyPTQlJGQV1HbXHqGk8dMkMUM3N
         896tcJejTWuIGENX+n/X4/mEI1nUPdcBnWggiKPj5hfqbqtjTP8UGHIXv4Ntd9TtN1Oh
         4ZWyEK9UyfxU16o1JVWm5h+ql25xEUrOIEjiezCZa9Ft4yRNlRiq4QgTuPEQyDYjO7Rk
         3D1z/VOI3m7FNjRmn5er9uMRULbOXCoQ2DerVjPlSSb1C+R8Vx6ZNSEnya3csZdjlOns
         sBucWbT1fOkiQ0D3kk7p8yG9NKOZFqokMlPLE+0hc0TZh4CVvXEIpwgEH4J+DkNIrUOO
         jCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=4ge+2NHH9JufrVRNeL90eQ7Qt84+3AXBtx69q6pXD+U=;
        b=QbBf87k2irpI6Q//Ak1QbfdDwHMOTSRhg7aKRg9uEApFWrEQmSUe/IzW2EGM5nxM2/
         +5d/klNwNSurSfkxoUxL1Zo0fK/hZfsfVLBbJ14JTKe2eOmFFvueenbPEgsHgQei8ql5
         p+lJeJiegz7LgtmlDXi4NVHln9V9qCTcpxuGZb3ktV2jJ3qSyAsAm7TrnO1TeLBW3tcv
         SP+zijsa3kuUkshLaggiXMpAeyAWCFbLuYiq5rXG8EtlzDjc/+9K7sLf9M0BOOdnIIjq
         WGVsDr2ZliuZL9yc4N9Ad9/dNKE4lBwDj2dCwYyABTRpIvY+UBFSPjoG23mchiQAYl06
         7XYw==
X-Gm-Message-State: AOAM530j2hGoDhpsdZEOwzHKy27N0e2Ozt9W9dEyJKA+i8FwGI8Mrgne
        mptKn5OcgDO3IKBHQqiZEYo=
X-Google-Smtp-Source: ABdhPJyiB/3a62OlqHSkNMnT1YeWh1AdJxRlmcqp+tiC0JFLG9EQaXqCpj+oM+UK/LuXdNAxHbi/4A==
X-Received: by 2002:a05:6214:96e:: with SMTP id do14mr26695697qvb.39.1636860286915;
        Sat, 13 Nov 2021 19:24:46 -0800 (PST)
Received: from Zekuns-MBP-16.fios-router.home (cpe-74-73-56-100.nyc.res.rr.com. [74.73.56.100])
        by smtp.gmail.com with ESMTPSA id n20sm3569356qkk.3.2021.11.13.19.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 19:24:46 -0800 (PST)
Date:   Sat, 13 Nov 2021 22:24:40 -0500
From:   Zekun Shen <bruceshenzk@gmail.com>
To:     bruceshenzk@gmail.com
Cc:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zekun Shen <bruceshenzk@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: [PATCH] atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait
Message-ID: <YZCBeNdJaWqaH1jG@Zekuns-MBP-16.fios-router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bug report shows up when running our research tools. The
reports is SOOB read, but it seems SOOB write is also possible
a few lines below.

In details, fw.len and sw.len are inputs coming from io. A len
over the size of self->rpc triggers SOOB. The patch fixes the
bugs by adding sanity checks.

The bugs are triggerable with compromised/malfunctioning devices.
They are potentially exploitable given they first leak up to
0xffff bytes and able to overwrite the region later.

The patch is tested with QEMU emulater.
This is NOT tested with a real device.

Attached is the log we found by fuzzing.

BUG: KASAN: slab-out-of-bounds in
	hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
Read of size 4 at addr ffff888016260b08 by task modprobe/213
CPU: 0 PID: 213 Comm: modprobe Not tainted 5.6.0 #1
Call Trace:
 dump_stack+0x76/0xa0
 print_address_description.constprop.0+0x16/0x200
 ? hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 ? hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 __kasan_report.cold+0x37/0x7c
 ? aq_hw_read_reg_bit+0x60/0x70 [atlantic]
 ? hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 kasan_report+0xe/0x20
 hw_atl_utils_fw_upload_dwords+0x393/0x3c0 [atlantic]
 hw_atl_utils_fw_rpc_call+0x95/0x130 [atlantic]
 hw_atl_utils_fw_rpc_wait+0x176/0x210 [atlantic]
 hw_atl_utils_mpi_create+0x229/0x2e0 [atlantic]
 ? hw_atl_utils_fw_rpc_wait+0x210/0x210 [atlantic]
 ? hw_atl_utils_initfw+0x9f/0x1c8 [atlantic]
 hw_atl_utils_initfw+0x12a/0x1c8 [atlantic]
 aq_nic_ndev_register+0x88/0x650 [atlantic]
 ? aq_nic_ndev_init+0x235/0x3c0 [atlantic]
 aq_pci_probe+0x731/0x9b0 [atlantic]
 ? aq_pci_func_init+0xc0/0xc0 [atlantic]
 local_pci_probe+0xd3/0x160
 pci_device_probe+0x23f/0x3e0

Reported-by: Brendan Dolan-Gavitt <brendandg@nyu.edu>
Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
---
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c   | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
index fc0e66006644..3f1704cbe1cb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_utils.c
@@ -559,6 +559,11 @@ int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 			goto err_exit;
 
 		if (fw.len == 0xFFFFU) {
+			if (sw.len > sizeof(self->rpc)) {
+				printk(KERN_INFO "Invalid sw len: %x\n", sw.len);
+				err = -EINVAL;
+				goto err_exit;
+			}
 			err = hw_atl_utils_fw_rpc_call(self, sw.len);
 			if (err < 0)
 				goto err_exit;
@@ -567,6 +572,11 @@ int hw_atl_utils_fw_rpc_wait(struct aq_hw_s *self,
 
 	if (rpc) {
 		if (fw.len) {
+			if (fw.len > sizeof(self->rpc)) {
+				printk(KERN_INFO "Invalid fw len: %x\n", fw.len);
+				err = -EINVAL;
+				goto err_exit;
+			}
 			err =
 			hw_atl_utils_fw_downld_dwords(self,
 						      self->rpc_addr,
-- 
2.25.1

