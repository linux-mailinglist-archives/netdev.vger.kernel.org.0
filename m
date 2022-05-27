Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B118535D3A
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbiE0JMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350579AbiE0JLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:11:54 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4246113C36F
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 02:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653642505; x=1685178505;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=C9nAhmJGVLFRsDfrnddwjcwKvsG0JoJ14Hik8F6vvqw=;
  b=XbfaeHIszMutKueYzK34NdzFbhWZ3jnxMr0RnTLVB6/ke8j6iZm00p/0
   xgv3+SnM1HSQD6SUTDFAyJkNAyIS1hJwCZPb8bJvfVT0PQ+tz28y4Pch0
   M8r+2po0M0hHrcV39DPG2RWQRpabAye2jFdkII9JVh4Cg84cTZO3V1C8k
   H0RFRO2PNFtRPGkgupWRHl1q1w4HFpLthDIHOT86F2Gmq7IV32grwO37o
   eVkxLTMNNf1TaieNj58dDFEmgxRWshmPPFnChplsJnwkw9w0QAD2xC88Z
   9Cd4EX+Nh+7nX1azg9I3/tONK0paAdhog2cwJ58/FYx0mZ9aLZ0SBFdjs
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10359"; a="273240601"
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="273240601"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:08:24 -0700
X-IronPort-AV: E=Sophos;i="5.91,255,1647327600"; 
   d="scan'208";a="603770259"
Received: from zhoufuro-mobl.ccr.corp.intel.com (HELO [10.255.30.80]) ([10.255.30.80])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 02:08:21 -0700
Message-ID: <e6cb8b03-4d3d-b64b-0aca-642fe53ecb90@linux.intel.com>
Date:   Fri, 27 May 2022 17:08:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net-next v5 09/11] igc: Add support for Frame Preemption
 verification
Content-Language: en-US
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, vladimir.oltean@nxp.com, po.liu@nxp.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org
References: <20220520011538.1098888-1-vinicius.gomes@intel.com>
 <20220520011538.1098888-10-vinicius.gomes@intel.com>
From:   Zhou Furong <furong.zhou@linux.intel.com>
In-Reply-To: <20220520011538.1098888-10-vinicius.gomes@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +
> +	struct delayed_work fp_verification_work;
> +	unsigned long fp_start;
> +	bool fp_received_smd_v;
> +	bool fp_received_smd_r;
> +	unsigned int fp_verify_cnt;
> +	enum frame_preemption_state fp_tx_state;
> +	bool fp_disable_verify;

struct size would be smaller if add member to right place


> +	if (!netif_running(adapter->netdev))
> +		return -ENOTCONN;
> +
> +	/* FIXME: rename this function to something less specific, as
> +	 * it can be used outside XDP.
> +	 */
> +	ring = igc_xdp_get_tx_ring(adapter, cpu);
> +	nq = txring_txq(ring);
> +
> +	skb = alloc_skb(IGC_FP_SMD_FRAME_SIZE, GFP_KERNEL);
> +	if (!skb)
> +		return -ENOMEM;
> +
if there is chance of NOMEM, move this before
ring = igc_xdp_get_tx_ring(adapter, cpu);


> +static void igc_fp_verification_work(struct work_struct *work)
> +{
> +	struct delayed_work *dwork = to_delayed_work(work);
> +	struct igc_adapter *adapter;
> +	int err;
> +
> +	adapter = container_of(dwork, struct igc_adapter, fp_verification_work);
> +
please remove blank

> +	if (adapter->fp_disable_verify)
> +		goto done;
> +
> +	switch (adapter->fp_tx_state) {
> +	case FRAME_PREEMPTION_STATE_START:
> +		adapter->fp_received_smd_r = false;
> +		err = igc_xmit_smd_frame(adapter, IGC_SMD_TYPE_SMD_V);
> +		if (err < 0)
> +			netdev_err(adapter->netdev, "Error sending SMD-V frame\n");
> +
> +		adapter->fp_tx_state = FRAME_PREEMPTION_STATE_SENT;
state is SENT when send error?

> +		adapter->fp_start = jiffies;
> +		schedule_delayed_work(&adapter->fp_verification_work, IGC_FP_TIMEOUT);
> +		break;
> +





> +
> +			if (adapter->fp_verify_cnt > IGC_MAX_VERIFY_CNT) {
> +				adapter->fp_verify_cnt = 0;
> +				adapter->fp_tx_state = FRAME_PREEMPTION_STATE_FAILED;
> +				netdev_err(adapter->netdev,
> +					   "Exceeded number of attempts for frame preemption verification\n");
> +			} else {
> +				adapter->fp_tx_state = FRAME_PREEMPTION_STATE_START;
> +			}
> +			schedule_delayed_work(&adapter->fp_verification_work, IGC_FP_TIMEOUT);
> +		}
> +
> +		break;
> +
> +	case FRAME_PREEMPTION_STATE_FAILED:
> +	case FRAME_PREEMPTION_STATE_DONE:
miss default?

> +		break;
> +	}
> +
