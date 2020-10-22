Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9309F296563
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 21:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370307AbgJVTal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 15:30:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:41380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2509624AbgJVTak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 15:30:40 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 474B624658;
        Thu, 22 Oct 2020 19:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603395039;
        bh=Y0tU6jE3TQqLARV5f7YDnlH92DMeuAB8j2kzzA7z+FA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=InkluomokR+a7oFN8Sjq7W6/KqVoUGaGl7FvGbcmONbSQHUzli4xDo0i5AaHFLoQ5
         W1x+X2UK1s6qvJb08qM2pQK2xjN2GpDt4ABA4ehcVX1iTG7bThQfoF4i4w8yBARBBR
         4F/50zzb64W6bSgoVejEtfZyo4iYTqN/Ofeck1/I=
Date:   Thu, 22 Oct 2020 12:30:37 -0700
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
Message-ID: <20201022123037.09e198a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
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
> 
> Signed-off-by: Neal Cardwell <ncardwell@google.com>
> Reported-by: Apollon Oikonomopoulos <apoikos@dmesg.gr>
> Tested-by: Apollon Oikonomopoulos <apoikos@dmesg.gr>
> Link: https://www.spinics.net/lists/netdev/msg692430.html
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Acked-by: Yuchung Cheng <ycheng@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks!
