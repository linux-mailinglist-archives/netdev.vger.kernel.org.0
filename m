Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684DF583629
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbiG1BKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236234AbiG1BKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:10:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96C91CB00
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 18:10:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42464617CB
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545CCC433D7;
        Thu, 28 Jul 2022 01:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658970640;
        bh=jcgQwR/aOGMy4fVLfmNDDICwZU+b62DeNKL9oXuAv5M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B9/i7uFcROtvuNK2wCRuAkBvthPS7fYpIcVHg23MMIsmqcPJEYE64amlNnVUabObE
         1u/iZUo0hw/+hwr+jdrnpydtOUz+Ya2mXUiRVDSqgn8in2rP8r8ylNJhqKbou/S21v
         XozGEXOUc8DqnUxn4Z83BuoNjqDsBb1UNVVv+M+5fy+/Ul0LrbueFWjAze5B/HTCaK
         06HOtZdeAWWtM0Cr6sauvlLbrvM6iE66Q/yZU+cxUbAkJsH81fiK9eB5KMKSbOfyGA
         2sIv9A/oS/ewl8tSNj/rZ9j5+6DI1r3/z6rKk6hmb32KF+jgdj3E2jEPiEYm+hZx6/
         j8IJ+ZAc1aMPw==
Date:   Wed, 27 Jul 2022 18:10:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Zhang, Xuejun" <xuejun.zhang@intel.com>,
        "Sreenivas, Bharathi" <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net 3/3] iavf: enable tc filter configuration only if
 hw-tc-offload is on
Message-ID: <20220727181039.19c7622a@kernel.org>
In-Reply-To: <IA1PR11MB6266229ADD3AF60477F4FE04E4979@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20220725170452.920964-1-anthony.l.nguyen@intel.com>
        <20220725170452.920964-4-anthony.l.nguyen@intel.com>
        <20220725194547.0702bd73@kernel.org>
        <IA1PR11MB6266229ADD3AF60477F4FE04E4979@IA1PR11MB6266.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 23:37:27 +0000 Mogilappagari, Sudheer wrote:
> > > +	if (!(adapter->netdev->features & NETIF_F_HW_TC)) {
> > > +		dev_err(&adapter->pdev->dev,
> > > +			"Can't apply TC flower filters, turn ON hw-tc-offload and try again");  
> > > +		return -EOPNOTSUPP;
> > > +	}
> > > +
> > >  	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
> > >  	if (!filter)
> > >  		return -ENOMEM;  
> > 
> > tc_can_offload() checks this in the core already, no?  
> 
> Hi Jakub,
> Seems like there is no check in core code in this path. Tested again
> to confirm that no error is thrown by core code. Below is the call
> trace while adding filter.
> [  927.358001]  dump_stack_lvl+0x44/0x58
> [  927.358009]  ice_add_cls_flower+0x73/0x90 [ice]
> [  927.358066]  tc_setup_cb_add+0xc7/0x1e0
> [  927.358074]  fl_hw_replace_filter+0x143/0x1e0 [cls_flower]
> [  927.358081]  fl_change+0xbc3/0xed8 [cls_flower]
> [  927.358086]  tc_new_tfilter+0x382/0xbc0

Oh, you're right, we moved to drivers doing the check it seems.

But you already have a check in iavf_setup_tc_block_cb()
- tc_cls_can_offload_and_chain0() should validate the device has
TC offload enabled. It that not working somehow?
