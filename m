Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFBC2CDF35
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 20:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgLCTxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 14:53:50 -0500
Received: from smtp2.cs.stanford.edu ([171.64.64.26]:60434 "EHLO
        smtp2.cs.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLCTxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 14:53:50 -0500
Received: from mail-lf1-f42.google.com ([209.85.167.42]:37691)
        by smtp2.cs.Stanford.EDU with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1kkuf6-0006xL-ON
        for netdev@vger.kernel.org; Thu, 03 Dec 2020 11:53:09 -0800
Received: by mail-lf1-f42.google.com with SMTP id s30so4503562lfc.4
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 11:53:08 -0800 (PST)
X-Gm-Message-State: AOAM530jSOTBQB5RdLUa8/5UdMMu17wczabiUK/NeTrSkCpONpwZ8Qmy
        ntLKQ0as4JHQkCumSdHLtIa6QvY7q3xrkeNvNR0=
X-Google-Smtp-Source: ABdhPJygrff0lafCRhctFEzvVg4kizLQGV9Or8JbS0Icov8W6ZgN+hLx8jAKeYvn5V71rJlGOO4qhMVS6LNVcRCMBwM=
X-Received: by 2002:a19:c6d3:: with SMTP id w202mr2030869lff.8.1607025187563;
 Thu, 03 Dec 2020 11:53:07 -0800 (PST)
MIME-Version: 1.0
References: <CAGXJAmx_xQr56oiak8k8MC+JPBNi+tQBtTvBRqYVsimmKtW4MA@mail.gmail.com>
 <72f3ea21-b4bd-b5bd-f72f-be415598591f@gmail.com>
In-Reply-To: <72f3ea21-b4bd-b5bd-f72f-be415598591f@gmail.com>
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Thu, 3 Dec 2020 11:52:30 -0800
X-Gmail-Original-Message-ID: <CAGXJAmwEEnhX5KBvPZmwOKF_0hhVuGfvbXsoGR=+vB8bGge1sQ@mail.gmail.com>
Message-ID: <CAGXJAmwEEnhX5KBvPZmwOKF_0hhVuGfvbXsoGR=+vB8bGge1sQ@mail.gmail.com>
Subject: Re: GRO: can't force packet up stack immediately?
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: -1.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin on smtp2.cs.Stanford.EDU
X-Scan-Signature: 127ff6e1eac6b45a32dc112250ed777d
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Homa uses GRO to collect batches of packets for protocol processing,
but there are times when it wants to push a batch of packet up through
the stack immediately (it doesn't want any more packets to be
processed at NAPI level before pushing the batch up). However, I can't
see a way to achieve this goal. I can return a packet pointer as the
result of homa_gro_receive (and this used to be sufficient to push the
packet up the stack). What happens now is:
* dev_gro_receive calls napi_gro_complete (same as before)
* napi_gro_complete calls gro_normal_one, whereas it used to call
netif_receive_skb_internal
* gro_normal_one just adds the packet to napi->rx_list.

Then NAPI-level packet processing continues, until eventually
napi_complete_done is called; it invokes gro_normal_list, which calls
netif_receive_skb_list_internal.

Because of this, packets can be delayed several microseconds before
they are pushed up the stack. Homa is trying to squeeze out latency,
so the extra delay is undesirable.

-John-

On Thu, Dec 3, 2020 at 11:35 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 12/3/20 8:03 PM, John Ousterhout wrote:
> > I recently upgraded my kernel module implementing the Homa transport
> > protocol from 4.15.18 to 5.4.80, and a GRO feature available in the
> > older version seems to have gone away in the newer version. In
> > particular, it used to be possible for a protocol's xxx_gro_receive
> > function to force a packet up the stack immediately by returning that
> > skb as the result of xxx_gro_receive. However, in the newer kernel
> > version, these packets simply get queued on napi->rx_list; the queue
> > doesn't get flushed up-stack until napi_complete_done is called or
> > gro_normal_batch packets accumulate. For Homa, this extra level of
> > queuing gets in the way.
>
>
> Could you describe what the issue is ?
>
> >
> > Is there any way for a xxx_gro_receive function to force a packet (in
> > particular, one of those in the list passed as first argument to
> > xxx_gro_receive) up the protocol stack immediately? I suppose I could
> > set gro_normal_batch to 1, but that might interfere with other
> > protocols that really want the batching.
> >
> > -John-
> >
