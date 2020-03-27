Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B395195EFA
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgC0TnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:43:05 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:45582 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgC0TnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:43:05 -0400
Received: by mail-yb1-f193.google.com with SMTP id g6so5187744ybh.12
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 12:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WsDaqpOfdJyz3/1vqVgKkW/VeTqkoGhUWwj/b7cFsQw=;
        b=c1OUjtGMkC5Jc9yAna3EWfexOC6ofMftUltKVpAuQZ8l5uL0k6TPJoP1nVuRzHVaki
         ow7NzwHkGuIxv1WRXstqeBErg+r38wYey9MhbXTwHGxymOkKd00st57XpZa6m0yJsxOj
         tq5D5i1EzCCP5l3aod1w/5cld8korY8+dc/gP8+KsFb1tLsxeLTTjp1fapiR/ANuu/sJ
         3CAnTTWthcePUFv7mgqsFlFAYtM/eyII/V58TZyGDa//9COoADxixxvgg/Pm4V/F+MQU
         RU+7R/dRMcpZmFLGWSKQR8ocY9NWErCa+a9LiQBiqqV8zK7Ub/PYe7mGz1OJi6lPYxyT
         0piQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WsDaqpOfdJyz3/1vqVgKkW/VeTqkoGhUWwj/b7cFsQw=;
        b=uEI+GM1VTgbglfgy1KLwZl1X8VbNf/lBsNLhth9B13eVQLsm/xIhXkRDriTevPH7Nc
         4tehYD83KBL69vDcqoPZeXEaEbxAot0+c7FS8y33m8hZRbMI3bC4USxroMrKzRLDr7wn
         5EQj+ZLzJGEfI/oUk6Z+WICev+pVgpmnw3hBhOq8pfo1ZkASKbyYEOrsx6Ieb+27xSua
         OyuC4uPYpo+UnrOG/B32ddCx2YWC+/iDhnY4nJeLgGSjdDbCA9foRDiq6fr/56a0UE8d
         M2lI/zP92fu6KqEBUIr6kxPk2d2mLveBgKdga0Irnkih4j7EmiD8IkI1bg94wqELTFbc
         EPJA==
X-Gm-Message-State: ANhLgQ13kBOyVPcSN3Lvk8L6aLJWBlhLruB4OMePxESwNK0n0a9eWNHt
        mdliTtU9fuRAI1aVOrUUHgwNbGy/y3fCjPaOfZmHNg==
X-Google-Smtp-Source: ADFU+vsySDTvywL+P3nSwy0x7nMCi96EABiQdRZWF/z0eTarOa+c4QaRrDRxh7yOtSdGdAdGjiQkyrAwRxhJ8qQp6ng=
X-Received: by 2002:a25:c206:: with SMTP id s6mr706470ybf.101.1585338183506;
 Fri, 27 Mar 2020 12:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com> <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com> <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com>
In-Reply-To: <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 27 Mar 2020 12:42:51 -0700
Message-ID: <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Charles Daymand <charles.daymand@wifirst.fr>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 12:17 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 27.03.2020 19:52, Eric Dumazet wrote:
> > On Fri, Mar 27, 2020 at 10:41 AM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >>
> >> On 27.03.2020 10:39, Heiner Kallweit wrote:
> >>> On 27.03.2020 10:08, Charles Daymand wrote:
> >>>> During kernel upgrade testing on our hardware, we found that macvlan
> >>>> interface were no longer able to send valid multicast packet.
> >>>>
> >>>> tcpdump run on our hardware was correctly showing our multicast
> >>>> packet but when connecting a laptop to our hardware we didn't see any
> >>>> packets.
> >>>>
> >>>> Bisecting turned up commit 93681cd7d94f
> >>>> "r8169: enable HW csum and TSO" activates the feature NETIF_F_IP_CSUM
> >>>> which is responsible for the drop of packet in case of macvlan
> >>>> interface. Note that revision RTL_GIGA_MAC_VER_34 was already a specific
> >>>> case since TSO was keep disabled.
> >>>>
> >>>> Deactivating NETIF_F_IP_CSUM using ethtool is correcting our multicast
> >>>> issue, but we believe that this hardware issue is important enough to
> >>>> keep tx checksum off by default on this revision.
> >>>>
> >>>> The change is deactivating the default value of NETIF_F_IP_CSUM for this
> >>>> specific revision.
> >>>>
> >>>
> >>> The referenced commit may not be the root cause but just reveal another
> >>> issue that has been existing before. Root cause may be in the net core
> >>> or somewhere else. Did you check with other RTL8168 versions to verify
> >>> that it's indeed a HW issue with this specific chip version?
> >>>
> >>> What you could do: Enable tx checksumming manually (via ethtool) on
> >>> older kernel versions and check whether they are fine or not.
> >>> If an older version is fine, then you can start a new bisect with tx
> >>> checksumming enabled.
> >>>
> >>> And did you capture and analyze traffic to verify that actually the
> >>> checksum is incorrect (and packets discarded therefore on receiving end)?
> >>>
> >>>
> >>>> Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> >>>> Signed-off-by: Charles Daymand <charles.daymand@wifirst.fr>
> >>>> ---
> >>>>  net/drivers/net/ethernet/realtek/r8169_main.c | 3 +++
> >>>>  1 file changed, 3 insertions(+)
> >>>>
> >>>> diff --git a/net/drivers/net/ethernet/realtek/r8169_main.c b/net/drivers/net/ethernet/realtek/r8169_main.c
> >>>> index a9bdafd15a35..3b69135fc500 100644
> >>>> --- a/net/drivers/net/ethernet/realtek/r8169_main.c
> >>>> +++ b/net/drivers/net/ethernet/realtek/r8169_main.c
> >>>> @@ -5591,6 +5591,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
> >>>>              dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
> >>>>              dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
> >>>>              dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
> >>>> +            if (tp->mac_version == RTL_GIGA_MAC_VER_34) {
> >>>> +                    dev->features &= ~NETIF_F_IP_CSUM;
> >>>> +            }
> >>>>      }
> >>>>
> >>>>      dev->hw_features |= NETIF_F_RXALL;
> >>>>
> >>>
> >>
> >> After looking a little bit at the macvlen code I think there might be an
> >> issue in it, but I'm not sure, therefore let me add Eric (as macvlen doesn't
> >> seem to have a dedicated maintainer).
> >>
> >> r8169 implements a ndo_features_check callback that disables tx checksumming
> >> for the chip version in question and small packets (due to a HW issue).
> >> macvlen uses passthru_features_check() as ndo_features_check callback, this
> >> seems to indicate to me that the ndo_features_check callback of lowerdev is
> >> ignored. This could explain the issue you see.
> >>
> >
> > macvlan_queue_xmit() calls dev_queue_xmit_accel() after switching skb->dev,
> > so the second __dev_queue_xmit() should eventually call the real_dev
> > ndo_features_check()
> >
> Thanks, Eric. There's a second path in macvlan_queue_xmit() calling
> dev_forward_skb(vlan->lowerdev, skb). Does what you said apply also there?

This path wont send packets to the physical NIC, packets are injected
back via dev_forward_skb()

>
> Still I find it strange that a tx hw checksumming issue should affect multicasts
> only. Also the chip version in question is quite common and I would expect
> others to have hit the same issue.
> Maybe best would be to re-test on the affected system w/o involving macvlen.
>
> >
> >
> >> Would be interesting to see whether it fixes your issue if you let the
> >> macvlen ndo_features_check call lowerdev's ndo_features_check. Can you try this?
> >>
> >> By the way:
> >> Also the ndo_fix_features callback of lowerdev seems to be ignored.
>
