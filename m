Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD17E6A224F
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 20:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjBXTWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 14:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjBXTWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 14:22:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD816DD9D
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:22:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D9D27CE2462
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 19:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DFAC433D2;
        Fri, 24 Feb 2023 19:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677266528;
        bh=tNgto6vLaoVuHczKAGpGdCdwK9Ymm2rcmtFHNFYWQrI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fp4nYKQ35/CrccfWt10ZmWuxXoUBgA07tFLMsU3pUs6nJNQRkKiwnmXeGUMYDVoCy
         BoTQA2uaiD7Ofmh+RU868O5j5XKZsB8PfEHLFNn5GHVOV0UbZp6ekYRKo1A7lxd1Id
         MyAxtQpfl9ZN5obqEj8BFQ5qq4VApKZHAdHWseyc+Z1Nj0jNhCW6S6T10qsh5v8uWU
         4BPpMNPmVmDFC+U9on4zRtUejbZwnKfvcmlg7Xohn7Zsax5TEgsY3Dfg47XjJ5djSN
         N+Z172/f6eLQRuHQ852t2zkSm/6n4IU53S22tnqrb1k6W+zf+7XgxqVh94J1cG3vN7
         qCNh00RNhmsgQ==
Date:   Fri, 24 Feb 2023 11:22:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nambiar, Amritha" <amritha.nambiar@intel.com>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        "Saeed Mahameed" <saeed@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: Kernel interface to configure queue-group parameters
Message-ID: <20230224112207.055165bd@kernel.org>
In-Reply-To: <34993e14-2c33-8eaf-67a9-e3412778e6f0@intel.com>
References: <e4deec35-d028-c185-bf39-6ba674f3a42e@intel.com>
        <c8476530638a5f4381d64db0e024ed49c2db3b02.camel@gmail.com>
        <893f1f98-7f64-4f66-3f08-75865a6916c3@intel.com>
        <20230216093222.18f9cefe@kernel.org>
        <34993e14-2c33-8eaf-67a9-e3412778e6f0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 01:14:15 -0800 Nambiar, Amritha wrote:
> On 2/16/2023 9:32 AM, Jakub Kicinski wrote:
> > On Thu, 16 Feb 2023 02:35:35 -0800 Nambiar, Amritha wrote:  
> >> Right. Something like /sys/class/net/<iface>/napis/napi<0-N>
> >> Maybe, initially there would be as many napis as queues due to 1:1
> >> association, but as the queues bitmap is tuned for the napi, only those
> >> napis that have queue[s] associated with it would be exposed.  
> > 
> > Forget about using sysfs, please. We've been talking about making
> > "queues first class citizen", mapping to pollers is part of that
> > problem space. And it's complex enough to be better suited for netlink.  
> 
> Okay. Can ethtool netlink be an option for this? For example,
> 
> ethtool --show-napis
> 	Lists all the napi instances and associated queue[s] list for each napi 
> for the specified network device.
> 
> ethtool --set-napi
> 	Configure the attributes (say, queue[s] list) for each napi
> 	
> 	napi <napi_id>
> 		The napi instance to configure
> 	
> 	queues <q_id1, q_id2, ...>
> 		The queue[s] that are to be serviced by the napi instance.

The netdev-genl family is a better target.

But the work is doing the refactoring within the kernel to abstract
all this stuff away from the drivers, so that the kernel has 
a stronger model of queues. If we just expose the calls to the drivers
directly we'll end up with a lot of code duplication and not-so-subtle
differences between vendors :(
