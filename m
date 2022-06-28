Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC8755EEBC
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbiF1TvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiF1Tut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:49 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C343A70F;
        Tue, 28 Jun 2022 12:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445749; x=1687981749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sU25U5z5Fc524fPGWGwlzdwktQUtdwxy/KN7ZKjuDgg=;
  b=mq8Q9LSUF6oCyxKAiCE/RoEeJVrMWv4z20yJDeMLi721w6LSj4xiotIy
   r+lewqVNNKqXZiuSi6UTDwCKanerJWk1qMbGdGLareZFKNiSL/mhBCXvs
   xhVAh1KeqzrG7xjvI9pc2oeuX+z/WsqeH3nzecT4TU7P8/COQmfbCZmZz
   z9nkE/hx/V1I41R63Rc0I2y+rpnTbDvpxRqz5qEhcZHj81HIgSfm0c387
   FD/TweloT9rueCIu/A97hXz1+U5HgIRN6sqcAyLbpth/dDj46D4PAqkOv
   O5Dwnz5tK3yCMOxsCowmleIoTAM4AS0+/wtusBWLfp7GqMyjC4dhUWaGX
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="282568051"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="282568051"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="590426284"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga002.jf.intel.com with ESMTP; 28 Jun 2022 12:49:03 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr96022013;
        Tue, 28 Jun 2022 20:49:02 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 06/52] bpf: pass a pointer to union bpf_attr to bpf_link_ops::update_prog()
Date:   Tue, 28 Jun 2022 21:47:26 +0200
Message-Id: <20220628194812.1453059-7-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to be able to use any arbitrary data from
bpf_attr::link_update inside the bpf_link_ops::update_prog()
implementations, pass a pointer to the whole attr as a callback
argument.
@new_prog and @old_prog arguments are still here as ::link_update
contains only their FDs.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 include/linux/bpf.h        | 3 ++-
 kernel/bpf/bpf_iter.c      | 1 +
 kernel/bpf/cgroup.c        | 4 +++-
 kernel/bpf/net_namespace.c | 1 +
 kernel/bpf/syscall.c       | 2 +-
 net/bpf/dev.c              | 4 +++-
 6 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d05e1495a06e..c08690a49011 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1155,7 +1155,8 @@ struct bpf_link_ops {
 	void (*release)(struct bpf_link *link);
 	void (*dealloc)(struct bpf_link *link);
 	int (*detach)(struct bpf_link *link);
-	int (*update_prog)(struct bpf_link *link, struct bpf_prog *new_prog,
+	int (*update_prog)(struct bpf_link *link, const union bpf_attr *attr,
+			   struct bpf_prog *new_prog,
 			   struct bpf_prog *old_prog);
 	void (*show_fdinfo)(const struct bpf_link *link, struct seq_file *seq);
 	int (*fill_link_info)(const struct bpf_link *link,
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 7e8fd49406f6..1d3dcc853f70 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -400,6 +400,7 @@ static void bpf_iter_link_dealloc(struct bpf_link *link)
 }
 
 static int bpf_iter_link_replace(struct bpf_link *link,
+				 const union bpf_attr *attr,
 				 struct bpf_prog *new_prog,
 				 struct bpf_prog *old_prog)
 {
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 7a394f7c205c..f4d8100dd22f 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -664,7 +664,9 @@ static int __cgroup_bpf_replace(struct cgroup *cgrp,
 	return 0;
 }
 
-static int cgroup_bpf_replace(struct bpf_link *link, struct bpf_prog *new_prog,
+static int cgroup_bpf_replace(struct bpf_link *link,
+			      const union bpf_attr *attr,
+			      struct bpf_prog *new_prog,
 			      struct bpf_prog *old_prog)
 {
 	struct bpf_cgroup_link *cg_link;
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 868cc2c43899..5d80a4a9d0bd 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -162,6 +162,7 @@ static void bpf_netns_link_dealloc(struct bpf_link *link)
 }
 
 static int bpf_netns_link_update_prog(struct bpf_link *link,
+				      const union bpf_attr *attr,
 				      struct bpf_prog *new_prog,
 				      struct bpf_prog *old_prog)
 {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7d5af5b99f0d..f7a674656067 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4614,7 +4614,7 @@ static int link_update(union bpf_attr *attr)
 	}
 
 	if (link->ops->update_prog)
-		ret = link->ops->update_prog(link, new_prog, old_prog);
+		ret = link->ops->update_prog(link, attr, new_prog, old_prog);
 	else
 		ret = -EINVAL;
 
diff --git a/net/bpf/dev.c b/net/bpf/dev.c
index dfe0402947f8..68a7b2c49392 100644
--- a/net/bpf/dev.c
+++ b/net/bpf/dev.c
@@ -619,7 +619,9 @@ static int bpf_xdp_link_fill_link_info(const struct bpf_link *link,
 	return 0;
 }
 
-static int bpf_xdp_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
+static int bpf_xdp_link_update(struct bpf_link *link,
+			       const union bpf_attr *attr,
+			       struct bpf_prog *new_prog,
 			       struct bpf_prog *old_prog)
 {
 	struct bpf_xdp_link *xdp_link = container_of(link, struct bpf_xdp_link, link);
-- 
2.36.1

