Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A13860E9E6
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 22:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbiJZUIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 16:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbiJZUHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 16:07:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AAA137287
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0363362092
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D718EC433D6;
        Wed, 26 Oct 2022 20:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666814863;
        bh=2i9Ki80Rh7tPc9WIwVUnVsAcjE3qZsSkoXZGDfEps34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nAPfzRCD2hzfUQu3D7ZVcEIyqRlCjuXoSlberpSJiazemvClMx+rnCbukyvJm9WRY
         oWTUdKNL0tqmOeMl5Niq5r4CTPFT7SEC6m74Cm4fRZq4MafC1vtcnFWPr5Vho2pTLN
         jtINLZ3zLjRW6teP3TT4hXXHxCETOtZVOdjVkSk/Ntd30l3LK3RPv+HV3G72snLADK
         hAampRVqJSRVe5hCdbUkVvgGX7GdiUn00qH7TFAcj67qJpNUrF23H3T+cfZ+DRF04G
         MadPeusB2WFdKPgQPYjDAUuhVAMSnOXGLk9mDMfw2MzAWLyPfCAfXbnTcQ8dRv4XCF
         OXFM+/Dp4mDwA==
Date:   Wed, 26 Oct 2022 13:07:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Yinjun Zhang <yinjun.zhang@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Nole Zhang <peng.zhang@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next 0/3] nfp: support VF multi-queues configuration
Message-ID: <20221026130741.1b8f118c@kernel.org>
In-Reply-To: <20221026142221.7vp4pkk6qgbwcrjk@sx1>
References: <20221019140943.18851-1-simon.horman@corigine.com>
        <20221019180106.6c783d65@kernel.org>
        <20221020013524.GA27547@nj-rack01-04.nji.corigine.com>
        <20221025075141.v5rlybjvj3hgtdco@sx1>
        <DM6PR13MB370566F6E88DB8A258B93F29FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20221025110514.urynvqlh7kasmwap@sx1>
        <DM6PR13MB3705B01B27C679D20E0224F4FC319@DM6PR13MB3705.namprd13.prod.outlook.com>
        <20221026142221.7vp4pkk6qgbwcrjk@sx1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Oct 2022 15:22:21 +0100 Saeed Mahameed wrote:
> >Sorry, I thought you meant each VF creates a devlink obj. So still one devlink obj
> >and each VF registers a devlink port, right? But the configuration is supposed to
> >be done before VFs are created, it maybe not appropriate to register ports before
> >relevant VFs are created I think.
> 
> Usually you create the VFs unbound, configure them and then bind them.
> otherwise a query will have to query any possible VF which for some vendors
> can be thousands ! it's better to work on created but not yet deployed vfs

And the vendors who need to configure before spawning will do what,
exactly? Let's be practical.

> >> can you provide an example of how you imagine the reosurce vf-max-queue
> >> api
> >> will look like ?  
> >
> >Two options,
> >one is from VF's perspective, you need configure one by one, very straightforward:
> >```
> >pci/xxxx:xx:xx.x:
> >  name max_q size 128 unit entry
> >    resources:
> >      name VF0 size 1 unit entry size_min 1 size_max 128 size_gran 1
> >      name VF1 size 1 unit entry size_min 1 size_max 128 size_gran 1
> >      ...  
> 
> the above semantics are really weird, 
> VF0 can't be a sub-resource of max_q ! 
> 
> sorry i can't think of a way where devlink resoruce semantics can work for
> VF resource allocation.

It's just an API section. New forms of configuration can be added.
In fact they should so we can stop having this conversation.

> Unless a VF becomes a resource and it's q_table becomes a sub resource of that
> VF, which means you will have to register each vf as a resource individually.
> 
> Note that i called the resource "q_table" and not "max_queues",
> since semantically max_queues is a parameter where q_table can be looked at
> as a sub-resource of the VF, the q_table size decides the max_queues a VF
> will accept, so there you go ! 

Somewhere along the way you missed the other requirements to also allow
configuring guaranteed count that came from brcm as some point.

> arghh weird.. just make it an attribute for devlink port function and name it
> max_q as god intended it to be ;)

Let's not equate what fits the odd world of Melvidia FW with god.

> Fix your FW to allow changing VF maxqueue for unbound VFs if needed.

Not every device out there is all FW. Thankfully.
