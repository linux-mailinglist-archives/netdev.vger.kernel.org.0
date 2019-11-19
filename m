Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202F61021B0
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfKSKJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:09:08 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38682 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbfKSKJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 05:09:07 -0500
Received: by mail-qk1-f195.google.com with SMTP id e2so17252263qkn.5
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 02:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kthzsFDv3BtXMmmJRQd1qCPqKASHhxamk1aLgY0fuLQ=;
        b=kPWwFSfnlnu9XmSpJkG19s/iNALUrvrShZ1C2Czk8j+q0g1ifRmXzjO7YHXd0Q1dOX
         Ken9OddoZlUkmrM9m+umBzKw13kRR7mNzFg1wI+oC8dS+YLk616rxc5Sg81P5atJpGYd
         qSO9RCZZX9iN4OJKVboKydfL/0ODVcP/UVn+Ts03/6e7WHZEzvm/d7lj5rlvE/wBFAAM
         VyYt0jJPsXOrT4UMMEdVd5dQ6guTn7n0ZMGStIqBOF5PwnXSg/TNiFkg31py0Zypjp5j
         vrSh7+Qq3R1ZqjtFGdovVZ0OaPYXl/RW7Jox8/Ua90XBVBAgc/coO/Zw1cCQa2J3oKOU
         Ydhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kthzsFDv3BtXMmmJRQd1qCPqKASHhxamk1aLgY0fuLQ=;
        b=UcohT1tEiuZO47PpMxArOvP61QE9ppqmMGPuijP+ysAukcC9dF3+d8U7to/x4tX0Dj
         mqJrU1aro0reBWLUqnloyG9M7XRI5D1D3sObkLCc68hBAD2IhSImrJpjgpxWva6zcuV3
         4DrvbzuWvfyP/nablwfIWr0Ab7HGyUrLCsS5C+O4X8p6X6d9ue6qONFehqDvP6ZV89xk
         2KtkjM14avS1OogDxUJx5QOO03KoE/WYsIBFglJnyWzOGFIT89DmWHoHzy5xCdGr09W8
         SAHOEDiND/CRzs5stSlkK1WCfSwVDDiVs7Re4ZdjEpfRDAiE8ydnVX8an5E3Juc5xEMz
         NXzg==
X-Gm-Message-State: APjAAAXGlw4f1rnDn3DYJQWaqOX7RjWHa2l37iDNYCPykjoijkApQRWq
        flh/WIVOB8Op1XQYA/1+gEOWM1vB4hTG3R/mAgjQAg==
X-Google-Smtp-Source: APXvYqz3sW+a1UoaZIdKYgIlbIKJ5VYWfPjuUI7mT8jMQMykt/NPr28fXvPHFDM4PpsUCVdsAZOz5StnaJQW1bzfBxo=
X-Received: by 2002:a37:6156:: with SMTP id v83mr27936505qkb.43.1574158143641;
 Tue, 19 Nov 2019 02:09:03 -0800 (PST)
MIME-Version: 1.0
References: <0000000000005c08d10597a3a05d@google.com> <a5f73d92-fdf2-2590-c863-39a181dca8e1@hartkopp.net>
 <deedd609-6f3b-8035-47e1-252ab221faa1@pengutronix.de> <7934bc2b-597f-0bb3-be2d-32f3b07b4de9@hartkopp.net>
 <7f5c4546-0c1a-86ae-581e-0203b5fca446@pengutronix.de> <1f7d6ea7-152e-ff18-549c-b196d8b5e3a7@hartkopp.net>
In-Reply-To: <1f7d6ea7-152e-ff18-549c-b196d8b5e3a7@hartkopp.net>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 19 Nov 2019 11:08:52 +0100
Message-ID: <CACT4Y+acOwzqwrJ1OSStRkvdxsmM4RY6mz4qDEFAUpMM2P-FiQ@mail.gmail.com>
Subject: Re: KMSAN: uninit-value in can_receive
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Alexander Potapenko <glider@google.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        syzbot <syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, linux-can@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 8:36 AM Oliver Hartkopp <socketcan@hartkopp.net> wrote:
> On 18/11/2019 22.15, Marc Kleine-Budde wrote:
> > On 11/18/19 9:49 PM, Oliver Hartkopp wrote:
> >>
> >>
> >> On 18/11/2019 21.29, Marc Kleine-Budde wrote:
> >>> On 11/18/19 9:25 PM, Oliver Hartkopp wrote:
> >>
> >>>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >>>>> Reported-by: syzbot+b02ff0707a97e4e79ebb@syzkaller.appspotmail.com
> >>>>>
> >>>>> =====================================================
> >>>>> BUG: KMSAN: uninit-value in can_receive+0x23c/0x5e0 net/can/af_can.c:649
> >>>>> CPU: 1 PID: 3490 Comm: syz-executor.2 Not tainted 5.4.0-rc5+ #0
> >>
> >>>>
> >>>> In line 649 of 5.4.0-rc5+ we can find a while() statement:
> >>>>
> >>>> while (!(can_skb_prv(skb)->skbcnt))
> >>>>    can_skb_prv(skb)->skbcnt = atomic_inc_return(&skbcounter);
> >>>>
> >>>> In linux/include/linux/can/skb.h we see:
> >>>>
> >>>> static inline struct can_skb_priv *can_skb_prv(struct sk_buff *skb)
> >>>> {
> >>>>    return (struct can_skb_priv *)(skb->head);
> >>>> }
> >>>>
> >>>> IMO accessing can_skb_prv(skb)->skbcnt at this point is a valid
> >>>> operation which has no uninitialized value.
> >>>>
> >>>> Can this probably be a false positive of KMSAN?
> >>>
> >>> The packet is injected via the packet socket into the kernel. Where does
> >>> skb->head point to in this case? When the skb is a proper
> >>> kernel-generated skb containing a CAN-2.0 or CAN-FD frame skb->head is
> >>> maybe properly initialized?
> >>
> >> The packet is either received via vcan or vxcan which checks via
> >> can_dropped_invalid_skb() if we have a valid ETH_P_CAN type skb.
> >
> > According to the call stack it's injected into the kernel via a packet
> > socket and not via v(x)can.
>
> See ioctl$ifreq https://syzkaller.appspot.com/x/log.txt?x=14563416e00000
>
> 23:11:34 executing program 2:
> r0 = socket(0x200000000000011, 0x3, 0x0)
> ioctl$ifreq_SIOCGIFINDEX_vcan(r0, 0x8933,
> &(0x7f0000000040)={'vxcan1\x00', <r1=>0x0})
> bind$packet(r0, &(0x7f0000000300)={0x11, 0xc, r1}, 0x14)
> sendmmsg(r0, &(0x7f0000000d00), 0x400004e, 0x0)
>
> We only can receive skbs from (v(x))can devices.
> No matter if someone wrote to them via PF_CAN or PF_PACKET.
> We check for ETH_P_CAN(FD) type and ARPHRD_CAN dev type at rx time.
>
> >> We additionally might think about introducing a check whether we have a
> >> can_skb_reserve() created skbuff.
> >>
> >> But even if someone forged a skbuff without this reserved space the
> >> access to can_skb_prv(skb)->skbcnt would point into some CAN frame
> >> content - which is still no access to uninitialized content, right?
>
> So this question remains still valid whether we have a false positive
> from KMSAN here.

+Alex, please check re KMSAN false positive.
Oliver, Marc, where this skbcnt should have been initialized in this case?
