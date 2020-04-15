Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF3F1A973D
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894956AbgDOIp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:45:58 -0400
Received: from mail.fudan.edu.cn ([202.120.224.73]:55850 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2894947AbgDOIpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 04:45:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=e38fCYno9Kg9NlWmZaHhXh61HmgAfMMOj8Y0iA5cL+s=; b=a
        owa2vF1f4sVbxAm5sfCk7LCq0+kPR80uHE0lAA/A1rhwAAKRyK9bA5YxTWw9+o2X
        qmbmNqmOTQKzxXMCV2LrOuNIzpCIXf2cuEYGwvX6O3QclJJvAu50bYV9hBDsE18L
        PN1GkD4XYGi4Ek7gvQrdvacN9IZYcbYlB90iS+KaZ0=
Received: from localhost.localdomain (unknown [120.229.255.108])
        by app2 (Coremail) with SMTP id XQUFCgC3voIayJZegFVZAA--.91S3;
        Wed, 15 Apr 2020 16:38:51 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] net: netrom: Fix potential nr_neigh refcnt leak in nr_add_node
Date:   Wed, 15 Apr 2020 16:36:19 +0800
Message-Id: <1586939780-69791-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgC3voIayJZegFVZAA--.91S3
X-Coremail-Antispam: 1UD129KBjvdXoW7XryDAryfCrW7KF1kWF4UArb_yoWkuFX_GF
        1kWF9rWwn5Jr40g34jgw4fX39xta18Jr1rXrWfCrWaq34Ygw17ArZ5ur95ur1fWw4rGF98
        C3s5JrW2y3WxujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbTkFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_GcCE
        3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
        1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v
        4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK67AK6r43MxAIw28IcxkI7VAKI48JMx
        C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
        wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
        vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
        0xvaj40_Zr0_Wr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
        0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU6Hq7UUUUU=
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nr_add_node() invokes nr_neigh_get_dev(), which returns a local
reference of the nr_neigh object to "nr_neigh" with increased refcnt.

When nr_add_node() returns, "nr_neigh" becomes invalid, so the refcount
should be decreased to keep refcount balanced.

The issue happens in one normal path of nr_add_node(), which forgets to
decrease the refcnt increased by nr_neigh_get_dev() and causes a refcnt
leak. It should decrease the refcnt before the function returns like
other normal paths do.

Fix this issue by calling nr_neigh_put() before the nr_add_node()
returns.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/netrom/nr_route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index d41335bad1f8..89cd9de21594 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -208,6 +208,7 @@ static int __must_check nr_add_node(ax25_address *nr, const char *mnemonic,
 		/* refcount initialized at 1 */
 		spin_unlock_bh(&nr_node_list_lock);
 
+		nr_neigh_put(nr_neigh);
 		return 0;
 	}
 	nr_node_lock(nr_node);
-- 
2.7.4

