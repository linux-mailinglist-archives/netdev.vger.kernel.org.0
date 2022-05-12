Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC570525180
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 17:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244212AbiELPp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 11:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355771AbiELPpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 11:45:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1C264734;
        Thu, 12 May 2022 08:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23C6D61F0A;
        Thu, 12 May 2022 15:45:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C54C385B8;
        Thu, 12 May 2022 15:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652370322;
        bh=DD2xdLhXWSgHygwViWrC+JPg+DvdP1KdqEAZISrgsLE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E8fLQzpQszdxSpiGQ65QWq7DvwYlrfrN47FGDOwRSWFRCpif0/oQv3+gCXv+DvGJm
         EBmLeUXRee/dc3a/he7JT/2pfQYXgOqFwKLF19OsVLLcThSKuXz9XMWbjvqTJIkD2x
         ZLJZjt18/H342ovoSBtczpldKaMPL/SyAFhq7eoNcvL0+TebKMar7wdG9l24vRtXLm
         kI/wd7HW5xHeusx2PaUCMnV6wdt9vVpxKjTZ234Ahv+UtsdXdY/7fCpgChEWR1hE9S
         EFkTI8sM9+Qg+zBnruAucNiukrziCEPWGO2zZRVtQhkJDCV6LOkPOmbIHO7gzqFiqt
         E1Cm2XFMayXhQ==
Date:   Thu, 12 May 2022 08:45:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harini Katakam <harinik@xilinx.com>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        dumazet@google.com, Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH v2] net: macb: Disable macb pad and fcs for fragmented
 packets
Message-ID: <20220512084520.0cdb9dd1@kernel.org>
In-Reply-To: <CAFcVECK2gARjppHjALg4w2v94FPgo6BvqNrZvCY-4x_mJbh7oQ@mail.gmail.com>
References: <20220510162809.5511-1-harini.katakam@xilinx.com>
        <20220511154024.5e231704@kernel.org>
        <CAFcVECK2gARjppHjALg4w2v94FPgo6BvqNrZvCY-4x_mJbh7oQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 May 2022 12:26:15 +0530 Harini Katakam wrote:
> On Thu, May 12, 2022 at 4:10 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 10 May 2022 21:58:09 +0530 Harini Katakam wrote:  
> > > data_len in skbuff represents bytes resident in fragment lists or
> > > unmapped page buffers. For such packets, when data_len is non-zero,
> > > skb_put cannot be used - this will throw a kernel bug. Hence do not
> > > use macb_pad_and_fcs for such fragments.
> > >
> > > Fixes: 653e92a9175e ("net: macb: add support for padding and fcs computation")
> > > Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> > > Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> > > Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> > > Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>  
> >
> > I'm confused. When do we *have to* compute the FCS?
> >
> > This commit seems to indicate that we can't put the FCS so it's okay to
> > ask the HW to do it. But that's backwards. We should ask the HW to
> > compute the FCS whenever possible, to save the CPU cycles.
> >
> > Is there an unstated HW limitation here?  
> 
> Thanks for the review. The top level summary is that there CSUM
> offload is enabled by
> via NETIF_F_HW_CSUM (and universally in IP registers) and then
> selectively disabled for
> certain packets (using NOCRC bit in buffer descriptors) where the
> application intentionally
> performs CSUM and HW should not replace it, for ex. forwarding usecases.
> I'm modifying this list of exceptions with this patch.
> 
> This was due to HW limitation (see
> https://www.spinics.net/lists/netdev/msg505065.html).
> Further to this, Claudiu added macb_pad_and_fcs support. Please see
> comment starting
> with "It was reported in" below:
> https://lists.openwall.net/netdev/2018/10/30/76
> 
> Hope this helps.
> I'll fix the nit and send another version.

So the NOCRC bit controls both ethernet and transport protocol
checksums? The CRC in the name is a little confusing.

Are you sure commit 403dc16796f5 ("cadence: force nonlinear buffers to
be cloned") does not fix the case you're trying to address?
