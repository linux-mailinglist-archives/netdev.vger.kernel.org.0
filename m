Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15799581BB0
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 23:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiGZVgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 17:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGZVgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 17:36:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AB41B78A;
        Tue, 26 Jul 2022 14:36:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B975616CC;
        Tue, 26 Jul 2022 21:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547FAC433D6;
        Tue, 26 Jul 2022 21:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658871370;
        bh=jvymIjL+qZO9QbVLb21Dh5GWSsyWsTxOb1BllQ1hc2s=;
        h=From:To:Cc:Subject:Date:From;
        b=g+49nZlvS45uE55Bb2tfrsFcOJt45Kh2UoC5UTwYp6fMNQXmBm1U9YV5lfLlrA7Ul
         CjRFc155zOTjK8vJE3GXEOFr/pKWMadKupsQIJ7VOprL3EbKd0CN6xjPTv40JLQlii
         cHVs2kUaBqt6mUSsjbQPs0j8Xhxo+kCtjT14IyBD9da++nQDS74EMYNmz0RQHnuzAS
         kpWYwBIwr8Es2fBjoyAz5Y3kxoRliz9dr4VVe5Aw5HK9qxJX9NsKfG7yTIftTPbxqn
         SwrAn0wf1bCnmh8S/0bhtMoAF3wFpnN8KmO5TK/4lFLE34MAcMaEFQM1hSlolmqHr8
         pl2gfL55dZpRA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, ast@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+ad24705d3fd6463b18c6@syzkaller.appspotmail.com
Subject: [PATCH bpf] netdevsim: avoid allocation warnings triggered from user space
Date:   Tue, 26 Jul 2022 14:36:05 -0700
Message-Id: <20220726213605.154204-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to suppress warnings from sily map sizes. Also switch
from GFP_USER to GFP_KERNEL_ACCOUNT, I'm pretty sure I misunderstood
the flags when writing this code.

Fixes: 395cacb5f1a0 ("netdevsim: bpf: support fake map offload")
Reported-by: syzbot+ad24705d3fd6463b18c6@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/bpf.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index a43820212932..50854265864d 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -351,10 +351,12 @@ nsim_map_alloc_elem(struct bpf_offloaded_map *offmap, unsigned int idx)
 {
 	struct nsim_bpf_bound_map *nmap = offmap->dev_priv;
 
-	nmap->entry[idx].key = kmalloc(offmap->map.key_size, GFP_USER);
+	nmap->entry[idx].key = kmalloc(offmap->map.key_size,
+				       GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (!nmap->entry[idx].key)
 		return -ENOMEM;
-	nmap->entry[idx].value = kmalloc(offmap->map.value_size, GFP_USER);
+	nmap->entry[idx].value = kmalloc(offmap->map.value_size,
+					 GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (!nmap->entry[idx].value) {
 		kfree(nmap->entry[idx].key);
 		nmap->entry[idx].key = NULL;
@@ -496,7 +498,7 @@ nsim_bpf_map_alloc(struct netdevsim *ns, struct bpf_offloaded_map *offmap)
 	if (offmap->map.map_flags)
 		return -EINVAL;
 
-	nmap = kzalloc(sizeof(*nmap), GFP_USER);
+	nmap = kzalloc(sizeof(*nmap), GFP_KERNEL_ACCOUNT);
 	if (!nmap)
 		return -ENOMEM;
 
-- 
2.37.1

