Return-Path: <netdev+bounces-10742-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E56730130
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E38A028147F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01675D515;
	Wed, 14 Jun 2023 14:07:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B16C151
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 14:07:30 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBA0CD;
	Wed, 14 Jun 2023 07:07:28 -0700 (PDT)
From: Florian Kauer <florian.kauer@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1686751646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EJvyE/C3PvQNTvDv0SaWnfKcEUXisJIN7Dyyhzdk0bk=;
	b=3Q9xpOFUIfL7l3ShdTyCf/oPmQEtVietstpFXDZcC2uxcw2CO16I3QM1SI6PtPAihPoEdQ
	WcSY4OWzi3pUEZylPYJ8dVld3HCtDHwoOV3yl4D+vBbq+xI1RlCBolQYjfUDGggqz64bxO
	/gYjusYOQcHiRgqTxI5dVqmGtvNIN0P4DfFkYjNhS7irCxcug1B5XRZElKy1oWg5j0HNIh
	Y84YDnr/bGYpHetH/WTZUIfR4o5AkGyL2toHMPM/xdd+Wr6wKl/1+3IBku/S5XXgT5xj4h
	a64dKSYV7/3Bp5Krjy5xGcMKjhNQwFDD8/S62mU0/W0H37Chyh79dDKNwyoQ8A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1686751646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EJvyE/C3PvQNTvDv0SaWnfKcEUXisJIN7Dyyhzdk0bk=;
	b=mJ5bM/swMdWLiQBPI6q6TyY9ppPwCbZ9rstTumP66sDYj9b1FTLJZEarsSRivBST0aS3Wm
	YNFRVGe+ccxH+WBw==
To: Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Tan Tee Min <tee.min.tan@linux.intel.com>,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
	Aravindhan Gunasekaran <aravindhan.gunasekaran@intel.com>,
	Malli C <mallikarjuna.chilakala@intel.com>
Cc: intel-wired-lan@lists.osuosl.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kurt@linutronix.de,
	florian.kauer@linutronix.de
Subject: [PATCH net-next 0/6] igc: Fix corner cases for TSN offload
Date: Wed, 14 Jun 2023 16:07:08 +0200
Message-Id: <20230614140714.14443-1-florian.kauer@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The igc driver supports several different offloading capabilities
relevant in the TSN context. Recent patches in this area introduced
regressions for certain corner cases that are fixed in this series.

Each of the patches (except the first one) addresses a different
regression that can be separately reproduced. Still, they have
overlapping code changes so they should not be separately applied.

Especially #4 and #6 address the same observation,
but both need to be applied to avoid TX hang occurrences in
the scenario described in the patches.

Signed-off-by: Florian Kauer <florian.kauer@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>

Florian Kauer (6):
  igc: Rename qbv_enable to taprio_offload_enable
  igc: Do not enable taprio offload for invalid arguments
  igc: Handle already enabled taprio offload for basetime 0
  igc: No strict mode in pure launchtime/CBS offload
  igc: Fix launchtime before start of cycle
  igc: Fix inserting of empty frame for launchtime

 drivers/net/ethernet/intel/igc/igc.h      |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c | 24 ++++++++-------------
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 26 ++++++++++++++++++++---
 3 files changed, 33 insertions(+), 19 deletions(-)

-- 
2.39.2


