Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA0C3017FF
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 20:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbhAWTPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 14:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbhAWTPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 14:15:41 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D96DC061793
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:14:39 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id m1so7610259wrq.12
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MQFRWknyAl/1Cui1EOvTm7B+cIJiqUHswcy8wXBiXA8=;
        b=kbdtP7svCZOtpdcStxGmw5om25pdag+JRuyrNEvlgHWTi6K+aLa7v3k8uw6+6SYKz4
         CYvgsr1ekzd4vxWNkhYnzmQvYhvpaxJmEdx45ky0pxnrHbNLgiROLDTTTg0HpXXL58BZ
         e7owOOhsjf0SdgbC3d0PnP/n4bZRoqzAWKpbOB9QWuKZYlL0dbUZkuIt4Lj5k10Ojj5U
         L/NjSlus7svbG9FhetExmFbmKcEAbyg+TF3gNTkI1V8myo3ZrckffVsu6ucdCucnmWrh
         BUbW/wjyckg/748guHaUc5TVbzn8+Utyi9Z8A65/4PJd1ktj8vTsIZnOB1ZqBeVLBz/m
         u0/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MQFRWknyAl/1Cui1EOvTm7B+cIJiqUHswcy8wXBiXA8=;
        b=oYuqQKHCYgOc92pKPm2EBF2b5vpVnTvli2/dCdWsVrit+YmJasn0sml6ak+dyOyeTT
         jhYRH/t3MPWzmFaQ6osgJW3AdNSer+9Hir2YVU3tPIjomzsrr/JdMDzW8rARCQCVrPu8
         +HZKbNf6susMbcTRQChImrdlK0RKOn9UkwFCSf/iraJ16M70ANQX42ycWH/DY33+qt9b
         o0wwNpmXL23KL1SX20FVaFMk0A5hhXsQLJrlEHQ2dgAYbMUSO93vjngnYTfI4oif7XmR
         NSRdlz1oTT/VBBU2tp/VX/xSe6WFb06mQqg8Z+4DLxyl+Ebkg6oVzQiJ3UlclFCbNFlR
         +OHQ==
X-Gm-Message-State: AOAM530/HtzT+frWW09TCvUvQy/YQQDinlTRKctT8vXmkYaHIsBaxOZo
        kvLAtrWEO8/4oRNUGRsnEy5QzrVp5aJG7Doc4oaY7Q==
X-Google-Smtp-Source: ABdhPJxh01J0Hx2Ms0P6x7wiYu1s9OewRWH/lwY/T4sqBeVUJzgLDxZ8kH0q0tuZmVTuS+/+bzPnIlNFuRG2trDlguw=
X-Received: by 2002:adf:e38d:: with SMTP id e13mr5570386wrm.231.1611429277658;
 Sat, 23 Jan 2021 11:14:37 -0800 (PST)
MIME-Version: 1.0
References: <CAK6E8=dAyf+ajSFZ1eoA_BbVRDnLQRJwCL=t6vDBvEkCiquwxw@mail.gmail.com>
 <1611410338-12911-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1611410338-12911-1-git-send-email-yangpc@wangsu.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Sat, 23 Jan 2021 11:14:00 -0800
Message-ID: <CAK6E8=cQ1Y7+vqG9aCbBZbmrEX0GkhNHPL5SDHbzXy=bZauKnQ@mail.gmail.com>
Subject: Re: [PATCH net] tcp: fix TLP timer not set when CA_STATE changes from
 DISORDER to OPEN
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 5:27 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> On Sat, Jan 23, 2021 at 5:02 AM "Yuchung Cheng" <ycheng@google.com> wrote:
> >
> > On Fri, Jan 22, 2021 at 6:37 AM Neal Cardwell <ncardwell@google.com> wrote:
> > >
> > > On Fri, Jan 22, 2021 at 5:53 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Fri, Jan 22, 2021 at 11:28 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> > > > >
> > > > > When CA_STATE is in DISORDER, the TLP timer is not set when receiving
> > > > > an ACK (a cumulative ACK covered out-of-order data) causes CA_STATE to
> > > > > change from DISORDER to OPEN. If the sender is app-limited, it can only
> >
> > Could you point which line of code causes the state to flip
> > incorrectly due to the TLP timer setting?
> >
>
> I mean TLP timer is not set due to receiving an ACK that changes CA_STATE
> from DISORDER to OPEN.
Acked-by: Yuchung Cheng <ycheng@google.com>


