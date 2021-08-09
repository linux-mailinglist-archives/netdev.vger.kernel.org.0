Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553FA3E486A
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 17:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbhHIPPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 11:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:37648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234075AbhHIPPw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 11:15:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19FCE60F11;
        Mon,  9 Aug 2021 15:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628522132;
        bh=UsgdSVtypHPDXHWt0l4nRtfQCNMgQ+tKCWPtUY6fvQM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TEQoBhRzIfInMZC6f1hCPJlOBVQuPh5jS+8Z7dw1KMPloWztnrKWfPZBocZj3cwAt
         3e4nXWVFBWVvbmyoMA8x2C3qood/bgHHL8Iy1VTx8o6Zc743iZ7NRbTKySelqcgifl
         A6DjSJB9A02YbLuklhwlI/Lc5tMuoswJVIKgbM2YNepJanHNF3UiWFbBT7jqJc7SXp
         zPcLOaE032NMvCYK6HjG204ADxFB756DAJwDan4+O/wEIeSonUPrmNSHfiy6tHI33h
         sdssnpN/+KKUYwdT85GaGppKiUoRnvB3YVn2isXOrJ4JowJVOkHltWw6NaeWeaIHAF
         WTcrMpMUyGPfw==
Received: by pali.im (Postfix)
        id C2169C7C; Mon,  9 Aug 2021 17:15:29 +0200 (CEST)
Date:   Mon, 9 Aug 2021 17:15:29 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
Message-ID: <20210809151529.ymbq53f633253loz@pali>
References: <7EE80F78-6107-4C6E-B61D-01752D44155F@gmail.com>
 <YQy9JKgo+BE3G7+a@kroah.com>
 <08EC1CDD-21C4-41AB-B6A8-1CC2D40F5C05@gmail.com>
 <20210808152318.6nbbaj3bp6tpznel@pali>
 <8BDDA0B3-0BEE-4E80-9686-7F66CF58B069@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8BDDA0B3-0BEE-4E80-9686-7F66CF58B069@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday 08 August 2021 18:29:30 Martin Zaharinov wrote:
> Hi Pali
> 
> Kernel 5.13.8
> 
> 
> The problem is from kernel 5.8 > I try all major update 5.9, 5.10, 5.11 ,5.12
> 
> I use accel-pppd daemon (not pppd) .

I'm not using accel-pppd, so cannot help here.

I would suggest to try "git bisect" kernel version which started to be
problematic for accel-pppd.

Providing state of ppp channels and ppp units could help to debug this
issue, but I'm not sure if accel-pppd has this debug feature. IIRC only
process which has ppp file descriptors can retrieve and dump this
information.

> And yes after users started to connecting .
> 
> When system boot and connect first time all user connect without any problem .
> In time of work user disconnect and connect (power cut , fiber cut or other problem in network) , but in time of spike (may be make lock or other problem ) disconnect ~ 400-500 users  and affect other users. Process go to load over 100% and In statistic I see many finishing connection and many start connection. 
> And in this time in log get many lines with   ioctl(PPPIOCCONNECT): Transport endpoint is not connected. After finish (unlock or other) stop to see this error and system is back to normal. And connect all disconnected users.
> 
> Martin
> 
> > On 8 Aug 2021, at 18:23, Pali Rohár <pali@kernel.org> wrote:
> > 
> > Hello!
> > 
> > On Sunday 08 August 2021 18:14:09 Martin Zaharinov wrote:
> >> Add Pali Rohár,
> >> 
> >> If have any idea .
> >> 
> >> Martin
> >> 
> >>> On 6 Aug 2021, at 7:40, Greg KH <gregkh@linuxfoundation.org> wrote:
> >>> 
> >>> On Thu, Aug 05, 2021 at 11:53:50PM +0300, Martin Zaharinov wrote:
> >>>> Hi Net dev team
> >>>> 
> >>>> 
> >>>> Please check this error :
> >>>> Last time I write for this problem : https://www.spinics.net/lists/netdev/msg707513.html
> >>>> 
> >>>> But not find any solution.
> >>>> 
> >>>> Config of server is : Bonding port channel (LACP)  > Accel PPP server > Huawei switch.
> >>>> 
> >>>> Server is work fine users is down/up 500+ users .
> >>>> But in one moment server make spike and affect other vlans in same server .
> > 
> > When this error started to happen? After kernel upgrade? After pppd
> > upgrade? Or after system upgrade? Or when more users started to
> > connecting?
> > 
> >>>> And in accel I see many row with this error.
> >>>> 
> >>>> Is there options to find and fix this bug.
> >>>> 
> >>>> With accel team I discus this problem  and they claim it is kernel bug and need to find solution with Kernel dev team.
> >>>> 
> >>>> 
> >>>> [2021-08-05 13:52:05.294] vlan912: 24b205903d09718e: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:05.298] vlan912: 24b205903d097162: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:05.626] vlan641: 24b205903d09711b: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:11.000] vlan912: 24b205903d097105: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:17.852] vlan912: 24b205903d0971ae: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:21.113] vlan641: 24b205903d09715b: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:27.963] vlan912: 24b205903d09718d: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:30.249] vlan496: 24b205903d097184: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:30.992] vlan420: 24b205903d09718a: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:33.937] vlan640: 24b205903d0971cd: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:40.032] vlan912: 24b205903d097182: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:40.420] vlan912: 24b205903d0971d5: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:42.799] vlan912: 24b205903d09713a: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:42.799] vlan614: 24b205903d0971e5: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:43.102] vlan912: 24b205903d097190: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097153: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:43.850] vlan479: 24b205903d097141: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:43.852] vlan912: 24b205903d097198: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:43.977] vlan637: 24b205903d097148: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>>> [2021-08-05 13:52:44.528] vlan637: 24b205903d0971c3: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>> 
> >>> These are userspace error messages, not kernel messages.
> >>> 
> >>> What kernel version are you using?
> > 
> > Yes, we need to know, what kernel version are you using.
> > 
> >>> thanks,
> >>> 
> >>> greg k-h
> >> 
> > 
> > And also another question, what version of pppd daemon are you using?
> > 
> > Also, are you able to dump state of ppp channels and ppp units? It is
> > needed to know to which tty device, file descriptor (or socket
> > extension) is (or should be) particular ppp channel bounded.
> 
