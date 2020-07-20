Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B4D226DA3
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbgGTRzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:55:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgGTRzq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 13:55:46 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D81D920709;
        Mon, 20 Jul 2020 17:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595267745;
        bh=gKIze89vWBzrFx6zTW6q8+6OGOi2eEHSp9M1U5xgK5Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IVyIlrMN24MPKjy4d8SMWaW7uCiUcpLg3yjCC0C2S6ZfKpknKzmS2DwkqaZUR6kcj
         eH3tVcf8T0FWz3MgsFZPKw/95GZuUU1R6RXP6YgHYNC1Xrh1jm83A8jQXDelAkEKiB
         ufMchI7Ce61Y9ZnRUJK/bZ/+BU6OKViPemeOOMWQ=
Date:   Mon, 20 Jul 2020 10:55:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: [PATCH 03/24] net: add a new sockptr_t type
Message-ID: <20200720175543.GF1292162@gmail.com>
References: <20200720124737.118617-1-hch@lst.de>
 <20200720124737.118617-4-hch@lst.de>
 <20200720163748.GA1292162@gmail.com>
 <20200720174322.GA21785@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720174322.GA21785@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 07:43:22PM +0200, Christoph Hellwig wrote:
> On Mon, Jul 20, 2020 at 09:37:48AM -0700, Eric Biggers wrote:
> > How does this not introduce a massive security hole when
> > CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE?
> > 
> > AFAICS, userspace can pass in a pointer >= TASK_SIZE,
> > and this code makes it be treated as a kernel pointer.
> 
> Yeah, we'll need to validate that before initializing the pointer.
> 
> But thinking this a little further:  doesn't this mean any
> set_fs(KERNEL_DS) that has other user pointers than the one it is
> intended for has the same issue?  Pretty much all of these are gone
> in mainline now, but in older stable kernels there might be some
> interesting cases, especially in the compat ioctl handlers.

Yes.  I thought that eliminating that class of bug is one of the main
motivations for your "remove set_fs" work.  See commit 128394eff343
("sg_write()/bsg_write() is not fit to be called under KERNEL_DS") for a case
where this type of bug was fixed.

Are you aware of any specific cases that weren't already fixed?  If there are
any, they need to be urgently fixed.

- Eric
