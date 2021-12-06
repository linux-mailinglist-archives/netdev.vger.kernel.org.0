Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8653A46A092
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbhLFQF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:05:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381602AbhLFP7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 10:59:40 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9F8C08EB55;
        Mon,  6 Dec 2021 07:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MPeuvTxNc7e1r/s1dzAjdNjQbaM0LQOJRmSAdCiN7I4=; b=q07BlVPXYmGLZU+dKgzZJ0hiKT
        JUrhQDg+pP5lG9oLUYCnZCHWrZnLfKLbg1+7hElhB9qbRGIylmzLvVKhVkVOSE114gPp7O+Kgn6qM
        XQ35qg/+aEcMjank6MvVfYSt5tE2l364UAZI0FuGnqcS8+3vcnx2+ToMBXcm0nCDX15XTaUECX7F/
        nr28FgBQeQYlLsfZZFxb4ivohfTzLrQEHYU2yg8OuixSDDOIJfSgyF/lMOrQfhOvIJcFHC0JPITjE
        cD+3VG1/sIEG49N+bjV2sBSarVlBGseg6pmFkd6+gxAPZPk17OYN6JyvJlq6beuOTj0Fz1VXvz2G/
        0UVjV9/Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56100)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muG8j-0004w7-OQ; Mon, 06 Dec 2021 15:42:53 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muG8d-0004Sj-CM; Mon, 06 Dec 2021 15:42:47 +0000
Date:   Mon, 6 Dec 2021 15:42:47 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Emmanuel Deloget <emmanuel.deloget@eho.link>
Cc:     Louis Amas <louis.amas@eho.link>, andrii@kernel.org,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, mw@semihalf.com,
        netdev@vger.kernel.org, songliubraving@fb.com, yhs@fb.com
Subject: Re: [PATCH 1/1] net: mvpp2: fix XDP rx queues registering
Message-ID: <Ya4vd9+pBbVJML+K@shell.armlinux.org.uk>
References: <DB9PR06MB8058D71218633CD7024976CAFA929@DB9PR06MB8058.eurprd06.prod.outlook.com>
 <20211110144104.241589-1-louis.amas@eho.link>
 <bdc1f03c-036f-ee29-e2a1-a80f640adcc4@eho.link>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bdc1f03c-036f-ee29-e2a1-a80f640adcc4@eho.link>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 04:37:20PM +0100, Emmanuel Deloget wrote:
> Hello,
> 
> On 10/11/2021 15:41, Louis Amas wrote:
> > The registration of XDP queue information is incorrect because the
> > RX queue id we use is invalid. When port->id == 0 it appears to works
> > as expected yet it's no longer the case when port->id != 0.
> > 
> > When we register the XDP rx queue information (using
> > xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell them to use
> > rxq->id as the queue id. This value iscomputed as:
> > rxq->id = port->id * max_rxq_count + queue_id
> > 
> > where max_rxq_count depends on the device version. In the MB case,
> > this value is 32, meaning that rx queues on eth2 are numbered from
> > 32 to 35 - there are four of them.
> > 
> > Clearly, this is not the per-port queue id that XDP is expecting:
> > it wants a value in the range [0..3]. It shall directly use queue_id
> > which is stored in rxq->logic_rxq -- so let's use that value instead.
> > 
> > This is consistent with the remaining part of the code in
> > mvpp2_rxq_init().
> > 
> > Fixes: b27db2274ba8 ("mvpp2: use page_pool allocator")
> > Signed-off-by: Louis Amas <louis.amas@eho.link>
> > Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
> > Reviewed-by: Marcin Wojtas <mw@semihalf.com>
> > ---
> > This is a repost of [1]. The patch itself is not changed, but the
> > commit message has been enhanced using part of the explaination in
> > order to make it clearer (hopefully) and to incorporate the
> > reviewed-by tag from Marcin.
> > 
> > v1: original patch
> > v2: revamped commit description (no change in the patch itself)
> > 
> > [1] https://lore.kernel.org/bpf/20211109103101.92382-1-louis.amas@eho.link/
> > 
> >   drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > index 587def69a6f7..f0ea377341c6 100644
> > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > @@ -2959,11 +2959,11 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
> >   	mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
> >   	if (priv->percpu_pools) {
> > -		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->id, 0);
> > +		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->logic_rxq, 0);
> >   		if (err < 0)
> >   			goto err_free_dma;
> > -		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->id, 0);
> > +		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->logic_rxq, 0);
> >   		if (err < 0)
> >   			goto err_unregister_rxq_short;
> > 
> 
> Is there any update on this patch ? Without it, XDP only partially work on a
> MACCHIATOBin (read: it works on some ports, not on others, as described in
> our analysis sent together with the original patch).

Hi,

I suspect if you *didn't* thread your updated patch to your previous
submission, then it would end up with a separate entry in
patchwork.kernel.org, and the netdev maintainers will notice that the
patch is ready for inclusion, having been reviewed by Marcin.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
