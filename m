Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561CE24F3C6
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 10:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgHXIRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 04:17:16 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37381 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgHXIRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 04:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598257034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4qaHx+4DgU7tZu2iXG2DADTWF+wfpKAFg4isrL3CwcQ=;
        b=hs7KxdvtrJvs1aJH1h+zv5zkVAWaYNRtmY6rjRHVZJQOouBgZHVfiVQ3aCmHA+pGdDp4Aa
        SqMbg4HfsSrfQkihKZge0BISav6NNBUZERvxk6v8CHjTI29TQOTdSJw2c31oaCWiucLK9n
        qAYT35cgdQSuGSybdV9T89Dr5CE0dDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-qZiY-s5xPQqOytrDRO8Gjg-1; Mon, 24 Aug 2020 04:17:10 -0400
X-MC-Unique: qZiY-s5xPQqOytrDRO8Gjg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DAA081F006;
        Mon, 24 Aug 2020 08:17:08 +0000 (UTC)
Received: from ovpn-113-102.ams2.redhat.com (ovpn-113-102.ams2.redhat.com [10.36.113.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6464361982;
        Mon, 24 Aug 2020 08:17:04 +0000 (UTC)
Message-ID: <8ccf0b77c854a20f65026fdc68dcd64b93d07fc5.camel@redhat.com>
Subject: Re: BPF sk_lookup v5 - TCP SYN and UDP 0-len flood benchmarks
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Date:   Mon, 24 Aug 2020 10:17:03 +0200
In-Reply-To: <CAADnVQKE6y9h2fwX6OS837v-Uf+aBXnT_JXiN_bbo2gitZQ3tA@mail.gmail.com>
References: <20200717103536.397595-1-jakub@cloudflare.com>
         <87lficrm2v.fsf@cloudflare.com>
         <CAADnVQKE6y9h2fwX6OS837v-Uf+aBXnT_JXiN_bbo2gitZQ3tA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-08-18 at 11:19 -0700, Alexei Starovoitov wrote:
> On Tue, Aug 18, 2020 at 8:49 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >          :                      rcu_read_lock();
> >          :                      run_array = rcu_dereference(net->bpf.run_array[NETNS_BPF_SK_LOOKUP]);
> >     0.01 :   ffffffff817f8624:       mov    0xd68(%r12),%rsi
> >          :                      if (run_array) {
> >     0.00 :   ffffffff817f862c:       test   %rsi,%rsi
> >     0.00 :   ffffffff817f862f:       je     ffffffff817f87a9 <__udp4_lib_lookup+0x2c9>
> >          :                      struct bpf_sk_lookup_kern ctx = {
> >     1.05 :   ffffffff817f8635:       xor    %eax,%eax
> >     0.00 :   ffffffff817f8637:       mov    $0x6,%ecx
> >     0.01 :   ffffffff817f863c:       movl   $0x110002,0x40(%rsp)
> >     0.00 :   ffffffff817f8644:       lea    0x48(%rsp),%rdi
> >    18.76 :   ffffffff817f8649:       rep stos %rax,%es:(%rdi)
> >     1.12 :   ffffffff817f864c:       mov    0xc(%rsp),%eax
> >     0.00 :   ffffffff817f8650:       mov    %ebp,0x48(%rsp)
> >     0.00 :   ffffffff817f8654:       mov    %eax,0x44(%rsp)
> >     0.00 :   ffffffff817f8658:       movzwl 0x10(%rsp),%eax
> >     1.21 :   ffffffff817f865d:       mov    %ax,0x60(%rsp)
> >     0.00 :   ffffffff817f8662:       movzwl 0x20(%rsp),%eax
> >     0.00 :   ffffffff817f8667:       mov    %ax,0x62(%rsp)
> >          :                      .sport          = sport,
> >          :                      .dport          = dport,
> >          :                      };
> 
> Such heavy hit to zero init 56-byte structure is surprising.
> There are two 4-byte holes in this struct. You can try to pack it and
> make sure that 'rep stoq' is used instead of 'rep stos' (8 byte at a time vs 4).

I think here rep stos is copying 8 bytes at a time (%rax operand, %ecx
initalized with '6').

I think that you can avoid the costly instruction explicitly
initializing each field individually:

	struct bpf_sk_lookup_kern ctx;

	ctx.family = AF_INET;
	ctx.protocol = protocol;
	// ...

note, you likely want to explicitly zero the v6 addresses, too.

Cheers,

Paolo

