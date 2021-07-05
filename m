Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBB33BB90A
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 10:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhGEI04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 04:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbhGEI0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 04:26:55 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EBEC061760
        for <netdev@vger.kernel.org>; Mon,  5 Jul 2021 01:24:18 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id q18so31008848lfc.7
        for <netdev@vger.kernel.org>; Mon, 05 Jul 2021 01:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=jj7+TNaQPU7Jf9mnJvAob2AETZ45tmS9p0g/FllWrLI=;
        b=bW5aQeJv5u9spwJKsAoW+ujLrBiU5Ns/pklQSVKBACDfMVlR7mdbYQ7/RgXPZ64jLQ
         NUddf/CwUxaaxn5wfV66vKIsnv+uRLYUP1Ykd2a6/PkyAAkoaRb6HKSuBktdwmCd0kEF
         lXwU3pQ8lff2t1XXCXLhXCWMmLdUgWyuw8hig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=jj7+TNaQPU7Jf9mnJvAob2AETZ45tmS9p0g/FllWrLI=;
        b=DSWo4fwbG0kOT9v/W87i19/yyeYXokU/2q2rUC9BnD8Ljs/G1ET0qaXBfOOOvHOqSj
         hA4OXdAHzqsVHV20wLsGoKK67M36bcJswC+OLOVms1DvHt6+o7vZNvo7r8hxnYgXQksd
         /53zCga6riCGO1V0nrg8xTjZacSXR7oAMWw9zDxlt3FxKb1GH37p2kuH6RUF3x6ovL6F
         Jh11EMZpn7+sDOUvx/i96qd/5VNwLk/3S6W/Zs4PsbVNfWstEHNPBcYJybhvwBcY8u+7
         3dH+icMOEFa5Dez9CXtW3jOlZn+jPD4VSzLvhsPWjuLlzs6hFMDcLH09BN9jfDCW37Lc
         6s7g==
X-Gm-Message-State: AOAM532FwrvTysLd2EcLT6emGke9wu+JQ6FB95r4X8/t07M3lQOAs6Xy
        9z9lv/l9JCWPr97jotJY2zuDzA==
X-Google-Smtp-Source: ABdhPJyuv0Af+71XBG42//1ycauvRXPfDh2WQitebY4gI+kynh2D2B/vCHAtT6CTPB1LEz1fH6CX+g==
X-Received: by 2002:a05:6512:32a4:: with SMTP id q4mr4859841lfe.252.1625473457348;
        Mon, 05 Jul 2021 01:24:17 -0700 (PDT)
Received: from cloudflare.com (79.191.58.233.ipv4.supernova.orange.pl. [79.191.58.233])
        by smtp.gmail.com with ESMTPSA id f1sm1012993lfs.211.2021.07.05.01.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 01:24:16 -0700 (PDT)
References: <20210701061656.34150-1-xiyou.wangcong@gmail.com>
 <60ddec01c651b_3fe24208dc@john-XPS-13-9370.notmuch>
 <875yxrs2sc.fsf@cloudflare.com>
 <CAM_iQpW69PGfp_Y8mZoqznwCk2axask5qJLB7ntZjFgGO+Eizg@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [Patch bpf v2] skmsg: check sk_rcvbuf limit before queuing to
 ingress_skb
In-reply-to: <CAM_iQpW69PGfp_Y8mZoqznwCk2axask5qJLB7ntZjFgGO+Eizg@mail.gmail.com>
Date:   Mon, 05 Jul 2021 10:24:15 +0200
Message-ID: <8735strwwg.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 04, 2021 at 09:53 PM CEST, Cong Wang wrote:
> On Sat, Jul 3, 2021 at 10:52 AM Jakub Sitnicki <jakub@cloudflare.com> wro=
te:
>> When running with just the verdict prog attached, the -EIO error from
>> sk_psock_verdict_apply is propagated up to tcp_read_sock. That is, it
>> maps to 0 bytes used by recv_actor. sk_psock_verdict_recv in this case.
>>
>> tcp_read_sock, if 0 bytes were used =3D copied, won't sk_eat_skb. It sta=
ys
>> on sk_receive_queue.
>
> Are you sure?
>
> When recv_actor() returns 0, the while loop breaks:
>
> 1661                         used =3D recv_actor(desc, skb, offset, len);
> 1662                         if (used <=3D 0) {
> 1663                                 if (!copied)
> 1664                                         copied =3D used;
> 1665                                 break;
>
> then it calls sk_eat_skb() a few lines after the loop:
> ...
> 1690                 sk_eat_skb(sk, skb);

This sk_eat_skb is still within the loop:

1636:int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
1637-		  sk_read_actor_t recv_actor)
1638-{
	=E2=80=A6
1643-	int copied =3D 0;
        =E2=80=A6
1647-	while ((skb =3D tcp_recv_skb(sk, seq, &offset)) !=3D NULL) {
1648-		if (offset < skb->len) {
			=E2=80=A6
1661-			used =3D recv_actor(desc, skb, offset, len);
1662-			if (used <=3D 0) {
1663-				if (!copied)
1664-					copied =3D used;
1665-				break;
1666-			} else if (used <=3D len) {
1667-				seq +=3D used;
1668-				copied +=3D used;
1669-				offset +=3D used;
1670-			}
			=E2=80=A6
1684-		}
		=E2=80=A6
1690-		sk_eat_skb(sk, skb);
		=E2=80=A6
1694-	}
	=E2=80=A6
1699-	/* Clean up data we have read: This will do ACK frames. */
1700-	if (copied > 0) {
1701-		tcp_recv_skb(sk, seq, &offset);
1702-		tcp_cleanup_rbuf(sk, copied);
1703-	}
1704-	return copied;
1705-}

sk_eat_skb could get called by tcp_recv_skb =E2=86=92 sk_eat_skb if recv_ac=
tor
returned > 0 (the case when we have parser attached).

>
>>
>>   sk->sk_data_ready
>>     sk_psock_verdict_data_ready
>>       ->read_sock(..., sk_psock_verdict_recv)
>>         tcp_read_sock (used =3D copied =3D 0)
>>           sk_psock_verdict_recv -> ret =3D 0
>>             sk_psock_verdict_apply -> -EIO
>>               sk_psock_skb_redirect -> -EIO
>>
>> However, I think this gets us stuck. What if no more data gets queued,
>> and sk_data_ready doesn't get called again?
>
> I think it is dropped by sk_eat_skb() in TCP case and of course the
> sender will retransmit it after detecting this loss. So from this point of
> view, there is no difference between drops due to overlimit and drops
> due to eBPF program policy.

I'm not sure the retransmit will happen.

We update tp->rcv_nxt (tcp_rcv_nxt_update) when skb gets pushed onto
sk_receive_queue in either:

 - tcp_rcv_established -> tcp_queue_rcv, or
 - tcp_rcv_established -> tcp_data_queue -> tcp_queue_rcv

... and schedule ACK (tcp_event_data_recv) to be sent.

Say we are in quickack mode, then
tcp_ack_snd_check()/__tcp_ack_snd_check() would cause ACK to be sent
out.
