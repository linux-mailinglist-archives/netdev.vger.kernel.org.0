Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4AC5ED126
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 01:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiI0Xnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 19:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiI0Xnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 19:43:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD9D1D6D14
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 16:43:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF1D61A2D
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 23:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2A9C433C1;
        Tue, 27 Sep 2022 23:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664322230;
        bh=k1Je+6d7o2AcyvzuWjOyxK9d+1woqt9OpAwSoKnIQU0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C6TPIhUdjEdCC+vhnLB+ejJ2ym8c7X9cusUdzdtBLYMtfMAUXn7dKY0/cNmPImL34
         C3t4RLLecoEuGYMRN2zlVKZTu7cbHsDpcfP1smC1B8kCqVJ4yVf7bVcVJ7sGcqFM8G
         flOadv87YdFvaAQqBOXq34SkeyEK7t6RmD/vE10iJcQAdICEgVleCDB3g9pr4fGFEd
         XfMNvWAutr6ixLF90yTgGiwt9nCtfE+AclixSdCGSW7pZeMfQk9QLimXTevktEcxNn
         8pfSdDYMrRKi79XlfD2CnlZRD+87GLJx7ZntlfH4ch8BggjkqsEXA8Y2yjrx3GLgnF
         NTYMZn6j+mQVw==
Date:   Tue, 27 Sep 2022 16:43:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        ricklind@us.ibm.com, mmc@linux.ibm.com
Subject: Re: [PATCH net-next 3/3] ibmveth: Ethtool set queue support
Message-ID: <20220927164349.0a5316bd@kernel.org>
In-Reply-To: <7e18bf4d-b922-f6f5-b7fb-08d8cc9d58aa@linux.ibm.com>
References: <20220921215056.113516-1-nnac123@linux.ibm.com>
        <20220921215056.113516-3-nnac123@linux.ibm.com>
        <20220926114448.10434fba@kernel.org>
        <7e18bf4d-b922-f6f5-b7fb-08d8cc9d58aa@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Sep 2022 14:42:39 -0500 Nick Child wrote:
> >> +static int ibmveth_set_channels(struct net_device *netdev,
> >> +				struct ethtool_channels *channels)  
> 
> >> +	/* We have IBMVETH_MAX_QUEUES netdev_queue's allocated
> >> +	 * but we may need to alloc/free the ltb's.
> >> +	 */
> >> +	netif_tx_stop_all_queues(netdev);  
> > 
> > What if the device is not UP?  
> 
>  From my understanding this will just set the __QUEUE_STATE_DRV_XOFF bit
> of all of the queues. I don't think this will cause any issues if the
> device is DOWN. Please let me know if you are worried about anything
> in particular here.

My concern was that the memory is allocated on open and freed on close.
So we shouldn't be doing any extra work if the device is closed, just
record the desired number of queues and return success.

> Just as a side note, ibmveth never sets carrier state to UP since it
> cannot determine the link status of the physical device being
> virtualized. The state is instead left as UNKNOWN when not DOWN.

Sorry for lack of clarity - UP as in IFF_UP, not IFF_LOWER_UP.
