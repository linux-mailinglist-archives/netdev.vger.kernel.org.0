Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7BCE956
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 19:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbfD2RiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 13:38:21 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33057 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbfD2RiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 13:38:10 -0400
Received: by mail-wr1-f67.google.com with SMTP id s18so17344427wrp.0
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 10:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0omHDewSx32O4bBDBWpepZGBksu0q9LlHFraC8bW9WE=;
        b=asDaD9AxKe1nQCBDnfGBguX2l9g6ulARQXYBsTfh7EsEFHA0MAJocRADtBwDuh0HA6
         vEWZ/RfmhbRo31BApfgB84jLjx2dEWwbTj8ZXYe6m7HZ+rxrAuKLREMdXe8DSt2UVpZL
         4r9qCCtrhJnONQEjl22HDCTu85e04am1C9mNLTREkSOLnwVNsdtjf+9Nw4Z56RYRh8Y7
         2DmJTsq2hm8jr6Byc9LkMjVLhU7LZj0dQPJZOwgwJUoFS5P4iWde+b6Qd7wR4jeRfed5
         LgJ4VmA6WfAVRvfxqezzrZvLTner4LazLvSZwfTmRY03FwGzdMpZ17fAKYuMzUk+UxSR
         eGeA==
X-Gm-Message-State: APjAAAWCsLB3RuAybJHLLzpR7QsP2JApPvz/mD0+bdDt05j+ZxAGXaO+
        CTI3Qz1cbW5HWv4k4M0i44mlAJNwUGk=
X-Google-Smtp-Source: APXvYqxB8t3OO+Hk+A6mJqpJRAxbX9yChJfL6kq6ukDjNcwxsPp3wR8rYIRijlai2QxXC2pgePIcxQ==
X-Received: by 2002:adf:e984:: with SMTP id h4mr2222937wrm.32.1556559487300;
        Mon, 29 Apr 2019 10:38:07 -0700 (PDT)
Received: from raver.teknoraver.net (net-93-70-69-135.cust.vodafonedsl.it. [93.70.69.135])
        by smtp.gmail.com with ESMTPSA id z7sm86811wml.40.2019.04.29.10.38.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 29 Apr 2019 10:38:06 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net] cls_matchall: avoid panic when receiving a packet before filter set
Date:   Mon, 29 Apr 2019 19:38:05 +0200
Message-Id: <20190429173805.4455-1-mcroce@redhat.com>
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

Fix this by creating a dummy action in the init which is skipped
by mall_classify, and remove it upon the first action set in
mall_change. Doing this we avoid adding an extra check in the classify.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 net/sched/cls_matchall.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index a13bc351a414..8aaa9d80c2ca 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -27,6 +27,10 @@ struct cls_mall_head {
 	struct rcu_work rwork;
 };
 
+static const struct cls_mall_head match_none = {
+	.flags = TCA_CLS_FLAGS_SKIP_SW
+};
+
 static int mall_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 			 struct tcf_result *res)
 {
@@ -42,6 +46,8 @@ static int mall_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 
 static int mall_init(struct tcf_proto *tp)
 {
+	rcu_assign_pointer(tp->root, &match_none);
+
 	return 0;
 }
 
@@ -114,7 +120,7 @@ static void mall_destroy(struct tcf_proto *tp, bool rtnl_held,
 {
 	struct cls_mall_head *head = rtnl_dereference(tp->root);
 
-	if (!head)
+	if (head == &match_none)
 		return;
 
 	tcf_unbind_filter(tp, &head->res);
@@ -132,7 +138,7 @@ static void *mall_get(struct tcf_proto *tp, u32 handle)
 {
 	struct cls_mall_head *head = rtnl_dereference(tp->root);
 
-	if (head && head->handle == handle)
+	if (head != &match_none && head->handle == handle)
 		return head;
 
 	return NULL;
@@ -178,7 +184,7 @@ static int mall_change(struct net *net, struct sk_buff *in_skb,
 	if (!tca[TCA_OPTIONS])
 		return -EINVAL;
 
-	if (head)
+	if (head != &match_none)
 		return -EEXIST;
 
 	err = nla_parse_nested(tb, TCA_MATCHALL_MAX, tca[TCA_OPTIONS],
@@ -253,7 +259,7 @@ static void mall_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 	if (arg->count < arg->skip)
 		goto skip;
 
-	if (!head)
+	if (head == &match_none)
 		return;
 	if (arg->fn(tp, head, arg) < 0)
 		arg->stop = 1;
@@ -298,7 +304,7 @@ static int mall_dump(struct net *net, struct tcf_proto *tp, void *fh,
 	struct nlattr *nest;
 	int cpu;
 
-	if (!head)
+	if (!head || head == &match_none)
 		return skb->len;
 
 	t->tcm_handle = head->handle;
-- 
2.21.0

