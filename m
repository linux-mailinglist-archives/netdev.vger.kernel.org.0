Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BC922D1E8
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 00:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgGXWnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 18:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgGXWnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 18:43:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EDEC0619D3;
        Fri, 24 Jul 2020 15:43:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7C0081274F734;
        Fri, 24 Jul 2020 15:26:58 -0700 (PDT)
Date:   Fri, 24 Jul 2020 15:43:42 -0700 (PDT)
Message-Id: <20200724.154342.1433271593505001306.davem@davemloft.net>
To:     hch@lst.de
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
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
Subject: Re: get rid of the address_space override in setsockopt v2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200723060908.50081-1-hch@lst.de>
References: <20200723060908.50081-1-hch@lst.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 Jul 2020 15:26:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Date: Thu, 23 Jul 2020 08:08:42 +0200

> setsockopt is the last place in architecture-independ code that still
> uses set_fs to force the uaccess routines to operate on kernel pointers.
> 
> This series adds a new sockptr_t type that can contained either a kernel
> or user pointer, and which has accessors that do the right thing, and
> then uses it for setsockopt, starting by refactoring some low-level
> helpers and moving them over to it before finally doing the main
> setsockopt method.
> 
> Note that apparently the eBPF selftests do not even cover this path, so
> the series has been tested with a testing patch that always copies the
> data first and passes a kernel pointer.  This is something that works for
> most common sockopts (and is something that the ePBF support relies on),
> but unfortunately in various corner cases we either don't use the passed
> in length, or in one case actually copy data back from setsockopt, or in
> case of bpfilter straight out do not work with kernel pointers at all.
> 
> Against net-next/master.
> 
> Changes since v1:
>  - check that users don't pass in kernel addresses
>  - more bpfilter cleanups
>  - cosmetic mptcp tweak

Series applied to net-next, I'm build testing and will push this out when
that is done.

Thanks.
