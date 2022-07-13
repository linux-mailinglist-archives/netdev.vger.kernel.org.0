Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 055B0572E0C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 08:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiGMGSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 02:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiGMGSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 02:18:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A49C74AA;
        Tue, 12 Jul 2022 23:18:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FE9CB81CD5;
        Wed, 13 Jul 2022 06:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA19C341C0;
        Wed, 13 Jul 2022 06:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657693097;
        bh=7Jr/WtyBD/OhhC0jMkdq6M0DIxheahTz4Fxksu8AhyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ee8HFUeBQm8xg9ZT0Ml9L/4K+HOT7yXpWSvbDuXU68SYvs9Eif/E/04derHnvqHQZ
         01X5ahun5u9zpJdemIAWsKYF8cHNK2dumiUpvj9uD8sKQWuNi8jdYuvqkHGb+o6uLQ
         l7euJ+gS115DaYffFeJEQ826Tym7Wv1aGFNGbb70=
Date:   Wed, 13 Jul 2022 08:14:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Long Li <longli@microsoft.com>
Cc:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
 Network Adapter
Message-ID: <Ys5i4uvz7GP+dVne@kroah.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-13-git-send-email-longli@linuxonhyperv.com>
 <Ys3IM6S3nbT0NFs0@kroah.com>
 <PH7PR21MB32632A5DCB5EF60A4D599FC2CE869@PH7PR21MB3263.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR21MB32632A5DCB5EF60A4D599FC2CE869@PH7PR21MB3263.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 11:46:36PM +0000, Long Li wrote:
> > Subject: Re: [Patch v4 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure
> > Network Adapter
> > 
> > On Wed, Jun 15, 2022 at 07:07:20PM -0700, longli@linuxonhyperv.com wrote:
> > > --- /dev/null
> > > +++ b/drivers/infiniband/hw/mana/cq.c
> > > @@ -0,0 +1,80 @@
> > > +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> > 
> > Why perpetuate this mess that the OpenIB people created?  I thought that no
> > new drivers were going to be added with this, why does this one need to have it
> > as well if it is new?
> 
> I apologize for the incorrect license language. I followed other RDMA driver's license terms but didn't' realized their licensing language is not up to the standard.

You need to follow the license rules of your employer, please consult
with them as they know what to do here.

> The newly introduced EFA RDMA driver used the following license terms:
> (drivers/infiniband/hw/efa/efa_main.c)
> // SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
> 
> Is it acceptable that we use the same license terms?

Again, discuss this with the lawyers at your company.  But if you are
going to use a dual-license, you must be prepared to defend why you are
doing so.

thanks,

greg k-h
