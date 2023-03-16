Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6776BDAE8
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 22:27:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjCPV1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 17:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjCPV1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 17:27:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14645E2774;
        Thu, 16 Mar 2023 14:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BBD43B82348;
        Thu, 16 Mar 2023 21:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4C2C433D2;
        Thu, 16 Mar 2023 21:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679002031;
        bh=i4fHe3l07y4FDdBZ3+d3ViHDddpbHDTXNyxkUVDQmGY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a6tEIVgdtE2s3TxV46LETnhDW4HnC/vzUK6eDFjlcTrQ9vT4IcbUpMKlOF2I3GreR
         lqPIdRIb0JZd0XQ0I366Rt8K8V1JayheKbuC9DbstzmCCXWs4EWdQ6t3EVis8LYJCy
         1yGg9CRgGE1qcBrXEuPJQFfukTlwLAo0Jqs5lWqJ2a5MksawEBOf8bR1wt07PMFktH
         ITvecunbj3w+tJD4O4yXj96Gp6O1rsOj4ygGTVo5EWIy4nGPOWigyVAxAPfcGwkk3q
         tm4rlAN9SPps28M+vRbLMfmb8WcYLkKifdKIsgeP7bp277Hktt4n8hBxWWw9d5MY7h
         dzywfOiL6IkEA==
Date:   Thu, 16 Mar 2023 14:27:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        oss-drivers@corigine.com
Subject: Re: [PATCH net 1/1] nfp: correct number of MSI vectors requests
 returned
Message-ID: <20230316142710.3b79ed06@kernel.org>
In-Reply-To: <20230316110943.GV36557@unreal>
References: <20230315121733.27783-1-louis.peens@corigine.com>
        <20230316110943.GV36557@unreal>
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

On Thu, 16 Mar 2023 13:09:43 +0200 Leon Romanovsky wrote:
> On Wed, Mar 15, 2023 at 02:17:33PM +0200, Louis Peens wrote:
> > From: Xiaoyu Li <xiaoyu.li@corigine.com>
> > 
> > Before the referenced commit, when we requested a
> > certain number of interrupts, if we could not meet
> > the requirements, the number of interrupts supported
> > by the hardware would be returned. But after the
> > referenced commit, if the hardware failed to meet
> > the requirements, the error of invalid argument
> > would be directly returned, which caused a regression
> > in the nfp driver preventing probing to complete.  
> 
> Please don't break lines. You have upto 80 chars per-line.

72 I think, git adds an indentation. Not that I personally care
about "not using full lines".

> > diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > index 62f0bf91d1e1..0e4cab38f075 100644
> > --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> > @@ -370,6 +370,12 @@ nfp_net_irqs_alloc(struct pci_dev *pdev, struct msix_entry *irq_entries,
> >  {
> >  	unsigned int i;
> >  	int got_irqs;
> > +	int max_irqs;
> > +
> > +	max_irqs = pci_msix_vec_count(pdev);
> > +	if (max_irqs < 0)
> > +		return max_irqs;
> > +	wanted_irqs = min_t(unsigned int, max_irqs, wanted_irqs);  
> 
> 1. It looks like you need to fix your nfp_net_irqs_alloc() to provide
> valid wanted_irqs from the beginning.

Right, why do you have this problem in the first place?
Could you provide some concrete numbers?
