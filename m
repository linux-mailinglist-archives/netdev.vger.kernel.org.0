Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB101FBE6
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 16:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfD3OxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 10:53:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:43666 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbfD3OxK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 10:53:10 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7DB2014013FD3;
        Tue, 30 Apr 2019 07:53:09 -0700 (PDT)
Date:   Tue, 30 Apr 2019 10:53:06 -0400 (EDT)
Message-Id: <20190430.105306.1978317247998825768.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix net namespace cleanup
From:   David Miller <davem@davemloft.net>
In-Reply-To: <155660964874.18872.7446174793302616529.stgit@warthog.procyon.org.uk>
References: <155660964874.18872.7446174793302616529.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Apr 2019 07:53:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 30 Apr 2019 08:34:08 +0100

> In rxrpc_destroy_all_calls(), there are two phases: (1) make sure the
> ->calls list is empty, emitting error messages if not, and (2) wait for the
> RCU cleanup to happen on outstanding calls (ie. ->nr_calls becomes 0).
> 
> To avoid taking the call_lock, the function prechecks ->calls and if empty,
> it returns to avoid taking the lock - this is wrong, however: it still
> needs to go and do the second phase and wait for ->nr_calls to become 0.
> 
> Without this, the rxrpc_net struct may get deallocated before we get to the
> RCU cleanup for the last calls.  This can lead to:
> 
>   Slab corruption (Not tainted): kmalloc-16k start=ffff88802b178000, len=16384
>   050: 6b 6b 6b 6b 6b 6b 6b 6b 61 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkakkkkkkk
> 
> Note the "61" at offset 0x58.  This corresponds to the ->nr_calls member of
> struct rxrpc_net (which is >9k in size, and thus allocated out of the 16k
> slab).
> 
> 
> Fix this by flipping the condition on the if-statement, putting the locked
> section inside the if-body and dropping the return from there.  The
> function will then always go on to wait for the RCU cleanup on outstanding
> calls.
> 
> Fixes: 2baec2c3f854 ("rxrpc: Support network namespacing")
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied and queued up for -stable, thanks.
