Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59F1B123A14
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfLQWae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:30:34 -0500
Received: from mail-vk1-f194.google.com ([209.85.221.194]:46694 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbfLQWad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:30:33 -0500
Received: by mail-vk1-f194.google.com with SMTP id u6so65228vkn.13
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:30:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=APyDOzsXluwYf4e4WCi9N3O/M4cmjqY9ISDxb8xau2s=;
        b=C0F3GiPG2ods0YrTgQaDtLmnS64rcL16Vp524JXxXRIecZIOz+OUeyE0eFdo/h7cax
         dT7+cdZ6Z4gWjaK6gyqGJojeqkhkAMo4GyL8iB+wYsYgvgaKutxKzWQbLfyzQz/cbMBk
         El2mfIwfsxWkagloRPBi+aHPLhwphLdKb/M0ncp34gbFpZd9woQj6YPL0/nH9Z+x/9a8
         gdbRs6O/mIquveRWDV7kB1Y2bC9d6gq4QZS+bugb4t6qtszmbjeTXKPifOzg+hBHueUt
         qwPMtw2MruTX93mp5tO5alGJmFKVdZbcR4HRENzqo2NhBYVCE7rzUfK1nu4ZAmwlpXts
         gBlw==
X-Gm-Message-State: APjAAAX+A/UVNg6mYVCZgPk79w/ZG6memfguTfiS6/OB5KrFM9MjGkKN
        F4/WfGJa4xlYdTWD5j2G6lhiSDm6boEAfqJ1nh8=
X-Google-Smtp-Source: APXvYqym4eEZPPtb/59eIMOJOzwXqYj7PVy6wdzi9KfDe352TcDcYgcpU8mlcJVNh8g0HctRXXVlbOertNk8NoYupf0=
X-Received: by 2002:a1f:1e0c:: with SMTP id e12mr5553792vke.10.1576621832430;
 Tue, 17 Dec 2019 14:30:32 -0800 (PST)
MIME-Version: 1.0
References: <BA8DC06A-C508-402D-8A18-B715FBA674A2@amazon.com>
 <b28504a3-4a55-d302-91fe-63915e4568d3@iogearbox.net> <5FA3F980-29E6-4B91-8150-9F28C0E09C45@amazon.com>
 <20190823084704.075aeebd@carbon> <67C7F66A-A3F7-408F-9C9E-C53982BCCD40@amazon.com>
 <20191204155509.6b517f75@carbon> <ec2fd7f6da44410fbaeb021cf984f2f6@EX13D11EUC003.ant.amazon.com>
 <20191216150728.38c50822@carbon> <CA+hQ2+jp471vBvRna7ugdYyFgEB63a9tgCXZCOjEQkT+tZTM1g@mail.gmail.com>
 <20191217094635.7e4cac1c@carbon>
In-Reply-To: <20191217094635.7e4cac1c@carbon>
From:   Luigi Rizzo <rizzo@iet.unipi.it>
Date:   Tue, 17 Dec 2019 14:30:21 -0800
Message-ID: <CA+hQ2+jzz2dZONYbW_+H6rE+u50a+r8p5yLtAWWSJFvjmnBz1g@mail.gmail.com>
Subject: Re: XDP multi-buffer design discussion
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     "Jubran, Samih" <sameehj@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 12:46 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Mon, 16 Dec 2019 20:15:12 -0800
> Luigi Rizzo <rizzo@iet.unipi.it> wrote:
>...
> > For some use cases, the bpf program could deduct the total length
> > looking at the L3 header.
>
> Yes, that actually good insight.  I guess the BPF-program could also
> use this to detect that it doesn't have access to the full-lineary
> packet this way(?)
>
> > It won't work for XDP_TX response though.
>
> The XDP_TX case also need to be discussed/handled. IMHO need to support
> XDP_TX for multi-buffer frames.  XDP_TX *can* be driver specific, but
> most drivers choose to convert xdp_buff to xdp_frame, which makes it
> possible to use/share part of the XDP_REDIRECT code from ndo_xdp_xmit.
>
> We also need to handle XDP_REDIRECT, which becomes challenging, as the
> ndo_xdp_xmit functions of *all* drivers need to be updated (or
> introduce a flag to handle this incrementally).

Here is a possible course of action (please let me know if you find loose ends)

1. extend struct xdp_buff with a total length and sk_buff * (NULL by default);
2. add a netdev callback to construct the skb for the current packet.
  This code obviously already in all drivers, just needs to be exposed
as function
  callable by a bpf helper (next bullet);
3. add a new helper 'bpf_create_skb' that when invoked calls the previously
  mentioned netdev callback to  constructs an skb for the current packet,
  and sets the pointer in the xdp_buff, if not there already.
  A bpf program that needs to access segments beyond the first one can
  call bpf_create_skb() if needed, and then use existing helpers
  skb_load_bytes, skb_store_bytes, etc) to access the skb.

  My rationale is that if we need to access multiple segments, we are already
  in an expensive territory and it makes little sense to define a multi segment
  format that would essentially be an skb.

4. implement a mechanism to let so the driver know whether the currently
  loaded bpf program understands the new format.
  There are multiple ways to do that, a trivial one would be to check,
during load,
  that the program calls some known helper eg bpf_understands_fragments()
  which is then jit-ed to somethijng inexpensive

  Note that today, a netdev that cannot guarantee single segment
packets would not
  be able to enable xdp. Hence, without loss of functionality, such
netdev can refuse to
  load a program without bpf_undersdands_fragments().

With all the above, the generic xdp handler would do the following:
 if (!skb_is_linear() && !bpf_understands_fragments()) {
    < linearize skb>;
 }
  <construct xdp_buff with first segment and skb> // skb is unused by
old style programs
  <call bpf program>

The native driver for a device that cannot guarantee a single segment
would just refuse
to load a program that does not understand them (same as today), so
the code would be:

<construct xdp_buff with first segment and empty skb>
 <call bpf program>

On return, we might find that an skb has been built by the xdp program,
and can be immediately used for XDP_PASS (or dropped in case of XDP_DROP)
For XDP_TX and XDP_REDIRECT, something similar: if the packet is a
single segment
and there is no skb, use the existing accelerated path. If there are
multiple segments,
construct the skb if not existing already, and pass it to the standard tx path.

cheers
luigi
