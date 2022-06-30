Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3AE561EDB
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiF3PLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235605AbiF3PLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3FF72B193
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 08:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95D72B82B67
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 15:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A02C341CB;
        Thu, 30 Jun 2022 15:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656601896;
        bh=gwSQUBJy49XL7IzizxFxO/XDQE+QeEd2VPi7eD2twKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q/u2DyRGCkbOuNJZixI03Fa1ZrR5XPAq6Frmsud2EYnDwXCeLhYk8NI1+6I1ni59B
         uPTsvRMRWL77fhfXkjpuJGkGsSa+5a+lea8oL7UbTHuzTX1dLrgMf3Em/DSd791RlP
         1eKw3zxbZ6DrMv2PH83vNAo4yNs1OBfLlBoeByRDkWekh1HRXg0q/OxUhUkX7PNBMI
         2HdWmFgwyU+3TGpLSDKjUNuIf/kKX757vxHhmqMfA/a3c3FEhuYzgqFngrZNhEj0Al
         pzXmP3SUBkBr4qAAa2qZ73gKWjf1klOD7EBD5o89ZxN+rizr/8kRZNwPRC9YGAUPTR
         Wa+ViEDXInYgw==
Date:   Thu, 30 Jun 2022 08:11:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Piotr Skajewski <piotrx.skajewski@intel.com>
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, konrad0.jankowski@intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net 1/1] ixgbe: Add locking to prevent panic when
 setting sriov_numvfs to zero
Message-ID: <20220630081134.48b9bb53@kernel.org>
In-Reply-To: <20220630100839.14079-1-piotrx.skajewski@intel.com>
References: <20220628102707.436e7253@kernel.org>
        <20220630100839.14079-1-piotrx.skajewski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 12:08:39 +0200 Piotr Skajewski wrote:
> On Tue, 28 Jun 2022 10:27:07 -0700 Jakub Kicinski wrote:
> > On Tue, 28 Jun 2022 09:53:46 -0700 Tony Nguyen wrote:  
> > > +	spin_lock_irqsave(&adapter->vfs_lock, flags);
> > > +
> > >  	/* set num VFs to 0 to prevent access to vfinfo */
> > >  	adapter->num_vfs = 0;
> > >  
> > > @@ -228,6 +231,8 @@ int ixgbe_disable_sriov(struct ixgbe_adapter *adapter)
> > >  	kfree(adapter->mv_list);
> > >  	adapter->mv_list = NULL;
> > >  
> > > +	spin_unlock_irqrestore(&adapter->vfs_lock, flags);  
> >
> > There's a pci_dev_put() in there, are you sure it won't sleep?  
> 
> Thank Jakub for your notice, during development we were aware about this
> and tests we've made on this particular case, did not report any problems
> that could be related to might_sleep in conjunction with spinlock.

To be on the safe side how about we protect adapter->num_vfs instead 
of adapter->vfinfo ?

You can hold the lock just around setting adapter->num_vfs to zero,
and then inside ixgbe_msg_task() you don't have to add the new if()
because the loop bound is already adapter->num_vfs.

Smaller change, and safer.
