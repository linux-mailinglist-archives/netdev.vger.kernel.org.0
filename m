Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E195992CE
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 03:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244514AbiHSByQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 21:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiHSByP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 21:54:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9721D21E2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 18:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C62D6141D
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 01:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D24BC433D7;
        Fri, 19 Aug 2022 01:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660874053;
        bh=lNT/cK6JCtRVnD62+yUzQPG13QiZJhANa3a3Q/UTEkM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t0K6N/ifPkW+GpChZgxCShhXHMhk2mqMEb5zHcZosIgdNGeS+HFmgBIL5Mj8BkaxJ
         C77/AVXU584wjGR55VY2YuSD9oDisZMfI7/YLwcXQT1jfBeA3ifuLTbeo7Je77PTl4
         CMFivvW9sfGFI9fPsGTzw0sWjdKCMvUsUrFsJA5HrTHOWST30qz1ALnHNMSE+Jj6/j
         H/P0sn0InNh0t5XQNR38jh48PPQx1QITkhD2Bz3GOhvzqpj95+bPt4hWdex2aDDalA
         f62cMVzLNBK8peyoC0c2f32oxumv+rTHJNpDvshxXX8y6ON9KVItvi+gEL00KK0pPa
         uwN/vOzKbELyw==
Date:   Thu, 18 Aug 2022 18:54:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH xfrm-next v2 0/6] Extend XFRM core to allow full offload
 configuration
Message-ID: <20220818185412.6f294cef@kernel.org>
In-Reply-To: <20220818101031.GC566407@gauss3.secunet.de>
References: <cover.1660639789.git.leonro@nvidia.com>
        <20220816195408.56eec0ed@kernel.org>
        <Yvx6+qLPWWfCmDVG@unreal>
        <20220817111052.0ddf40b0@kernel.org>
        <Yv3M/T5K/f35R5UM@unreal>
        <20220818101031.GC566407@gauss3.secunet.de>
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

On Thu, 18 Aug 2022 12:10:31 +0200 Steffen Klassert wrote:
> > > You must provide a clear analysis (as in examination in data) and
> > > discussion (as in examination in writing) if you're intending to 
> > > change the "let's keep packet formation in the SW" policy. What you 
> > > got below is a good start but not sufficient.  
> 
> I'm still a bit unease about this approach. I fear that doing parts
> of statefull IPsec procesing in software and parts in hardware will
> lead to all sort of problems. E.g. with this implementation
> the software has no stats, liftetime, lifebyte and packet count
> information but is responsible to do the IKE communication.
> 
> We might be able to sort out all problems during the upstraming
> process, but I still have no clear picture how this should work
> in the end with all corener cases this creates.

Makes sense. I'm not sure any of the "deep and stateful offloads"
we have can be considered a success so IMHO we can be selective
in the approaches we accept.

> Also the name full offload is a bit missleading, because the
> software still has to hold all offloaded states and policies.
> In a full offload, the stack would IMO just act as a stub
> layer between IKE and hardware.
