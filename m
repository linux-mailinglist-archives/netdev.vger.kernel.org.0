Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7374DD08A
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 23:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiCQWLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 18:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiCQWL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 18:11:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C4C1FDFE3;
        Thu, 17 Mar 2022 15:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647555010; x=1679091010;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=QpWbczOzLS4au3qRyyNQY/DJiO8OZbjCj8/kWLrheTM=;
  b=WnehGXa1UhX8180TRwCdm1/0jqguxcSXcsdS4S/wqGEsYNdCkRiQD6it
   3avw0I6IaHwhJQEkXpckJ55X+XPDdBaNktEsinN8XZqLmE4AMAM5m2OnP
   rV+Y6GleoDLAAg1ptNy/pBZ6fm+iOu9ao/ZDhwBVQFKOrF9dmgijxKand
   cZUL3dYgDu0QSZRMCofKs6WhhbPKBrtAfrLJTuQ7p6UX+73olle+O7tKd
   xx5Nbqj/Xz6ljkCxLdqmhpKHh8OlbgWbP4BloGT+4jxINML4ActMjoE7r
   ayTZwjpiHqSyDEv8H40oaW9DCesA03qMvU08ywTJL681jxR73G7mCKil9
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="255821066"
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="255821066"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 15:10:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,190,1643702400"; 
   d="scan'208";a="599259580"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.9.212])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 15:10:09 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Yonglong Li <liyonglong@chinatelecom.cn>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, stable@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net] mptcp: Fix crash due to tcp_tsorted_anchor was initialized before release skb
Date:   Thu, 17 Mar 2022 15:09:53 -0700
Message-Id: <20220317220953.426024-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Li <liyonglong@chinatelecom.cn>

Got crash when doing pressure test of mptcp:

===========================================================================
dst_release: dst:ffffa06ce6e5c058 refcnt:-1
kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
BUG: unable to handle kernel paging request at ffffa06ce6e5c058
PGD 190a01067 P4D 190a01067 PUD 43fffb067 PMD 22e403063 PTE 8000000226e5c063
Oops: 0011 [#1] SMP PTI
CPU: 7 PID: 7823 Comm: kworker/7:0 Kdump: loaded Tainted: G            E
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.2.1 04/01/2014
Call Trace:
 ? skb_release_head_state+0x68/0x100
 ? skb_release_all+0xe/0x30
 ? kfree_skb+0x32/0xa0
 ? mptcp_sendmsg_frag+0x57e/0x750
 ? __mptcp_retrans+0x21b/0x3c0
 ? __switch_to_asm+0x35/0x70
 ? mptcp_worker+0x25e/0x320
 ? process_one_work+0x1a7/0x360
 ? worker_thread+0x30/0x390
 ? create_worker+0x1a0/0x1a0
 ? kthread+0x112/0x130
 ? kthread_flush_work_fn+0x10/0x10
 ? ret_from_fork+0x35/0x40
===========================================================================

In __mptcp_alloc_tx_skb skb was allocated and skb->tcp_tsorted_anchor will
be initialized, in under memory pressure situation sk_wmem_schedule will
return false and then kfree_skb. In this case skb->_skb_refdst is not null
because_skb_refdst and tcp_tsorted_anchor are stored in the same mem, and
kfree_skb will try to release dst and cause crash.

Fixes: f70cad1085d1 ("mptcp: stop relying on tcp_tx_skb_cache")
Cc: stable@vger.kernel.org
Reviewed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Yonglong Li <liyonglong@chinatelecom.cn>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1c72f25f083e..014c9d88f947 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1196,6 +1196,7 @@ static struct sk_buff *__mptcp_alloc_tx_skb(struct sock *sk, struct sock *ssk, g
 		tcp_skb_entail(ssk, skb);
 		return skb;
 	}
+	tcp_skb_tsorted_anchor_cleanup(skb);
 	kfree_skb(skb);
 	return NULL;
 }

base-commit: 551acdc3c3d2b6bc97f11e31dcf960bc36343bfc
-- 
2.35.1

