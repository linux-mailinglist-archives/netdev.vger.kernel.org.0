Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C530115BF
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfEBIvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:51:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40953 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbfEBIvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 04:51:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id h4so2144759wre.7
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 01:51:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8A56Rre3k7aBGmNQU4YWhBjgqJZl+Mib35DSUhbaDps=;
        b=UpUMjJqsGifpOCEcW9jXly4Ms27rne3/Za8oqzbVg4DVUwb/3Bni10wA0EHuF5V269
         AMA+3rRhPuskUyHf3slbsc5GcHxpJeIeEB14uGND4pNYimDZsUR+r8/2nXbAjc0PtBOD
         smu8x5RnxWg6DKbxupCpXxMQiV8xbrXlb4aB/yjnOPw/BkNwfl+JeAevCvtZKACtmt6J
         88lqhxOVacgke33zsnUfMeQc51buJmgEFhdLUO1nOpoAVFXA/N1WLHfAeVC8o34NCjMI
         PdcoJg0+JYgS/b1WY8HzE+Mp2HdlmgnCMs750cIE7x+z2P0fZLt7P0bBbwfvPCitauKn
         6BEQ==
X-Gm-Message-State: APjAAAXrbDboTuNxqHJ/gc/dzqv0ybbgpjrGJFlGpLJTZC3m+DEtZaAj
        DZ+M54p7efpWihzFZ910a/LQd1w0qTs=
X-Google-Smtp-Source: APXvYqzKqA26TTVFlks64WQcHDvLTQwxTMy9/MTjIb4emoa26zr+WwjZxZm/vqVP61IX92eMbf3LlQ==
X-Received: by 2002:a5d:5545:: with SMTP id g5mr1902942wrw.146.1556787067242;
        Thu, 02 May 2019 01:51:07 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y4sm6523232wmj.20.2019.05.02.01.51.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 May 2019 01:51:06 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net] cls_matchall: avoid panic when receiving a packet before filter set
Date:   Thu,  2 May 2019 10:51:05 +0200
Message-Id: <20190502085105.2967-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a matchall classifier is added, there is a small time interval in
which tp->root is NULL. If we receive a packet in this small time slice
a NULL pointer dereference will happen, leading to a kernel panic:

    # tc qdisc replace dev eth0 ingress
    # tc filter add dev eth0 parent ffff: matchall action gact drop
    Unable to handle kernel NULL pointer dereference at virtual address 0000000000000034
    Mem abort info:
      ESR = 0x96000005
      Exception class = DABT (current EL), IL = 32 bits
      SET = 0, FnV = 0
      EA = 0, S1PTW = 0
    Data abort info:
      ISV = 0, ISS = 0x00000005
      CM = 0, WnR = 0
    user pgtable: 4k pages, 39-bit VAs, pgdp = 00000000a623d530
    [0000000000000034] pgd=0000000000000000, pud=0000000000000000
    Internal error: Oops: 96000005 [#1] SMP
    Modules linked in: cls_matchall sch_ingress nls_iso8859_1 nls_cp437 vfat fat m25p80 spi_nor mtd xhci_plat_hcd xhci_hcd phy_generic sfp mdio_i2c usbcore i2c_mv64xxx marvell10g mvpp2 usb_common spi_orion mvmdio i2c_core sbsa_gwdt phylink ip_tables x_tables autofs4
    Process ksoftirqd/0 (pid: 9, stack limit = 0x0000000009de7d62)
    CPU: 0 PID: 9 Comm: ksoftirqd/0 Not tainted 5.1.0-rc6 #21
    Hardware name: Marvell 8040 MACCHIATOBin Double-shot (DT)
    pstate: 40000005 (nZcv daif -PAN -UAO)
    pc : mall_classify+0x28/0x78 [cls_matchall]
    lr : tcf_classify+0x78/0x138
    sp : ffffff80109db9d0
    x29: ffffff80109db9d0 x28: ffffffc426058800
    x27: 0000000000000000 x26: ffffffc425b0dd00
    x25: 0000000020000000 x24: 0000000000000000
    x23: ffffff80109dbac0 x22: 0000000000000001
    x21: ffffffc428ab5100 x20: ffffffc425b0dd00
    x19: ffffff80109dbac0 x18: 0000000000000000
    x17: 0000000000000000 x16: 0000000000000000
    x15: 0000000000000000 x14: 0000000000000000
    x13: ffffffbf108ad288 x12: dead000000000200
    x11: 00000000f0000000 x10: 0000000000000001
    x9 : ffffffbf1089a220 x8 : 0000000000000001
    x7 : ffffffbebffaa950 x6 : 0000000000000000
    x5 : 000000442d6ba000 x4 : 0000000000000000
    x3 : ffffff8008735ad8 x2 : ffffff80109dbac0
    x1 : ffffffc425b0dd00 x0 : ffffff8010592078
    Call trace:
     mall_classify+0x28/0x78 [cls_matchall]
     tcf_classify+0x78/0x138
     __netif_receive_skb_core+0x29c/0xa20
     __netif_receive_skb_one_core+0x34/0x60
     __netif_receive_skb+0x28/0x78
     netif_receive_skb_internal+0x2c/0xc0
     napi_gro_receive+0x1a0/0x1d8
     mvpp2_poll+0x928/0xb18 [mvpp2]
     net_rx_action+0x108/0x378
     __do_softirq+0x128/0x320
     run_ksoftirqd+0x44/0x60
     smpboot_thread_fn+0x168/0x1b0
     kthread+0x12c/0x130
     ret_from_fork+0x10/0x1c
    Code: aa0203f3 aa1e03e0 d503201f f9400684 (b9403480)
    ---[ end trace fc71e2ef7b8ab5a5 ]---
    Kernel panic - not syncing: Fatal exception in interrupt
    SMP: stopping secondary CPUs
    Kernel Offset: disabled
    CPU features: 0x002,00002000
    Memory Limit: none
    Rebooting in 1 seconds..

Fix this by adding a NULL check in mall_classify().

Fixes: ed76f5edccc9 ("net: sched: protect filter_chain list with filter_chain_lock mutex")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/sched/cls_matchall.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index a13bc351a414..3d021f2aad1c 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -32,6 +32,9 @@ static int mall_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 {
 	struct cls_mall_head *head = rcu_dereference_bh(tp->root);
 
+	if (unlikely(!head))
+		return -1;
+
 	if (tc_skip_sw(head->flags))
 		return -1;
 
-- 
2.21.0

