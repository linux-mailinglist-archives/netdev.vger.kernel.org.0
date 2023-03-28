Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77CD66CC935
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 19:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjC1RYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 13:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjC1RYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 13:24:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E329B2D5B;
        Tue, 28 Mar 2023 10:24:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87299B81D72;
        Tue, 28 Mar 2023 17:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E803EC4339B;
        Tue, 28 Mar 2023 17:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680024287;
        bh=O8m+p0zD+XNFiA03Z+/yCzyznUzLzCLRpXdQTJ8dP+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=RldpunhtC07J9KzcN6AhpUCmYq+S2XB4JSuwhsGPYTfVDvDz0rkamEDIHzb53qlzY
         UH0NCPk2pyMqQ7XhPU4+B6QRoHbW6qopkRssgz7ZXzG87ReBJtU2RPqyNeLwxJdRgB
         AwvgMNJ91k3jHME+1zm+fxvIEyVp7a8YgMckCKuFvk+U/0KElQytwPOdNMnMU/2m9N
         5Y0R6mjaZaipytIgrDIOlCuZGbmRAyjJh5Bhj4YoR/Ika5lg4OG5WLjyE5auzsbOud
         Ji65Cp3/2Dh6FTnUBinyRs/35CvO8iUXoC0swemghz7ySQWSCq5p/pvu1qJuC2Bgdc
         YM5GHRU5QMy7w==
Date:   Tue, 28 Mar 2023 12:24:45 -0500
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
Message-ID: <20230328172445.GA2951931@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR21MB133553326FBAD376DE9DB48ABF889@SA1PR21MB1335.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 05:38:59AM +0000, Dexuan Cui wrote:
> > From: Saurabh Singh Sengar <ssengar@microsoft.com>
> > Sent: Monday, March 27, 2023 10:29 PM
> > > ...
> > > ---
> 
> Please note this special line "---". 
> Anything after the special line and before the line "diff --git" is discarded
> automaticaly by 'git' and 'patch'. 
> 
> > >  drivers/pci/controller/pci-hyperv.c | 13 +++++++++++++
> > >  1 file changed, 13 insertions(+)
> > >
> > > @@ -3635,6 +3641,8 @@ static int hv_pci_probe(struct hv_device *hdev,
> > >
> > >  retry:
> > >  	ret = hv_pci_query_relations(hdev);
> > > +	printk("hv_pci_query_relations() exited\n");
> > 
> > Can we use pr_* or the appropriate KERN_<LEVEL> in all the printk(s).
> 
> This is not part of the real patch :-)
> I just thought the debug code can help understand the issues
> resolved by the patches.
> I'll remove the debug code to avoid confusion if I need to post v2.

I guess that means you *will* post a v2, right?  Or do you expect
somebody else to remove the debug code?  If you do keep any debug or
other logging, use pci_info() (or dev_info()) whenever possible.

Also capitalize the subject line to match the others in the series.

Bjorn
