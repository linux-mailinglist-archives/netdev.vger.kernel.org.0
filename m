Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED6F215DE4
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgGFSCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729657AbgGFSCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:02:42 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5362C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 11:02:41 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x72so7845518pfc.6
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 11:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vE9HhVeh7WdKuA497jnquICOWUMZkjd853XLQH+n2do=;
        b=eLbmlA+N2fonS3GB9j07zQECHziylWc7EVfQwxyhunlxc79l6miPFzWTXeri20LNH7
         ytT36GOhR7EPPHafMSU1d6vgetvGPotI/SD2LpV72cqii9z6HwpvPitiv0m4Z0P2Zq6z
         dX9TCfI95Bn7VwhJDQVqD65i1+/8z70ov6F0ZxSKjm6K2yYPU9CM7MUw5g+sBlUH/nwB
         rDgsBGa5c7zJQoJ6v1pEddjVvl7Pc6TPV1wJy/ktL/Y1ZBeEclcy/1UJ1vXU6Rczbwvm
         ZU66Yax6tOotoLB8WiS0dHEo8AMWR7mqKUj5Wvbeee3d13Ryku6CXY7KIs6Bn8JNIf+Q
         nYsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vE9HhVeh7WdKuA497jnquICOWUMZkjd853XLQH+n2do=;
        b=PiK+UEHjEZQMJwpiuYhWZvay3Wsrf2i1O5yz16+v6FZGqwdMwxlDSHVnYxHpfVHQXr
         Gm+ZauJ36nGw8zeYMdylrKwrtr77F5LYuQ0Q4MmMOeP90cmm2muXUbAPiRDVJz6DBz41
         rHLHsIYctDi7kIMd7Em4V9H+fn6mgWf1iCF6HnbBqKTnsGxYMYFUrwnc8J9i5sHy06ca
         Hmn4PmfXd/UoPS2z37201kYxNIEwftXB2x2Pu2H1q0NO0zX0WE3eLkmRqgsOwYN94NYv
         SWy0rXoVmRzPiPI+lFZBQlRfpB3qe+/EAIRYA6E6XMqfjc5zEt4sXk6zB9WmgHaagC/8
         1tRA==
X-Gm-Message-State: AOAM532x9KadwkJVG6MmFbRYvIy8grNcwxE5l/l8kPp618u2toXOluYz
        I/Ly1OWBVP01haIOa1RZpjThncXVL3g=
X-Google-Smtp-Source: ABdhPJxGHXc39IpY38UVyh4KdTIbsU1Ou7yE6g/so/Htjco6xfjVi/T+3nSvPDFb5A2yeHCcegVqNQ==
X-Received: by 2002:a63:3005:: with SMTP id w5mr40528976pgw.441.1594058560988;
        Mon, 06 Jul 2020 11:02:40 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v15sm19972562pgo.15.2020.07.06.11.02.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jul 2020 11:02:40 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, James Chapman <jchapman@katalix.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: [PATCH net] l2tp: remove skb_dst_set() from l2tp_xmit_skb()
Date:   Tue,  7 Jul 2020 02:02:32 +0800
Message-Id: <57ec206296ac8049d51755667b69aa0e978e3d6e.1594058552.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the tx path of l2tp, l2tp_xmit_skb() calls skb_dst_set() to set
skb's dst. However, it will eventually call inet6_csk_xmit() or
ip_queue_xmit() where skb's dst will be overwritten by:

   skb_dst_set_noref(skb, dst);

without releasing the old dst in skb. Then it causes dst/dev refcnt leak:

  unregister_netdevice: waiting for eth0 to become free. Usage count = 1

This can be reproduced by simply running:

  # modprobe l2tp_eth && modprobe l2tp_ip
  # sh ./tools/testing/selftests/net/l2tp.sh

So before going to inet6_csk_xmit() or ip_queue_xmit(), skb's dst
should be dropped. This patch is to fix it by removing skb_dst_set()
from l2tp_xmit_skb() and moving skb_dst_drop() into l2tp_xmit_core().

Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/l2tp/l2tp_core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index fcb53ed..df133c24 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1028,6 +1028,7 @@ static void l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb,
 
 	/* Queue the packet to IP for output */
 	skb->ignore_df = 1;
+	skb_dst_drop(skb);
 #if IS_ENABLED(CONFIG_IPV6)
 	if (l2tp_sk_is_v6(tunnel->sock))
 		error = inet6_csk_xmit(tunnel->sock, skb, NULL);
@@ -1099,10 +1100,6 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
 		goto out_unlock;
 	}
 
-	/* Get routing info from the tunnel socket */
-	skb_dst_drop(skb);
-	skb_dst_set(skb, sk_dst_check(sk, 0));
-
 	inet = inet_sk(sk);
 	fl = &inet->cork.fl;
 	switch (tunnel->encap) {
-- 
2.1.0

