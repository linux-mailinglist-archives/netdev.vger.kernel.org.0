Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17DCA873FB
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 10:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405818AbfHIIZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 04:25:38 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:38809 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405713AbfHIIZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 04:25:38 -0400
Received: by mail-yw1-f68.google.com with SMTP id f187so35227972ywa.5
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 01:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NnqCxV67Kpvag8TWJQCPipgj+n/1ZDDQmxvY6twlVNo=;
        b=HQrmXO5w4lMp2SjAMJtMtqvx1gHTGCInQN0I/AFlrbzPZth6rRP9Oe3XL5mko9WINm
         8j5ZK5bg3kSnOruUDp9Oc4oBvcMGEx5cWYOLsepjLaE5wbWVfAsVJHGyYxm0Hutb8RNM
         bMunrl01RgOWITi9r42upGF1dPO01LbTyH7tDJJy9x55394cLhoyojFevJ+e3yzJtude
         cQTBMoGSDfUYNgNMH9Tm/VEO/IoTzEmfeBXkffKlaP22dgB/80ChRJr9dkTfJaW1+1YS
         A7/w9XJde6BeyReGWM/QKnyh9RJxeGYUfaxqabW2ja7iDV3L5fCm7YjkiVjV2DEcb6cH
         IoOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NnqCxV67Kpvag8TWJQCPipgj+n/1ZDDQmxvY6twlVNo=;
        b=E4m85U/zk41ReuQrgry4AYIEAJWG5UmKxHMYWjRhM4W1PUJNkVDGIQuAuJKoSm3xVx
         TW6IeVGx4lVvJEjsDgSwAAyE64CkCKcKiBoFD6Fp3isxzl8APaqc7IjAKfdMyiQZet5o
         ieN2bz9miCnh9PyfEFV3cfzRyA+7Yyys4OnYaCJOXH+4A1toBP/fKI/O2xxcysSmwsJH
         kWLkzejqnumHxgEdiVEyqqG7KCeCKJ1lmjUL+PnpddJVOfXrUBnAJXPFmggvll8OO30S
         YGS1xlzhpNfEe3BlTNtxYHHMTXyODM42KBH8M7NYMRBtZc004kbW1lSsIHdYyEf+QVlX
         bwGg==
X-Gm-Message-State: APjAAAVRXDWl+qjzCjErPvC7qxtlOiThvumbGzOfldoD/7p8vzcGdPex
        ZRGb1G/4Wgd28tF6DSNTjf2xb9196AVIWED7aVmLSQ==
X-Google-Smtp-Source: APXvYqxgriZn3SBfMwnXpzyI2sHTLaFlHJOZljAvP1izmtB10GTfPbRIoR0jmGq4L8XmWtKI+HeAFk3W0LUek6t/ZX4=
X-Received: by 2002:a81:1090:: with SMTP id 138mr5895021ywq.179.1565339136890;
 Fri, 09 Aug 2019 01:25:36 -0700 (PDT)
MIME-Version: 1.0
References: <2950b2f7-7460-cce0-d964-ad654d897295@gmail.com>
 <acd65426-0c7e-8c5f-a002-a36286f09122@applied-asynchrony.com>
 <cfb9a1c7-57c8-db04-1081-ac1cb92bb447@applied-asynchrony.com>
 <a19bb3de-a866-d342-7cca-020fef219d03@gmail.com> <868a1f4c-5fba-c64b-ea31-30a3770e6a2f@applied-asynchrony.com>
 <f08a3207-0930-4b71-16f1-81e352f87a9c@gmail.com> <eecaaf82-e6cd-2b75-5756-006a70258a9f@applied-asynchrony.com>
In-Reply-To: <eecaaf82-e6cd-2b75-5756-006a70258a9f@applied-asynchrony.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 9 Aug 2019 10:25:25 +0200
Message-ID: <CANn89iKjPz5-EypQ9cb3LRsLJBy1Hr0vLoW6Sjd_Df082H1Yzw@mail.gmail.com>
Subject: Re: [PATCH net-next] r8169: make use of xmit_more
To:     =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 10:04 AM Holger Hoffst=C3=A4tte
<holger@applied-asynchrony.com> wrote:
>
> On 8/8/19 10:08 PM, Heiner Kallweit wrote:
> (..snip..)
> >>>
> >>> I was about to ask exactly that, whether you have TSO enabled. I don'=
t know what
> >>> can trigger the HW issue, it was just confirmed by Realtek that this =
chip version
> >>> has a problem with TSO. So the logical conclusion is: test w/o TSO, i=
deally the
> >>> linux-next version.
> >>
> >> So disabling TSO alone didn't work - it leads to reduced throughout (~=
70 MB/s in iperf).
> >> Instead I decided to backport 93681cd7d94f ("r8169: enable HW csum and=
 TSO"), which
> >> wasn't easy due to cleanups/renamings of dependencies, but I managed t=
o backport
> >> it and .. got the same problem of reduced throughout. wat?!
> >>
> >> After lots of trial & error I started disabling all offloads and final=
ly found
> >> that sg (Scatter-Gather) enabled alone - without TSO - will lead to th=
e throughput
> >> drop. So the culprit seems 93681cd7d94f, which disabled TSO on my NIC,=
 but left
> >> sg on by default. This weas repeatable - switch on sg, throughput drop=
; turn it
> >> off - smooth sailing, now with reduced buffers.
> >>
> >> I modified the relevant bits to disable tso & sg like this:
> >>
> >>      /* RTL8168e-vl has a HW issue with TSO */
> >>      if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_34) {
> >> +        dev->vlan_features &=3D ~(NETIF_F_ALL_TSO|NETIF_F_SG);
> >> +        dev->hw_features &=3D ~(NETIF_F_ALL_TSO|NETIF_F_SG);
> >> +        dev->features &=3D ~(NETIF_F_ALL_TSO|NETIF_F_SG);
> >>      }
> >>
> >> This seems to work since it restores performance without sg/tso by def=
ault
> >> and without any additional offloads, yet with xmit_more in the mix.
> >> We'll see whether that is stable over the next few days, but I strongl=
y
> >> suspect it will be good and that the hiccups were due to xmit_more/TSO
> >> interaction.
>
> So that didn't take long - got another timeout this morning during some
> random light usage, despite sg/tso being disabled this time.
> Again the only common element is the xmit_more patch. :(
> Not sure whether you want to revert this right away or wait for 5.4-rc1
> feedback. Maybe this too is chipset-specific?
>
> > Thanks a lot for the analysis and testing. Then I'll submit the disabli=
ng
> > of SG on RTL8168evl (on your behalf), independent of whether it fixes
> > the timeout issue.
>
> Got it, thanks!
>
> Holger

I would try this fix maybe ?

diff --git a/drivers/net/ethernet/realtek/r8169_main.c
b/drivers/net/ethernet/realtek/r8169_main.c
index b2a275d8504cf099cff738f2f7554efa9658fe32..e77628813daba493ad50dab9ac1=
e3703e38b560c
100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5691,6 +5691,7 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff =
*skb,
                 */
                smp_wmb();
                netif_stop_queue(dev);
+               door_bell =3D true;
        }

        if (door_bell)
