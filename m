Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70E9B20F103
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 10:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731798AbgF3I6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 04:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731726AbgF3I6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 04:58:19 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0ECC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 01:58:19 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id f5so5651893ljj.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 01:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:cc:subject:from:to:date:message-id
         :in-reply-to;
        bh=yv6uDy0lAnd3Ptn8hYdwAqhvu4buq/NSXsXDjLYP4dk=;
        b=josQmRh9NZmvOhFDmgvXEX2b4CFboN7mmE+gtaYCghd0HyY0d/voS/N0DaAlI0JxRn
         ZBLtMe+a8Dc0lkJlmkYmu37vINsM2HSWPZM4aRaAt8HWjML+C1O/vXHOihE/KUIPdugz
         wDSHmcmi0FZ3w051eqxChfW4LpQzAndmSMMFqjP8duqcbEuRCxXeCe13Q55YGPlDlLHh
         cpYW/1P3J2iT8q6UyeRySq63QiMYVXc/+CuW/w0ZR8aViSgcWbRBl3XElWSu3MNSERS3
         +xI1mOz+vnfXCEsyJgaiFjPNLc/s6nZv7HK+211/MteprjPpjGxM6B1Oe8KeyE8mH2bn
         bpAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:cc:subject:from:to
         :date:message-id:in-reply-to;
        bh=yv6uDy0lAnd3Ptn8hYdwAqhvu4buq/NSXsXDjLYP4dk=;
        b=QcgsQNxE84J6d1W/CrMGi3EC7splJhzSm5O4rvjG1VmeU1hHVeh5Cwerb+nw3xJ1J7
         uElYoItYeU+Odu44w+Zx8AexCkyf30E/WvrKa10oZT5h+bb0SqAEj2UcVKzhQ9Dj/+uq
         KrIKQ9ol/Ia3vNykRwIWX0qPC4MxFziyg0VvVkJIwujq6+7E1iXN07ThGCXhBoMjRdeX
         V2NiF7YFItsIN3FjcxjTVyW+3dDXdCboR4NiO1pU/M1IC72/3TXMtMqgNTrBOBbTRrNx
         rDLT11qXYnsjciGOwvQr7+VHPzo6gXGMVwVlnA/zyVoKCxfM7Qco4LEix3JbIn6OzH8G
         9lYA==
X-Gm-Message-State: AOAM5330IsawFDIVF8aJ9dgyf2WU1O7oO6/20sXsIo2Y2PluEVKe+V/E
        ARYIYuL/tx7zU5xu13ympQ2xqg==
X-Google-Smtp-Source: ABdhPJz5g5us0yfb+LObLu5FQjdEdcVFsW6bF49Q4OAfxhFXHTfaAzzNVc8EP2xtRERws7cYMQxDMw==
X-Received: by 2002:a2e:a544:: with SMTP id e4mr10864635ljn.264.1593507497092;
        Tue, 30 Jun 2020 01:58:17 -0700 (PDT)
