Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A15F526F3D
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiENFH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 01:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiENFHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 01:07:18 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A7511459;
        Fri, 13 May 2022 22:07:16 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id a19so9083004pgw.6;
        Fri, 13 May 2022 22:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H2vPjy+h7Y8GUV/wp9Zv2KNgoVls+M4vPazMSA3baUA=;
        b=lZb8z0XiAUTqwdC/VVUzZQTLh/PGfvDXeR0rR794bcPhRSpYzLVfWIWo21le5pWRgp
         Z40y5ok0WwmbQqOMfUbOIIY19HO5H8gig0eTIdiWYbU2W0/8DnbLRgLD8DWzdCKPYjLf
         umO3bH7hIdfiuPH6DF2ZgdaCvVRSIKqpZIVesJ3iL2bthMiTZIXg6x+w7hEYlULaY5LT
         M7gR0qB6KS9yYFPYlXRMSIvzPZOiJlth4ec14rpTYM720haFoImtfXVOWrNtmNTVWMkz
         zBCHmWb+OY5RVsa4cGqD5Dew9v4FG21o/iZWID3i6y5oDMBiTNJmETRINq60ZPtkuMJj
         GnWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H2vPjy+h7Y8GUV/wp9Zv2KNgoVls+M4vPazMSA3baUA=;
        b=juKAPcqD/v4OWUJ8l/kzBCEpnjEt+Dsu1lxHYZiT+/77YmHCB8hAOM8Zh6myg6b8KY
         Zpw56mwBDbW83vJPO8utPtEdx+YuGfPpbNSPpkt3CfmgSQX8SWt3kfiCfk8jIDMjlwa0
         80beYOTC6bC4uAzQV0pgi6GV58EYK+12UjisUSNNNBhVXt1yLR3DbfU9FNSWjr9moyXr
         7yL1xwU0OPYivih5U037+mZpCluBPFSZn0n3WSLdotAjE7jHuz53Q7fDbL7fLq8nufwy
         AnMbBj4/Si6YmfZhkQdyREcgj+udUZMX6qP4CX3tB0JqL+Ljw3n0HLaJorwXg0HfRIaH
         K4PA==
X-Gm-Message-State: AOAM533VGQQtqQecznlviTGDjXXobpBYZZ7tzT3gXeUL7slvHHO2wLut
        MceO9UXkP+mZW/m4HJtkhew=
X-Google-Smtp-Source: ABdhPJwarltTZOBUl9PmMmibemLHJjSdFDWHcXaGIewR1h+LNsnrpUESg1D8sL7Ml+1jTGT4cuaTzg==
X-Received: by 2002:a63:2b01:0:b0:3c2:4b0b:e1c6 with SMTP id r1-20020a632b01000000b003c24b0be1c6mr6523935pgr.288.1652504835592;
        Fri, 13 May 2022 22:07:15 -0700 (PDT)
Received: from localhost ([166.111.139.123])
        by smtp.gmail.com with ESMTPSA id t10-20020a62d14a000000b0050dc7628155sm2614731pfl.47.2022.05.13.22.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 22:07:15 -0700 (PDT)
From:   Zixuan Fu <r33s3n6@gmail.com>
To:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, Zixuan Fu <r33s3n6@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH v3] net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()
Date:   Sat, 14 May 2022 13:07:11 +0800
Message-Id: <20220514050711.2636709-1-r33s3n6@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vmxnet3_rq_create(), when dma_alloc_coherent() fails, 
vmxnet3_rq_destroy() is called. It sets rq->rx_ring[i].base to NULL. Then
vmxnet3_rq_create() returns an error to its callers mxnet3_rq_create_all()
-> vmxnet3_change_mtu(). Then vmxnet3_change_mtu() calls 
vmxnet3_force_close() -> dev_close() in error handling code. And the driver
calls vmxnet3_close() -> vmxnet3_quiesce_dev() -> vmxnet3_rq_cleanup_all()
-> vmxnet3_rq_cleanup(). In vmxnet3_rq_cleanup(), 
rq->rx_ring[ring_idx].base is accessed, but this variable is NULL, causing
a NULL pointer dereference.

To fix this possible bug, an if statement is added to check whether 
rq->rx_ring[0].base is NULL in vmxnet3_rq_cleanup() and exit early if so.

The error log in our fault-injection testing is shown as follows:

[   65.220135] BUG: kernel NULL pointer dereference, address: 0000000000000008
...
[   65.222633] RIP: 0010:vmxnet3_rq_cleanup_all+0x396/0x4e0 [vmxnet3]
...
[   65.227977] Call Trace:
...
[   65.228262]  vmxnet3_quiesce_dev+0x80f/0x8a0 [vmxnet3]
[   65.228580]  vmxnet3_close+0x2c4/0x3f0 [vmxnet3]
[   65.228866]  __dev_close_many+0x288/0x350
[   65.229607]  dev_close_many+0xa4/0x480
[   65.231124]  dev_close+0x138/0x230
[   65.231933]  vmxnet3_force_close+0x1f0/0x240 [vmxnet3]
[   65.232248]  vmxnet3_change_mtu+0x75d/0x920 [vmxnet3]
...

Fixes: d1a890fa37f27 ("net: VMware virtual Ethernet NIC driver: vmxnet3")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
---
v2:
* Move check to the front and exit early if rq->rx_ring[0].base is NULL.
  Thank Jakub Kicinski for helpful advice.
---
v3:
* Change targeting tree and add Fixes tag.
  Thank Paolo Abeni for helpful advice.
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index d9d90baac72a..6b8f3aaa313f 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1666,6 +1666,10 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
 	u32 i, ring_idx;
 	struct Vmxnet3_RxDesc *rxd;
 
+	/* ring has already been cleaned up */
+	if (!rq->rx_ring[0].base)
+		return;
+
 	for (ring_idx = 0; ring_idx < 2; ring_idx++) {
 		for (i = 0; i < rq->rx_ring[ring_idx].size; i++) {
 #ifdef __BIG_ENDIAN_BITFIELD
-- 
2.25.1

