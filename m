Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BCB56175D
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234820AbiF3KMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiF3KMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:12:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A520A44A0C
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656583956; x=1688119956;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1uyrMKDMXPjUfTBkhIn5ehdJv35+kJF3t4cLCOEei6c=;
  b=CFFSzy71iW1B/f2VXdZVpPsNxtP3YP0Itn2KFPvK/zVxyjEbJ9mLNgxz
   UHwnA13oaCaCh791GEkbmrGQ3SNOWi/nPN6zVqpR78pGmgeFBHClh7+Kh
   I5bHDYYoozWeBdCNCCEgvKwNoAxzBMPmlc33U7j395QKBK6H0nOhHT2uJ
   6D7CxkaqMegxE9frl5MzMs591b/N5yyUfv0inToaP8d65jCBJ7UWaDoxk
   GlTpCV9gupPmcEhvEWsw/rDxvFw2Ibz8CWr6CI2+yIHwaIk8USM38ktSw
   qDyRn0qG3PpJsxCVU/I8YUlcU6wGB0aKXZemMeE/OTboKcE+In0W9IbXV
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10393"; a="271075985"
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="271075985"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 03:12:36 -0700
X-IronPort-AV: E=Sophos;i="5.92,233,1650956400"; 
   d="scan'208";a="917991704"
Received: from unknown (HELO s240.localdomain) ([10.237.94.19])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2022 03:12:34 -0700
From:   Piotr Skajewski <piotrx.skajewski@intel.com>
To:     kuba@kernel.org
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, konrad0.jankowski@intel.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        piotrx.skajewski@intel.com
Subject: Re: [PATCH net 1/1] ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero
Date:   Thu, 30 Jun 2022 12:08:39 +0200
Message-Id: <20220630100839.14079-1-piotrx.skajewski@intel.com>
X-Mailer: git-send-email 2.35.0.rc0
In-Reply-To: <20220628102707.436e7253@kernel.org>
References: <20220628102707.436e7253@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 10:27:07 -0700 Jakub Kicinski wrote:
> On Tue, 28 Jun 2022 09:53:46 -0700 Tony Nguyen wrote:
> > +	spin_lock_irqsave(&adapter->vfs_lock, flags);
> > +
> >  	/* set num VFs to 0 to prevent access to vfinfo */
> >  	adapter->num_vfs = 0;
> >  
> > @@ -228,6 +231,8 @@ int ixgbe_disable_sriov(struct ixgbe_adapter *adapter)
> >  	kfree(adapter->mv_list);
> >  	adapter->mv_list = NULL;
> >  
> > +	spin_unlock_irqrestore(&adapter->vfs_lock, flags);
>
> There's a pci_dev_put() in there, are you sure it won't sleep?

Thank Jakub for your notice, during development we were aware about this
and tests we've made on this particular case, did not report any problems
that could be related to might_sleep in conjunction with spinlock.
