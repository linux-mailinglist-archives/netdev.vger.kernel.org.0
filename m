Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BD223D0AE
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgHETwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:52:07 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21823 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728179AbgHEQvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596646294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r5xlMTb9c9iOlpIFXkzToRbyVMDVlpxS0zDqWUzYUZ0=;
        b=ezUi9XPXJjjltcTQFgcIJwfZkTRdU4ckVBj8tezQOaQpkI74GGNIaLD/UYIY/oqnF+/gFl
        +ylNV0KKbfw0ILfzkia9tvny8uDJuZfW18J+kD9EaKVSJMwtU3+q0K5L81uvu6FX6Q2vkF
        3UtFCtjkHlTmqjIC/c2mUvh0JFpDSqU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-tJjPWY-gN66lMFBMVfSQzg-1; Wed, 05 Aug 2020 09:23:42 -0400
X-MC-Unique: tJjPWY-gN66lMFBMVfSQzg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53D62102C7E9;
        Wed,  5 Aug 2020 13:23:41 +0000 (UTC)
Received: from localhost (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8D89712C5;
        Wed,  5 Aug 2020 13:23:38 +0000 (UTC)
Date:   Wed, 5 Aug 2020 15:23:34 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20200805152334.6b36a06d@redhat.com>
In-Reply-To: <20200805132144.GA12227@osiris>
References: <20200805223121.7dec86de@canb.auug.org.au>
        <20200805150627.3351fe24@redhat.com>
        <20200805132144.GA12227@osiris>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Aug 2020 15:21:44 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> On Wed, Aug 05, 2020 at 03:06:27PM +0200, Stefano Brivio wrote:
> > On Wed, 5 Aug 2020 22:31:21 +1000
> > Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >   
> > > Hi all,
> > > 
> > > After merging the net-next tree, today's linux-next build (s390 defconfig)
> > > failed like this:
> > > 
> > > net/ipv4/ip_tunnel_core.c:335:2: error: implicit declaration of function 'csum_ipv6_magic' [-Werror=implicit-function-declaration]
> > > 
> > > Caused by commit
> > > 
> > >   4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")  
> > 
> > Ouch, sorry for that.
> > 
> > I'm getting a few of them by the way:
> > 
> > ---
> > net/core/skbuff.o: In function `skb_checksum_setup_ipv6':
> > /home/sbrivio/net-next/net/core/skbuff.c:4980: undefined reference to `csum_ipv6_magic'
> > net/core/netpoll.o: In function `netpoll_send_udp':
> > /home/sbrivio/net-next/net/core/netpoll.c:419: undefined reference to `csum_ipv6_magic'
> > net/netfilter/utils.o: In function `nf_ip6_checksum':
> > /home/sbrivio/net-next/net/netfilter/utils.c:74: undefined reference to `csum_ipv6_magic'
> > /home/sbrivio/net-next/net/netfilter/utils.c:84: undefined reference to `csum_ipv6_magic'
> > net/netfilter/utils.o: In function `nf_ip6_checksum_partial':
> > /home/sbrivio/net-next/net/netfilter/utils.c:112: undefined reference to `csum_ipv6_magic'
> > net/ipv4/ip_tunnel_core.o:/home/sbrivio/net-next/net/ipv4/ip_tunnel_core.c:335: more undefined references to `csum_ipv6_magic' follow
> > ---
> > 
> > ...checking how it should be fixed now.
> > 
> > Heiko, by the way, do we want to provide a s390 version similar to the
> > existing csum_partial() implementation in
> > arch/s390/include/asm/checksum.h right away? Otherwise, I'll just take
> > care of the ifdeffery.  
> 
> You probably only need to include include/net/ip6_checksum.h which
> contains the default implementation.

Yes, patch already sent a couple of minutes ago, still waiting for it to
reach the lists. Thanks!

-- 
Stefano

