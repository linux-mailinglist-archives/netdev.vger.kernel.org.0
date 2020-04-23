Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD6E1B5407
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgDWFON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:14:13 -0400
Received: from mail.fudan.edu.cn ([202.120.224.10]:37472 "EHLO fudan.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725562AbgDWFOM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 01:14:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=00QdfgWbICLjOQqr+eyyelgIderli09+aEykugx5RcA=; b=F
        bnfA7t8ONTH01mN0KCRERzjifAVRWkGUYtSH0ZPEBP6ZxwIoGdY9uwTI50iCFEZq
        xotLnqPIILyeyEa7dEyavkI4erm2hIxwDj7lH3Frz+TrBpDj+cJoVxjIPRadg0/X
        R9m7LIVIKeMCIg/QqetSlBrAIVFfKlxpkXmM0EG3Q4=
Received: from localhost.localdomain (unknown [120.229.255.80])
        by app1 (Coremail) with SMTP id XAUFCgAXHaH5I6FeO6g8AA--.30594S3;
        Thu, 23 Apr 2020 13:13:30 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Allison Randal <allison@lohutok.net>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, kjlu@umn.edu,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] net/x25: Fix x25_neigh refcnt leak when reveiving frame
Date:   Thu, 23 Apr 2020 13:13:03 +0800
Message-Id: <1587618786-13481-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XAUFCgAXHaH5I6FeO6g8AA--.30594S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKF1UXr4DGrykuw15WF4kJFb_yoWktrc_CF
        n7tws7Xw12yr1xG3yxtw45AFyIvw17Xa1v9FWxtFWxZFyjgFyxAF93Xrn3Wr1fW3yxArn8
        JFnxGr97Awn7ZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbTAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_GcCE
        3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
        1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IE
        w4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r1j6r4UMc
        vjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v
        4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK67AK6r4rMxAIw28IcxkI7VAKI48JMx
        C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
        wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
        vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxK
        x2IYs7xG6Fyj6rWUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
        v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYR6wDUUUU
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

x25_lapb_receive_frame() invokes x25_get_neigh(), which returns a
reference of the specified x25_neigh object to "nb" with increased
refcnt.

When x25_lapb_receive_frame() returns, local variable "nb" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one path of
x25_lapb_receive_frame(). When pskb_may_pull() returns false, the
function forgets to decrease the refcnt increased by x25_get_neigh(),
causing a refcnt leak.

Fix this issue by calling x25_neigh_put() when pskb_may_pull() returns
false.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/x25/x25_dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
index 00e782335cb0..25bf72ee6cad 100644
--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -115,8 +115,10 @@ int x25_lapb_receive_frame(struct sk_buff *skb, struct net_device *dev,
 		goto drop;
 	}
 
-	if (!pskb_may_pull(skb, 1))
+	if (!pskb_may_pull(skb, 1)) {
+		x25_neigh_put(nb);
 		return 0;
+	}
 
 	switch (skb->data[0]) {
 
-- 
2.7.4

