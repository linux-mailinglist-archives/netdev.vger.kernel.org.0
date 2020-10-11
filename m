Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E1228A95A
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 20:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgJKSb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 14:31:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725909AbgJKSb1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 14:31:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5AAC2087D;
        Sun, 11 Oct 2020 18:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602441087;
        bh=+DjaoLE5WvL/XzpfwArfuBKyT3gCjSrjKTV/AoaOXUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=y+Hy8NRefGd5w4E9q7R8hZ2uQgUmO4wKT/Y7F1FdLQxYkdzluaeZzFEtW0t728T0c
         kQLLpDYHRMVr+RbCIHmo+97Xp1HuQojwO04Y1cefdgFwKywpuGYoeqMGdDF5dvXmyK
         5QY90/QD1HJf861bqo9V9ze6cnppmarE9M9hULws=
Date:   Sun, 11 Oct 2020 11:31:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Wilder <dwilder@us.ibm.com>,
        Network Development <netdev@vger.kernel.org>,
        tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com
Subject: Re: [ PATCH v1 2/2] ibmveth: Identify ingress large send packets.
Message-ID: <20201011113125.3f370b77@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CA+FuTSejypj6fvU3-b8V-kU6Xcwg7m4R3OO3Ry4kQK=87hNwvw@mail.gmail.com>
References: <20201008190538.6223-1-dwilder@us.ibm.com>
        <20201008190538.6223-3-dwilder@us.ibm.com>
        <CA+FuTSc8qw_U=nKR0tM06z99Es8JVKR0P6rQpR=Bkwj1eOtXCw@mail.gmail.com>
        <CA+FuTSejypj6fvU3-b8V-kU6Xcwg7m4R3OO3Ry4kQK=87hNwvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Oct 2020 12:51:30 -0400 Willem de Bruijn wrote:
> > > @@ -1385,7 +1386,17 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
> > >                         skb_put(skb, length);
> > >                         skb->protocol = eth_type_trans(skb, netdev);
> > >
> > > -                       if (length > netdev->mtu + ETH_HLEN) {
> > > +                       /* PHYP without PLSO support places a -1 in the ip
> > > +                        * checksum for large send frames.
> > > +                        */
> > > +                       if (be16_to_cpu(skb->protocol) == ETH_P_IP) {

You can byteswap the constant, so its done at compilation time.

> > > +                               struct iphdr *iph = (struct iphdr *)skb->data;
> > > +
> > > +                               iph_check = iph->check;  
> >
> > Check against truncated/bad packets.  
> 
> .. unless I missed context. Other code in this driver seems to peek in
> the network and transport layer headers without additional geometry
> and integrity checks, too.

Good catch, even if we trust the hypervisor to only forward valid
frames this needs to be at least mentioned in the commit message.

Also please add Fixes tags to both patches.
