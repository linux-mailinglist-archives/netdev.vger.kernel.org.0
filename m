Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99A8470F8D
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 01:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345505AbhLKApL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 19:45:11 -0500
Received: from mga06.intel.com ([134.134.136.31]:55436 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237381AbhLKApJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 19:45:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639183294; x=1670719294;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=j+pEU2PK/unlZK6R1gJ5fO9x4s2w4KWtjX5taAKJMtY=;
  b=QwjvILN89+nZx52q/oQJqldwhGeR12+ziVMyb/HDmW6l6eyfetsLLXdq
   5rT8D0Cb0oeIkcVC24cACdVCiSaUcYJ/zxfp0UG+/17H67PRwWF02zCma
   SEST2Lf7h+4lPndRfm4gg5yHFP/LlkSwOTveMmX+Da39J34Yy+JWRxsN8
   5w15SD4lxLLSOjOSE11ZFmmqDp13OQn4N2VJ7a7LLFXQq0+Y8fzKufVAn
   849V1qZCb+lchdKcXOkJYk5aWlDZMlBxq4fpkY+EHqqfE0z1iSDg98f9T
   5hf4yl9UWR2NpAcxWFGsT4p8zTQe62p91ouTFMyLupCvLcVaZLwg/3som
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="299277364"
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208,223";a="299277364"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 16:41:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,197,1635231600"; 
   d="scan'208,223";a="504160187"
Received: from mmcarty-mobl.amr.corp.intel.com (HELO vcostago-mobl3) ([10.209.82.172])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 16:41:33 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Stefan Dietrich <roots@gmx.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     kuba@kernel.org, greg@kroah.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, regressions@lists.linux.dev
Subject: Re: [PATCH] igc: Avoid possible deadlock during suspend/resume
In-Reply-To: <d4c9bb101aa79c5acaaa6dd7b42159fb0c91a341.camel@gmx.de>
References: <87r1awtdx3.fsf@intel.com>
 <20211201185731.236130-1-vinicius.gomes@intel.com>
 <5a4b31d43d9bf32e518188f3ef84c433df3a18b1.camel@gmx.de>
 <87o85yljpu.fsf@intel.com>
 <063995d8-acf3-9f33-5667-f284233c94b4@leemhuis.info>
 <8e59b7d6b5d4674d5843bb45dde89e9881d0c741.camel@gmx.de>
 <5c5b606a-4694-be1b-0d4b-80aad1999bd9@leemhuis.info>
 <d4c9bb101aa79c5acaaa6dd7b42159fb0c91a341.camel@gmx.de>
Date:   Fri, 10 Dec 2021 16:41:32 -0800
Message-ID: <87h7bgrn0j.fsf@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

Hi Stefan,

Stefan Dietrich <roots@gmx.de> writes:

> Agreed and thanks for the pointers; please see the log files and
> .config attached as requested.
>

Thanks for the logs.

Very interesting that the initialization of the device is fine, so it's
something that happens later.

Can you test the attached patch?

If the patch works, I would also be interested if you notice any loss of
functionality with your NIC. (I wouldn't think so, as far as I know,
i225-V models have PTM support but don't have any PTP support).

>
> Cheers,
> Stefan
>
>
> On Fri, 2021-12-10 at 15:01 +0100, Thorsten Leemhuis wrote:
>> On 10.12.21 14:45, Stefan Dietrich wrote:
>> > thanks for keeping an eye on the issue. I've sent the files in
>> > private
>> > because I did not want to spam the mailing lists with them. Please
>> > let
>> > me know if this is the correct procedure.
>>

Cheers,
-- 
Vinicius


--=-=-=
Content-Type: text/x-patch
Content-Disposition: attachment;
 filename=0001-igc-Do-not-enable-crosstimestamping-for-i225-V-model.patch
Content-Description: test patch for deadlock in igc

From bc78a215cd3a68375ec62a05080070876e31d733 Mon Sep 17 00:00:00 2001
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date: Fri, 10 Dec 2021 16:23:42 -0800
Subject: [TEST ONLY] igc: Do not enable crosstimestamping for i225-V models

WIP WIP WIP

Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 30568e3544cd..b525035a8a2b 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -768,7 +768,13 @@ int igc_ptp_get_ts_config(struct net_device *netdev, struct ifreq *ifr)
  */
 static bool igc_is_crosststamp_supported(struct igc_adapter *adapter)
 {
-	return IS_ENABLED(CONFIG_X86_TSC) ? pcie_ptm_enabled(adapter->pdev) : false;
+	if (!IS_ENABLED(CONFIG_X86_TSC))
+		return false;
+
+	if (adapter->pdev->device == IGC_DEV_ID_I225_V)
+		return false;
+
+	return pcie_ptm_enabled(adapter->pdev);
 }
 
 static struct system_counterval_t igc_device_tstamp_to_system(u64 tstamp)
-- 
2.33.1


--=-=-=--
