Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAE846A0EB
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380585AbhLFQR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385933AbhLFQQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 11:16:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87766C09B130;
        Mon,  6 Dec 2021 08:03:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D762FB81018;
        Mon,  6 Dec 2021 16:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD70C341C2;
        Mon,  6 Dec 2021 16:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638806617;
        bh=0hIMxUiKaxfvgogyudivj6aZ0CmABcuX/qtX3tWTxI0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qUJFfeWzPWhRDMoZff20CrLQgcnCfziWN+toVPZp3km3h3sgM2GN5jgjHSGKmjZ84
         i+zraFxKmtDBSMonqNfLCGbYHsSdY/XRktPsww8p+7hZik4r+zfeJzcbvpmnVrxMrp
         rzFjUB0a0FnQv3n8snNVTjtav+iHl9PuSNVX2z5uWCGPwSDVDqxWHEHFU9sJMfZ1AE
         /6sx4O0f5D/1r7XpcaN/T+1U2923ytgvktav+1UXUGB476ynUpIwxp6R601y7aIfbC
         dftx15eMOpGF1qIv3DMSdMaQ+1wI+uxGrNeVL3HK5Xq1jDCz15+BTbhKpZGG0oTk1v
         ZWSQ7LvRn/2GQ==
Date:   Mon, 6 Dec 2021 08:03:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Emmanuel Deloget <emmanuel.deloget@eho.link>,
        Louis Amas <louis.amas@eho.link>, andrii@kernel.org,
        ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        mw@semihalf.com, netdev@vger.kernel.org, songliubraving@fb.com,
        yhs@fb.com
Subject: Re: [PATCH 1/1] net: mvpp2: fix XDP rx queues registering
Message-ID: <20211206080337.13fc9ae7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Ya4vd9+pBbVJML+K@shell.armlinux.org.uk>
References: <DB9PR06MB8058D71218633CD7024976CAFA929@DB9PR06MB8058.eurprd06.prod.outlook.com>
        <20211110144104.241589-1-louis.amas@eho.link>
        <bdc1f03c-036f-ee29-e2a1-a80f640adcc4@eho.link>
        <Ya4vd9+pBbVJML+K@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021 15:42:47 +0000 Russell King (Oracle) wrote:
> On Mon, Dec 06, 2021 at 04:37:20PM +0100, Emmanuel Deloget wrote:
> > On 10/11/2021 15:41, Louis Amas wrote:  
> > > The registration of XDP queue information is incorrect because the
> > > RX queue id we use is invalid. When port->id == 0 it appears to works
> > > as expected yet it's no longer the case when port->id != 0.
> > > 
> > > When we register the XDP rx queue information (using
> > > xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell them to use
> > > rxq->id as the queue id. This value iscomputed as:
> > > rxq->id = port->id * max_rxq_count + queue_id
> > > 
> > > where max_rxq_count depends on the device version. In the MB case,
> > > this value is 32, meaning that rx queues on eth2 are numbered from
> > > 32 to 35 - there are four of them.
> > > 
> > > Clearly, this is not the per-port queue id that XDP is expecting:
> > > it wants a value in the range [0..3]. It shall directly use queue_id
> > > which is stored in rxq->logic_rxq -- so let's use that value instead.
> > > 
> > > This is consistent with the remaining part of the code in
> > > mvpp2_rxq_init().

> > Is there any update on this patch ? Without it, XDP only partially work on a
> > MACCHIATOBin (read: it works on some ports, not on others, as described in
> > our analysis sent together with the original patch).  
> 
> I suspect if you *didn't* thread your updated patch to your previous
> submission, then it would end up with a separate entry in
> patchwork.kernel.org,

Indeed, it's easier to keep track of patches which weren't posted 
as a reply in a thread, at least for me.

> and the netdev maintainers will notice that the
> patch is ready for inclusion, having been reviewed by Marcin.

In this case I _think_ it was dropped because it didn't apply.

Please rebase on top of net/master and repost if the changes is still
needed.
