Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16E7521784
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243968AbiEJN1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 09:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242816AbiEJNYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:24:51 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6463C73C;
        Tue, 10 May 2022 06:17:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j10-20020a17090a94ca00b001dd2131159aso2038421pjw.0;
        Tue, 10 May 2022 06:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CpaxkyLXY3zOxvy+PWuOdmNGNqpS8nV9r1oVXj4P2e4=;
        b=HG9sL/v3AfTfiMs9a8C4XDwax31irSqgyAjftb/nShoJndig7yWc0P6QvRT13yGIr6
         op+i5A6QN0tquZHUsL58VthQlRr9bGIjiN9sNQ8prXKqxOOAAnfYWS2SNA/Q8zRfpOEf
         8hsAQQnuVxrw1D2tW3Oli1X3HuPNmgqC50H4JTxnXi5ZcC+RFivpME1CR/RaBZi6dzhk
         8YtIp9lp6lYlKFfmS4pS3SRSwHzdL2HsyH9OWik1YY4aS0j6d4b4YFZUk5dhelRvktY7
         QCgqEkD4c9XF5PkgK3itYp+yVmSzPZWsn1MJC36DukKHJKHKVBZSZSBF5TN2oKg5V8bF
         Hf3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CpaxkyLXY3zOxvy+PWuOdmNGNqpS8nV9r1oVXj4P2e4=;
        b=LvZYOmDcddTTJVk/V8ZIKtznEU4v3KRUXMMavq+ITzptiZX4C0PbMPrlU28LS0OdiD
         jbXEznLbjDc37FU7Rq3VAZCjNlRCKeId5sb4RGi3p/tUh4rrFmaB9MSD+11EoJmfDXeR
         viAPxHr9WM96lmnmkraRndfaHpdV1g2kvBB7tKGlFc0LzERIcq9mA2lfm3NDA5T6gUgN
         491EF6elorLemz0+3SQZcyOtdDwGiSeKqwDupbCfoyFWjud2O98f3hkpPB1ryVHLo9kF
         W0z9i+mCAIJeQvJQAXVz4z/tC63uNFzI7Ti4JFNFivbZWz4Bto+IEvh5ZOVe+3uM1SUT
         HJjA==
X-Gm-Message-State: AOAM533mRX9IdYxzlfXuWmzvJsQ0R4cowfT/LvpJDsPYSShOm6u/su4N
        E1PECVmRf97CXPGjXTZI3Kk=
X-Google-Smtp-Source: ABdhPJxGfll/v9rAGME19fDjnkXB12Zs4+hjHU+09s8eDu7Qg/tjC9cdI/LoK0+mvZC16vlLj51T1g==
X-Received: by 2002:a17:902:bf06:b0:156:af5b:e6c with SMTP id bi6-20020a170902bf0600b00156af5b0e6cmr20835014plb.147.1652188658363;
        Tue, 10 May 2022 06:17:38 -0700 (PDT)
Received: from localhost ([166.111.139.123])
        by smtp.gmail.com with ESMTPSA id c17-20020a63ef51000000b003c2f9540127sm10386232pgk.93.2022.05.10.06.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 06:17:37 -0700 (PDT)
From:   Zixuan Fu <r33s3n6@gmail.com>
To:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baijiaju1990@gmail.com, Zixuan Fu <r33s3n6@gmail.com>,
        TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH v2]  drivers: net: vmxnet3: fix possible NULL pointer dereference in vmxnet3_rq_cleanup()
Date:   Tue, 10 May 2022 21:17:27 +0800
Message-Id: <20220510131727.929547-1-r33s3n6@gmail.com>
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

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Zixuan Fu <r33s3n6@gmail.com>
---
v2:
* Move check to the front and exit early if rq->rx_ring[0].base is NULL.
  Thank Jakub Kicinski for helpful advice.
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

