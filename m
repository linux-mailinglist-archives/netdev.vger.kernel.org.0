Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 185B11874A9
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732648AbgCPVXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:23:40 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38196 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732567AbgCPVXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:23:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id s1so1365480wrv.5;
        Mon, 16 Mar 2020 14:23:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QDOgkrVz8ewx9AciRaUk8U8O72lBJhXXGq2eSOJbIms=;
        b=CysS+J/i1RqZibfePOqmh1m97X3WfSUNIVjtrTt5/qoh2vD+kPGzmuYJQQtwgkCDd1
         rhfOEIsts33FMSL5HkzZclER3V9ucJd/N1kj5Rhg3OiPhZO25+gvRUbGvZP48oRi5YG3
         JmyUs8gudBAsEQNkbrbLWjkzXJd4mjsKXkcjA11Asa+BVia+ct0wXgXK6+wTUMpL2txc
         D1McV9ynFlszIqKLZdV1IbKlfuC3dVJvtMvnizd9VHn0WnjUv65gsaNdJ9BUcNm4Njlz
         aJKZvLIZ/C7zpEc1BRnGX3adsXgkfVKvOARU/qk75Z3s9/1nfVnDx0/SzvkX1Nwn3Oeu
         bPRg==
X-Gm-Message-State: ANhLgQ1aiEl9TrdyakvDjCTf+T7sj+iklQwWEAe9TrWSjNVpP1h6QNVI
        5ciX7SSCZoVyiH92i/qTu3KE3pjurhM/4hbTuGo=
X-Google-Smtp-Source: ADFU+vsGy7pvEgviPlRLc2PPHqUj5DkK0c547LMbJhTzJDJYCKzcw/tZdjXhLgaoACIImlVAMzM0p9U0XT8q9XK9mC0=
X-Received: by 2002:adf:ce8e:: with SMTP id r14mr1330915wrn.415.1584393818504;
 Mon, 16 Mar 2020 14:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-4-joe@wand.net.nz>
 <87mu8gy5m6.fsf@cloudflare.com>
In-Reply-To: <87mu8gy5m6.fsf@cloudflare.com>
From:   Joe Stringer <joe@wand.net.nz>
Date:   Mon, 16 Mar 2020 14:23:24 -0700
Message-ID: <CAOftzPiUKa87U4UtxFMvWPpZYTTjvfgyb5E=u110jRCsjUh--g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Joe Stringer <joe@wand.net.nz>, bpf@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 3:08 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> [+CC Florian]
>
> Hey Joe,
>
> On Fri, Mar 13, 2020 at 12:36 AM CET, Joe Stringer wrote:
> > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
> >
> > This helper requires the BPF program to discover the socket via a call
> > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
> > helper takes its own reference to the socket in addition to any existing
> > reference that may or may not currently be obtained for the duration of
> > BPF processing. For the destination socket to receive the traffic, the
> > traffic must be routed towards that socket via local route, the socket
> > must have the transparent option enabled out-of-band, and the socket
> > must not be closing. If all of these conditions hold, the socket will be
> > assigned to the skb to allow delivery to the socket.
>
> My impression from the last time we have been discussing TPROXY is that
> the check for IP_TRANSPARENT on ingress doesn't serve any purpose [0].
>
> The socket option only has effect on output, when there is a need to
> source traffic from a non-local address.
>
> Setting IP_TRANSPARENT requires CAP_NET_{RAW|ADMIN}, which grant a wider
> range of capabilities than needed to build a transparent proxy app. This
> is problematic because you to lock down your application with seccomp.
>
> It seems it should be enough to use a port number from a privileged
> range, if you want to ensure that only the designed process can receive
> the proxied traffic.

Thanks for looking this over. You're right, I neglected to fix up the
commit message here from an earlier iteration that enforced this
constraint. I can fix this up in a v2.

> Or, alternatively, instead of using socket lookup + IP_TRANSPARENT
> check, get the socket from sockmap and apply control to who can update
> the BPF map.

There's no IP_TRANSPARENT check in this iteration of the series.

Cheers,
Joe
