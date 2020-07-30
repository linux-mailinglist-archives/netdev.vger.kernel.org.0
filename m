Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715CD233C49
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730800AbgG3XvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgG3XvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 19:51:07 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15025C061574;
        Thu, 30 Jul 2020 16:51:07 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5BD01126C0C7A;
        Thu, 30 Jul 2020 16:34:21 -0700 (PDT)
Date:   Thu, 30 Jul 2020 16:51:06 -0700 (PDT)
Message-Id: <20200730.165106.583204907666935136.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org,
        syzbot+b54969381df354936d96@syzkaller.appspotmail.com,
        marc.dionne@auristor.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix race between recvmsg and sendmsg on
 immediate call failure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <159597743637.3473535.17426270487937799293.stgit@warthog.procyon.org.uk>
References: <159597743637.3473535.17426270487937799293.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jul 2020 16:34:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Wed, 29 Jul 2020 00:03:56 +0100

> There's a race between rxrpc_sendmsg setting up a call, but then failing to
> send anything on it due to an error, and recvmsg() seeing the call
> completion occur and trying to return the state to the user.
> 
> An assertion fails in rxrpc_recvmsg() because the call has already been
> released from the socket and is about to be released again as recvmsg deals
> with it.  (The recvmsg_q queue on the socket holds a ref, so there's no
> problem with use-after-free.)
> 
> We also have to be careful not to end up reporting an error twice, in such
> a way that both returns indicate to userspace that the user ID supplied
> with the call is no longer in use - which could cause the client to
> malfunction if it recycles the user ID fast enough.
> 
> Fix this by the following means:
 ...
> An oops like the following is produced:
 ...
> Fixes: 357f5ef64628 ("rxrpc: Call rxrpc_release_call() on error in rxrpc_new_client_call()")
> Reported-by: syzbot+b54969381df354936d96@syzkaller.appspotmail.com
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Marc Dionne <marc.dionne@auristor.com>

Applied and queued up for -stable, thanks David.
