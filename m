Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2883255736
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbfFYS3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:29:21 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36168 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727138AbfFYS3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:29:20 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so17808705wrs.3
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:29:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5lMQyYjvaWZUSyr7PpIB+ezTZriyAAalCYsnvnsHxVc=;
        b=nKYhpcxttSffgmMUaAO7L7v9psBF44EqdH1g8yc/gqkIR21DRdr8v8GvX222mSEn4K
         jUdAuamG7QNmXttKLjNmh+4Ut4VXZ7xb9aq89Riseet+G4mZQ7woQ4ThyDBlmjq2N4o1
         OCiDke1gpTH/jF+O+VBaeUPneH5YftJmtpo2n9Aupd3/xtg+5DW5mO0WBUNao+0kjeVN
         c5IuwQoe5iMiOqtgjhLRONBaXU7zIMjq9oyZeZk/AG8rBLFb5Czu5sRDcVEnZ0rcF+Sn
         YJYgmq5/60/SpjAldvShe6ILGcputJbZfIk+dESc90631Eaqz3fJICAcnXqgrRs8Ir1Q
         9iGg==
X-Gm-Message-State: APjAAAWmtdbaq2wqXeVCSOpbA0lWDuQzwJT5rOGTJYiMKlca9mgrU/e2
        0np8UZk9EN+kyO/JCexqol6w6PL52Z9Sxr8IMs0=
X-Google-Smtp-Source: APXvYqyjN/VRJtnUDOhYN7xOHANcLIzOXLAYdVbxsBTvNcRxoGXozc2n70+kNQtcDG1IjqQgVOhwXlUy+1h40fOI93c=
X-Received: by 2002:adf:fb47:: with SMTP id c7mr2405518wrs.116.1561487358292;
 Tue, 25 Jun 2019 11:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
 <ab745372-35eb-8bb8-30a4-0e861af27ac2@mojatatu.com> <CAOftzPj_+6hfrb-FwU+E2P83RLLp6dtv0nJizSG1Fw7+vCgYwA@mail.gmail.com>
 <f69a7930-6e8a-d717-0aa4-a63ea6e7b5e0@mojatatu.com>
In-Reply-To: <f69a7930-6e8a-d717-0aa4-a63ea6e7b5e0@mojatatu.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Tue, 25 Jun 2019 11:29:05 -0700
Message-ID: <CAOftzPhkMWqUFi4_Q8W-fVM-WFEes++RpiiwTdOeVrQZ7T6FZw@mail.gmail.com>
Subject: Re: Removing skb_orphan() from ip_rcv_core()
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Joe Stringer <joe@wand.net.nz>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 4:07 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2019-06-24 11:26 p.m., Joe Stringer wrote:
> [..]
> >
> > I haven't got as far as UDP yet, but I didn't see any need for a
> > dependency on netfilter.
>
> I'd be curious to see what you did. My experience, even for TCP is
> the socket(transparent/tproxy) lookup code (to set skb->sk either
> listening or established) is entangled in
> CONFIG_NETFILTER_SOMETHING_OR_OTHER. You have to rip it out of
> there (in the tproxy tc action into that  code). Only then can you
> compile out netfilter.
> I didnt bother to rip out code for udp case.
> i.e if you needed udp to work with the tc action,
> youd have to turn on NF. But that was because we had
> no need for udp transparent proxying.
> IOW:
> There is really no reason, afaik, for tproxy code to only be
> accessed if netfilter is compiled in. Not sure i made sense.

Oh, I see. Between the existing bpf_skc_lookup_tcp() and
bpf_sk_lookup_tcp() helpers in BPF, plus a new bpf_sk_assign() helper
and a little bit of lookup code using the appropriate tproxy ports
etc. from the BPF side, I was able to get it working. One could
imagine perhaps wrapping all this logic up in a higher level
"bpf_sk_lookup_tproxy()" helper call or similar, but I didn't go that
direction given that the BPF socket primitives seemed to provide the
necessary functionality in a more generic manner.
