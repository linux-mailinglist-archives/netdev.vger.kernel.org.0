Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237E1623E69
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiKJJRR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:17:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKJJRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:17:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C7A69DEC;
        Thu, 10 Nov 2022 01:17:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DFEE60ABE;
        Thu, 10 Nov 2022 09:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0ADDC433C1;
        Thu, 10 Nov 2022 09:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668071834;
        bh=6TJNnSviLlX563oQpc85BIYcQat1cVbnGv4v0Qc+vJk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nuErvBV+JiX3N5HtvK2D1LR6w1MiTqz7BX5r2A6wKtpNtZxMsDPZj7y69xuhyTrD3
         BUuHNxOElpY18O+P3jV6r/vZL6mlUcfRAjl+enMvT2qbPtgbmZkiEtspmxeUt+1w7n
         q4uZwOiaNepckD00u0BL2SBfyOBikhzIxoi3VjYOaJgOrlyf6ktk7M8di8qVtZzIab
         OXbOV+mAGv40umA6nNEOja5M8uFKT8hIhlrr6pd8XGadKRJv0LVic4dCy1Q9h/nomD
         H/P/X+7S3skPgOh5bRAlJxAdvunajMCzS7uhQBOTp9dcUiexSdwcxlhpp/lEFb9DHM
         kM6oHKUX4Cm5Q==
Date:   Thu, 10 Nov 2022 11:17:09 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     ivecera <ivecera@redhat.com>,
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
Message-ID: <Y2zBlcpKZooaQhtL@unreal>
References: <20221108102502.2147389-1-ivecera@redhat.com>
 <Y2vvbwkvAIOdtZaA@unreal>
 <CO1PR11MB508996B0D00B5FE6187AF085D63E9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB508996B0D00B5FE6187AF085D63E9@CO1PR11MB5089.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 08:11:55PM +0000, Keller, Jacob E wrote:
> 
> 
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Wednesday, November 9, 2022 10:21 AM
> > To: ivecera <ivecera@redhat.com>
> > Cc: netdev@vger.kernel.org; sassmann@redhat.com; Keller, Jacob E
> > <jacob.e.keller@intel.com>; Piotrowski, Patryk <patryk.piotrowski@intel.com>;
> > SlawomirX Laba <slawomirx.laba@intel.com>; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> > <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Eric
> > Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
> > Abeni <pabeni@redhat.com>; moderated list:INTEL ETHERNET DRIVERS <intel-
> > wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>
> > Subject: Re: [PATCH net] iavf: Do not restart Tx queues after reset task failure
> > 
> > On Tue, Nov 08, 2022 at 11:25:02AM +0100, Ivan Vecera wrote:
> > > After commit aa626da947e9 ("iavf: Detach device during reset task")
> > > the device is detached during reset task and re-attached at its end.
> > > The problem occurs when reset task fails because Tx queues are
> > > restarted during device re-attach and this leads later to a crash.
> > 
> > <...>
> > 
> > > +	if (netif_running(netdev)) {
> > > +		/* Close device to ensure that Tx queues will not be started
> > > +		 * during netif_device_attach() at the end of the reset task.
> > > +		 */
> > > +		rtnl_lock();
> > > +		dev_close(netdev);
> > > +		rtnl_unlock();
> > > +	}
> > 
> > Sorry for my naive question, I see this pattern a lot (including RDMA),
> > so curious. Everyone checks netif_running() outside of rtnl_lock, while
> > dev_close() changes state bit __LINK_STATE_START. Shouldn't rtnl_lock()
> > placed before netif_running()?
> 
> Yes I think you're right. A ton of people check it without the lock but I think thats not strictly safe. Is dev_close safe to call when netif_running is false? Why not just remove the check and always call dev_close then.

I honestly don't know.

To remove any doubts, this patch is LGTM.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
