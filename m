Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 590F520A14
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 16:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfEPOsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 10:48:14 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:38862 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfEPOsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 10:48:13 -0400
Received: by mail-ed1-f42.google.com with SMTP id w11so5656951edl.5
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 07:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PWkMgEFWXWrp3MS64NoHr7Gqf9GYgzhG77S2ki9Xa20=;
        b=r6Ou/S2oMXgyTaTKLGQe6us0e2qCxuWdFo2wyPXg/123pvc8G6fI6vMwLCozZ3ouv7
         JEepcjPqKGurB6mSJQSnNoMuvVTFDLXAu4iXaaJ46eda5FCDSQV77jKzfqz9Mpii9XhV
         W5Unc1clKeOaugOG2dFeohRDMXkFpFRyJFWlkhFa9BPKnpGmxtKfZMNdNS9VOWsnOwV1
         jAekKQP4mfjANzG3ouZ5U4Is/xuZiWCA/8Mase/rrhVgKE+rcRwUqh6+ctcaB67C5Lvw
         m3Ir9929K2Vx3EZVqW7Qr2nT4JCIULOWo5dedd/NVcE6X8hOHukL63SLjdZ4kp4IZeto
         0bNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PWkMgEFWXWrp3MS64NoHr7Gqf9GYgzhG77S2ki9Xa20=;
        b=DDV8LDrsCAXN0pKsDhATNq3FaSBM9/PAnv27wtvo0q3yld+7wV4S+WnvZLigFHI8N9
         P5FODoKtvl/weq7p03ixtc6J9LUlKdmHtQuatnCVkl+B20Vi67tCeTfeBIonpR3ioQnK
         qRGZEraoxqloPQH8oXt6m2QifvEoKgaMt7gcmaBS1OkKLPAh7WYeihFfDUYgnj/zRDGl
         V63FcOgs3ttSeEoQZKUZJr1Dgn/5AXGaowDqlmja7PQPNthpOW14ojjMD7BOcfi74VOG
         FOnVg5W+kp8NvX6aztj62MNu1bQX/kLBE09tyq+VTDZANKtA4P38mWGWOQYDHRtw8b5+
         pctg==
X-Gm-Message-State: APjAAAWB3w+lFqLB0FUFignUH2v/F6YOm413I3yxWZqefVeWInXVggBd
        lsUhEHbjGvXTlYgmVR/FTOzP694Ul/5eGHmvqSg=
X-Google-Smtp-Source: APXvYqx2Mkvlg8Dv4B0VRFqq+ZqNHlFTs8l/tD/TniFV2rrW3ZQMaue7np+D9oqso/N0Hwd/vyFjwrgbMx4ZsYXeick=
X-Received: by 2002:a17:906:5e50:: with SMTP id b16mr16771531eju.287.1558018092001;
 Thu, 16 May 2019 07:48:12 -0700 (PDT)
MIME-Version: 1.0
References: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
In-Reply-To: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 16 May 2019 10:47:35 -0400
Message-ID: <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
Subject: Re: Kernel UDP behavior with missing destinations
To:     Adam Urban <adam.urban@appleguru.org>
Cc:     Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 3:57 PM Adam Urban <adam.urban@appleguru.org> wrote:
>
> We have an application where we are use sendmsg() to send (lots of)
> UDP packets to multiple destinations over a single socket, repeatedly,
> and at a pretty constant rate using IPv4.
>
> In some cases, some of these destinations are no longer present on the
> network, but we continue sending data to them anyways. The missing
> devices are usually a temporary situation, but can last for
> days/weeks/months.
>
> We are seeing an issue where packets sent even to destinations that
> are present on the network are getting dropped while the kernel
> performs arp updates.
>
> We see a -1 EAGAIN (Resource temporarily unavailable) return value
> from the sendmsg() call when this is happening:
>
> sendmsg(72, {msg_name(16)={sa_family=AF_INET, sin_port=htons(1234),
> sin_addr=inet_addr("10.1.2.3")}, msg_iov(1)=[{"\4\1"..., 96}],
> msg_controllen=0, msg_flags=0}, MSG_NOSIGNAL) = -1 EAGAIN (Resource
> temporarily unavailable)
>
> Looking at packet captures, during this time you see the kernel arping
> for the devices that aren't on the network, timing out, arping again,
> timing out, and then finally arping a 3rd time before setting the
> INCOMPLETE state again (very briefly being in a FAILED state).
>
> "Good" packets don't start going out again until the 3rd timeout
> happens, and then they go out for about 1s until the 3s delay from ARP
> happens again.
>
> Interestingly, this isn't an all or nothing situation. With only a few
> (2-3) devices missing, we don't run into this "blocking" situation and
> data always goes out. But once 4 or more devices are missing, it
> happens. Setting static ARP entries for the missing supplies, even if
> they are bogus, resolves the issue, but of course results in packets
> with a bogus destination going out on the wire instead of getting
> dropped by the kernel.
>
> Can anyone explain why this is happening? I have tried tuning the
> unres_qlen sysctl without effect and will next try to set the
> MSG_DONTWAIT socket option to try and see if that helps. But I want to
> make sure I understand what is going on.
>
> Are there any parameters we can tune so that UDP packets sent to
> INCOMPLETE destinations are immediately dropped? What's the best way
> to prevent a socket from being unavailable while arp operations are
> happening (assuming arp is the cause)?

Sounds like hitting SO_SNDBUF limit due to datagrams being held on the
neighbor queue. Especially since the issue occurs only as the number
of unreachable destinations exceeds some threshold. Does
/proc/net/stat/ndisc_cache show unresolved_discards? Increasing
unres_qlen may make matters only worse if more datagrams can get
queued. See also the branch on NUD_INCOMPLETE in __neigh_event_send.
