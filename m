Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F186624E234
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 22:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgHUUlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 16:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbgHUUlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 16:41:46 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F6802076E;
        Fri, 21 Aug 2020 20:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598042506;
        bh=tuzYGNAkPDdRqbgfeiJVvEDKKuw+FhIxqy89SpT1leA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BEI6j9952MgI3ZXCqm1itrl+R2saxIIQNneC7KpeHuILEXiHqeOdx8TNHWLlIAAUp
         Xe6EnPLanG/PK465Gdr0gw8bmGSkejCqm0VZujggLCDj3BS1CbnHE99xerXBR+1tCq
         Bv/5ZKZO7JYqaFd2Kj93AxB/zMsT6eblp7vC7eZE=
Date:   Fri, 21 Aug 2020 13:41:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luke Hsiao <luke.w.hsiao@gmail.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Luke Hsiao <lukehsiao@google.com>,
        Arjun Roy <arjunroy@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 2/2] io_uring: ignore POLLIN for recvmsg on
 MSG_ERRQUEUE
Message-ID: <20200821134144.642f6fbb@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200820234954.1784522-3-luke.w.hsiao@gmail.com>
References: <20200820234954.1784522-1-luke.w.hsiao@gmail.com>
        <20200820234954.1784522-3-luke.w.hsiao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 16:49:54 -0700 Luke Hsiao wrote:
> +	/* If reading from MSG_ERRQUEUE using recvmsg, ignore POLLIN */
> +	if (req->opcode == IORING_OP_RECVMSG && (sqe->msg_flags & MSG_ERRQUEUE))
> +		mask &= ~(POLLIN);

FWIW this adds another W=1 C=1 warnings to this code:

fs/io_uring.c:4940:22: warning: invalid assignment: &=
fs/io_uring.c:4940:22:    left side has type restricted __poll_t
fs/io_uring.c:4940:22:    right side has type int


And obviously the brackets around POLLIN are not necessary.