Thanks for the clarification and the fix. The initial cmsg reads like
the timer setting is causing state flips. I'd suggest this commit
message in your next rev.

"Upon receiving a cumulative ACK that changes the congestion state
from Disorder to Open, the TLP timer is not set. If the sender is
app-limited, it can only wait for the RTO timer to expire and
retransmit.

The reason for this ... "


>
> Receive an ACK covered out-of-order data in disorder state:
>
> tcp_ack()
> |-tcp_set_xmit_timer()  // RTO timer is set instead of TLP timer
> |  ...
> |-tcp_fastretrans_alert() // change from disorder to open
>
> > > > > wait for the RTO timer to expire and retransmit.
> > > > >
> > > > > The reason for this is that the TLP timer is set before CA_STATE changes
> > > > > in tcp_ack(), so we delay the time point of calling tcp_set_xmit_timer()
> > > > > until after tcp_fastretrans_alert() returns and remove the
> > > > > FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer is set.
> > > > >
> > > > > This commit has two additional benefits:
> > > > > 1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
> > > > > avoid spurious RTO caused by RTO timer early expires.
> > > > > 2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
> > > > > timer is set.
> > > > >
> > > > > Link: https://lore.kernel.org/netdev/1611139794-11254-1-git-send-email-yangpc@wangsu.com
> > > > > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > > > > Cc: Neal Cardwell <ncardwell@google.com>
> > > > > ---
> > > >
> > > > This looks like a very nice patch, let me run packetdrill tests on it.
> > > >
> > > > By any chance, have you cooked a packetdrill test showing the issue
> > > > (failing on unpatched kernel) ?
> > >
> > > Thanks, Pengcheng. This patch looks good to me as well, assuming it
> > > passes our packetdrill tests. I agree with Eric that it would be good
> > > to have an explicit packetdrill test for this case.
> > >
> > > neal
>
> Here is a packetdrill test case:
>
> // Enable TLP
>     0 `sysctl -q net.ipv4.tcp_early_retrans=3`
>
> // Establish a connection
>    +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
>    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>    +0 bind(3, ..., ...) = 0
>    +0 listen(3, 1) = 0
>
> // RTT 100ms, RTO 300ms
>   +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
>    +0 > S. 0:0(0) ack 1 <...>
>   +.1 < . 1:1(0) ack 1 win 257
>    +0 accept(3, ..., ...) = 4
>
> // Send 4 data segments
>    +0 write(4, ..., 4000) = 4000
>    +0 > P. 1:4001(4000) ack 1
>
> // out-of-order: ca_state turns to disorder
>   +.1 < . 1:1(0) ack 1 win 257 <sack 1001:2001,nop,nop>
>
> // ACK covered out-of-order data: ca_state turns to open,
> // but RTO timer is set instead of TLP timer and the RTO
> // timer will expire at rtx_head_time+RTO (in 200ms).
>    +0 < . 1:1(0) ack 2001 win 257
>
> // Expect to send TLP packet in 2*rtt (200ms)
> +.2~+.25 > P. 3001:4001(1000) ack 1
>
>
> I ran this packetdrill test case on the kernel without
> the patch applied:
>
> tlp_timer_unset.pkt:31: error handling packet: live packet
> field tcp_seq: expected: 3001 (0xbb9) vs actual: 2001 (0x7d1)
> script packet:  0.644587 P. 3001:4001(1000) ack 1
> actual packet:  0.646197 . 2001:3001(1000) ack 1 win 502
>
