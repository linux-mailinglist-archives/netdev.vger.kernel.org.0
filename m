Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6775E46AC2B
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 23:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351081AbhLFWgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 17:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241471AbhLFWgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 17:36:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F03AC061746;
        Mon,  6 Dec 2021 14:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IKF1Yy9+H/v912cwn1CDM3PcR8oTVzSiOSHZuXDeCYk=; b=YpDwBCjWMOaBNCU4fA+JxLvAcz
        ZHwDm0BUHOgCWIqK4LYFzubQ5VEwtIjCeAqiPpHfhdKaoO9eBmtsNHWTQQenB6wu8KigxI5zfF6tB
        gnYUd/m/xa2xXh5qRtyqMKFCLWI4XaiXd9mgOWl1FBdwKtQ5MB4fmFQEMOBASJw0WvyNv4iiH4bZw
        UZedv0TRC7Y7C+0RaIBj/tCQd2V2ZsAvgXXCgnAkbaVIMrbr6TM7tJnaI3frQxviq3E++u5bE4app
        gubV4+/3FUc56yTnHnORg4kAJMRKxScyUhF4GK45JvEh4pxTy4M+R/qjjhb+3B9HT347RuF04OcA4
        fqTg7xQg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56128)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1muMWn-0005TN-VJ; Mon, 06 Dec 2021 22:32:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1muMWf-0004iR-J3; Mon, 06 Dec 2021 22:32:01 +0000
Date:   Mon, 6 Dec 2021 22:32:01 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Emmanuel Deloget <emmanuel.deloget@eho.link>
Cc:     Jakub Kicinski <kuba@kernel.org>, Louis Amas <louis.amas@eho.link>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3 net 1/1] net: mvpp2: fix XDP rx queues registering
Message-ID: <Ya6PYeb4+Je+wXfD@shell.armlinux.org.uk>
References: <20211206172220.602024-1-louis.amas@eho.link>
 <20211206125513.5e835155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cfd7a6c3-dee9-e0ba-e332-46dc656ba531@eho.link>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfd7a6c3-dee9-e0ba-e332-46dc656ba531@eho.link>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 11:14:38PM +0100, Emmanuel Deloget wrote:
> Hello,
> 
> On 06/12/2021 21:55, Jakub Kicinski wrote:
> > On Mon,  6 Dec 2021 18:22:19 +0100 Louis Amas wrote:
> > > The registration of XDP queue information is incorrect because the
> > > RX queue id we use is invalid. When port->id == 0 it appears to works
> > > as expected yet it's no longer the case when port->id != 0.
> > > 
> > > The problem arised while using a recent kernel version on the
> > > MACCHIATOBin. This board has several ports:
> > >   * eth0 and eth1 are 10Gbps interfaces ; both ports has port->id == 0;
> > >   * eth2 is a 1Gbps interface with port->id != 0.
> > 
> > Still doesn't apply to net/master [1]. Which tree is it based on?
> > Perhaps you are sending this for the BPF tree? [2] Hm, doesn't apply
> > there either...
> > 
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/
> 
> Strange...
> 
> AFAIK the commit was added on top of net/master (as cloned at approximately
> 17:30 CET). I'll check with Louis tomorrow morning. We may have messed-up
> something.

The reason it doesn't apply is because something is butchering the
whitespace. Whatever it is, it thinks it knows better than you do,
and is converting the tabs in the patch to a series of space
characters. Your email also appears to be using quoted-printable
encoding.

It looks like you're using git-send-email - and that should be fine.
It also looks like you're sending through a MS Exchange server...
My suspicion would be that the MS Exchange server is re-encoding
to quoted-printable and is butchering the white space, but that's
just a guess. I've no idea what you can do about that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
