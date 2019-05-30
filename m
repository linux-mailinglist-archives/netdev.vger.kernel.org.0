Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFBDA30081
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbfE3RAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:00:16 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38615 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726684AbfE3RAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:00:16 -0400
Received: by mail-pf1-f195.google.com with SMTP id a186so3642414pfa.5
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LzUjzhIXGjVbF8+LVF2BCE7V8md5OpBES44x2OTXInQ=;
        b=S/N6XSGc/owogajUNgwzGdQhUrSkvyuW0GsPCfePBvxGLrdJc+B6NSuXsEj0nCIIwx
         Gnpf9x7REAbcuhB+8H10wu0AgWAiCg+fFhKrL4eUO1gKo18MP9Mfhz+9gA0r5jfVPSV8
         Mr0allou9wcNfygy9dSzXKZYqk1FY8KL7HBBkoP8wH9sTNqTaKuqqtj7o6T/cRc1Rl+i
         M76s6cAARKqSM5mqHY8+ZH4DzOIT5278PWQ3Bs8+3V7JjrP6JlEs1Ola5vLw8WwEeeZH
         zYfqS4FGB6uOowT6MQWmhLdyF4ARtHVAgFSqpQ6ZvWa7b9UbqAKRAT7vGByKBv/siT2d
         5ucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LzUjzhIXGjVbF8+LVF2BCE7V8md5OpBES44x2OTXInQ=;
        b=uLrvZ6rLQ2D5ipbnG3OGhVVMvf3iw7b89mWukU2ZeEU6unyjwLJV4vkSVuM+CjPdnA
         ZOPAaZIUHIyP9m7Qy+KkbCN7zVomFrPGtitCdxS3PZ1V1wNl5oqSb7thNWeWMDZ0TsRk
         n2EiVe5keLHmFJwA1NHue5UC7T5pqf9XiiuIdACdlsba1wscTb3N/l58LO1x3bGXNMID
         7gIM2nWM3YzVJs915R7dH7qYa4dJITn7dl/+LltpDt636gADtZedkK/WoCMO/mU/DqEe
         DBqPxQLppM1ZgpgqjSaF0MiTHg1DuTGc8ADyV9rjdWSPM4daqGiRwyq9M0A52lGtd3Uj
         U5hQ==
X-Gm-Message-State: APjAAAUtCahLQbJvhhN2hHTa5v8x8P0tohoKI5AfymDHrC1yus39HsJi
        CQ1bwDZwfAoUxH/CykdA9TmAJzgH
X-Google-Smtp-Source: APXvYqxIn2UEOWslBnNFnsG2/qYsB+2DMX+zUVpf95zQ6sKa9HFirCz50plaOkoWoqvWYGMLMkoReg==
X-Received: by 2002:a63:130d:: with SMTP id i13mr4509593pgl.396.1559235615223;
        Thu, 30 May 2019 10:00:15 -0700 (PDT)
Received: from sc9-mailhost2.vmware.com ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id t124sm3296872pfb.80.2019.05.30.10.00.14
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 10:00:14 -0700 (PDT)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Subject: [PATCHv2 net] net: ip6_gre: access skb data after skb_cow_head()
Date:   Thu, 30 May 2019 09:59:40 -0700
Message-Id: <1559235580-31747-1-git-send-email-u9012063@gmail.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When increases the headroom, skb's data pointer might get re-allocated.
As a result, the skb->data before the skb_cow_head becomes a dangling pointer,
and dereferences to daddr causes general protection fault at the following
line in __gre6_xmit():

  if (dev->header_ops && dev->type == ARPHRD_IP6GRE)                      
      fl6->daddr = ((struct ipv6hdr *)skb->data)->daddr;

general protection fault: 0000 [#1] SMP PTI
OE 4.15.0-43-generic #146-Ubuntu 
Hardware name: VMware, Inc. VMware Virtual Platform 440BX Desktop Reference
Platform, BIOS 6.00 07/03/2018 
RIP: 0010: __gre6_xmit+0x11f/0x2c0 [openvswitch] 
RSP: 0018:ffffb8d5c44df6a8 EFLAGS: 00010286
RAX: 00000000ffffffea RBX: ffff8b1528a0000 RCX: 0000000000000036 
RDX: ffff000000000000 RSI: 0000000000000000 RDI: ffff8db267829200
RBP: ffffb8d5c44df 700 R08: 0000000000005865 RØ9: ffffb8d5c44df724
R10: 0000000000000002 R11: 0000000000000000 R12: ffff8db267829200
R13: 0000000000000000 R14: ffffb8d5c44df 728 R15: 00000000ffffffff
FS: 00007f8744df 2700(0000) GS:ffff8db27fc0000000000) knlGS:0000000000000000 
CS: 0910 DS: 0000 ES: 9000 CRO: 0000000080050033 
CR2: 00007f893ef92148 CR3: 0000000400462003 CR4: 00000000001626f8
Call Trace: 
ip6gre_tunnel_xmit+0x1cc/0x530 [openvswitch]
? skb_clone+0x58/0xc0 
__ip6gre_tunnel_xmit+0x12/0x20 [openvswitch]
ovs_vport_send +0xd4/0x170 [openvswitch] 
do_output+0x53/0x160 [openvswitch]
do_execute_actions+0x9a1/0x1880 [openvswitch]

Fix it by moving skb_cow_head before accessing the skb->data pointer.

Fixes: 01b8d064d58b4 ("net: ip6_gre: Request headroom in __gre6_xmit()")
Reported-by: Haichao Ma <haichaom@vmware.com>
Signed-off-by: William Tu <u9012063@gmail.com>
---
v1-v2: add more details in commit message.
---
 net/ipv6/ip6_gre.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 655e46b227f9..90b2b129b105 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -714,6 +714,9 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 	struct ip6_tnl *tunnel = netdev_priv(dev);
 	__be16 protocol;
 
+	if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
+		return -ENOMEM;
+
 	if (dev->type == ARPHRD_ETHER)
 		IPCB(skb)->flags = 0;
 
@@ -722,9 +725,6 @@ static netdev_tx_t __gre6_xmit(struct sk_buff *skb,
 	else
 		fl6->daddr = tunnel->parms.raddr;
 
-	if (skb_cow_head(skb, dev->needed_headroom ?: tunnel->hlen))
-		return -ENOMEM;
-
 	/* Push GRE header. */
 	protocol = (dev->type == ARPHRD_ETHER) ? htons(ETH_P_TEB) : proto;
 
-- 
2.7.4

