Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793154AC42A
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245576AbiBGPoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384430AbiBGPcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 10:32:17 -0500
X-Greylist: delayed 587 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 07:32:15 PST
Received: from mail.baikalelectronics.ru (mail.baikalelectronics.com [87.245.175.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2614FC0401C1
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 07:32:15 -0800 (PST)
Received: from mail.baikalelectronics.ru (unknown [192.168.51.25])
        by mail.baikalelectronics.ru (Postfix) with ESMTP id 2A4898030799;
        Mon,  7 Feb 2022 18:22:23 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.baikalelectronics.ru 2A4898030799
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baikalelectronics.ru; s=mail; t=1644247345;
        bh=7FIBgT9RabrUkGZeZ4dNqh2XzQCAmooVRhDkWjfxPm8=;
        h=Date:From:To:CC:Subject:References:In-Reply-To:From;
        b=p+Jr4wwfpYlsCvPt6o4rj/lfnxogOTYCpsxei5w2VQSPZ8rZES0ZvPu7UgBasd7rM
         9kDjpBIr3sYy2emlvZw43Y8w2dZicU3Ho0GmGJ2GLtyGhh1Qa6Zi9joc+ZAnEdAL7s
         3AMRPhuoVAhZNj0rad9mTN0e8LS1deBhgtmRMBzc=
Received: from mobilestation (192.168.152.164) by mail (192.168.51.25) with
 Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 7 Feb 2022 18:22:04 +0300
Date:   Mon, 7 Feb 2022 18:22:13 +0300
From:   Serge Semin <Sergey.Semin@baikalelectronics.ru>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Serge Semin <fancer.lancer@gmail.com>,
        Alexey Sheplyakov <asheplyakov@basealt.ru>,
        <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Evgeny Sinelnikov <sin@basealt.ru>
Subject: Re: [PATCH 1/2] net: stmmac: added Baikal-T1/M SoCs glue layer
Message-ID: <20220207152213.folasobthqadj6f2@mobilestation>
References: <20220126084456.1122873-1-asheplyakov@basealt.ru>
 <20220128150642.qidckst5mzkpuyr3@mobilestation>
 <YfQ8De5OMLDLKF6g@asheplyakov-rocket>
 <20220128122718.686912e9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220201155439.hv42mqed2n7wekuo@mobilestation>
 <20220201110838.7d626862@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220201110838.7d626862@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: MAIL.baikal.int (192.168.51.25) To mail (192.168.51.25)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 11:08:38AM -0800, Jakub Kicinski wrote:
> On Tue, 1 Feb 2022 18:54:39 +0300 Serge Semin wrote:
> > On Fri, Jan 28, 2022 at 12:27:18PM -0800, Jakub Kicinski wrote:
> > > On Fri, 28 Jan 2022 22:55:09 +0400 Alexey Sheplyakov wrote:  
> > > > In general quite a number of Linux drivers (GPUs, WiFi chips, foreign
> > > > filesystems, you name it) provide a limited support for the corresponding
> > > > hardware (filesystem, protocol, etc) and don't cover all peculiarities.
> > > > Yet having such a limited support in the mainline kernel is much more
> > > > useful than no support at all (or having to use out-of-tree drivers,
> > > > obosolete vendor kernels, binary blobs, etc).
> > > > 
> > > > Therefore "does not cover all peculiarities" does not sound like a valid
> > > > reason for rejecting this driver. That said it's definitely up to stmmac
> > > > maintainers to decide if the code meets the quality standards, does not
> > > > cause excessive maintanence burden, etc.  
> > > 
> > > Sounds sensible, Serge please take a look at the v2 and let us know if
> > > there are any bugs in there. Or any differences in DT bindings or user
> > > visible behaviors with what you're planning to do. If the driver is
> > > functional and useful it can evolve and gain support for features and
> > > platforms over time.  
> > 
> > I've already posted my comments in this thread regarding the main
> > problematic issues of the driver, but Alexey for some reason ignored
> > them (dropped from his reply). Do you want me to copy my comments to
> > v2 and to proceed with review there?
> 
> Right, on a closer look there are indeed comments you raised that were
> not addressed and not constrained to future compatibility. 
> 
> Alexey, please take another look at those and provide a changelog in
> your next posting so we can easily check what was addressed.
> 
> > Regarding the DT-bindings and the user-visible behavior. Right, I'll
> > add my comments in this matter. Thanks for suggesting. This was one of
> > the problems why I was against the driver integrating into the kernel.
> > One of our patchset brings a better organization to the current
> > DT-bindings of the Synopsys DW *MAC devices. In particular it splits
> > up the generic bindings for the vendor-specific MACs to use and the
> > bindings for the pure DW MAC compatible devices. In addition the
> > patchset will add the generic Tx/Rx clocks DT-bindings and the
> > DT-bindings for the AXI/MTL nodes. All of that and the rest of our
> > work will be posted a bit later as a set of the incremental patchsets
> > with small changes, one by one, for an easier review. We just need
> > some more time to finish the left of the work. The reason why the
> > already developed patches hasn't been delivered yet is that the rest
> > of the work may cause adding changes into the previous patches. In
> > order to decrease a number of the patches to review and present a
> > complete work for the community, we decided to post the patchsets
> > after the work is fully done.
> 

> TBH starting to post stuff is probably best choice you can make,
> for example the DT rework you mention sounds like a refactoring 
> you can perform without posting any Baikal support.

I wouldn't say that the DT-part is a refactoring. Since it's
DT-bindings I can't change it' interface much (as I'd like to for
instance in the snps,axi-config or mtp-{tx,rx}-config sub-nodes
bindings). At the very least I can't make them incompatible with
already defined DT-interface. So that was more like an optimization
with updating the Yaml-schemas to be more generic for all the DW MACs:
MAC100, GMAC, EQOS and xGMAC.

Regarding submitting the stuff now and delivering the updates
afterwards. Thanks for suggesting. I thought about that at first, but
then changed my mind. The thing is that I am still in progress of the
STMMAC-related development. Even though a few more tasks left to be
done, they will concerns the bindings change. In addition working on
review comments will distract me from the rest of the STMMAC tasks. So
I'd rather finish all what we've planned first and then start sending
the series one after another with well structured cover letters. Thus
the community will have a coherent set of sets and less patches for
review, while I'll have less gray hairs due to deadlines and
distractions.)

-Sergey
