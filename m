Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55DC3FDD9C
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 16:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244916AbhIAOEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 10:04:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244850AbhIAOEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 10:04:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31DD461056;
        Wed,  1 Sep 2021 14:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630505037;
        bh=nX6C2DRBXiBkE79Xdd4pyWzyoxxhjeSK8IZ79WR96nc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RgBb0MwFXE4yguaCPfNxHQ/4fIPuvD09hONxNLn8i7e2M1rYy6SH03i+w5KmJX6Hy
         IJqWbUqbbL/lMNdlKyG6mzGC6seuXjMWA+9aEXJuEh8if1ehmtsY1YYwC4ycG6gcvj
         YK1/6I4mflU22vTF/BWkkHl4fBYMdUAcN5S78nYIHXMR8p8LH8RvGOzeGPZ4wIiu3V
         VtjPdYJM8/pbDebu66h9EtdMb+V1XmhaWVaOk/q7FaeccswfeIRHwYWO68W4HY2TiS
         yBQRZ1dudOuxje4NEmdppuxNmFnHddFh5A2gHMw5ib2fYR5AbaTmuA7JHjq6ueAd5K
         60ZajFp5EQW6w==
Date:   Wed, 1 Sep 2021 07:03:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Peter Collingbourne <pcc@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Arnd Bergmann" <arnd@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2] net: don't unconditionally copy_from_user a struct
 ifreq for socket ioctls
Message-ID: <20210901070356.750ea996@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bf0f47974d7141358d810d512d4b9a00@AcuMS.aculab.com>
References: <20210826194601.3509717-1-pcc@google.com>
        <20210831093006.6db30672@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <bf0f47974d7141358d810d512d4b9a00@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Sep 2021 08:22:42 +0000 David Laight wrote:
> From: Jakub Kicinski
> > Sent: 31 August 2021 17:30
> > 
> > On Thu, 26 Aug 2021 12:46:01 -0700 Peter Collingbourne wrote:  
> > > @@ -3306,6 +3308,8 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
> > >  	struct ifreq ifreq;
> > >  	u32 data32;
> > >
> > > +	if (!is_socket_ioctl_cmd(cmd))
> > > +		return -ENOTTY;
> > >  	if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
> > >  		return -EFAULT;
> > >  	if (get_user(data32, &u_ifreq32->ifr_data))  
> > 
> > Hi Peter, when resolving the net -> net-next merge conflict I couldn't
> > figure out why this chunk is needed. It seems all callers of
> > compat_ifr_data_ioctl() already made sure it's a socket IOCTL.
> > Please double check my resolution (tip of net-next) and if this is
> > indeed unnecessary perhaps send a cleanup? Thanks!  
> 
> To stop the copy_from_user() faulting when the user buffer
> isn't long enough.
> In particular for iasatty() on arm with tagged pointers.

Let me rephrase. is_socket_ioctl_cmd() is always true here. There were
only two callers, both check cmd is of specific, "sockety" type.
