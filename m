Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D743A404480
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 06:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350362AbhIIEem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 00:34:42 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:58315
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1350256AbhIIEei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 00:34:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=l/j2pDn/mjthv3uqEbVaJbJjaFQ1TYxsqeN3B0C0v/0=; b=M
        gVaqEVBmCdIvP2FF1JiFDVNbwdKxqBMq6oeTyNozrfIceF+vy9bJLWYPoeWdXsvg
        SU/tihYdUCEraDgz9WrctT+LL75DN3Zrzal6jyu+msKCqRgoMiQEIyiu2E77tfTo
        2V13ROWsieq08eXcY/PQZhsFRHAfr1aXgYZscbdBt4=
Received: from localhost.localdomain (unknown [10.162.127.118])
        by app1 (Coremail) with SMTP id XAUFCgDXOGZcjjlhUX09AA--.1099S3;
        Thu, 09 Sep 2021 12:32:28 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Tom Parkin <tparkin@katalix.com>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] net/l2tp: Fix reference count leak in l2tp_udp_recv_core
Date:   Thu,  9 Sep 2021 12:32:00 +0800
Message-Id: <1631161930-77772-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XAUFCgDXOGZcjjlhUX09AA--.1099S3
X-Coremail-Antispam: 1UD129KBjvJXoW7urW7CF48tr17Jw43Gr4UJwb_yoW8GF15pF
        4UCr9rKFy5KF9rAr18Ja4kXa4YkayY9FyrCFWvkwn0ywnxA343Kayj9FnIqFyUArykta1Y
        v3ZYvr45ZF4DtFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9C14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMx
        C20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAF
        wI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20x
        vE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v2
        0xvaj40_Zr0_Wr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
        0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUAkucUUUUU=
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reference count leak issue may take place in an error handling
path. If both conditions of tunnel->version == L2TP_HDR_VER_3 and the
return value of l2tp_v3_ensure_opt_in_linear is nonzero, the function
would directly jump to label invalid, without decrementing the reference
count of the l2tp_session object session increased earlier by
l2tp_tunnel_get_session(). This may result in refcount leaks.

Fix this issue by decrease the reference count before jumping to the
label invalid.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 net/l2tp/l2tp_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 53486b162f01..93271a2632b8 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -869,8 +869,10 @@ static int l2tp_udp_recv_core(struct l2tp_tunnel *tunnel, struct sk_buff *skb)
 	}
 
 	if (tunnel->version == L2TP_HDR_VER_3 &&
-	    l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr))
+	    l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr)) {
+		l2tp_session_dec_refcount(session);
 		goto invalid;
+	}
 
 	l2tp_recv_common(session, skb, ptr, optr, hdrflags, length);
 	l2tp_session_dec_refcount(session);
-- 
2.7.4

