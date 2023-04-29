Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303896F2704
	for <lists+netdev@lfdr.de>; Sun, 30 Apr 2023 00:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjD2Wk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 18:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjD2Wkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 18:40:53 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DE5E65
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 15:40:52 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-7515631b965so233289285a.0
        for <netdev@vger.kernel.org>; Sat, 29 Apr 2023 15:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682808051; x=1685400051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qHWjQ5y7sdq1lEzMlodqYYV4HxL5KkG3T5QxP3eicA=;
        b=RHLmr9mR/NpruWH+WAfcTvM2/fglyG8IPXWSntfy7XNz3sETdrkZhktRiEQZSSt/sB
         eG9CfKJ8RVIRyfmSVIIhvPMNgS3TZ1rWZ9Np8bBkzhtrBurLkQAQ2fxHfPQRWLAMD8Ht
         DgG26i7DnhBlpKAGPTBPmEP9bXd3c84RbFVr3TnjgvkS8A1DZDulL+XbteLUXP+qWMyu
         DtOQ0IUV97TbejGKXwUbMiI27WuXTqj80FSlgVH2+hwB8QO9JdalopyVMYU9E53nVwxG
         6A7HtjPnNvxtvvXkYj0NUgEmWB0TVMrwZOWOcJ5ojuPK/mwiM/lY67+wWim7AsGDsK9L
         eluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682808051; x=1685400051;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2qHWjQ5y7sdq1lEzMlodqYYV4HxL5KkG3T5QxP3eicA=;
        b=V7Cd2mhZjNqHNo5UWZXEjUTWh4pJk9CclGZ0C33WItxj1fVsBvviNLAD6+4STOwmpb
         pMvJHhGqbFSByUmv9i9nrfb/ZtmnnsmuR+8mdK8BvevP1TQtXMB5C7zxsUyR4wpp9Dnk
         XVH5G3ugYc3tpwWGEw2hDQbpuXMGnzGH7lok5+QfT722h0ySYx0khbN51abn6LoCTnkU
         4QYwbFYbr/4eNWddZ6tFoh4z6HdD8q+sbVCilKF/t5+2EApsunuXJxRUbLyu1v5rwGPp
         QUPaL2owXyYEUOhBtFj/UCotZLnuy75BXujyMFYzjRh/malKQIj5CqCWDOPlvszmHZoK
         45/A==
X-Gm-Message-State: AC+VfDz9tKo9PEHMmnOW/GVkFRW8iL/C/3PXTPCmlLfDRtmwHsZ4YW3y
        Zm07k6NkNwRO6BUe5zP2zfIDFP4ejK1oQg==
X-Google-Smtp-Source: ACHHUZ5CAIr8mf2xf7QdnYmLVMDpGcglRjC1fgZI7nqHVq2ObmlyJF+howDznfuY3qxXnfTuR1OtOw==
X-Received: by 2002:ad4:5bc8:0:b0:5ef:5481:595 with SMTP id t8-20020ad45bc8000000b005ef54810595mr23543601qvt.0.1682808050922;
        Sat, 29 Apr 2023 15:40:50 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id p12-20020a0ce18c000000b00606322241b4sm6595741qvl.27.2023.04.29.15.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Apr 2023 15:40:50 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>
Subject: [PATCH net 2/2] tipc: do not update mtu if msg_max is too small
Date:   Sat, 29 Apr 2023 18:40:47 -0400
Message-Id: <22ba689983844705563c15c2f16e6381f2a0412c.1682807958.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1682807958.git.lucien.xin@gmail.com>
References: <cover.1682807958.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When doing link mtu negotiation, a malicious peer may send Activate msg
with a very small mtu, e.g. 4 in Shuang's testing, without checking for
the minimum mtu, l->mtu will be set to 4 in tipc_link_proto_rcv(), then
n->links[bearer_id].mtu is set to 4294967228, which is a overflow of
'4 - INT_H_SIZE - EMSG_OVERHEAD' in tipc_link_mss().

With tipc_link.mtu = 4, tipc_link_xmit() kept printing the warning:

 tipc: Too large msg, purging xmit list 1 5 0 40 4!
 tipc: Too large msg, purging xmit list 1 15 0 60 4!

And with tipc_link_entry.mtu 4294967228, a huge skb was allocated in
named_distribute(), and when purging it in tipc_link_xmit(), a crash
was even caused:

  general protection fault, probably for non-canonical address 0x2100001011000dd: 0000 [#1] PREEMPT SMP PTI
  CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Not tainted 6.3.0.neta #19
  RIP: 0010:kfree_skb_list_reason+0x7e/0x1f0
  Call Trace:
   <IRQ>
   skb_release_data+0xf9/0x1d0
   kfree_skb_reason+0x40/0x100
   tipc_link_xmit+0x57a/0x740 [tipc]
   tipc_node_xmit+0x16c/0x5c0 [tipc]
   tipc_named_node_up+0x27f/0x2c0 [tipc]
   tipc_node_write_unlock+0x149/0x170 [tipc]
   tipc_rcv+0x608/0x740 [tipc]
   tipc_udp_recv+0xdc/0x1f0 [tipc]
   udp_queue_rcv_one_skb+0x33e/0x620
   udp_unicast_rcv_skb.isra.72+0x75/0x90
   __udp4_lib_rcv+0x56d/0xc20
   ip_protocol_deliver_rcu+0x100/0x2d0

This patch fixes it by checking the new mtu against tipc_bearer_min_mtu(),
and not updating mtu if it is too small.

Fixes: ed193ece2649 ("tipc: simplify link mtu negotiation")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/link.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index b3ce24823f50..a9e46c58b28a 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2200,7 +2200,7 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	struct tipc_msg *hdr = buf_msg(skb);
 	struct tipc_gap_ack_blks *ga = NULL;
 	bool reply = msg_probe(hdr), retransmitted = false;
-	u32 dlen = msg_data_sz(hdr), glen = 0;
+	u32 dlen = msg_data_sz(hdr), glen = 0, msg_max;
 	u16 peers_snd_nxt =  msg_next_sent(hdr);
 	u16 peers_tol = msg_link_tolerance(hdr);
 	u16 peers_prio = msg_linkprio(hdr);
@@ -2283,8 +2283,9 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 		l->peer_session = msg_session(hdr);
 		l->in_session = true;
 		l->peer_bearer_id = msg_bearer_id(hdr);
-		if (l->mtu > msg_max_pkt(hdr))
-			l->mtu = msg_max_pkt(hdr);
+		msg_max = msg_max_pkt(hdr);
+		if (msg_max >= tipc_bearer_min_mtu(l->net, l->bearer_id) && l->mtu > msg_max)
+			l->mtu = msg_max;
 		break;
 
 	case STATE_MSG:
-- 
2.39.1

