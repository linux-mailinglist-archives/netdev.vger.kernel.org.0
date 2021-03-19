Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBD63418AE
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 10:45:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhCSJow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 05:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhCSJo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 05:44:29 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677B1C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 02:44:29 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v4so8414753wrp.13
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 02:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rhxRypXWBIGPZjrBmwxPrS7jLVYj5CNzdKl7yMpzqmM=;
        b=FexAy/16+hK8OjOoSLGte9Qe4fJvNFt9faDiGxosrICvTyNd+oXDCf5Pce1f1phuu5
         x2ZctcpBE177seVihn4Skhl3Ndkbk/x7S/20SjryP85vDKCjbbeFp/wos0ISN/fd/TWR
         uIYNzFPqjDrDRSTiOnCJf//gXSY2VaooheMaD9FGA4IBzRnamMePIGYYfJfAY5yJOAnw
         SL1EISoxOS1tbDe1ytEwFL1CdlJ/+F/1okPgIex7RVXnm8e4paq8cqHLzhPwuMnCydt5
         2Da75Vd2nlpH6s/Lo+dUhJGyRymBTInlDv/KYdtj30mz9h7xyBSELFbuZdWMefr7VVSw
         hcEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rhxRypXWBIGPZjrBmwxPrS7jLVYj5CNzdKl7yMpzqmM=;
        b=gaxoqgdes0ys9C8mAtZsbbd7YbJXqDPRFuj7ggE/lDfSTsz0B9qQO4ahw/wSX20efS
         EMsF++B1HoooPRmiQN43c/xoex6NjoL6zwaGrmqxy845nLTlUjUMr5rxdD5v97qUrRBE
         JhONZjjBAsMoewBDEr7qlGOhYh1lDXj7FCtLS0uWllNYCE5TkKX/w/A9BP+LxZx85/ul
         /sherTFW+jfNZSij62sizPK0yresWc7iTsJcn7tqMpj4uN6dsAVi5sozp96T6dXLlueG
         bVM6WvSKv25oYGWmX2YcBGZ5E8ODHyi14CJkYEiIZVLOaTf13ToGSgF2rdnb4bv0iSdt
         VzXw==
X-Gm-Message-State: AOAM532RMQ4+m2gSTtMZe4/HtiFVj+s7bG5C8T6rl2anNelzMTCJgEEx
        lQFQ6SGyuZwiBmqgTJ+PT2g=
X-Google-Smtp-Source: ABdhPJw9dEYESsiU51m9Wk69msQPQs66o+7Ai1vyt35Qn9RuP3YuQLrH3fj2TL1V8gTX4xAkyIQHRQ==
X-Received: by 2002:a5d:684d:: with SMTP id o13mr3696852wrw.235.1616147068126;
        Fri, 19 Mar 2021 02:44:28 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id e18sm7403139wru.73.2021.03.19.02.44.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Mar 2021 02:44:27 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, intel-wired-lan@lists.osuosl.org,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     netdev@vger.kernel.org, bjorn.topel@gmail.com,
        Sreedevi Joshi <sreedevi.joshi@intel.com>
Subject: [PATCH intel-net] i40e: fix receiving of single packets in xsk zero-copy mode
Date:   Fri, 19 Mar 2021 10:44:10 +0100
Message-Id: <20210319094410.3633-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix so that single packets are received immediately instead of in
batches of 8. If you sent 1 pss to a system, you received 8 packets
every 8 seconds instead of 1 packet every second. The problem behind
this was that the work_done reporting from the Tx part of the driver
was broken. The work_done reporting in i40e controls not only the
reporting back to the napi logic but also the setting of the interrupt
throttling logic. When Tx or Rx reports that it has more to do,
interrupts are throttled or coalesced and when they both report that
they are done, interrupts are armed right away. If the wrong work_done
value is returned, the logic will start to throttle interrupts in a
situation where it should have just enabled them. This leads to the
undesired batching behavior seen in user-space.

Fix this by returning the correct boolean value from the Tx xsk
zero-copy path. Return true if there is nothing to do or if we got
fewer packets to process than we asked for. Return false if we got as
many packets as the budget since there might be more packets we can
process.

Fixes: 3106c580fb7c ("i40e: Use batched xsk Tx interfaces to increase performance")
Reported-by: Sreedevi Joshi <sreedevi.joshi@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index fc32c5019b0f..12ca84113587 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -471,7 +471,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 
 	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, descs, budget);
 	if (!nb_pkts)
-		return false;
+		return true;
 
 	if (xdp_ring->next_to_use + nb_pkts >= xdp_ring->count) {
 		nb_processed = xdp_ring->count - xdp_ring->next_to_use;
@@ -488,7 +488,7 @@ static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 
 	i40e_update_tx_stats(xdp_ring, nb_pkts, total_bytes);
 
-	return true;
+	return nb_pkts < budget;
 }
 
 /**

base-commit: c79a707072fe3fea0e3c92edee6ca85c1e53c29f
-- 
2.29.0

