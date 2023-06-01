Return-Path: <netdev+bounces-7243-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8914271F48E
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 23:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC0912818F3
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 21:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B428924120;
	Thu,  1 Jun 2023 21:24:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01F533DF
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 21:24:24 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F223F1A7
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 14:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685654661; x=1717190661;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=Lozp43ednVYkDC2WKxGwUfNzJqJ6eA5JyvuRnQOQoEg=;
  b=PKrxG70neVzUMUqNjr13PvjYmcl0IqJ/PA7Tzy+VS9HkOPSxF1PmTB9m
   PwJ4Zlt5CrkAZo9+ku0jNG444uosvZR89DHze8QqA+vgA8T5IKL6ia9F7
   l5l/i4yqInrYtqCKp66RSdghxWu9qlCHQBRghp/3F60AaH3T3Kna+NHhb
   ndfaisBU+ivGab8ogSkDGXlevwV5n47yNsHa/mqsOCAdK7F5O5IZ+Hb1+
   OQHA51+K9C+adpYmcaabNoH1cHlpSDYk/UPMnyyrk6QR2MWBN0ppKG6f6
   m3M40o1vBIGrFBBjeh2ReuZ6XBHAuAH3anb0XQecrdX+l/33x1xGecs9Y
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="358116751"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="358116751"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 14:21:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="710671039"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="710671039"
Received: from zzhou9-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.252.141.43])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 14:21:36 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 netdev@vger.kernel.org, sasha.neftin@intel.com, richardcochran@gmail.com,
 Vladimir Oltean <vladimir.oltean@nxp.com>, Naama Meir
 <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 2/4] igc: Check if hardware TX timestamping is
 enabled earlier
In-Reply-To: <20230531231029.36822957@kernel.org>
References: <20230530174928.2516291-1-anthony.l.nguyen@intel.com>
 <20230530174928.2516291-3-anthony.l.nguyen@intel.com>
 <20230531231029.36822957@kernel.org>
Date: Thu, 01 Jun 2023 14:21:35 -0700
Message-ID: <87353aubds.fsf@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 30 May 2023 10:49:26 -0700 Tony Nguyen wrote:
>> -	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
>> +	if (unlikely(adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
>> +		     skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
>>  		/* FIXME: add support for retrieving timestamps from
>>  		 * the other timer registers before skipping the
>>  		 * timestamping request.
>> @@ -1586,7 +1587,7 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
>>  		unsigned long flags;
>>  
>>  		spin_lock_irqsave(&adapter->ptp_tx_lock, flags);
>> -		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON && !adapter->ptp_tx_skb) {
>> +		if (!adapter->ptp_tx_skb) {
>
> AFAICT the cancel / cleanup path is not synchronized (I mean for
> accesses to adapter->tstamp_config) so this looks racy to me :(
>

As far as I can see, the racy behavior wasn't introduced here, can I
propose the fix as a follow up patch? Or do you prefer that I re-spin
this series?


Cheers,
-- 
Vinicius

