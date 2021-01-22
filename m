Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3CA9300A8E
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbhAVSAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:00:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729180AbhAVRuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 12:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CE7323A6A;
        Fri, 22 Jan 2021 17:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611337807;
        bh=TNat9Fz4c+AJvaXKvMJxYfpWWoA/QqN7cxH1mr47xUY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A0kk4pHqex98Nwc38GqH8Byhql0nJ16ivRXbrHDs3wNT+uWraKkw1PGlfwse1BpCS
         sDWSqZuC+wA3vHKjfBHGnaMymXcA1KTmdQ7a4vTvrvm9Zn4gquG7ZcQ//gmcCKTya3
         rGDQdN5ytDhba5x0HiCtUwLMXpVDSXWG6RgsMfGBRKUt6qMpsVvuK+k4HYdUpYrmJO
         GtSQ1OTEClSljeLC4qOYl+LTLneR0yJ4oIVPNS1tUKkHTjGLvgp33fp6636HatFfFr
         LidOkWhADdgaBE0/NmIqcw1N3JUSQvPRB8vJ1/y/st9HmMqbAkj1ZkTSQ91X/tPiHr
         QGbfSeaJEukeQ==
Date:   Fri, 22 Jan 2021 09:50:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Petr Vandrovec <petr@vmware.com>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH net-next] vmxnet3: Remove buf_info from device
 accessible structures
Message-ID: <20210122095006.58d258aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <888F37FB-B8BD-43D8-9E75-4F1CE9D4FAC7@vmware.com>
References: <20210120021941.9655-1-doshir@vmware.com>
        <20210121170705.08ecb23d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <888F37FB-B8BD-43D8-9E75-4F1CE9D4FAC7@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 08:24:59 +0000 Ronak Doshi wrote:
> On 1/21/21, 5:07 PM, "Jakub Kicinski" <kuba@kernel.org> wrote:
> >  On Tue, 19 Jan 2021 18:19:40 -0800 Ronak Doshi wrote:  
> > > +	tq->buf_info = kmalloc_array_node(tq->tx_ring.size, sizeof(tq->buf_info[0]),
> > > +					  GFP_KERNEL | __GFP_ZERO,
> > > +					  dev_to_node(&adapter->pdev->dev));  
> > > +	if (!tq->buf_info) {
> > > +		netdev_err(adapter->netdev, "failed to allocate tx buffer info\n")  
> >
> > Please drop the message, OOM splat will be visible enough. checkpatch
> > usually points this out  
> 
> Okay, will drop it. Checkpatch did not complain about the error message though.

Looks like it matches alloc_node or alloc_array, but not
alloc_array_node ?

our $allocFunctions = qr{(?x:
	(?:(?:devm_)?
		(?:kv|k|v)[czm]alloc(?:_node|_array)? |


CCing Joe in case he thinks it's worth fixing
