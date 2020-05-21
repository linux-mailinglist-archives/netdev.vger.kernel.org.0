Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2041DC8B3
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 10:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgEUIek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 04:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgEUIek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 04:34:40 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF45CC061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 01:34:38 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id l21so7826250eji.4
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 01:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NBjbnCOh61b7cgKVaUsbqPDW94/cGzD2MQ0ZynD04OI=;
        b=VtkWO+UlZXR6dHQYJP28BAe/uNVGTjTU4W4MhifCI5ih7nSlP0Cxfn/QVDu7CgjjJ5
         oaY/rFGpUpZDRwZ5Jh6hXzagrfQr+Twd84fwdKMZjm390/Hf/J0dJ5WS+tRg6QST0Os2
         eNazPat/1t4w31HVH0E87ceKkM7BB8PtPK3Jo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NBjbnCOh61b7cgKVaUsbqPDW94/cGzD2MQ0ZynD04OI=;
        b=X2ScagpDVpHlf+x7Lw/DV3QWBwcXsCYct1m9oVTvdv+Yv26BQt9w3tL8Aq3YEYOFxI
         tO8D7ZtgLYdKMWXjK0RlTpXAKrO9Sckuf08eP2gr8zhm3HRSIcCkunpaCb9SCKs30u6Y
         XZNEfp2zFFaCeEjSFb3ojCjNxlONv+UY268DTiXn1O9fX25DHfPNhE5r/+vm/odbB45W
         UE6Kgqa1OeqYoWso4Z16dx0mIjQpeWnZpNIaFr+Er2apsFeLHs+OISN7GGte/NVMzdmM
         K23UpueC1YLJU07CdMznefgh4tWwsrJk/btxSgKVJNq8QBlD/s15vlVJHQ3zz9B8AuGj
         NXag==
X-Gm-Message-State: AOAM532PC6wzSaXpzZ1bCC/pUCT25u4qbGzo90DUqirv3Khu1Wy9aeEd
        LdgO3Ahcq/jEfYHKBy3rKiebcw==
X-Google-Smtp-Source: ABdhPJwqPcShx3HijRp3m1yW21LlqC0tmWcv7pLr0/2aUApSFyhEOXvWg/jt93rib49tzmYEZWy+xw==
X-Received: by 2002:a17:906:82d9:: with SMTP id a25mr2442349ejy.43.1590050077182;
        Thu, 21 May 2020 01:34:37 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id b14sm4231685edx.93.2020.05.21.01.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2020 01:34:36 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Stanislav Fomichev <sdf@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH bpf v2] flow_dissector: Drop BPF flow dissector prog ref on netns cleanup
Date:   Thu, 21 May 2020 10:34:35 +0200
Message-Id: <20200521083435.560256-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---

Notes:
    v2:
    - Share code between pre_exit and prog_detach callbacks (Stanislav)

 net/core/flow_dissector.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 3eff84824c8b..3ad723b2e299 100644
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
@@ -1827,6 +1843,8 @@ EXPORT_SYMBOL(flow_keys_basic_dissector);
 
 static int __init init_default_flow_dissectors(void)
 {
+	int err;
+
 	skb_flow_dissector_init(&flow_keys_dissector,
 				flow_keys_dissector_keys,
 				ARRAY_SIZE(flow_keys_dissector_keys));
@@ -1836,7 +1854,11 @@ static int __init init_default_flow_dissectors(void)
 	skb_flow_dissector_init(&flow_keys_basic_dissector,
 				flow_keys_basic_dissector_keys,
 				ARRAY_SIZE(flow_keys_basic_dissector_keys));
-	return 0;
+
+	err = register_pernet_subsys(&flow_dissector_pernet_ops);
+
+	WARN_ON(err);
+	return err;
 }
 
 core_initcall(init_default_flow_dissectors);
-- 
2.25.4

