Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7276CEED3
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjC2QJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjC2QIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:08:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB126A68;
        Wed, 29 Mar 2023 09:08:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA23DB82380;
        Wed, 29 Mar 2023 16:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B66C433EF;
        Wed, 29 Mar 2023 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680106020;
        bh=5TeBLispGIT0/O/bAlol6e+ZU9oTyEWmKB7xL8PgETU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=aqwsWfwBAdIClOqylEovHwvISOj3IS/RTZENmj+dB9X+mIrpp8kVguFJV9No6vuFz
         KFQsINCBzB+90He6/V1S1tePT0T0dI4nyYo2igXdhjufovIScTDTVNPLr87rtlDtJL
         uCBj7V0UmTIVIxPRmlWr3vboZ7uB/LWeJA9hSNRXaT6OatjuQS2zuRgh4DTlT0/IFc
         ufLOpUNPHaWufxr4pwNWVkChvOhUdsUVTdHnoDw8W/L//JMZAo1dvCVwfC8Py+5wZ5
         MUGVa+p5+5MxPW+t9olrPYAPbn59OhzT1jH95MBtO/N+iUMNO1griItw9Fs4m2HLs1
         WUH0zgc21qN4Q==
Date:   Wed, 29 Mar 2023 11:06:58 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Saurabh Singh Sengar <ssengar@microsoft.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Jake Oshins <jakeo@microsoft.com>,
        "kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>,
        KY Srinivasan <kys@microsoft.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh@kernel.org" <robh@kernel.org>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Long Li <longli@microsoft.com>,
        "boqun.feng@gmail.com" <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXTERNAL] [PATCH 1/6] PCI: hv: fix a race condition bug in
 hv_pci_query_relations()
Message-ID: <20230329160658.GA3061706@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR21MB13359123DC327D00C2EF47E7BF899@SA1PR21MB1335.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 08:37:20AM +0000, Dexuan Cui wrote:
> > From: Bjorn Helgaas <helgaas@kernel.org>
> > Sent: Tuesday, March 28, 2023 10:25 AM
> > To: Dexuan Cui <decui@microsoft.com>
> > ...
> > On Tue, Mar 28, 2023 at 05:38:59AM +0000, Dexuan Cui wrote:
> > > > From: Saurabh Singh Sengar <ssengar@microsoft.com>
> > > > Sent: Monday, March 27, 2023 10:29 PM
> > > > > ...
> > > > > ---
> > >
> > > Please note this special line "---".
> > > Anything after the special line and before the line "diff --git" is discarded
> > > automaticaly by 'git' and 'patch'.
> > >
> > > > >  drivers/pci/controller/pci-hyperv.c | 13 +++++++++++++
> > > > >  1 file changed, 13 insertions(+)
> > > > >
> > > > > @@ -3635,6 +3641,8 @@ static int hv_pci_probe(struct hv_device *hdev,
> > > > >
> > > > >  retry:
> > > > >  	ret = hv_pci_query_relations(hdev);
> > > > > +	printk("hv_pci_query_relations() exited\n");
> > > >
> > > > Can we use pr_* or the appropriate KERN_<LEVEL> in all the printk(s).
> > >
> > > This is not part of the real patch :-)
> > > I just thought the debug code can help understand the issues
> > > resolved by the patches.
> > > I'll remove the debug code to avoid confusion if I need to post v2.
> > 
> > I guess that means you *will* post a v2, right?  
> 
> I guess I didn't make myself clear, sorry. The "debug code" is not
> part of the real patch body -- if we run the "patch" program or "git am"
> to apply the patches, the "debug code" is automatically dropped because
> it's between the special "---" line and the real start of the patch body (i.e.
> the "diff --git" line). 
> 
> So far, IMO I don't have to post v2 because the patch body and the patch
> description (except for the part that's automatically removed by 'patch'
> and 'git') don't need any change.

Ah, sorry, I didn't notice that, even though you explicitly pointed it
out earlier.  No need to repost just to capitalize the subject,
Lorenzo can do it or not as he chooses.

Bjorn
