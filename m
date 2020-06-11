Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D311F6E2C
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 21:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgFKTsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 15:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgFKTsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 15:48:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474B1C08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 12:48:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A89C1286690A;
        Thu, 11 Jun 2020 12:48:24 -0700 (PDT)
Date:   Thu, 11 Jun 2020 12:48:23 -0700 (PDT)
Message-Id: <20200611.124823.1088254975354242598.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net] tipc: fix kernel WARNING in tipc_msg_append()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200611100735.24184-1-tuong.t.lien@dektech.com.au>
References: <20200611100735.24184-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jun 2020 12:48:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Thu, 11 Jun 2020 17:07:35 +0700

> syzbot found the following issue:
> 
> WARNING: CPU: 0 PID: 6808 at include/linux/thread_info.h:150 check_copy_size include/linux/thread_info.h:150 [inline]
> WARNING: CPU: 0 PID: 6808 at include/linux/thread_info.h:150 copy_from_iter include/linux/uio.h:144 [inline]
> WARNING: CPU: 0 PID: 6808 at include/linux/thread_info.h:150 tipc_msg_append+0x49a/0x5e0 net/tipc/msg.c:242
> Kernel panic - not syncing: panic_on_warn set ...
> 
> This happens after commit 5e9eeccc58f3 ("tipc: fix NULL pointer
> dereference in streaming") that tried to build at least one buffer even
> when the message data length is zero... However, it now exposes another
> bug that the 'mss' can be zero and the 'cpy' will be negative, thus the
> above kernel WARNING will appear!
> The zero value of 'mss' is never expected because it means Nagle is not
> enabled for the socket (actually the socket type was 'SOCK_SEQPACKET'),
> so the function 'tipc_msg_append()' must not be called at all. But that
> was in this particular case since the message data length was zero, and
> the 'send <= maxnagle' check became true.
> 
> We resolve the issue by explicitly checking if Nagle is enabled for the
> socket, i.e. 'maxnagle != 0' before calling the 'tipc_msg_append()'. We
> also reinforce the function to against such a negative values if any.
> 
> Reported-by: syzbot+75139a7d2605236b0b7f@syzkaller.appspotmail.com
> Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>

Applied and queued up for v5.5+ -stable.
