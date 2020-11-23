Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548192C10BC
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 17:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732054AbgKWQeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 11:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732584AbgKWQe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 11:34:26 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CDDB20665;
        Mon, 23 Nov 2020 16:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606149265;
        bh=rRy1XN3BM1aJ+1OM2XKGfERXpJFhceWamOKyhXrGVO8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PBSap7QXYKnMdtrYl8Xk6i4UvChYotLmarg0pAI4uW2U57DxQSkZIUqU2qmKT32vX
         eN3dTLPZKPji3F4MuOrj9U1KbngzlBRcTHXt2O3WuKlEl8AG4I7RwBQv87LJbswcSd
         MMRusshAWImd/ZvOGFx/lVnKqJzwQiVNhcb5H9MA=
Date:   Mon, 23 Nov 2020 08:34:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>, netdev@vger.kernel.org
Subject: Re: [net v3] net/tls: missing received data after fast remote close
Message-ID: <20201123083424.34f9ba9f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <64311360-e363-133c-6862-4de1298942ee@novek.ru>
References: <1605801588-12236-1-git-send-email-vfedorenko@novek.ru>
        <20201120102637.7d36a9f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <64311360-e363-133c-6862-4de1298942ee@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 13:40:46 +0000 Vadim Fedorenko wrote:
> On 20.11.2020 18:26, Jakub Kicinski wrote:
> > On Thu, 19 Nov 2020 18:59:48 +0300 Vadim Fedorenko wrote:  
> >> In case when tcp socket received FIN after some data and the
> >> parser haven't started before reading data caller will receive
> >> an empty buffer. This behavior differs from plain TCP socket and
> >> leads to special treating in user-space.
> >> The flow that triggers the race is simple. Server sends small
> >> amount of data right after the connection is configured to use TLS
> >> and closes the connection. In this case receiver sees TLS Handshake
> >> data, configures TLS socket right after Change Cipher Spec record.
> >> While the configuration is in process, TCP socket receives small
> >> Application Data record, Encrypted Alert record and FIN packet. So
> >> the TCP socket changes sk_shutdown to RCV_SHUTDOWN and sk_flag with
> >> SK_DONE bit set. The received data is not parsed upon arrival and is
> >> never sent to user-space.
> >>
> >> Patch unpauses parser directly if we have unparsed data in tcp
> >> receive queue.
> >>
> >> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>  
> > Applied, thanks!  
> Looks like I missed fixes tag to queue this patch to -stable.
> 
> Fixes: c46234ebb4d1 ("tls: RX path for ktls")

I put this on:

Fixes: fcf4793e278e ("tls: check RCV_SHUTDOWN in tls_wait_data")

It's queued for stable, but it needs to hit Linus' tree first, so it'll
take another week or so to show up in stable releases.
