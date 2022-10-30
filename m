Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12599612A54
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 12:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiJ3LY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 07:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJ3LY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 07:24:28 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B4425F8;
        Sun, 30 Oct 2022 04:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667129067; x=1698665067;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZDwLt1JxlL7tE7yCgnQ84ANfngwDWA+sGuiJcNf49J0=;
  b=lUk1AHe9WMsxT65x5eXVpo1NZoxdyZpdjUAqQNUFA3Em1rnMwuFN5xNc
   4OJ4cdq0caUc2nwXwcwglvje51JrIuNb+gUMkOeGPWweId0w/j9oLLEHP
   Vpwh4u6zAahDtVaOVzXabD2fhCzASdieUjvQAMhvSe289YuJ8ykF0NTDI
   c+vtjMFz4nJej7i9/ZyQ5v4HNK59J1dSfOEzBkueeI5IgbuRkCcimCm5d
   o7FTKFZcbqPaLSU/iHf+avpSMXS9nVTzjCuLVo5bneLxkIaFS18DElJdM
   mbxel3TpZyGTc5woXE6KIj1UhX3I4woaZ8CkJrffdMxaadiLCYf8bhL6h
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="335391561"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="335391561"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2022 04:24:27 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="758550970"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="758550970"
Received: from naamamex-mobl.ger.corp.intel.com (HELO [10.214.234.205]) ([10.214.234.205])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2022 04:24:24 -0700
Message-ID: <fe7ce0bb-35b6-e16f-d86c-766a040b76df@linux.intel.com>
Date:   Sun, 30 Oct 2022 13:24:14 +0200
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
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
