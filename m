Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD97418C5C5
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 04:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgCTD25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 23:28:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46326 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgCTD25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 23:28:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 84615158EC784;
        Thu, 19 Mar 2020 20:28:56 -0700 (PDT)
Date:   Thu, 19 Mar 2020 20:28:55 -0700 (PDT)
Message-Id: <20200319.202855.777232170285897789.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 0/6] rxrpc, afs: Interruptibility fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158461880968.3094720.5019510060910604912.stgit@warthog.procyon.org.uk>
References: <158461880968.3094720.5019510060910604912.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 20:28:56 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 19 Mar 2020 11:53:29 +0000

> Here are a number of fixes for AF_RXRPC and AFS that make AFS system calls
> less interruptible and so less likely to leave the filesystem in an
> uncertain state.  There's also a miscellaneous patch to make tracing
> consistent.
> 
>  (1) Firstly, abstract out the Tx space calculation in sendmsg.  Much the
>      same code is replicated in a number of places that subsequent patches
>      are going to alter, including adding another copy.
> 
>  (2) Fix Tx interruptibility by allowing a kernel service, such as AFS, to
>      request that a call be interruptible only when waiting for a call slot
>      to become available (ie. the call has not taken place yet) or that a
>      call be not interruptible at all (e.g. when we want to do writeback
>      and don't want a signal interrupting a VM-induced writeback).
> 
>  (3) Increase the minimum delay on MSG_WAITALL for userspace sendmsg() when
>      waiting for Tx buffer space as a 2*RTT delay is really small over 10G
>      ethernet and a 1 jiffy timeout might be essentially 0 if at the end of
>      the jiffy period.
> 
>  (4) Fix some tracing output in AFS to make it consistent with rxrpc.
> 
>  (5) Make sure aborted asynchronous AFS operations are tidied up properly
>      so we don't end up with stuck rxrpc calls.
> 
>  (6) Make AFS client calls uninterruptible in the Rx phase.  If we don't
>      wait for the reply to be fully gathered, we can't update the local VFS
>      state and we end up in an indeterminate state with respect to the
>      server.
> 
> The patches are tagged here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
> 	rxrpc-fixes-20200319

Pulled, thanks David.
