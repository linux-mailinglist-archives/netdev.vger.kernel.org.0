Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADC04D7C1B
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 08:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbiCNHkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 03:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiCNHkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 03:40:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E1A15A0C;
        Mon, 14 Mar 2022 00:38:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59FE3B80D09;
        Mon, 14 Mar 2022 07:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4479BC340F5;
        Mon, 14 Mar 2022 07:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647243535;
        bh=kswDHq1yjjDaHfiDPIN10j7tWCwGwvkRsCL4lzFzP4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JGaBr7QE1wFWt0IqT20RFxIpjPJgq5Zrv4BqB4Zu0n0Ao7CVpuMuvV6vuHpQZgE5g
         icqC9KxYX6eTBkOsa/PSBKIs9fTDrKrXq/1sJYKRyv6i6pd4VsXV80aSJAHGzOHSsP
         lEiQYjFzT4q5tTpiHIcfjGrKe7B2LdBF1FJGe7x4=
Date:   Mon, 14 Mar 2022 08:38:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     stephen@networkplumber.org, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] hv_netvsc: Add check for kvmalloc_array
Message-ID: <Yi7xCSdtTmSgIcgp@kroah.com>
References: <20220314073349.2501022-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314073349.2501022-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 03:33:49PM +0800, Jiasheng Jiang wrote:
> On Fri, Mar 11, 2022 at 02:43:48PM +0800, Greg KH wrote:
> >> As the potential failure of the kvmalloc_array(),
> >> it should be better to check and restore the 'data'
> >> if fails in order to avoid the dereference of the
> >> NULL pointer.
> >> 
> >> Fixes: 6ae746711263 ("hv_netvsc: Add per-cpu ethtool stats for netvsc")
> >> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> >> ---
> >>  drivers/net/hyperv/netvsc_drv.c | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >> 
> >> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> >> index 3646469433b1..018c4a5f6f44 100644
> >> --- a/drivers/net/hyperv/netvsc_drv.c
> >> +++ b/drivers/net/hyperv/netvsc_drv.c
> >> @@ -1587,6 +1587,12 @@ static void netvsc_get_ethtool_stats(struct net_device *dev,
> >>  	pcpu_sum = kvmalloc_array(num_possible_cpus(),
> >>  				  sizeof(struct netvsc_ethtool_pcpu_stats),
> >>  				  GFP_KERNEL);
> >> +	if (!pcpu_sum) {
> >> +		for (j = 0; j < i; j++)
> >> +			data[j] = 0;
> >> +		return;
> >> +	}
> > 
> >How did you test this to verify it is correct?
> 
> Thanks, I have tested the patch by kernel_patch_verify,

What is that?

> and all the tests are passed.

What tests exactly?  How did you fail this allocation?

thanks,

greg k-h
