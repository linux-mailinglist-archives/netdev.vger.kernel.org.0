Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8890B29625A
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 18:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894718AbgJVQIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 12:08:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894368AbgJVQIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 12:08:01 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3E6224182;
        Thu, 22 Oct 2020 16:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603382880;
        bh=Ssnd7vYRcJaelhif0ept1lCEp8MTX/bpG3VWRtvagyc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ES2kTyfBu9gnrxPwhFoDic+3dDKbKeVpQeY9a3WGWHq6raDD8LqvunJIKIzE+b9+g
         lU6RbSlxOXw+GRGng/8RAOU5ucTkGsYlxiznseEIATqzAbP77b8NybmM77IIaziaS+
         FAGMMnU5LmruLK/sYUClUBXMVm/D3IHa/hxySGck=
Date:   Thu, 22 Oct 2020 09:07:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Neal Cardwell <ncardwell.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Apollon Oikonomopoulos <apoikos@dmesg.gr>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] tcp: fix to update snd_wl1 in bulk receiver fast
 path
Message-ID: <20201022090757.4ac6ba0f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022143331.1887495-1-ncardwell.kernel@gmail.com>
References: <20201022143331.1887495-1-ncardwell.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 10:33:31 -0400 Neal Cardwell wrote:
> From: Neal Cardwell <ncardwell@google.com>
> 
> In the header prediction fast path for a bulk data receiver, if no
> data is newly acknowledged then we do not call tcp_ack() and do not
> call tcp_ack_update_window(). This means that a bulk receiver that
> receives large amounts of data can have the incoming sequence numbers
> wrap, so that the check in tcp_may_update_window fails:
>    after(ack_seq, tp->snd_wl1)
> 
> If the incoming receive windows are zero in this state, and then the
> connection that was a bulk data receiver later wants to send data,
> that connection can find itself persistently rejecting the window
> updates in incoming ACKs. This means the connection can persistently
> fail to discover that the receive window has opened, which in turn
> means that the connection is unable to send anything, and the
> connection's sending process can get permanently "stuck".
> 
> The fix is to update snd_wl1 in the header prediction fast path for a
> bulk data receiver, so that it keeps up and does not see wrapping
> problems.
> 
> This fix is based on a very nice and thorough analysis and diagnosis
> by Apollon Oikonomopoulos (see link below).
> 
> This is a stable candidate but there is no Fixes tag here since the
> bug predates current git history. Just for fun: looks like the bug
> dates back to when header prediction was added in Linux v2.1.8 in Nov
> 1996. In that version tcp_rcv_established() was added, and the code
> only updates snd_wl1 in tcp_ack(), and in the new "Bulk data transfer:
> receiver" code path it does not call tcp_ack(). This fix seems to
> apply cleanly at least as far back as v3.2.

In that case - can I slap:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

on it?
