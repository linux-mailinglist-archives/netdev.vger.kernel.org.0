Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09F3155587
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgBGKV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:21:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgBGKV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:21:57 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09D5315A32105;
        Fri,  7 Feb 2020 02:21:55 -0800 (PST)
Date:   Fri, 07 Feb 2020 11:21:54 +0100 (CET)
Message-Id: <20200207.112154.1238920306232628596.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix service call disconnection
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158099730157.2198513.14087711871251670411.stgit@warthog.procyon.org.uk>
References: <158099730157.2198513.14087711871251670411.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 02:21:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 06 Feb 2020 13:55:01 +0000

> The recent patch that substituted a flag on an rxrpc_call for the
> connection pointer being NULL as an indication that a call was disconnected
> puts the set_bit in the wrong place for service calls.  This is only a
> problem if a call is implicitly terminated by a new call coming in on the
> same connection channel instead of a terminating ACK packet.
> 
> In such a case, rxrpc_input_implicit_end_call() calls
> __rxrpc_disconnect_call(), which is now (incorrectly) setting the
> disconnection bit, meaning that when rxrpc_release_call() is later called,
> it doesn't call rxrpc_disconnect_call() and so the call isn't removed from
> the peer's error distribution list and the list gets corrupted.
> 
> KASAN finds the issue as an access after release on a call, but the
> position at which it occurs is confusing as it appears to be related to a
> different call (the call site is where the latter call is being removed
> from the error distribution list and either the next or pprev pointer
> points to a previously released call).
> 
> Fix this by moving the setting of the flag from __rxrpc_disconnect_call()
> to rxrpc_disconnect_call() in the same place that the connection pointer
> was being cleared.
> 
> Fixes: 5273a191dca6 ("rxrpc: Fix NULL pointer deref due to call->conn being cleared on disconnect")
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied and queued up for -stable.