Received: from localhost (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id l12sm337532ljj.43.2020.06.30.01.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 01:58:16 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: prevent tx
 starvation under high rx load
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Andy Duan" <fugang.duan@nxp.com>,
        "David Miller" <davem@davemloft.net>
Date:   Tue, 30 Jun 2020 10:55:56 +0200
Message-Id: <C3UB7PGXY0YN.1CF0AAIPSG6EI@wkz-x280>
In-Reply-To: <AM6PR0402MB3607E5066DA857CD4D9B33A3FF6F0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Jun 30, 2020 at 10:26 AM CEST, Andy Duan wrote:
> From: Tobias Waldekranz <tobias@waldekranz.com> Sent: Tuesday, June 30,
> 2020 3:31 PM
> > On Tue Jun 30, 2020 at 8:27 AM CEST, Andy Duan wrote:
> > > From: Tobias Waldekranz <tobias@waldekranz.com> Sent: Tuesday, June
> > > 30,
> > > 2020 12:29 AM
> > > > On Sun Jun 28, 2020 at 8:23 AM CEST, Andy Duan wrote:
> > > > > I never seem bandwidth test cause netdev watchdog trip.
> > > > > Can you describe the reproduce steps on the commit, then we can
> > > > > reproduce it on my local. Thanks.
> > > >
> > > > My setup uses a i.MX8M Nano EVK connected to an ethernet switch, bu=
t
> > > > can get the same results with a direct connection to a PC.
> > > >
> > > > On the iMX, configure two VLANs on top of the FEC and enable IPv4
> > > > forwarding.
> > > >
> > > > On the PC, configure two VLANs and put them in different namespaces=
.
> > > > From one namespace, use trafgen to generate a flow that the iMX wil=
l
> > > > route from the first VLAN to the second and then back towards the
> > > > second namespace on the PC.
> > > >
> > > > Something like:
> > > >
> > > >     {
> > > >         eth(sa=3DPC_MAC, da=3DIMX_MAC),
> > > >         ipv4(saddr=3D10.0.2.2, daddr=3D10.0.3.2, ttl=3D2)
> > > >         udp(sp=3D1, dp=3D2),
> > > >         "Hello world"
> > > >     }
> > > >
> > > > Wait a couple of seconds and then you'll see the output from fec_du=
mp.
> > > >
> > > > In the same setup I also see a weird issue when running a TCP flow
> > > > using iperf3. Most of the time (~70%) when i start the iperf3 clien=
t
> > > > I'll see ~450Mbps of throughput. In the other case (~30%) I'll see
> > > > ~790Mbps. The system is "stably bi-modal", i.e. whichever rate is
> > > > reached in the beginning is then sustained for as long as the sessi=
on is kept
> > alive.
> > > >
> > > > I've inserted some tracepoints in the driver to try to understand
> > > > what's going
> > > > on:
> > > > https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Fsv
> > > > gsha
> > re.com%2Fi%2FMVp.svg&amp;data=3D02%7C01%7Cfugang.duan%40nxp.com%
> > > >
> > 7C12854e21ea124b4cc2e008d81c59d618%7C686ea1d3bc2b4c6fa92cd99c5c
> > > >
> > 301635%7C0%7C0%7C637290519453656013&amp;sdata=3Dby4ShOkmTaRkFfE
> > > > 0xJkrTptC%2B2egFf9iM4E5hx4jiSU%3D&amp;reserved=3D0
> > > >
> > > > What I can't figure out is why the Tx buffers seem to be collected
> > > > at a much slower rate in the slow case (top in the picture). If we
> > > > fall behind in one NAPI poll, we should catch up at the next call (=
which we
> > can see in the fast case).
> > > > But in the slow case we keep falling further and further behind
> > > > until we freeze the queue. Is this something you've ever observed? =
Any
> > ideas?
> > >
> > > Before, our cases don't reproduce the issue, cpu resource has better
> > > bandwidth than ethernet uDMA then there have chance to complete
> > > current NAPI. The next, work_tx get the update, never catch the issue=
.
> >=20
> > It appears it has nothing to do with routing back out through the same
> > interface.
> >=20
> > I get the same bi-modal behavior if just run the iperf3 server on the i=
MX and
> > then have it be the transmitting part, i.e. on the PC I run:
> >=20
> >     iperf3 -c $IMX_IP -R
> >=20
> > I would be very interesting to see what numbers you see in this scenari=
o.
> I just have on imx8mn evk in my hands, and run the case, the numbers is
> ~940Mbps
> as below.
>
> root@imx8mnevk:~# iperf3 -s
> -----------------------------------------------------------
> Server listening on 5201
> -----------------------------------------------------------
> Accepted connection from 10.192.242.132, port 43402
> [ 5] local 10.192.242.96 port 5201 connected to 10.192.242.132 port
> 43404
> [ ID] Interval Transfer Bitrate Retr Cwnd
> [ 5] 0.00-1.00 sec 109 MBytes 913 Mbits/sec 0 428 KBytes
> [ 5] 1.00-2.00 sec 112 MBytes 943 Mbits/sec 0 447 KBytes
> [ 5] 2.00-3.00 sec 112 MBytes 941 Mbits/sec 0 472 KBytes
> [ 5] 3.00-4.00 sec 113 MBytes 944 Mbits/sec 0 472 KBytes
> [ 5] 4.00-5.00 sec 112 MBytes 942 Mbits/sec 0 472 KBytes
> [ 5] 5.00-6.00 sec 112 MBytes 936 Mbits/sec 0 472 KBytes
> [ 5] 6.00-7.00 sec 113 MBytes 945 Mbits/sec 0 472 KBytes
> [ 5] 7.00-8.00 sec 112 MBytes 944 Mbits/sec 0 472 KBytes
> [ 5] 8.00-9.00 sec 112 MBytes 941 Mbits/sec 0 472 KBytes
> [ 5] 9.00-10.00 sec 112 MBytes 940 Mbits/sec 0 472 KBytes
> [ 5] 10.00-10.04 sec 4.16 MBytes 873 Mbits/sec 0 472 KBytes
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval Transfer Bitrate Retr
> [ 5] 0.00-10.04 sec 1.10 GBytes 939 Mbits/sec 0 sender

Are you running the client with -R so that the iMX is the transmitter?
What if you run the test multiple times, do you get the same result
each time?
