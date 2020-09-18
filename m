Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F188F26F3E7
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 05:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbgIRDK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 23:10:26 -0400
Received: from mail.fudan.edu.cn ([202.120.224.73]:45203 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726786AbgIRDKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 23:10:17 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 23:10:15 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=ombxFY+WtHzRTIMahcPDgE9Yl8BvDDN9V7y66FFXn+M=; b=J
        gNgaRnLpT6kT6Q/wzRgKmdsAot0xgW/JCCHEsvyQU93c6Bc/loQ//oIwdkFIc6BY
        OshXylupO2b1G1Hgs3Q3/m8eUJ3p4D7OSy3h98G9o3mevzl7ESwTz7LCMYagQ/Sb
        8d0tTMPb4wD9d9FBGfMJK6lYmiGa0ABKxLro9ZePVI=
Received: from localhost.localdomain (unknown [10.162.140.61])
        by app2 (Coremail) with SMTP id XQUFCgCnbAiJI2Rfrd9VBQ--.17995S3;
        Fri, 18 Sep 2020 11:03:37 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] batman-adv: Fix orig node refcnt leak when creating neigh node
Date:   Fri, 18 Sep 2020 11:03:19 +0800
Message-Id: <1600398200-8198-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgCnbAiJI2Rfrd9VBQ--.17995S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WrWfCr1DuFW5Aw1DJF43Wrg_yoW8WFWDpw
        1fK3y5Cr95t3WkGFWkt34ruryUJa1qyr4jyrZ5u3WayryDX3savr4F9r4UCF1rJFWkWryj
        qr1093ZIvF1DCFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9G14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl
        6s0DM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
        64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8Jw
        Am72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAG
        YxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCFx2
        IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
        6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
        AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IY
        s7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxV
        W8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbHa0DUUUUU==
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

batadv_neigh_node_create() is used to create a neigh node object, whose
fields will be initialized with the specific object. When a new
reference of the specific object is created during the initialization,
its refcount should be increased.

However, when "neigh_node" object initializes its orig_node field with
the "orig_node" object, the function forgets to hold the refcount of the
"orig_node", causing a potential refcount leak and use-after-free issue
for the reason that the object can be freed in other places.

Fix this issue by increasing the refcount of orig_node object during the
initialization and adding corresponding batadv_orig_node_put() in
batadv_neigh_node_release().

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/batman-adv/originator.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/batman-adv/originator.c b/net/batman-adv/originator.c
index 805d8969bdfb..d6c2296f8e35 100644
--- a/net/batman-adv/originator.c
+++ b/net/batman-adv/originator.c
@@ -306,6 +306,8 @@ static void batadv_neigh_node_release(struct kref *ref)
 
 	batadv_hardif_put(neigh_node->if_incoming);
 
+	batadv_orig_node_put(neigh_node->orig_node);
+
 	kfree_rcu(neigh_node, rcu);
 }
 
@@ -685,6 +687,7 @@ batadv_neigh_node_create(struct batadv_orig_node *orig_node,
 	kref_get(&hard_iface->refcount);
 	ether_addr_copy(neigh_node->addr, neigh_addr);
 	neigh_node->if_incoming = hard_iface;
+	kref_get(&orig_node->refcount);
 	neigh_node->orig_node = orig_node;
 	neigh_node->last_seen = jiffies;
 
-- 
2.7.4

