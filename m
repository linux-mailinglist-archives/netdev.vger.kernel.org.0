Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662F2562E6D
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 10:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236686AbiGAIgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 04:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236548AbiGAIf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 04:35:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D29F72EFF
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 01:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656664544; x=1688200544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5/0TiTQBCeOznX2uGmvgRSYJCRcfQlVH1AK7l3tTnZQ=;
  b=PtK5j4Wy7+AJVFs1B7tQf2iWXWt1/ns81pwSXiEXZo4wMO+4QXZGe+3e
   P3HNvzMPCIVmjIfAWq2gZQWxYSaz4TXVQustvCi/QVk+LW7bWeD011Z5V
   4gDK7PCbb+pEZ4/tYi1qksVYXod8ZonvNYg+c6O5EirNWwdmzp4//XHhG
   ygiZlOrUi8H/80FgMayydiw9Fz6unxIi5iw6KGTim2+OKo0bmXAlAmxqy
   btx2b+JRqK/bjPzGUxWt1LkWgxBEmu/wq3dTqgSefy1RNjM7wuY2WUHBT
   eTQoLS19b2HUn9ALQ3GagT5jjQRqOj7pMA2XcGyuQzRDyCAGFNNg4paWI
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10394"; a="281354144"
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="281354144"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 01:35:25 -0700
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="681320747"
Received: from unknown (HELO s240.localdomain) ([10.237.94.19])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2022 01:35:23 -0700
From:   Piotr Skajewski <piotrx.skajewski@intel.com>
To:     kuba@kernel.org
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, konrad0.jankowski@intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        piotrx.skajewski@intel.com
Subject: Re: [PATCH net 1/1] ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero
Date:   Fri,  1 Jul 2022 10:31:28 +0200
Message-Id: <20220701083128.11707-1-piotrx.skajewski@intel.com>
X-Mailer: git-send-email 2.35.0.rc0
In-Reply-To: <20220630081134.48b9bb53@kernel.org>
References: <20220630081134.48b9bb53@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 08:11:34 -0700 Jakub Kicinski wrote:
> On Thu, 30 Jun 2022 12:08:39 +0200 Piotr Skajewski wrote:
> > On Tue, 28 Jun 2022 10:27:07 -0700 Jakub Kicinski wrote:
> > > On Tue, 28 Jun 2022 09:53:46 -0700 Tony Nguyen wrote:  
> > > > +	spin_lock_irqsave(&adapter->vfs_lock, flags);
> > > > +
> > > >  	/* set num VFs to 0 to prevent access to vfinfo */
> > > >  	adapter->num_vfs = 0;
> > > >  
> > > > @@ -228,6 +231,8 @@ int ixgbe_disable_sriov(struct ixgbe_adapter *adapter)
> > > >  	kfree(adapter->mv_list);
> > > >  	adapter->mv_list = NULL;
> > > >  
> > > > +	spin_unlock_irqrestore(&adapter->vfs_lock, flags);  
> > >
> > > There's a pci_dev_put() in there, are you sure it won't sleep?  
> > 
> > Thank Jakub for your notice, during development we were aware about this
> > and tests we've made on this particular case, did not report any problems
> > that could be related to might_sleep in conjunction with spinlock.
> 
> To be on the safe side how about we protect adapter->num_vfs instead 
> of adapter->vfinfo ?
> 
> You can hold the lock just around setting adapter->num_vfs to zero,
> and then inside ixgbe_msg_task() you don't have to add the new if()
> because the loop bound is already adapter->num_vfs.
> 
> Smaller change, and safer.

Yes sounds good, I will test it and prepare the patch.
