Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA646A7C2
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 13:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfGPL41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 07:56:27 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:39582 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfGPL41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 07:56:27 -0400
Received: by mail-ot1-f52.google.com with SMTP id r21so14682317otq.6
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 04:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XA0Tw3m9nPCTlyx5u3HFpZCSs2AM6cW6PSGoJjPSveE=;
        b=DQ9tSmUCQStpjrEN600n7lRKfRZeP94cOt9bQBsIpqRCUBQmV3JKECYwQuOF+7ilao
         mjjDEH5pwSzKuxsL8kg5Kz7juWCl56zNRByhpJk403tjn1mTjeQPp+qZCcKCYTYSOCj6
         tLJV/dEg5dzgVulGDTRpUg2sGYtfYntCgWF6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XA0Tw3m9nPCTlyx5u3HFpZCSs2AM6cW6PSGoJjPSveE=;
        b=tG2Vd3q8/pzhkzHvRUIQv7DWRo1PzWqDczWV24R1sRkBqmEQy+lUsfIr8KmbDmfyYs
         1tCBQ+bV7RtmWpIme0In1x3rklG/b8/stQo69A1hqes1gx+jrh/L1V2cLl/7+7jODKjK
         GAktfmDlZkA90CEaAVQttX0x4pD8sfawibUcYHW/NQSxLg0fN7i85u55jKk5zSmheLY7
         WsKWvQcYu4kD8nWldCiTydd0Z0dy1LrYkFnJ3kBvqGOtKIFEJ4R+QZ95jui1w8uOUXCC
         nvEC21XxJ9O8D2EU3BNvJ0sYBFdutwTVr8lt9TcTED5mS17HPKCTJAAaK7glCdCT3XsL
         WRoQ==
X-Gm-Message-State: APjAAAX0KX6pd8AVe7+CIidayQAV0CbJyWpyR3AxC8Rp5CIKCKImnMBl
        GkQnSZPqE5xQNX93Ip2Azuw68g8nDFInCLs26X31nA==
X-Google-Smtp-Source: APXvYqxn/1n9yccyaizqgW0lyNzrFT0OG6ONAqxeTvwmWoQvYzG6UxPVmDSpu8/XPO9n3l4drJHgHkHLJJte7Aw8GfM=
X-Received: by 2002:a05:6830:1485:: with SMTP id s5mr23445908otq.132.1563278186261;
 Tue, 16 Jul 2019 04:56:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190716002650.154729-1-ppenkov.kernel@gmail.com>
 <20190716002650.154729-4-ppenkov.kernel@gmail.com> <b6ef24b0-0415-c67d-5a66-21f1c2530414@gmail.com>
In-Reply-To: <b6ef24b0-0415-c67d-5a66-21f1c2530414@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 16 Jul 2019 12:56:15 +0100
Message-ID: <CACAyw9_5+3cznRspLJ2ZDcK22keLVtQQHbQOypSs4sx-F=ajow@mail.gmail.com>
Subject: Re: [bpf-next RFC 3/6] bpf: add bpf_tcp_gen_syncookie helper
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Petar Penkov <ppenkov.kernel@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Jul 2019 at 08:59, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > +             return -EINVAL;
> > +
> > +     if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
> > +             return -EINVAL;
> > +
> > +     if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
> > +             return -EINVAL;
> > +
> > +     if (!th->syn || th->ack || th->fin || th->rst)
> > +             return -EINVAL;
> > +
> > +     switch (sk->sk_family) {
>
> This is strange, because a dual stack listener will have sk->sk_family set to AF_INET6.
>
> What really matters here is if the packet is IPv4 or IPv6.
>
> So you need to look at iph->version instead.
>
> Then look if the socket family allows this packet to be processed
> (For example AF_INET6 sockets might prevent IPv4 packets, see sk->sk_ipv6only )

Does this apply for (the existing) tcp_check_syn_cookie as well?

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
