Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B011196830
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 18:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgC1Rml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 13:42:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53385 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgC1Rmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 13:42:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id b12so15004831wmj.3;
        Sat, 28 Mar 2020 10:42:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kd3IHVOoWilpVKmOv2R0KTVrxQn6hoapvMbqPZo9anE=;
        b=AYQIwqSG4zFO1Rk28PWE6PhaSYEM//SKwRs8+9Ea9AObH1/X/yaCPW752L05g3XVTH
         DkyCeFgUydp5REbhvAEpb44JZJXlKbsx67nEX4uptQXUiZwU+EBAAUDnr8nAWnmB49Gx
         x1z5tIavoV8lid64klCWbMQvpX5SdR7Y4OUmmp7BQNC+cjzT9H+Fh8Nw5t5Hs9upXyjE
         fRPz4rNCOvgxgamKvcg6UxbzFzpz0QQSeI7QbbkuW1SGAjt5gwF4s5VWwXl8QKw2DJmq
         ZTIAVEIeCpc4W6ce+lW8tgmJU3ycU/cTr4qTRROxVCeOwdwIfNU7+3+bXGvUQY5dNEeC
         gVzg==
X-Gm-Message-State: ANhLgQ2tx7NiDfQLV0FMISOGnCobsfyca2mCj9Hhr08zeDGlozghJH25
        uxm64I98zFx0oJASkIXXv3V3C4yuodTLQdTue3Y=
X-Google-Smtp-Source: ADFU+vsFGl/l4ujYMiscFEzlNal+N2cjjrlAVVEe4Ovah2Yx/rciOhDFQ2f90FxIKhWWUQ52+tQxr8NkQ6Ahwk2/Xiw=
X-Received: by 2002:a7b:c205:: with SMTP id x5mr233203wmi.189.1585417358602;
 Sat, 28 Mar 2020 10:42:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200327042556.11560-1-joe@wand.net.nz> <20200327184621.67324727o5rtu42p@kafai-mbp>
 <CAOftzPjv8rcP7Ge59fc4rhy=BR2Ym1=G3n3fvi402nx61zLf-Q@mail.gmail.com> <7e58a449-16a1-0cbd-f133-7d612a82fae1@iogearbox.net>
In-Reply-To: <7e58a449-16a1-0cbd-f133-7d612a82fae1@iogearbox.net>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Sat, 28 Mar 2020 10:42:27 -0700
Message-ID: <CAOftzPj9a59FXi+xnU5vCTGhZ4m+xXPed3q8qkH35PNj6kBOaA@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 0/5] Add bpf_sk_assign eBPF helper
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Joe Stringer <joe@wand.net.nz>, Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 28, 2020 at 10:26 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/27/20 10:05 PM, Joe Stringer wrote:
> > On Fri, Mar 27, 2020 at 11:46 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >>
> >> On Thu, Mar 26, 2020 at 09:25:51PM -0700, Joe Stringer wrote:
> >>> Introduce a new helper that allows assigning a previously-found socket
> >>> to the skb as the packet is received towards the stack, to cause the
> [...]
> >>> Changes since v1:
> >>> * Replace the metadata_dst approach with using the skb->destructor to
> >>>    determine whether the socket has been prefetched. This is much
> >>>    simpler.
> >>> * Avoid taking a reference on listener sockets during receive
> >>> * Restrict assigning sockets across namespaces
> >>> * Restrict assigning SO_REUSEPORT sockets
> >>> * Fix cookie usage for socket dst check
> >>> * Rebase the tests against test_progs infrastructure
> >>> * Tidy up commit messages
> >> lgtm.
> >>
> >> Acked-by: Martin KaFai Lau <kafai@fb.com>
> >
> > Thanks for the reviews!
> >
> > I've rolled in the current nits + acks into the branch below, pending
> > any further feedback. Alexei, happy to respin this on the mailinglist
> > at some point if that's easier for you.
> >
> > https://github.com/joestringer/linux/tree/submit/bpf-sk-assign-v3+
>
> Please send the updated series to the list with Martin's ACK retained, so
> that we can process the series through our patchwork scripts wrt formatting,
> tags etc (please also make sure it's rebased).

Sure thing, will send it out soon.
