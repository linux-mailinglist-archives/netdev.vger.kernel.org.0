Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5456920E461
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391023AbgF2VYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:24:45 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:27801 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390666AbgF2VYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 17:24:39 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jun 2020 17:24:38 EDT
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [172.25.230.4])
        by smtp.aristanetworks.com (Postfix) with ESMTP id DB96540186E;
        Mon, 29 Jun 2020 14:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1593465481;
        bh=6rzpagTEz/0c76jqpV4RCeaagtLY9blrBtt6YCEHTrw=;
        h=Date:To:Subject:From:From;
        b=T7f3fBEHpUZytdu2dNWE4IOyY2k7FnzrY+o/OenHEBt9S58mhUR6c/sbUsE90U9um
         63HFFog4ODYUbrqhwyMkQ343mLRQk+Czh8yoTjh+Pm4O/tpDpKx1PT5w0q3r/QyAGr
         PRGBqfHrx/7eQB71w/KdbZrJZxIr5UEq0GjbQ3HrBZw1K2F0Y7AaHSuAJ6ig3TLcg8
         3RNjXFcd9utZlJ6YFi3eUfn/ZX64DNvg+C6tvNfESlrjJjI6SFLQJWFKnw+HEH4hQR
         r0evEFRhEBprt3Jv6Zxm+wdSvOgEYxn+fHauuuUYP52erWnuWY0rL1ObWwXLXZka/8
         DrkZaIFaGJmGA==
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id C3D7095C0900; Mon, 29 Jun 2020 14:18:01 -0700 (PDT)
Date:   Mon, 29 Jun 2020 14:18:01 -0700
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, kuba@kernel.org,
        davem@davemloft.net, jeffrey.t.kirsher@intel.com,
        fruggeri@arista.com
Subject: [PATCH] igb: reinit_locked() should be called with rtnl_lock
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20200629211801.C3D7095C0900@us180.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We observed a panic in igb_reset_task caused by this race condition
when doing a reboot -f:

	kworker			reboot -f

	igb_reset_task
	igb_reinit_locked
	igb_down
	napi_synchronize
				__igb_shutdown
				igb_clear_interrupt_scheme
				igb_free_q_vectors
				igb_free_q_vector
				adapter->q_vector[v_idx] = NULL;
	napi_disable
	Panics trying to access
	adapter->q_vector[v_idx].napi_state

This commit applies to igb the same changes that were applied to ixgbe
in commit 8f4c5c9fb87a ("ixgbe: reinit_locked() should be called with
rtnl_lock") and commit 88adce4ea8f9 ("ixgbe: fix possible race in
reset subtask").

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 8bb3db2cbd41..b79a78e102f3 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6224,9 +6224,11 @@ static void igb_reset_task(struct work_struct *work)
 	struct igb_adapter *adapter;
 	adapter = container_of(work, struct igb_adapter, reset_task);
 
+	rtnl_lock();
 	igb_dump(adapter);
 	netdev_err(adapter->netdev, "Reset adapter\n");
 	igb_reinit_locked(adapter);
+	rtnl_unlock();
 }
 
 /**

