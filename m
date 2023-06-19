Return-Path: <netdev+bounces-11912-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E089735189
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:09:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 834842810A8
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01EF2C8C8;
	Mon, 19 Jun 2023 10:09:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84ADBE6C
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:09:17 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C643E62;
	Mon, 19 Jun 2023 03:09:08 -0700 (PDT)
From: Florian Kauer <florian.kauer@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1687169346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UfXg5kiqedtrj71y05Um//hTyaY890VMSarbops9Qv0=;
	b=CfxdODntikelGjFSsAFgP5n/2oYhcQzDEtPk1mXUdkWJlGRNp8c+OIK74oGnhT7GMTg4c9
	Ec0BqJABi9heLcGLTe0dbkV4KT1zTqc1pbPh/8Po6Xj/LosB4b3oJJ2TNuHmK2YfLUpRi4
	wywZMMAVITUYT2pjbeVRXZ1/6GfGz7sPyuno/iLjdo2yTZ6/AVX59rNrgocCGP2FPOEkr9
	I+qmdqgeAgVMf6B3aBotL251iEcaO48dfxxfNKdLZBwGyUD3lmpJBjRsPY/9fABQ16PVm+
	9Fh0PQ8svXSM6DovMixcJyYL6+kUvBVvh7X+lNefrZYbR3OuzQelsIJGecvvuA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1687169346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=UfXg5kiqedtrj71y05Um//hTyaY890VMSarbops9Qv0=;
	b=LCAJK6sIZF73m7TU3iMW18qkDQ0HbpxquUVo9rcjk3DVqKKA3A8OcyvITTCz7WcUHUT3OF
	qM5dTIH0Noj9VBAA==
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
Subject: [PATCH net v2 0/6] igc: Fix corner cases for TSN offload
Date: Mon, 19 Jun 2023 12:08:52 +0200
Message-Id: <20230619100858.116286-1-florian.kauer@linutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
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

---

v2: - Rebased onto net. #1-#2 needed adaptations, others unmodified.
    - Extend #3 commit message that it only regards i225.

---

Florian Kauer (6):
  igc: Rename qbv_enable to taprio_offload_enable
  igc: Do not enable taprio offload for invalid arguments
  igc: Handle already enabled taprio offload for basetime 0
  igc: No strict mode in pure launchtime/CBS offload
  igc: Fix launchtime before start of cycle
  igc: Fix inserting of empty frame for launchtime

 drivers/net/ethernet/intel/igc/igc.h      |  2 +-
 drivers/net/ethernet/intel/igc/igc_main.c | 10 ++++-----
 drivers/net/ethernet/intel/igc/igc_tsn.c  | 26 ++++++++++++++++++++---
 3 files changed, 29 insertions(+), 9 deletions(-)

-- 
2.39.2


