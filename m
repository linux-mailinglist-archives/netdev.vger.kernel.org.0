Return-Path: <netdev+bounces-11841-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F40734C52
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F1FC280EC8
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 07:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6ACB524A;
	Mon, 19 Jun 2023 07:27:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FA923C0
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:27:16 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F325A9
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 00:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687159635; x=1718695635;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=s0WIj2gOkb34db8gx15ytiRMeoR7t8zcxuBH9xYeUZ4=;
  b=P0vcC9zVzqIxzwhU76ozvdgQoHFQ5A1eEiKnmlZOKex9z/sBi8RWmETi
   EGrCK9MAU4O2VM/fC0KFiThlmCMiSSFxNYn3c2JCQN3QtpWEdECKmIxis
   iMtVCEgkG+OIGOPTLsWuR8SOGHb4/4jrn95tRoxeshFSgz2vli508f5DG
   iyPyI1k6Dg9N5syTS7xAj1r4LLuGSC/PsDIZQSOmOVZ1Nsw6vX85y9v64
   CAAC347XoiDIwzn7sPMrIXd3jnhoxjPWUCO7ENQfF4vo0Lg7WywPuKbYW
   nN4mbavJFbX1MuzMd6+r7i4DyHk3ghzxl+L/vw73hsDb9eZppytuYSSLE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="349284279"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="349284279"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 00:27:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10745"; a="713567167"
X-IronPort-AV: E=Sophos;i="6.00,254,1681196400"; 
   d="scan'208";a="713567167"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.13.12.68]) ([10.13.12.68])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 00:27:10 -0700
Message-ID: <b567fd9a-7a22-85bf-cb52-6ea2a383949c@linux.intel.com>
Date: Mon, 19 Jun 2023 10:27:08 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net 1/4] igc: Fix race condition in PTP tx code
Content-Language: en-US
To: Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>, sasha.neftin@intel.com,
 richardcochran@gmail.com, Andre Guedes <andre.guedes@intel.com>,
 Kurt Kanzenbach <kurt@linutronix.de>
References: <20230530174928.2516291-1-anthony.l.nguyen@intel.com>
 <20230530174928.2516291-2-anthony.l.nguyen@intel.com>
From: "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20230530174928.2516291-2-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/2023 20:49, Tony Nguyen wrote:
> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> 
> Currently, the igc driver supports timestamping only one tx packet at a
> time. During the transmission flow, the skb that requires hardware
> timestamping is saved in adapter->ptp_tx_skb. Once hardware has the
> timestamp, an interrupt is delivered, and adapter->ptp_tx_work is
> scheduled. In igc_ptp_tx_work(), we read the timestamp register, update
> adapter->ptp_tx_skb, and notify the network stack.
> 
> While the thread executing the transmission flow (the user process
> running in kernel mode) and the thread executing ptp_tx_work don't
> access adapter->ptp_tx_skb concurrently, there are two other places
> where adapter->ptp_tx_skb is accessed: igc_ptp_tx_hang() and
> igc_ptp_suspend().
> 
> igc_ptp_tx_hang() is executed by the adapter->watchdog_task worker
> thread which runs periodically so it is possible we have two threads
> accessing ptp_tx_skb at the same time. Consider the following scenario:
> right after __IGC_PTP_TX_IN_PROGRESS is set in igc_xmit_frame_ring(),
> igc_ptp_tx_hang() is executed. Since adapter->ptp_tx_start hasn't been
> written yet, this is considered a timeout and adapter->ptp_tx_skb is
> cleaned up.
> 
> This patch fixes the issue described above by adding the ptp_tx_lock to
> protect access to ptp_tx_skb and ptp_tx_start fields from igc_adapter.
> Since igc_xmit_frame_ring() called in atomic context by the networking
> stack, ptp_tx_lock is defined as a spinlock, and the irq safe variants
> of lock/unlock are used.
> 
> With the introduction of the ptp_tx_lock, the __IGC_PTP_TX_IN_PROGRESS
> flag doesn't provide much of a use anymore so this patch gets rid of it.
> 
> Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")
> Signed-off-by: Andre Guedes <andre.guedes@intel.com>
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>   drivers/net/ethernet/intel/igc/igc.h      |  5 +-
>   drivers/net/ethernet/intel/igc/igc_main.c |  9 ++--
>   drivers/net/ethernet/intel/igc/igc_ptp.c  | 57 ++++++++++++-----------
>   3 files changed, 41 insertions(+), 30 deletions(-)

Tested-by: Naama Meir <naamax.meir@linux.intel.com>

