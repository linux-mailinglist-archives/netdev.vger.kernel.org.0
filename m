Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3F66247E7
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiKJRHL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiKJRHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:07:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2B81103;
        Thu, 10 Nov 2022 09:07:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6174DB82262;
        Thu, 10 Nov 2022 17:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FEFC433D6;
        Thu, 10 Nov 2022 17:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668100027;
        bh=rj3ISQCkCco2AbbC4p5BztsDjwUFjBW0QWdyLsCUyq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YmORyJ0NKtlSVkovWmaabP0b9SgZQ1lh3Ym059adNM78LU2bsgoG9df90eYdUQt6y
         k5/I4sdiGRMTPgbuueWayNeCIFe7KTk/TZ3peRxCj2E06LfextPj/54SM2gxmQXcMQ
         vD3KG6xUxHxX0UrhgDmrbngWgKGqifl8Y2mII+FTvFHb4O0p1rEEloGAW+GMdeGmSP
         yjzhvbl01cvkHE7xniSFg1ZkB8+Mso5xNAiMAEbufp+1hbujiFnUm9JPgQ/P8ErZnl
         HKizbNHytdfuWh8htn10atiLOK274b5fWq2H9LamSj/xx8Mflu7htI2Rz87eg5x4Pu
         0KsWK8sqe1oGQ==
Date:   Thu, 10 Nov 2022 19:07:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        SlawomirX Laba <slawomirx.laba@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] iavf: Do not restart Tx queues after reset task
 failure
Message-ID: <Y20vtqd6raqg8iwy@unreal>
References: <20221108102502.2147389-1-ivecera@redhat.com>
 <Y2vvbwkvAIOdtZaA@unreal>
 <CO1PR11MB508996B0D00B5FE6187AF085D63E9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20221110155147.1a2c57f6@p1.luc.cera.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110155147.1a2c57f6@p1.luc.cera.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 03:51:47PM +0100, Ivan Vecera wrote:
> On Wed, 9 Nov 2022 20:11:55 +0000
> "Keller, Jacob E" <jacob.e.keller@intel.com> wrote:
> 
> > > Sorry for my naive question, I see this pattern a lot (including RDMA),
> > > so curious. Everyone checks netif_running() outside of rtnl_lock, while
> > > dev_close() changes state bit __LINK_STATE_START. Shouldn't rtnl_lock()
> > > placed before netif_running()?  
> > 
> > Yes I think you're right. A ton of people check it without the lock but I think thats not strictly safe. Is dev_close safe to call when netif_running is false? Why not just remove the check and always call dev_close then.
> > 
> > Thanks,
> > Jake
> 
> Check for a bit value (like netif_runnning()) is much cheaper than unconditionally
> taking global lock like RTNL.

This cheap operation is racy and performed in non-performance critical path.

Thanks

> 
> Ivan
> 
