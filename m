Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFD36BD791
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjCPRw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjCPRwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:52:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380261D918;
        Thu, 16 Mar 2023 10:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678989170; x=1710525170;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a2ZOAIhOwVTv6T+fWNrtdzmGB8PmumzxRCDd1wYy0sw=;
  b=UEk8gvUuk1alqRKt0OQiINQgFqXduuS5BFjZVcLXruetz3zEsvOvPV0e
   1m9XqFVz+UDaSQivY3GQw3HO6jJG/xCvvfJk40Po/B0q0MJe1sBF6LQH7
   URtHpnBKnX/G7yfcOcYFJ0comCOJ0OXnOLtaNcZ+j12CceqloZidy9iMd
   6g4XRnXoy3HOUlXmqVc1kuVsKtL4+LwUCJOU2ixDuKlOH6PLnXOin80AH
   vIjXYp41ktUeIF0f/hdN/LJeoKoSJrzg+R86DY+SJEOLUIu4jAXgIGQnj
   bzW7aPOLOY/hTquAmra71zTFqoSi1glwsNREEoZfaX0nAzWYcPYB2OwIL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317721448"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="317721448"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 10:52:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="823351306"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="823351306"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga001.fm.intel.com with ESMTP; 16 Mar 2023 10:52:05 -0700
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Alexander Lobakin <aleksander.lobakin@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com
Subject: [PATCH bpf-next 1/2] bpf, test_run: fix crashes due to XDP frame overwriting/corruption
Date:   Thu, 16 Mar 2023 18:50:50 +0100
Message-Id: <20230316175051.922550-2-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316175051.922550-1-aleksander.lobakin@intel.com>
References: <20230316175051.922550-1-aleksander.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot and Ilya faced the splats when %XDP_PASS happens for bpf_test_run
after skb PP recycling was enabled for {__,}xdp_build_skb_from_frame():

BUG: kernel NULL pointer dereference, address: 0000000000000d28
RIP: 0010:memset_erms+0xd/0x20 arch/x86/lib/memset_64.S:66
[...]
Call Trace:
 <TASK>
 __finalize_skb_around net/core/skbuff.c:321 [inline]
 __build_skb_around+0x232/0x3a0 net/core/skbuff.c:379
 build_skb_around+0x32/0x290 net/core/skbuff.c:444
 __xdp_build_skb_from_frame+0x121/0x760 net/core/xdp.c:622
 xdp_recv_frames net/bpf/test_run.c:248 [inline]
 xdp_test_run_batch net/bpf/test_run.c:334 [inline]
 bpf_test_run_xdp_live+0x1289/0x1930 net/bpf/test_run.c:362
 bpf_prog_test_run_xdp+0xa05/0x14e0 net/bpf/test_run.c:1418
[...]

This happens due to that it calls xdp_scrub_frame(), which nullifies
xdpf->data. bpf_test_run code doesn't reinit the frame when the XDP
program doesn't adjust head or tail. Previously, %XDP_PASS meant the
page will be released from the pool and returned to the MM layer, but
now it does return to the Pool with the nullified xdpf->data, which
doesn't get reinitialized then.
So, in addition to checking whether the head and/or tail have been
adjusted, check also for a potential XDP frame corruption. xdpf->data
is 100% affected and also xdpf->flags is the field closest to the
metadata / frame start. Checking for these two should be enough for
non-extreme cases.

Fixes: 9c94bbf9a87b ("xdp: recycle Page Pool backed skbs built from XDP frames")
Reported-by: syzbot+e1d1b65f7c32f2a86a9f@syzkaller.appspotmail.com
Link: https://lore.kernel.org/bpf/000000000000f1985705f6ef2243@google.com
Reported-by: Ilya Leoshkevich <iii@linux.ibm.com>
Link: https://lore.kernel.org/bpf/e07dd94022ad5731705891b9487cc9ed66328b94.camel@linux.ibm.com
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 net/bpf/test_run.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 71226f68270d..8d6b31209bd6 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -208,6 +208,16 @@ static void xdp_test_run_teardown(struct xdp_test_data *xdp)
 	kfree(xdp->skbs);
 }
 
+static bool frame_was_changed(const struct xdp_page_head *head)
+{
+	/* xdp_scrub_frame() zeroes the data pointer, flags is the last field,
+	 * i.e. has the highest chances to be overwritten. If those two are
+	 * untouched, it's most likely safe to skip the context reset.
+	 */
+	return head->frm.data != head->orig_ctx.data ||
+	       head->frm.flags != head->orig_ctx.flags;
+}
+
 static bool ctx_was_changed(struct xdp_page_head *head)
 {
 	return head->orig_ctx.data != head->ctx.data ||
@@ -217,7 +227,7 @@ static bool ctx_was_changed(struct xdp_page_head *head)
 
 static void reset_ctx(struct xdp_page_head *head)
 {
-	if (likely(!ctx_was_changed(head)))
+	if (likely(!frame_was_changed(head) && !ctx_was_changed(head)))
 		return;
 
 	head->ctx.data = head->orig_ctx.data;
-- 
2.39.2

