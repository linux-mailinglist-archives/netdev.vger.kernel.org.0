Return-Path: <netdev+bounces-6985-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3C6D719231
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5675728152C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:34:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 435C223D9;
	Thu,  1 Jun 2023 05:34:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3791323BD
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 05:34:48 +0000 (UTC)
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2642129;
	Wed, 31 May 2023 22:34:46 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aef03.dynamic.kabel-deutschland.de [95.90.239.3])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id B3F0361DFA913;
	Thu,  1 Jun 2023 07:33:53 +0200 (CEST)
Message-ID: <92180324-fa55-5427-839e-d555ac5a6cd7@molgen.mpg.de>
Date: Thu, 1 Jun 2023 07:33:53 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [Intel-wired-lan] [PATCH] igb: Fix extts capture value format for
 82580/i354/i350
Content-Language: en-US
To: Yuezhen Luan <eggcar.luan@gmail.com>
Cc: jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 linux-kernel@vger.kernel.org
References: <20230531090805.3959-1-eggcar.luan@gmail.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230531090805.3959-1-eggcar.luan@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dear Yuezhen,


Thank you very much for your patch.

Am 31.05.23 um 11:08 schrieb Yuezhen Luan:
> 82580/i354/i350 features circle-counter-like timestamp registers
> that are different with newer i210. The EXTTS capture value in
> AUXTSMPx should be converted from raw circle counter value to
> timestamp value in resolution of 1 nanosec by the driver.

It’d be great, if you added a paragraph how to reproduce the issue.

> Signed-off-by: Yuezhen Luan <eggcar.luan@gmail.com>
> ---
>   drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index 58872a4c2..187daa8ef 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -6947,6 +6947,7 @@ static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
>   	struct e1000_hw *hw = &adapter->hw;
>   	struct ptp_clock_event event;
>   	struct timespec64 ts;
> +	unsigned long flags;

I do not see the variable *flags* being used.

>   
>   	if (pin < 0 || pin >= IGB_N_SDP)
>   		return;
> @@ -6954,9 +6955,12 @@ static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
>   	if (hw->mac.type == e1000_82580 ||
>   	    hw->mac.type == e1000_i354 ||
>   	    hw->mac.type == e1000_i350) {
> -		s64 ns = rd32(auxstmpl);
> +		u64 ns = rd32(auxstmpl);
>   
> -		ns += ((s64)(rd32(auxstmph) & 0xFF)) << 32;
> +		ns += ((u64)(rd32(auxstmph) & 0xFF)) << 32;
> +		spin_lock_irqsave(&adapter->tc, ns);
> +		ns = timecounter_cyc2time(&adapter->tc, ns);
> +		spin_unlock_irqrestore(&adapter->tc, ns);
>   		ts = ns_to_timespec64(ns);
>   	} else {
>   		ts.tv_nsec = rd32(auxstmpl);


Kind regards,

Paul

