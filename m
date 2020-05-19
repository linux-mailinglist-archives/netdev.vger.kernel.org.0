Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A171DA3C6
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 23:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgESVnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 17:43:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgESVnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 17:43:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CB6120C09;
        Tue, 19 May 2020 21:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589924584;
        bh=BeIMsQvyRiSEijaf9rj6Gp/weYuIoBWcbTERVgekK9Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NRaREweqN4zMFSIyjE4ypan2weM8v04bLAAPL1j07PfVWWQgF29BB4fWWA4kM7ZKE
         dFS87OprHQ77L0MjBWQCsT1luugSCIZ9K55YyBGgbSNxe+qTDX5yvilVzSeGSy089c
         DKo0nYbO3sqHKZdrc8Wz4T3aSMuWg6kEi5UhsVzk=
Date:   Tue, 19 May 2020 14:42:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pooja Trivedi <poojatrivedi@gmail.com>
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        davem@davemloft.net, vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        mallesham.jatharkonda@oneconvergence.com, josh.tway@stackpath.com,
        Pooja Trivedi <pooja.trivedi@stackpath.com>
Subject: Re: [PATCH net] net/tls(TLS_SW): Fix integrity issue with
 non-blocking sw KTLS request
Message-ID: <20200519144255.3a7416c4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOrEds=Mo4YHm1CPrgVmPhsJagUAQ0PzyDPk9Cq3URq-7vfCWA@mail.gmail.com>
References: <1589732796-22839-1-git-send-email-pooja.trivedi@stackpath.com>
        <20200518155016.75be3663@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAOrEds=Mo4YHm1CPrgVmPhsJagUAQ0PzyDPk9Cq3URq-7vfCWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 May 2020 13:21:56 -0400 Pooja Trivedi wrote:
> On Mon, May 18, 2020 at 6:50 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Sun, 17 May 2020 16:26:36 +0000 Pooja Trivedi wrote:  
> > > In pure sw ktls(AES-NI), -EAGAIN from tcp layer (do_tcp_sendpages for
> > > encrypted record) gets treated as error, subtracts the offset, and
> > > returns to application. Because of this, application sends data from
> > > subtracted offset, which leads to data integrity issue. Since record is
> > > already encrypted, ktls module marks it as partially sent and pushes the
> > > packet to tcp layer in the following iterations (either from bottom half
> > > or when pushing next chunk). So returning success in case of EAGAIN
> > > will fix the issue.
> > >
> > > Fixes: a42055e8d2c3 ("net/tls: Add support for async encryption")
> > > Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
> > > Reviewed-by: Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>
> > > Reviewed-by: Josh Tway <josh.tway@stackpath.com>  
> >
> > This looks reasonable, I think. Next time user space calls if no new
> > buffer space was made available it will get a -EAGAIN, right?
> 
> Yes, this fix should only affect encrypted record. Plain text calls from
> user space should be unaffected.

AFAICS if TCP layer is full next call from user space should hit
sk_stream_wait_memory() immediately and if it has MSG_DONTWAIT set 
exit with EAGAIN. Which I believe to be correct behavior.

> > Two questions - is there any particular application or use case that
> > runs into this?
> 
> We are running into this case when we hit our kTLS-enabled homegrown
> webserver with a 'pipeline' test tool, also homegrown. The issue basically
> happens whenever the send buffer on the server gets full and TCP layer
> returns EAGAIN when attempting to TX the encrypted record. In fact, we
> are also able to reproduce the issue by using a simple wget with a large
> file, if/when sndbuf fills up.

I see just a coincidence, then, no worries.

> > Seems a bit surprising to see a patch from Vadim and
> > you guys come at the same time.
> 
> Not familiar with Vadim or her/his patch. Could you please point me to it?

http://patchwork.ozlabs.org/project/netdev/patch/20200517014451.954F05026DE@novek.ru/

> > Could you also add test for this bug?
> > In tools/testing/selftests/net/tls.c
> >  
> 
> Sure, yes. Let me look into this.

Thanks!
