Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58206316722
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 13:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhBJMxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 07:53:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhBJMw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 07:52:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612961491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ugPjlCfZxXXobtAMOc/wdDCpv4LkRF9qteob74JQanE=;
        b=JR5Tw3a3nDuARSYygiu1uHGV015mhjrsbdcvCj8zGfqUjBEM9ZEGa4Xvkn36ghYCC1XmAa
        g+953g+Ygw7qC4r28P/3+0V/R2kHqNuovUoLKsOhwCAHjcML78YH7pYvf0dGf+NPoLYQhi
        7M7IInv+clPBV6c1qenFL+TlkRjGUa8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-nZcOcRj5OQGFsSMRm8IhjA-1; Wed, 10 Feb 2021 07:51:28 -0500
X-MC-Unique: nZcOcRj5OQGFsSMRm8IhjA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3311980402C;
        Wed, 10 Feb 2021 12:51:24 +0000 (UTC)
Received: from ovpn-115-79.ams2.redhat.com (ovpn-115-79.ams2.redhat.com [10.36.115.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CD435D9C0;
        Wed, 10 Feb 2021 12:51:12 +0000 (UTC)
Message-ID: <1fb33427fe84e20e0e41b69bf075d4ded11282ef.camel@redhat.com>
Subject: Re: [v3 net-next 08/10] skbuff: reuse NAPI skb cache on allocation
 path (__build_skb())
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yonghong Song <yhs@fb.com>, zhudi <zhudi21@huawei.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Edward Cree <ecree.xilinx@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Wed, 10 Feb 2021 13:51:11 +0100
In-Reply-To: <20210210122414.8064-1-alobakin@pm.me>
References: <20210209204533.327360-1-alobakin@pm.me>
         <20210209204533.327360-9-alobakin@pm.me>
         <b6efe8d3a4ebf8188c040c5401b50b6c11b6eaf9.camel@redhat.com>
         <20210210122414.8064-1-alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-02-10 at 12:25 +0000, Alexander Lobakin wrote:
> Paolo Abeni <pabeni@redhat.com> on Wed, 10 Feb 2021 11:21:06 +0100 wrote:
> > Perhaps giving the device drivers the ability to opt-in on this infra
> > via a new helper - as done back then with napi_consume_skb() - would
> > make this change safer?
> 
> That's actually a very nice idea. There's only a little in the code
> to change to introduce an ability to take heads from the cache
> optionally. This way developers could switch to it when needed.
> 
> Thanks for the suggestions! I'll definitely absorb them into the code
> and give it a test.

Quick reply before is too late. I suggest to wait a bit for others
opinions before coding - if others dislike this I would regret wasting
your time.

Cheers,

Paolo

