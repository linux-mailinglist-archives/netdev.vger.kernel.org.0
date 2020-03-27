Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6969F195DE8
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgC0SwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:52:25 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:37757 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgC0SwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:52:25 -0400
Received: by mail-yb1-f196.google.com with SMTP id n2so3783191ybg.4
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 11:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oXyY9Cqkpt36UF3g2G9meMulmiGW65IttpetEawfwP0=;
        b=bAfDi4wVZ13V/KsPYxR72wsWOv/zTEHmTZimx689hqU8pjrdWw3aEEr+QzWvLSP9LV
         qZ3cXi+YjHBPsQv+5K3DBnYpMEpRYuH4KMoNemoLp/mGBLSa1fEkBoKfP8X/hlIB9YMH
         zjebawG9GQucFlvrkBSNFYMbkZbk218wDUQWPqJ0mnh1rH5nidpRVJrJYUnLVlb5qtGT
         vngEreUroI/4cGPg1aX+195SjlbwNf/u4PIjC9AD9cBWNZFgMelCE4XnVAtShbn8xyHd
         J3vg0IofQjb3n8qTdIGkCzGckOu3WnhVHX0iXHnGx8oOgg2Cl2VAdNBKuM3chj+CiyMh
         Da7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oXyY9Cqkpt36UF3g2G9meMulmiGW65IttpetEawfwP0=;
        b=ajacvGHWuYA4cmOPwvtXMfj7H9F078K6Zmp/6MB5jeW+iRE1axVTk70rR0/V+1Qgdg
         CzyAS69hgiLvcqNtJGDYteneLPQ/EP1Jm04AXFJxVZRe+qVn6HzPGK8Sx2r4hBeGb5iz
         +5hx7eJQEfRvGFdXWTTw+4vDRdfF7oYgieLG2jy9v3/aX5cs1r9jO/aqbpVnE9AIEgGH
         W5LY728Meb8EgAXoXHzyJtBFKVyz/+4mHv9xK18mUuU/ZIb2wBxv2m5TsiuuJKESJH7A
         qf92nCavhCZe2MHs1rfG/BgfZ/4U0jpQFMhbQi6QUoLJaAaafFDc2DOP5tQmlPOlXato
         DnhQ==
X-Gm-Message-State: ANhLgQ3Docgt+ECl5SKeTxDGvJ4V9/SBV2QywqbeExNuXApVwSwKMrRS
        uX0dsrhVstTAwmxhmkCHEx6EL8WIgjyjVt7FcvMVmw==
X-Google-Smtp-Source: ADFU+vvoNXNYQmeFw77RLjJrbXZDkxnJqipea5fEYeiIFGZES1Ln3PrzE3jjGZL8BrhQpgI7ovSWQrYyjo4A0H3JeLM=
X-Received: by 2002:a25:c206:: with SMTP id s6mr311809ybf.101.1585335143719;
 Fri, 27 Mar 2020 11:52:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com> <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
In-Reply-To: <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 27 Mar 2020 11:52:12 -0700
Message-ID: <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Charles Daymand <charles.daymand@wifirst.fr>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 10:41 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 27.03.2020 10:39, Heiner Kallweit wrote:
> > On 27.03.2020 10:08, Charles Daymand wrote:
> >> During kernel upgrade testing on our hardware, we found that macvlan
> >> interface were no longer able to send valid multicast packet.
> >>
> >> tcpdump run on our hardware was correctly showing our multicast
> >> packet but when connecting a laptop to our hardware we didn't see any
> >> packets.
> >>
> >> Bisecting turned up commit 93681cd7d94f
> >> "r8169: enable HW csum and TSO" activates the feature NETIF_F_IP_CSUM
> >> which is responsible for the drop of packet in case of macvlan
> >> interface. Note that revision RTL_GIGA_MAC_VER_34 was already a specific
> >> case since TSO was keep disabled.
> >>
> >> Deactivating NETIF_F_IP_CSUM using ethtool is correcting our multicast
> >> issue, but we believe that this hardware issue is important enough to
> >> keep tx checksum off by default on this revision.
> >>
> >> The change is deactivating the default value of NETIF_F_IP_CSUM for this
> >> specific revision.
> >>
> >
> > The referenced commit may not be the root cause but just reveal another
> > issue that has been existing before. Root cause may be in the net core
> > or somewhere else. Did you check with other RTL8168 versions to verify
> > that it's indeed a HW issue with this specific chip version?
> >
> > What you could do: Enable tx checksumming manually (via ethtool) on
> > older kernel versions and check whether they are fine or not.
> > If an older version is fine, then you can start a new bisect with tx
> > checksumming enabled.
> >
> > And did you capture and analyze traffic to verify that actually the
> > checksum is incorrect (and packets discarded therefore on receiving end)?
> >
> >
> >> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> >> Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr>
> >> ---
> >>  net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c b/net/drivers/net/ethernet/realtek/r8169_main.c
> >> index a9bdafd15a35..3b69135fc500 100644
> >> --- a/net/drivers/net/ethernet/realtek/r8169_main.c
> >> +++ b/net/drivers/net/ethernet/realtek/r8169_main.c
> >> @@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >>              dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
> >>              dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
> >>              dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
> >> +            if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
> >> +                    dev->features &= ~NETIF_F_IP_CSUM;
> >> +            }
> >>      }
> >>
> >>      dev->hw_features |= NETIF_F_RXALL;
> >>
> >
>
> After looking a little bit at the macvlen code I think there might be an
> issue in it, but I'm not sure, therefore let me add Eric (as macvlen doesn't
> seem to have a dedicated maintainer).
>
> r8169 implements a ndo_features_check callback that disables tx checksumming
> for the chip version in question and small packets (due to a HW issue).
> macvlen uses passthru_features_check() as ndo_features_check callback, this
> seems to indicate to me that the ndo_features_check callback of lowerdev is
> ignored. This could explain the issue you see.
>

macvlan_queue_xmit() calls dev_queue_xmit_accel() after switching skb->dev,
so the second __dev_queue_xmit() should eventually call the real_dev
ndo_features_check()



> Would be interesting to see whether it fixes your issue if you let the
> macvlen ndo_features_check call lowerdev's ndo_features_check. Can you try this?
>
> By the way:
> Also the ndo_fix_features callback of lowerdev seems to be ignored.
