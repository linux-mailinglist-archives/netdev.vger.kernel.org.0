Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1607711C5D
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 17:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfEBPNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 11:13:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40443 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfEBPNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 11:13:23 -0400
Received: by mail-wr1-f66.google.com with SMTP id h4so3883342wre.7
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 08:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3pLbw6omsWuPgSQnYCfN0GtkX9q9KvEVqwsUzq+USwk=;
        b=Ldj6qpGUWGD2BDHdJ19o71lJkxrFRVaThKYTJlB4BeUpoANK7EHLiV8CMwF/40FxDM
         tJvhIJ8SHNuSPNccBB7sL6GUkoRBahujEdGa13JeeY1MPvILCtYx4LEtROYZkQJlYuSj
         45ehH8WHZkgnMKHAm2L01yjUGxk12xAQQKwzWyn6gAGp9XIeX/VNmLOa5JqgPD5f+n1G
         fEi/V6+IkdCLXNLjWS/bxk2t6wtbVZE9N5z/jPib7vKH5h1b/TrEeOA4dhiqeGdswkXL
         pIpt8WB8wH2+uudNuzQh0DCQmpIgp4czpZRcG4wf5C2FxAIis2IlnKLE/d3eBaYoQBZp
         131w==
X-Gm-Message-State: APjAAAVSYs/JoZyTOxexrhxFlw5N8ImmwiHBEivWbHPR6HRWCU8sVRJB
        CKoSq0VwP/yyM4KT1qIa5bTeo6IDFmI=
X-Google-Smtp-Source: APXvYqwcDElKSu7Ll3TBTrQeIHFS+taBb8h9T8Er1GBYOMMnHim4Ip2e7PhnRkQqvRYX1CkcHdeQfw==
X-Received: by 2002:adf:b696:: with SMTP id j22mr3233428wre.85.1556810000810;
        Thu, 02 May 2019 08:13:20 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 195sm3166760wme.32.2019.05.02.08.13.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 May 2019 08:13:19 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH net] cls_cgroup: avoid panic when receiving a packet before filter set
Date:   Thu,  2 May 2019 17:13:18 +0200
Message-Id: <20190502151318.1884-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a cgroup classifier is added, there is a small time interval in
which tp->root is NULL. If we receive a packet in this small time slice
a NULL pointer dereference will happen, leading to a kernel panic:

    # mkdir /sys/fs/cgroup/net_cls/0
    # echo 0x100001 >  /sys/fs/cgroup/net_cls/0/net_cls.classid
    # echo $$ >/sys/fs/cgroup/net_cls/0/tasks
    # ping -qfb 255.255.255.255 -I eth0 &>/dev/null &
    # tc qdisc add dev eth0 root handle 10: htb
    # while : ; do
    > tc filter add dev eth0 parent 10: protocol ip prio 10 handle 1: cgroup
    > tc filter delete dev eth0
    > done
    Unable to handle kernel NULL pointer dereference at virtual address 0000000000000028
    Mem abort info:
      ESR = 0x96000005
      Exception class = DABT (current EL), IL = 32 bits
      SET = 0, FnV = 0
      EA = 0, S1PTW = 0
    Data abort info:
      ISV = 0, ISS = 0x00000005
      CM = 0, WnR = 0
    user pgtable: 4k pages, 39-bit VAs, pgdp = 0000000098a7ff91
    [0000000000000028] pgd=0000000000000000, pud=0000000000000000
    Internal error: Oops: 96000005 [#1] SMP
    Modules linked in: sch_htb cls_cgroup algif_hash af_alg nls_iso8859_1 nls_cp437 vfat fat xhci_plat_hcd m25p80 spi_nor xhci_hcd mtd usbcore usb_common spi_orion sfp i2c_mv64xxx phy_generic mdio_i2c marvell10g i2c_core mvpp2 mvmdio phylink sbsa_gwdt ip_tables x_tables autofs4
    Process ping (pid: 5421, stack limit = 0x00000000b20b1505)
    CPU: 3 PID: 5421 Comm: ping Not tainted 5.1.0-rc6 #31
    Hardware name: Marvell 8040 MACCHIATOBin Double-shot (DT)
    pstate: 60000005 (nZCv daif -PAN -UAO)
    pc : cls_cgroup_classify+0x80/0xec [cls_cgroup]
    lr : cls_cgroup_classify+0x34/0xec [cls_cgroup]
    sp : ffffff8012e6b850
    x29: ffffff8012e6b850 x28: ffffffc423dd3c00
    x27: ffffff801093ebc0 x26: ffffffc425a85b00
    x25: 0000000020000000 x24: 0000000000000000
    x23: ffffff8012e6b910 x22: ffffffc428db4900
    x21: ffffff8012e6b910 x20: 0000000000100001
    x19: 0000000000000000 x18: 0000000000000000
    x17: 0000000000000000 x16: 0000000000000000
    x15: 0000000000000000 x14: 0000000000000000
    x13: 0000000000000000 x12: 000000000000001c
    x11: 0000000000000018 x10: ffffff8012e6b840
    x9 : 0000000000003580 x8 : 000000000000009d
    x7 : 0000000000000002 x6 : ffffff8012e6b860
    x5 : 000000007cd66ffe x4 : 000000009742a193
    x3 : ffffff800865b4d8 x2 : ffffff8012e6b910
    x1 : 0000000000000400 x0 : ffffffc42c38f300
    Call trace:
     cls_cgroup_classify+0x80/0xec [cls_cgroup]
     tcf_classify+0x78/0x138
     htb_enqueue+0x74/0x320 [sch_htb]
     __dev_queue_xmit+0x3e4/0x9d0
     dev_queue_xmit+0x24/0x30
     ip_finish_output2+0x2e4/0x4d0
     ip_finish_output+0x1d8/0x270
     ip_mc_output+0xa8/0x240
     ip_local_out+0x58/0x68
     ip_send_skb+0x2c/0x88
     ip_push_pending_frames+0x44/0x50
     raw_sendmsg+0x458/0x830
     inet_sendmsg+0x54/0xe8
     sock_sendmsg+0x34/0x50
     __sys_sendto+0xd0/0x120
     __arm64_sys_sendto+0x30/0x40
     el0_svc_common.constprop.0+0x88/0xf8
     el0_svc_handler+0x2c/0x38
     el0_svc+0x8/0xc
    Code: 39496001 360002a1 b9425c14 34000274 (79405260)

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Fixes: ed76f5edccc9 ("net: sched: protect filter_chain list with filter_chain_lock mutex")
Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/sched/cls_cgroup.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/cls_cgroup.c b/net/sched/cls_cgroup.c
index 4c1567854f95..706a160142ea 100644
--- a/net/sched/cls_cgroup.c
+++ b/net/sched/cls_cgroup.c
@@ -32,6 +32,8 @@ static int cls_cgroup_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	struct cls_cgroup_head *head = rcu_dereference_bh(tp->root);
 	u32 classid = task_get_classid(skb);
 
+	if (unlikely(!head))
+		return -1;
 	if (!classid)
 		return -1;
 	if (!tcf_em_tree_match(skb, &head->ematches, NULL))
-- 
2.21.0

