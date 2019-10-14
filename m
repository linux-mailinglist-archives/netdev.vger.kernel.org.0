Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDA8D69A8
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 20:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732211AbfJNSpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 14:45:08 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:43195 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730971AbfJNSpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 14:45:08 -0400
Received: by mail-lj1-f196.google.com with SMTP id n14so17613641ljj.10;
        Mon, 14 Oct 2019 11:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eUxWIPHMP0PFmpZXC2jVL6Z+f/bCEtwgxXXPzHX8O4c=;
        b=DXkrF4PUtgHsSPPNrqQzC1ApTctQ4tahNPiJrBqe8+Lq0oP0qp1uGxQBlxP83MAfqs
         0SmybhYaa17r/7JXbil+iFpnAopTZGX7Yand/U/dclIUhQl9/5UEtR3CPh6her4OlFWz
         nF/46mgHblgFn03AUedFVXK8+H62WMV0E5poGWd7Qf2+PCNMTo+yJTKdgV/JA2RQwn7O
         MVexPNz59Z0UQOfLvubxAPa0TXvceVNDRmjVoIw2xADgtEJOWX8XkP5jo/hU5EExi40z
         WFUsjlgZOA0ubD+tgyHAyfw6fLMeLqjIWaRXCWq/Z3MSm6rH9XQ0BHfYffqPgF8nb8U9
         uc7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eUxWIPHMP0PFmpZXC2jVL6Z+f/bCEtwgxXXPzHX8O4c=;
        b=t59/eE5suj2h6s+cV4UhBwqQXnNYR3sCUAseymlUI4iq9SYifg4sx4P0WfkX8ATUe0
         tjaAy5iJ1xUvHeDqYSyeUFrooYwsqBGJ+AgbP/8pUcn6YCyYoVqr4mP7P3s3MFmyY1f7
         F805uJqeY2Zgr6b5W85I/UME+K1b4nL+d+Rz2gIRGYJfj6GKi62alab5YLHOW7kB3D7Z
         9VwwxDQoCwBj9DcrZFOcxZFUFM9T5mpdTVzB/3F+dfWfZfbUE8R6vkr+sE7G4sQEdzS1
         4OKfEjNJLhu/rYlZoIM+n65NMg24GOjvzdLPhxg4bf97pY6w97S1IvCkjSCgfc0jyDpg
         y1Zg==
X-Gm-Message-State: APjAAAWp7hhhtwFVnGwQQ6l7rStBKst5t+H2hKmARrSdcalqYrhYmJLZ
        PY+VfjR6yGmK7PuNzBjn1wP8iTUy3gD9OCTpr/g=
X-Google-Smtp-Source: APXvYqxRktItFKhpgX2RQhYSQPgUe73TihGFmiZmeh7pJw2jy47Tfiv9ClXZEg/OraYOdsZbZfvwxhFRAFyvtj/eT1M=
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr20287215lji.142.1571078704060;
 Mon, 14 Oct 2019 11:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <111664d58fe4e9dd9c8014bb3d0b2dab93086a9e.1570609794.git.jbenc@redhat.com>
 <CAADnVQKgXnmbEhBd1FvM16RP_i8s7+risvgM9yftwuP2DejFmA@mail.gmail.com> <CAFTs51WM7yC3Z2HDGy9APSgqy1LCczQtFVG_y+X0WdxY9WSd9Q@mail.gmail.com>
In-Reply-To: <CAFTs51WM7yC3Z2HDGy9APSgqy1LCczQtFVG_y+X0WdxY9WSd9Q@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 14 Oct 2019 11:44:52 -0700
Message-ID: <CAADnVQ+vHYwZGdmeKJRiTXkoOuu+6DNmT1F3RsAOCxhkhsOnSg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: lwtunnel: fix reroute supplying invalid dst
To:     Peter Oskolkov <posk@posk.io>
Cc:     Jiri Benc <jbenc@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 10:39 AM Peter Oskolkov <posk@posk.io> wrote:
>
> On Sat, Oct 12, 2019 at 9:59 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Wed, Oct 9, 2019 at 1:31 AM Jiri Benc <jbenc@redhat.com> wrote:
> > >
> > > The dst in bpf_input() has lwtstate field set. As it is of the
> > > LWTUNNEL_ENCAP_BPF type, lwtstate->data is struct bpf_lwt. When the bpf
> > > program returns BPF_LWT_REROUTE, ip_route_input_noref is directly called on
> > > this skb. This causes invalid memory access, as ip_route_input_slow calls
> > > skb_tunnel_info(skb) that expects the dst->lwstate->data to be
> > > struct ip_tunnel_info. This results to struct bpf_lwt being accessed as
> > > struct ip_tunnel_info.
> > >
> > > Drop the dst before calling the IP route input functions (both for IPv4 and
> > > IPv6).
> > >
> > > Reported by KASAN.
> > >
> > > Fixes: 3bd0b15281af ("bpf: add handling of BPF_LWT_REROUTE to lwt_bpf.c")
> > > Cc: Peter Oskolkov <posk@google.com>
> > > Signed-off-by: Jiri Benc <jbenc@redhat.com>
> >
> > Peter and other google folks,
> > please review.
>
> selftests/bpf/test_lwt_ip_encap.sh passes. Seems OK.
>
> Acked-by: Peter Oskolkov <posk@google.com>

Applied to bpf tree. Thanks
