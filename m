Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4986C3F79C4
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 18:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbhHYQFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 12:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234330AbhHYQFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 12:05:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 531E161212;
        Wed, 25 Aug 2021 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629907459;
        bh=4PpP/xVSQQyMFeqCK4UU8Iiiit03YHt+jjy7lQiJThg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LytHCMjaz2HLlW850RzBQGVKqF7KoVy0WOTohOx/nPOKNyNwaqoiSSdEBe/uPTVlk
         hzqIvXlyb3d/IkIxJEM6QhtWdxyloH1yT95UbvHj93U1eyBkOeiYWwrOKCJ5ysBh4t
         JyuER9108jK/lnaRwUNSGITdDOUdxe2ceQg/GJyHZcFV1XuUy653v945Kq0PK+Pq3v
         FFVuQuN2bQNNrjfM2RnOP94T8oqIm0oM87tBr0QXPgATjHxX/vbCYkxJgRG/eJsas8
         BH9rLx/vVLQ/46FtNK1bmVRMA3uQBNziqoYEoLjfcU/TyqPxzX4XtJgWaaeObIBJc+
         Gccv9t5NUWVSg==
Date:   Wed, 25 Aug 2021 09:04:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Zhongya Yan <yan2228598786@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>, ntspring@fb.com
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing v2
Message-ID: <20210825090418.57fd7d2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJO8jzjFWvJ610TPmKDE8WKi8ojTr_HWXLz5g=4pdQHEA@mail.gmail.com>
References: <20210825154043.247764-1-yan2228598786@gmail.com>
        <CANn89iJO8jzjFWvJ610TPmKDE8WKi8ojTr_HWXLz5g=4pdQHEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Aug 2021 08:47:46 -0700 Eric Dumazet wrote:
> On Wed, Aug 25, 2021 at 8:41 AM Zhongya Yan <yan2228598786@gmail.com> wrote:
> > @@ -5703,15 +5700,15 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
> >                         TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
> >                 NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
> >                 tcp_send_challenge_ack(sk, skb);
> > -               goto discard;
> > +               tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));  
> 
> I'd rather use a string. So that we can more easily identify _why_ the
> packet was drop, without looking at the source code
> of the exact kernel version to locate line number 1057

Yeah, the line number seems like a particularly bad idea. Hopefully
strings won't be problematic, given we can expect most serious users 
to feed the tracepoints via BPF. enum would be more convenient there,
I'd think.

> You can be sure that we will get reports in the future from users of
> heavily modified kernels.
> Having to download a git tree, or apply semi-private patches is a no go.

I'm slightly surprised by this angle. Are there downstream kernels with
heavily modified TCP other than Google's?

> If you really want to include __FILE__ and __LINE__, these both can be
> stringified and included in the report, with the help of macros.

