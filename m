Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E4E967C926
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbjAZKvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbjAZKvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:51:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9C532534
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 02:51:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 343E7B81B9F
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 10:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF42C433EF;
        Thu, 26 Jan 2023 10:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674730289;
        bh=cgu3ixTiTHRi1Vgp+MihHNE5QXxe9HjMFDDsPKdRvrk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=shHDmZ7euxCJJyCZCCqMs8RoqEyyUFLbbombJuYHCTNrUNHMrFKF0TGwSb9h0UlKs
         vuKuq92u8QdGdaQx36vyWM2VI1lYEj/+Hwtju8NL3pEyj0/Sg8ehV3N0o08hm4fMmR
         jD5xWXn1WQccEQYkTDn08lYj0MwPoJnHxu4xRFvqpfzZXcvk9Xaehxbk/R0TwP+kQE
         hRkiIQ9Re/d4xjvukWQdioea7Kttt86oJU9XUyP+PASfuDhnPyw2jLVMlhkZWwH4st
         Z5sMSgw7Ng2KI8WlSZGfWiqd34NVZrHhfrzFXmr9GdW2bjR8CFCJT6KGXfsQQshAws
         tr3Qmhc8Tab5w==
Date:   Thu, 26 Jan 2023 12:51:25 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Tan Tee Min <tee.min.tan@linux.intel.com>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 2/3] igc: offload queue max SDU from tc-taprio
Message-ID: <Y9JbLW/BF/Q6nKBy@unreal>
References: <20230125212702.4030240-1-anthony.l.nguyen@intel.com>
 <20230125212702.4030240-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125212702.4030240-3-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 01:27:01PM -0800, Tony Nguyen wrote:
> From: Tan Tee Min <tee.min.tan@linux.intel.com>
> 
> Add support for configuring the max SDU for each Tx queue.
> If not specified, keep the default.
> 
> All link speeds have been tested with this implementation.
> No performance issue observed.
> 
> How to test:
> 
> 1) Configure the tc with max-sdu
> 
> tc qdisc replace dev $IFACE parent root handle 100 taprio \
>     num_tc 4 \
>     map 0 1 2 3 3 3 3 3 3 3 3 3 3 3 3 3 \
>     queues 1@0 1@1 1@2 1@3 \
>     base-time $BASE \
>     sched-entry S 0xF 1000000 \
>     max-sdu 1500 1498 0 0 0 0 0 0 0 0 0 0 0 0 0 0 \
>     flags 0x2 \
>     txtime-delay 0
> 
> 2) Use network statistic to watch the tx queue packet to see if
> packet able to go out or drop.
> 
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc.h      |  1 +
>  drivers/net/ethernet/intel/igc/igc_main.c | 44 +++++++++++++++++++++++
>  2 files changed, 45 insertions(+)

<...>

> +skb_drop:
> +	dev_kfree_skb_any(skb);
> +	skb = NULL;

Why do you set skb to be NULL?

> +
>  	return NETDEV_TX_OK;
>  }
>  

Thanks
