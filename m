Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A356322070
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhBVTrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:47:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:56018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233170AbhBVTrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 14:47:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2882264E32;
        Mon, 22 Feb 2021 19:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614023180;
        bh=Ri6EYiuUvNYJEE/KKfHGb0Ek9sW1G6VurBQhUkhrAKM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qWDue/h774WdOmqKtOTNRHhdfACMCse0fNPE7EzY0SPZ4tLwNMDskTLdCVR5IIZWk
         KPIHIn+aIMmSeI+U07mTcRh4jyfOrKH3/1IxnS7Ss9YjdDcZ9FJTLz8DcPGecWZz0H
         yz6AFP3OHnmCMX2kls69gzfh7dOXd73lHUp57139zijMm6kTWrsFXjHC4geBWFVqOU
         74BKloc2L7ikBEpGCnH2WfpvVzzShg/iRTD3T0gOrCAU5mtl+wrAuG8IRkU0w9v06T
         CRBbMhTNScDtXBTEWVA3zUKfm5qxN4sjzDxYzdKBnrP0Cw5gSjh8s8UIwOgyTf6s30
         iDvgInU5Jt8Cw==
Date:   Mon, 22 Feb 2021 11:46:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH V4 net 3/5] net: stmmac: fix dma physical address of
 descriptor when display ring
Message-ID: <20210222114616.4eaac47c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DB8PR04MB67956B6D0E9BCEC015E57A81E6839@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210204112144.24163-1-qiangqing.zhang@nxp.com>
        <20210204112144.24163-4-qiangqing.zhang@nxp.com>
        <20210206122911.5037db4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB67956B6D0E9BCEC015E57A81E6839@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Feb 2021 07:43:33 +0000 Joakim Zhang wrote:
> > >  	pr_info("%s descriptor ring:\n", rx ? "RX" : "TX");
> > >
> > >  	for (i = 0; i < size; i++) {
> > > -		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
> > > -			i, (unsigned int)virt_to_phys(p),
> > > +		pr_info("%03d [0x%llx]: 0x%x 0x%x 0x%x 0x%x\n",
> > > +			i, (unsigned long long)(dma_rx_phy + i * desc_size),
> > >  			le32_to_cpu(p->des0), le32_to_cpu(p->des1),
> > >  			le32_to_cpu(p->des2), le32_to_cpu(p->des3));
> > >  		p++;  
> > 
> > Why do you pass the desc_size in? The virt memory pointer is incremented by
> > sizeof(*p) surely
> > 
> > 	dma_addr + i * sizeof(*p)  
> 
> I think we can't use sizeof(*p), as when display descriptor, only do
> " struct dma_desc *p = (struct dma_desc *)head;", but driver can pass
> "struct dma_desc", " struct dma_edesc" or " struct
> dma_extended_desc",

Looks like some of the functions you change already try to pick the
right type. Which one is problematic?

> so it's necessary to pass desc_size to compatible all cases.

But you still increment the the VMA pointer ('p' in the quote above)
but it's size, so how is that correct if the DMA addr needs a special
size increment?

