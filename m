Return-Path: <netdev+bounces-5297-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5646C710A5D
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 12:53:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F351B281504
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 10:53:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36D76E577;
	Thu, 25 May 2023 10:53:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC34D533
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 10:53:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A14CC433D2;
	Thu, 25 May 2023 10:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685011989;
	bh=DGZUNnKLpFIKKgAIoq8KpqEt+LPmKrgx96HvrKtT9Yw=;
	h=From:Date:Subject:To:Cc:From;
	b=Dft2P935xbpmZpkslBzCWrsDqbaeVKgPg3BoZ5+uADaeCLyX91goudh/37PWofh5j
	 YKZkCYWz+F0uWy56wWc5BSRRRTx7Pf6VvqulpN/Q3LoBo1NnJNS0yj++edEeri0DdZ
	 KfjL2vUmtjaAo38IuDuhlje4cSdsr9IWyyhvV5qIozhc1H76JayVKB4xYPrKO7mwqt
	 5rZ77eCbN8cVz3Nh4YgO12xlgfdpkmsgTRPVG7Oh37iKlPkzv1zGPOJPjArM/9NGWI
	 VaWQmNQXR5J4WyPKyl2Ig2sQF24+A9JNxW2I+jh5XKv5uApSVSni5S0D36RFXjgLe5
	 rWHWzZ/xO294Q==
From: Simon Horman <horms@kernel.org>
Date: Thu, 25 May 2023 12:52:58 +0200
Subject: [PATCH net] ice: Don't dereference NULL in ice_gns_read error path
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230525-null-ice-v1-1-30d10557b91e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAk+b2QC/x2M0QqDMBAEf0XuuQcmqaX4K6UPMa71QK6SVBHEf
 /fs4ywzu1NBFhRqq50yVinyVQN3qyiNUT9g6Y3J1z7UjW9Yl2liSeDQu2d8hOEe4Mj0LhZwl6O
 m0YJLs3HOGGT7/79I8aP3cZzb+JqMdAAAAA==
To: Jesse Brandeburg <jesse.brandeburg@intel.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: Jakub Kicinski <kuba@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Paolo Abeni <pabeni@redhat.com>, 
 Karol Kolacinski <karol.kolacinski@intel.com>, 
 Sudhansu Sekhar Mishra <sudhansu.mishra@intel.com>, 
 Dan Carpenter <dan.carpenter@linaro.org>, intel-wired-lan@lists.osuosl.org, 
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.12.2

If pf is NULL in ice_gns_read() then it will be dereferenced
in the error path by a call to dev_dbg(ice_pf_to_dev(pf), ...).

Avoid this by simply returning in this case.
If logging is desired an alternate approach might be to
use pr_err() before returning.

Flagged by Smatch as:

  .../ice_gnss.c:196 ice_gnss_read() error: we previously assumed 'pf' could be null (see line 131)

Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_gnss.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
index 2ea8a2b11bcd..3d0663840aa1 100644
--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
@@ -128,12 +128,7 @@ static void ice_gnss_read(struct kthread_work *work)
 	int err = 0;
 
 	pf = gnss->back;
-	if (!pf) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	if (!test_bit(ICE_FLAG_GNSS, pf->flags))
+	if (!pf || !test_bit(ICE_FLAG_GNSS, pf->flags))
 		return;
 
 	hw = &pf->hw;
@@ -191,7 +186,6 @@ static void ice_gnss_read(struct kthread_work *work)
 	free_page((unsigned long)buf);
 requeue:
 	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work, delay);
-exit:
 	if (err)
 		dev_dbg(ice_pf_to_dev(pf), "GNSS failed to read err=%d\n", err);
 }


