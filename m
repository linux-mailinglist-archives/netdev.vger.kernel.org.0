Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0FA300E73
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 22:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728506AbhAVVE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 16:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730926AbhAVVDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 16:03:30 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0940C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 13:02:48 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id l12so6356391wry.2
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 13:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q5FqMq8XEP9Kv7VKZkVK14Fonu9ZgFFzeE8qV8A/YE4=;
        b=XUdFTFd8sn7j/aYegGhQ1Dwe7T8vKTs6mEW0JmHX7xlb3DYEbvojqgVCW9+u0NGqYp
         ACWGp4nb8wGKCRXuK1IjL1ziCOnKnAYgTJL6ZjtPLUnnoh7bPQqoVFpClGJR4yfHczT9
         h3Xiq8uj7Cf8mWjThzzr0Amd7DxCiuhHLBT3gK64LGjqMZQoZYSVc2ehseYF8MMw0xgi
         1v1wC11OlXv61xG+1rIP3tZS0fUzNwfKF2h+9bjXUX0e8erv+rxVtxdRpF69WAk4OsfY
         XEXPRYXHKm62xlC1yI+nnSEQgyBZyZ4TnU7Ee8RVXlo30s8n0bnzBaJbF77DyncFwfuM
         34Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q5FqMq8XEP9Kv7VKZkVK14Fonu9ZgFFzeE8qV8A/YE4=;
        b=kXXM7bxtJ2/2zrjAz+f9n2Z7uROQB7XULKadOaoE1HadGJ30p3ZKxAjm+L0+231503
         rPNX1eMYCzxj/KJ7BB399A/nJQUUV8LM3RGzX7lsvFeC2oKsHSDTERj85tsPcIZx2QHq
         1dJu14fTVSAPhktljqZKMBExuL18egnNKIbR5sHnDd00Zsi9wl0WBJQAnJrL87qdjiiS
         6hoNbxu6YbbVrRtxE614h9PbTOE91zlWrX/Oc1nwJ4WpWFMeZNID+4K11sfI0ujbgEBo
         LfuyyJYhTBnwrMmgdQhUD33Wrun8AIGLOC5rnPQu4ORlP/K7zONW6DJdBiULyaz7nIZL
         F6Gw==
X-Gm-Message-State: AOAM5316o/rb0cxJoa8N+mPtvNPnhFDhj72zMN6V+VQPtfJCCroy0eYR
        o6CoB+08Iog0kw5+f7MqvdXpPzu7kAiqIosN1Vuh9Q==
X-Google-Smtp-Source: ABdhPJw48BcTBKmY0hoIlUcKh3pQm5bpRlEi91puKNIsep1KIp8OYrAsisFhKebCvh6dayyulyNJ5sPvp+/+76g3pMo=
X-Received: by 2002:a5d:4cd1:: with SMTP id c17mr6285516wrt.49.1611349367428;
 Fri, 22 Jan 2021 13:02:47 -0800 (PST)
MIME-Version: 1.0
References: <1611311242-6675-1-git-send-email-yangpc@wangsu.com>
 <CANn89iJoBeApn6y8k9xv_FZCGKG8n1GyXb9SKYq+LGBTp52cag@mail.gmail.com> <CADVnQynw7_4wJTUBHTnQ91rEoXKK+LuS1NQHdpYNhQs3CnMfsg@mail.gmail.com>
In-Reply-To: <CADVnQynw7_4wJTUBHTnQ91rEoXKK+LuS1NQHdpYNhQs3CnMfsg@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 22 Jan 2021 13:02:10 -0800
Message-ID: <CAK6E8=dAyf+ajSFZ1eoA_BbVRDnLQRJwCL=t6vDBvEkCiquwxw@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix TLP timer not set when CA_STATE changes from
 DISORDER to OPEN
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Pengcheng Yang <yangpc@wangsu.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 6:37 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Fri, Jan 22, 2021 at 5:53 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, Jan 22, 2021 at 11:28 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> > >
> > > When CA_STATE is in DISORDER, the TLP timer is not set when receiving
> > > an ACK (a cumulative ACK covered out-of-order data) causes CA_STATE to
> > > change from DISORDER to OPEN. If the sender is app-limited, it can only

Could you point which line of code causes the state to flip
incorrectly due to the TLP timer setting?

> > > wait for the RTO timer to expire and retransmit.
> > >
> > > The reason for this is that the TLP timer is set before CA_STATE changes
> > > in tcp_ack(), so we delay the time point of calling tcp_set_xmit_timer()
> > > until after tcp_fastretrans_alert() returns and remove the
> > > FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer is set.
> > >
> > > This commit has two additional benefits:
> > > 1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
> > > avoid spurious RTO caused by RTO timer early expires.
> > > 2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
> > > timer is set.
> > >
> > > Link: https://lore.kernel.org/netdev/1611139794-11254-1-git-send-email-yangpc@wangsu.com
> > > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > > Cc: Neal Cardwell <ncardwell@google.com>
> > > ---
> >
> > This looks like a very nice patch, let me run packetdrill tests on it.
> >
> > By any chance, have you cooked a packetdrill test showing the issue
> > (failing on unpatched kernel) ?
>
> Thanks, Pengcheng. This patch looks good to me as well, assuming it
> passes our packetdrill tests. I agree with Eric that it would be good
> to have an explicit packetdrill test for this case.
>
> neal
