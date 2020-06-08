Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177901F2CF4
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbgFIA3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:29:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730188AbgFHXQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 081222076C;
        Mon,  8 Jun 2020 23:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658171;
        bh=GYCIRJadqCjtngCxpF39DU3VLAgOV9p5ZuU8EFPmBRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+6EALdU7eNA1mZXNXw3+u3DH0+tJl9DOMsWtGMxBx5EmWhgZmoAfeCB2glw4+vbq
         aJO2U8a1RPl/a3yF0hr8Ab1lmUzhJNoF5kF2pFo5ttE2r/2pCoCa6Xs54PpEDeVkLP
         yD+38i2PwbGv9Lst42OrRXiv09IBXopQQzuU1psY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 198/606] flow_dissector: Drop BPF flow dissector prog ref on netns cleanup
Date:   Mon,  8 Jun 2020 19:05:23 -0400
Message-Id: <20200608231211.3363633-198-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

commit 5cf65922bb15279402e1e19b5ee8c51d618fa51f upstream.

When attaching a flow dissector program to a network namespace with
bpf(BPF_PROG_ATTACH, ...) we grab a reference to bpf_prog.

If netns gets destroyed while a flow dissector is still attached, and there
are no other references to the prog, we leak the reference and the program
remains loaded.

Leak can be reproduced by running flow dissector tests from selftests/bpf:

  # bpftool prog list
  # ./test_flow_dissector.sh
  ...
  selftests: test_flow_dissector [PASS]
  # bpftool prog list
  4: flow_dissector  name _dissect  tag e314084d332a5338  gpl
          loaded_at 2020-05-20T18:50:53+0200  uid 0
          xlated 552B  jited 355B  memlock 4096B  map_ids 3,4
          btf_id 4
  #

Fix it by detaching the flow dissector program when netns is going away.

Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/20200521083435.560256-1-jakub@cloudflare.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/flow_dissector.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index a1670dff0629..0e5012d7b7b5 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -160,12 +160,10 @@ int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
 	return ret;
 }
 
-int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
+static int flow_dissector_bpf_prog_detach(struct net *net)
 {
 	struct bpf_prog *attached;
-	struct net *net;
 
-	net = current->nsproxy->net_ns;
 	mutex_lock(&flow_dissector_mutex);
 	attached = rcu_dereference_protected(net->flow_dissector_prog,
 					     lockdep_is_held(&flow_dissector_mutex));
@@ -179,6 +177,24 @@ int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
 	return 0;
 }
 
+int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
+{
+	return flow_dissector_bpf_prog_detach(current->nsproxy->net_ns);
+}
+
+static void __net_exit flow_dissector_pernet_pre_exit(struct net *net)
+{
+	/* We're not racing with attach/detach because there are no
+	 * references to netns left when pre_exit gets called.
+	 */
+	if (rcu_access_pointer(net->flow_dissector_prog))
+		flow_dissector_bpf_prog_detach(net);
+}
+
+static struct pernet_operations flow_dissector_pernet_ops __net_initdata = {
+	.pre_exit = flow_dissector_pernet_pre_exit,
+};
+
 /**
  * __skb_flow_get_ports - extract the upper layer ports and return them
  * @skb: sk_buff to extract the ports from
@@ -1838,7 +1854,7 @@ static int __init init_default_flow_dissectors(void)
 	skb_flow_dissector_init(&flow_keys_basic_dissector,
 				flow_keys_basic_dissector_keys,
 				ARRAY_SIZE(flow_keys_basic_dissector_keys));
-	return 0;
-}
 
+	return register_pernet_subsys(&flow_dissector_pernet_ops);
+}
 core_initcall(init_default_flow_dissectors);
-- 
2.25.1

