Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F288719E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfHIFkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:40:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56258 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfHIFkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:40:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6632114470BBA;
        Thu,  8 Aug 2019 22:40:21 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:40:20 -0700 (PDT)
Message-Id: <20190808.224020.1080850652318993693.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, davejwatson@fb.com, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, willemb@google.com, edumazet@google.com,
        alexei.starovoitov@gmail.com, oss-drivers@netronome.com
Subject: Re: [PATCH net v3] net/tls: prevent skb_orphan() from leaking TLS
 plain text with offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808000359.20785-1-jakub.kicinski@netronome.com>
References: <20190808000359.20785-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:40:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed,  7 Aug 2019 17:03:59 -0700

> sk_validate_xmit_skb() and drivers depend on the sk member of
> struct sk_buff to identify segments requiring encryption.
> Any operation which removes or does not preserve the original TLS
> socket such as skb_orphan() or skb_clone() will cause clear text
> leaks.
> 
> Make the TCP socket underlying an offloaded TLS connection
> mark all skbs as decrypted, if TLS TX is in offload mode.
> Then in sk_validate_xmit_skb() catch skbs which have no socket
> (or a socket with no validation) and decrypted flag set.
> 
> Note that CONFIG_SOCK_VALIDATE_XMIT, CONFIG_TLS_DEVICE and
> sk->sk_validate_xmit_skb are slightly interchangeable right now,
> they all imply TLS offload. The new checks are guarded by
> CONFIG_TLS_DEVICE because that's the option guarding the
> sk_buff->decrypted member.
> 
> Second, smaller issue with orphaning is that it breaks
> the guarantee that packets will be delivered to device
> queues in-order. All TLS offload drivers depend on that
> scheduling property. This means skb_orphan_partial()'s
> trick of preserving partial socket references will cause
> issues in the drivers. We need a full orphan, and as a
> result netem delay/throttling will cause all TLS offload
> skbs to be dropped.
> 
> Reusing the sk_buff->decrypted flag also protects from
> leaking clear text when incoming, decrypted skb is redirected
> (e.g. by TC).
> 
> See commit 0608c69c9a80 ("bpf: sk_msg, sock{map|hash} redirect
> through ULP") for justification why the internal flag is safe.
> The only location which could leak the flag in is tcp_bpf_sendmsg(),
> which is taken care of by clearing the previously unused bit.
> 
> v2:
>  - remove superfluous decrypted mark copy (Willem);
>  - remove the stale doc entry (Boris);
>  - rely entirely on EOR marking to prevent coalescing (Boris);
>  - use an internal sendpages flag instead of marking the socket
>    (Boris).
> v3 (Willem):
>  - reorganize the can_skb_orphan_partial() condition;
>  - fix the flag leak-in through tcp_bpf_sendmsg.
> 
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied, thanks Jakub.
