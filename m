Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC291DF258
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 00:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbgEVWsf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 May 2020 18:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731029AbgEVWse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 18:48:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A30C061A0E;
        Fri, 22 May 2020 15:48:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5BD2112744698;
        Fri, 22 May 2020 15:48:34 -0700 (PDT)
Date:   Fri, 22 May 2020 15:48:33 -0700 (PDT)
Message-Id: <20200522.154833.1534807790311464208.davem@davemloft.net>
To:     jere.leppanen@nokia.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, David.Laight@aculab.com
Subject: Re: [PATCH net 1/1] sctp: Start shutdown on association restart if
 in SHUTDOWN-SENT state and socket is closed
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200520151531.787414-1-jere.leppanen@nokia.com>
References: <20200520151531.787414-1-jere.leppanen@nokia.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 May 2020 15:48:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jere Leppänen <jere.leppanen@nokia.com>
Date: Wed, 20 May 2020 18:15:31 +0300

> Commit bdf6fa52f01b ("sctp: handle association restarts when the
> socket is closed.") starts shutdown when an association is restarted,
> if in SHUTDOWN-PENDING state and the socket is closed. However, the
> rationale stated in that commit applies also when in SHUTDOWN-SENT
> state - we don't want to move an association to ESTABLISHED state when
> the socket has been closed, because that results in an association
> that is unreachable from user space.
> 
> The problem scenario:
> 
> 1.  Client crashes and/or restarts.
> 
> 2.  Server (using one-to-one socket) calls close(). SHUTDOWN is lost.
> 
> 3.  Client reconnects using the same addresses and ports.
> 
> 4.  Server's association is restarted. The association and the socket
>     move to ESTABLISHED state, even though the server process has
>     closed its descriptor.
> 
> Also, after step 4 when the server process exits, some resources are
> leaked in an attempt to release the underlying inet sock structure in
> ESTABLISHED state:
> 
>     IPv4: Attempt to release TCP socket in state 1 00000000377288c7
> 
> Fix by acting the same way as in SHUTDOWN-PENDING state. That is, if
> an association is restarted in SHUTDOWN-SENT state and the socket is
> closed, then start shutdown and don't move the association or the
> socket to ESTABLISHED state.
> 
> Fixes: bdf6fa52f01b ("sctp: handle association restarts when the socket is closed.")
> Signed-off-by: Jere Leppänen <jere.leppanen@nokia.com>

Applied and queued up for -stable, thanks.
