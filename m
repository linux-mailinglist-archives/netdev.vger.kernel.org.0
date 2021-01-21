Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC482FE16E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbhAUFSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:18:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:47152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726375AbhAUFOE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 00:14:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AE47206DC;
        Thu, 21 Jan 2021 05:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611206001;
        bh=iegJKhZb/xsI6UAobxKjZ6joA3H9TBOgbkjtkHGUZ2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XHSaNpUAjRQsEd/Sx4iWD3DDoTLuvVWmJJoauHZiBSlaAuXov3bNbs5jaOUYMTfMR
         t2sA0pupYIbyIn2/QZlu+EYZBYQ63p4w+bTduhNQnxrYo6R9PoxVLxnWR99I7fR/kd
         nhUu0yctYm92P7XoMhzqHcQxdHEkFjDkZ+Gu+7A6sVu8ElZby87myM3tasEhRPfPKI
         zLCoEBO7DuY9Wm0T65Ew+FJZWOHp4FBVePbO21h50bqBvOuq1OWXh+y5jzCzFFbSiE
         0YhkXlSL1kIaY/FvPnmySSMSx14z/J9gSBwHIE4zCjvARm3SdABku5pPA9RD0P0STw
         x3uEVawouVEeQ==
Date:   Wed, 20 Jan 2021 21:13:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kevin Hao <haokexin@gmail.com>
Cc:     sundeep.lkml@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, gakula@marvell.com, hkelam@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH] Revert "octeontx2-pf: Use the napi_alloc_frag() to
 alloc the pool buffers"
Message-ID: <20210120211320.61c612ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210121050910.GB442272@pek-khao-d2.corp.ad.wrs.com>
References: <1611118955-13146-1-git-send-email-sundeep.lkml@gmail.com>
        <20210121042035.GA442272@pek-khao-d2.corp.ad.wrs.com>
        <20210120205914.4d382e23@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210121050910.GB442272@pek-khao-d2.corp.ad.wrs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 13:09:10 +0800 Kevin Hao wrote:
> On Wed, Jan 20, 2021 at 08:59:14PM -0800, Jakub Kicinski wrote:
> > On Thu, 21 Jan 2021 12:20:35 +0800 Kevin Hao wrote:  
> > > Hmm, why not?
> > >   buf = napi_alloc_frag(pool->rbsize + 128);
> > >   buf = PTR_ALIGN(buf, 128);  
> > 
> > I'd keep the aligning in the driver until there are more users
> > needing this but yes, I agree, aligning the page frag buffers 
> > seems like a much better fix.  
> 
> It seems that the DPAA2 driver also need this (drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c):
> 	/* Prepare the HW SGT structure */
> 	sgt_buf_size = priv->tx_data_offset +
> 		       sizeof(struct dpaa2_sg_entry) *  num_dma_bufs;
> 	sgt_buf = napi_alloc_frag(sgt_buf_size + DPAA2_ETH_TX_BUF_ALIGN);
> 	if (unlikely(!sgt_buf)) {
> 		err = -ENOMEM;
> 		goto sgt_buf_alloc_failed;
> 	}
> 	sgt_buf = PTR_ALIGN(sgt_buf, DPAA2_ETH_TX_BUF_ALIGN);

We can fix them both up as a follow up in net-next, then?

Let's keep the patch small and local for the fix.
