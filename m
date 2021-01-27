Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4040306403
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 20:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhA0T36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 14:29:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231152AbhA0T36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 14:29:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C034F64DC5;
        Wed, 27 Jan 2021 19:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611775756;
        bh=RE3ASHgGtSPnCbkfYCYQSz5gcwq8q+reTrMwTmnykYg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=An41wkQ8MfeqkgPPnvTlgXIoHB5gdMWA606f1A0F/mBvdXBLiLkme9ZNuSNFQ/isb
         dChH6r8OUzwYt911tk5VpfISfh5gw+blQq1dPy3hdjhVDREWfhFDPa6G+8MWjYWea/
         VAYiTcYn7T3RgXqGVcJqkd0kO68xDiqblFZnWaNXhxCo473lZhLvF1o34L0ZvcBtyb
         hobdegYgp3dF/Lyx42weiswKFprFss/BUElf91WjIkBnSXBo7fgfjpMzQ26LIViZs+
         zO4H5kXFnycy+IQ/xoM/u9TuEPES5FrxVNDIqt2kZCjm+MhEvuc8nQVM5nddcLfukt
         sngOavUjsUmTQ==
Received: by pali.im (Postfix)
        id 0F9C05CD; Wed, 27 Jan 2021 20:29:13 +0100 (CET)
Date:   Wed, 27 Jan 2021 20:29:13 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     linux-man@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3] netdevice.7: Update documentation for SIOCGIFADDR
 SIOCSIFADDR SIOCDIFADDR
Message-ID: <20210127192913.e6ppkqwjclmgjh4a@pali>
References: <20210102140254.16714-1-pali@kernel.org>
 <20210116223610.14230-1-pali@kernel.org>
 <fc4a94d4-2eac-1b24-cc90-162045eae107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc4a94d4-2eac-1b24-cc90-162045eae107@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 19 January 2021 21:18:29 Alejandro Colomar (man-pages) wrote:
> Hi Pali,
> 
> I was a patch for environ.7 while I found some pattern.
> Please see below a minor fix.
> 
> Thanks,
> 
> Alex
> 
> On 1/16/21 11:36 PM, Pali Rohár wrote:
> > Unlike SIOCGIFADDR and SIOCSIFADDR which are supported by many protocol
> > families, SIOCDIFADDR is supported by AF_INET6 and AF_APPLETALK only.
> > 
> > Unlike other protocols, AF_INET6 uses struct in6_ifreq.
> > 
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  man7/netdevice.7 | 64 +++++++++++++++++++++++++++++++++++++++++-------
> >  1 file changed, 55 insertions(+), 9 deletions(-)
> > 
> > diff --git a/man7/netdevice.7 b/man7/netdevice.7
> > index 15930807c..bdc2d1922 100644
> > --- a/man7/netdevice.7
> > +++ b/man7/netdevice.7
> > @@ -56,9 +56,27 @@ struct ifreq {
> >  .EE
> >  .in
> >  .PP
> > +.B AF_INET6
> > +is an exception.
> > +It passes an
> > +.I in6_ifreq
> > +structure:
> > +.PP
> > +.in +4n
> > +.EX
> > +struct in6_ifreq {
> > +    struct in6_addr     ifr6_addr;
> > +    u32                 ifr6_prefixlen;
> > +    int                 ifr6_ifindex; /* Interface index */
> > +};
> > +.EE
> > +.in
> > +.PP
> >  Normally, the user specifies which device to affect by setting
> >  .I ifr_name
> > -to the name of the interface.
> > +to the name of the interface or
> > +.I ifr6_ifindex
> > +to the index of the interface.
> >  All other members of the structure may
> >  share memory.
> >  .SS Ioctls
> > @@ -143,13 +161,33 @@ IFF_ISATAP:Interface is RFC4214 ISATAP interface.
> >  .PP
> >  Setting the extended (private) interface flags is a privileged operation.
> >  .TP
> > -.BR SIOCGIFADDR ", " SIOCSIFADDR
> > -Get or set the address of the device using
> > -.IR ifr_addr .
> > -Setting the interface address is a privileged operation.
> > -For compatibility, only
> > +.BR SIOCGIFADDR ", " SIOCSIFADDR ", " SIOCDIFADDR
> > +Get, set, or delete the address of the device using
> > +.IR ifr_addr ,
> > +or
> > +.I ifr6_addr
> > +with
> > +.IR ifr6_prefixlen .
> > +Setting or deleting the interface address is a privileged operation.
> > +For compatibility,
> > +.B SIOCGIFADDR
> > +returns only
> >  .B AF_INET
> > -addresses are accepted or returned.
> > +addresses,
> > +.B SIOCSIFADDR
> > +accepts
> > +.B AF_INET
> > +and
> > +.B AF_INET6
> > +addresses, and
> > +.B SIOCDIFADDR
> > +deletes only
> > +.B AF_INET6
> > +addresses.
> > +A
> > +.B AF_INET
> > +address can be deleted by setting it to zero via
> > +.BR SIOCSIFADDR .
> >  .TP
> >  .BR SIOCGIFDSTADDR ", " SIOCSIFDSTADDR
> >  Get or set the destination address of a point-to-point device using
> > @@ -351,10 +389,18 @@ The names of interfaces with no addresses or that don't have the
> >  flag set can be found via
> >  .IR /proc/net/dev .
> >  .PP
> > -Local IPv6 IP addresses can be found via
> > -.I /proc/net
> > +.B AF_INET6
> > +IPv6 addresses can be read from
> > +.I /proc/net/if_inet6
> > +file or via
> > +.BR rtnetlink (7).
> > +Adding a new or deleting an existing IPv6 address can be done via
> > +.BR SIOCSIFADDR " / " SIOCDIFADDR
> 
> I found a few pages with the pattern [.BR X / Y],
> but none like [.BR X " / " Y].
> 
> $ grep -rn '\.BR [a-zA-Z]* / [a-zA-Z]*' man?
> man1/getent.1:365:.BR ahosts / getaddrinfo (3)
> man2/sigaction.2:526:.BR SIGIO / SIGPOLL
> man2/sigaction.2:638:.BR SIGIO / SIGPOLL
> man2/sigaction.2:814:.BR SIGIO / SIGPOLL
> man3/sysconf.3:181:.BR PAGESIZE / _SC_PAGESIZE .
> man7/signal.7:539:.BR SIGINFO / SIGPWR
> man7/pipe.7:114:.BR SIGPIPE / EPIPE
> man7/environ.7:127:.BR EDITOR / VISUAL
> $ grep -rn '\.BR [a-zA-Z]* " / " [a-zA-Z]*' man?
> $
> 
> Please fix this for the next revision.
> However, don't send a new one only for this.

Ok!

> I'd wait to see if someone reviews it or helps in any way ;)

Seems that nobody came up with suggestions for improvements...

> 
> >  or via
> >  .BR rtnetlink (7).
> > +Retrieving or changing destination IPv6 addresses of a point-to-point
> > +interface is possible only via
> > +.BR rtnetlink (7).
> >  .SH BUGS
> >  glibc 2.1 is missing the
> >  .I ifr_newname
> > 
