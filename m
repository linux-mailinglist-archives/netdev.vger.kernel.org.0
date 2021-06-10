Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E253A2E4A
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbhFJOfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:35:21 -0400
Received: from mail.toke.dk ([45.145.95.4]:40069 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231428AbhFJOfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 10:35:20 -0400
X-Greylist: delayed 60117 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Jun 2021 10:35:20 EDT
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1623335603; bh=6czCRZWKa4mIBpoPJ/D8AysyDAOaBz3uMCe0rDlb/xo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=kEgXSCi/XuTv8jIIA1tlE2aGn0gpsq9x3IlYpJ1krwCibbWKoRDTi6xyoLWj/eY3M
         oVCgLuyQavWFKJPshpP9SW2XT6GZw4u8qETe0Ibw/DWDa4Q6lVlzUoAZXry4X2pIlg
         sskOUf5iO7DHtnhPxjVFMveqo36J2EyDnpKMZsSEu7+x35e79rwYjMRoshLniRiI6I
         bxtxKGGI9Fo741jHtYGtrBecrjTCRJw7STyUhBcWB1466MUlS1r/GfVgNoRXKfruUQ
         RJZDkeCHNxO+SyeStmsYSVpuVKSezc4CNJbHKsEDp+HwRxrjOEOZpPyPjFaBwCvPbT
         eL1QKJAUcq7MA==
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>
Cc:     Young Xiao <92siuyang@gmail.com>, netdev@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Patrick McHardy <kaber@trash.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Peter Krystad <peter.krystad@linux.intel.com>
Subject: Re: [PATCH net 3/3] sch_cake: Fix out of bounds when parsing TCP
 options
In-Reply-To: <cddbb9c5-58d2-64c4-f77b-9991ec977dc3@nvidia.com>
References: <20210609142212.3096691-1-maximmi@nvidia.com>
 <20210609142212.3096691-4-maximmi@nvidia.com> <87h7i6n1us.fsf@toke.dk>
 <cddbb9c5-58d2-64c4-f77b-9991ec977dc3@nvidia.com>
Date:   Thu, 10 Jun 2021 16:33:22 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a6nxvlfx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy <maximmi@nvidia.com> writes:

> On 2021-06-10 00:51, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Maxim Mikityanskiy <maximmi@nvidia.com> writes:
>>=20
>>> The TCP option parser in cake qdisc (cake_get_tcpopt and
>>> cake_tcph_may_drop) could read one byte out of bounds. When the length
>>> is 1, the execution flow gets into the loop, reads one byte of the
>>> opcode, and if the opcode is neither TCPOPT_EOL nor TCPOPT_NOP, it reads
>>> one more byte, which exceeds the length of 1.
>>>
>>> This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
>>> out of bounds when parsing TCP options.").
>>>
>>> Cc: Young Xiao <92siuyang@gmail.com>
>>> Fixes: 8b7138814f29 ("sch_cake: Add optional ACK filter")
>>> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>>=20
>> Thanks for fixing this!
>>=20
>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>>=20
>
> Could you also review whether Florian's comment on patch 1 is relevant=20
> to this patch too? I have concerns about cake_get_tcphdr, which returns=20
> `skb_header_pointer(skb, offset, min(__tcp_hdrlen(tcph), bufsize),=20
> buf)`. Although I don't see a way for it to get out of bounds (it will=20
> read garbage instead of TCP header in the worst case), such code doesn't=
=20
> look robust.
>
> It's not possible for it to get out of bounds, because there is a call=20
> to skb_header_pointer above with sizeof(_tcph), which ensures that the=20
> SKB has at least 20 bytes after the beginning of the TCP header, which=20
> means that the second skb_header_pointer will either point to SKB (where=
=20
> we have at least 20 bytes) or to buf (which is allocated by the caller,=20
> so the caller shouldn't overflow its own buffer).
>
> On the other hand, parsing garbage doesn't look like a valid behavior=20
> compared to dropping/ignoring/whatever-cake-does-with-bad-packets, so we=
=20
> may want to handle it, for example:
>
>           return skb_header_pointer(skb, offset,
> -                                  min(__tcp_hdrlen(tcph), bufsize), buf);
> +                                  min(max(sizeof(struct tcphdr),=20
> __tcp_hdrlen(tcph)), bufsize), buf);
>
> What do you think? Or did I just miss some early check for doff?

No, I think your analysis is correct: It won't lead to any out-of-bounds
reads, but I suppose we could end up trying to parse garbage. However,
if we do get a packet that sets doff to an invalid value, and we try to
parse it, we're essentially parsing garbage anyway. So I think the fix
should rather be something like:

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 7d37638ee1c7..d312d75ab698 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -943,7 +943,7 @@ static struct tcphdr *cake_get_tcphdr(const struct sk_b=
uff *skb,
        }
=20
        tcph =3D skb_header_pointer(skb, offset, sizeof(_tcph), &_tcph);
-       if (!tcph)
+       if (!tcph || tcph->doff < 5)
                return NULL;
=20
        return skb_header_pointer(skb, offset,

> (I realize it's egress path and the packets produced by the system=20
> itself are unlikely to have bad doff, but it's not impossible, for=20
> example, with AF_PACKET, BPF hooks in tc, etc.)

Most CAKE deployments primarily handles forwarded packets, and I suppose
malformed TCP packets could make it through the forwarding path as
well...

-Toke
