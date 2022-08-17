Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F7A597587
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbiHQSK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiHQSK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:10:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC539676F
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 11:10:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A59AB81EB3
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 18:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2217FC433C1;
        Wed, 17 Aug 2022 18:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660759853;
        bh=SLEXdS2YvspUhQFPiH+leFY/JNnJU7lN+0Ak7OTb2Ms=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uOXUihOr7W7LJpe62pwGtkXGfJ7WgX9PJwIjdNN28pbBw85nrtXMB9L2ZVNuLbUML
         JkhMvQbYb9jwgf1K0Vj3OirfjdnAY0eQ5BMQ/Xb5bLkERQ/Zx7nPdlfvYTgVDSXSWm
         6om3dllapPfUTYQjz+fTnEbKKLEK9vFhGuZVobG6w3CLINCDFE8i0PNiFIJMI8hLu+
         Sq4WRkAMrxCvq6XwF3sAiD66iOo4Eia0ev6t+ulrhJESmFG6nJ2AjRXWMMAviISpzt
         Sl31MceXRtVUNvUhWYcPPm17Lch/qOTO1DSY9TDmwB1ZlBFSP4rJxBUVjnThlO8UII
         7NG/Xkk++h8oQ==
Date:   Wed, 17 Aug 2022 11:10:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220817111052.0ddf40b0@kernel.org>
In-Reply-To: <Yvx6+qLPWWfCmDVG@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
        <20220816195408.56eec0ed@kernel.org>
        <Yvx6+qLPWWfCmDVG@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Aug 2022 08:22:02 +0300 Leon Romanovsky wrote:
> On Tue, Aug 16, 2022 at 07:54:08PM -0700, Jakub Kicinski wrote:
> > This is making a precedent for full tunnel offload in netdev, right?  
> 
> Not really. SW IPsec supports two modes: tunnel and transport.
> 
> However HW and SW stack supports only offload of transport mode.
> This is the case for already merged IPsec crypto offload mode and
> the case for this full offload.

My point is on what you called "full offload" vs "crypto offload".
The policy so far has always been that Linux networking stack should
populate all the headers and instruct the device to do crypto, no
header insertion. Obviously we do header insertion in switch/router
offloads but that's different and stateless.

I believe the reasoning was to provide as much flexibility and control
to the software as possible while retaining most of the performance
gains.

You must provide a clear analysis (as in examination in data) and
discussion (as in examination in writing) if you're intending to 
change the "let's keep packet formation in the SW" policy. What you 
got below is a good start but not sufficient.

> > Could you indulge us with a more detailed description, motivation,
> > performance results, where the behavior of offload may differ (if at
> > all), what visibility users have, how SW and HW work together on the
> > datapath? Documentation would be great.  
> 
> IPsec full offload is actually improved version of IPsec crypto mode,
> In full mode, HW is responsible to trim/add headers in addition to
> decrypt/encrypt. In this mode, the packet arrives to the stack as already
> decrypted and vice versa for TX (exits to HW as not-encrypted).
> 
> My main motivation is to perform IPsec on RoCE traffic and in our
> preliminary results, we are able to do IPsec full offload in line
> rate. The same goes for ETH traffic.

If the motivation is RoCE I personally see no reason to provide the
configuration of this functionality via netdev interfaces, but I'll
obviously leave the final decision to Steffen.

> Regarding behavior differences - they are not expected.
> 
> We (Raed and me) tried very hard to make sure that IPsec full offload
> will behave exactly as SW path.
> 
> There are some limitations to reduce complexity, but they can be removed
> later if needs will arise. Right now, none of them are "real" limitations
> for various *swarn forks, which we extend as well.
> 
> Some of them:
> 1. Request to have reqid for policy and state. I use reqid for HW
> matching between policy and state.

reqid?

> 2. Automatic separation between HW and SW priorities, because HW sees
> packet first.

More detail needed on that.

> 3. Only main template is supported.
> 4. No fallback to SW if IPsec HW failed to handle packet. HW should drop
> such packet.

Not great for debug.

> Visibility:
> Users can see the mode through iproute2
> https://lore.kernel.org/netdev/cover.1652179360.git.leonro@nvidia.com/
> and see statistics through ethtool.

Custom vendor stats?

> Documentation will come as well. I assume that IPsec folks are familiar
> with this topic as it was discussed in IPsec coffee hour. 
