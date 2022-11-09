Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC60622A36
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiKILUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiKILUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:20:07 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E037E8D;
        Wed,  9 Nov 2022 03:19:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667992789; x=1699528789;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZDwLt1JxlL7tE7yCgnQ84ANfngwDWA+sGuiJcNf49J0=;
  b=mxdfHp2gCpFCPcni6k65HDGFE35sdiXbjYhrkd+APWjFbqU9PXy53Jbw
   haJ0WtKB+XBDBw/pAXZkABJphOQ2CF8UTOJpQWEhsnUb3pNV3E8pImTm7
   OJSnT2C6TGnDfU8cKYoP4idrtQL2CTupIXreM6zObRNn0K/8h7pkehnN2
   p+V+iAuEhLSMfI+SFq5e5Kc0iHpq5ogUxiGkBklfWdMdkbmCXMwHV427C
   JlqqQef0dur2faE/rtSHR6S0wHnDCOI1SfIkh19ZFLXduTR8CLAGaK2F8
   G5atSAxmAXLHHPJ/WL4X9TSGl/dEyz0dWD3rRhtgC/VPB5L228y1JANaY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="337686569"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="337686569"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 03:19:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="811601696"
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="811601696"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.214.219.86]) ([10.214.219.86])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 03:19:45 -0800
Message-ID: <e49eb50d-b8dd-59de-e4b7-9001b6beedef@linux.intel.com>
Date:   Wed, 9 Nov 2022 13:19:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Fix TX dispatch condition
Content-Language: en-US
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuri Benditovich <yuri.benditovich@daynix.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yan Vugenfirer <yan@daynix.com>,
        intel-wired-lan@lists.osuosl.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <20221013050044.11862-1-akihiko.odaki@daynix.com>
From:   "naamax.meir" <naamax.meir@linux.intel.com>
In-Reply-To: <20221013050044.11862-1-akihiko.odaki@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/2022 08:00, Akihiko Odaki wrote:
> e1000_xmit_frame is expected to stop the queue and dispatch frames to
> hardware if there is not sufficient space for the next frame in the
> buffer, but sometimes it failed to do so because the estimated maxmium
> size of frame was wrong. As the consequence, the later invocation of
> e1000_xmit_frame failed with NETDEV_TX_BUSY, and the frame in the buffer
> remained forever, resulting in a watchdog failure.
> 
> This change fixes the estimated size by making it match with the
> condition for NETDEV_TX_BUSY. Apparently, the old estimation failed to
> account for the following lines which determines the space requirement
> for not causing NETDEV_TX_BUSY:
>> 	/* reserve a descriptor for the offload context */
>> 	if ((mss) || (skb->ip_summed == CHECKSUM_PARTIAL))
>> 		count++;
>> 	count++;
>>
>> 	count += DIV_ROUND_UP(len, adapter->tx_fifo_limit);
> 
> This issue was found with http-stress02 test included in Linux Test
> Project 20220930.
> 
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>   drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
