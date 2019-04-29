Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF1B6E137
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 13:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfD2LWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 07:22:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36906 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727710AbfD2LWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 07:22:12 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hL4MC-0005tc-Kv; Mon, 29 Apr 2019 07:22:07 -0400
Date:   Mon, 29 Apr 2019 07:21:31 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: Re: [PATCH net] sctp: avoid running the sctp state machine
 recursively
Message-ID: <20190429112131.GA18158@hmswarspite.think-freely.org>
References: <3a5d5e96521a5f53ed36ca85219294c34be7d0ef.1556518579.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a5d5e96521a5f53ed36ca85219294c34be7d0ef.1556518579.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 02:16:19PM +0800, Xin Long wrote:
> Ying triggered a call trace when doing an asconf testing:
> 
>   BUG: scheduling while atomic: swapper/12/0/0x10000100
>   Call Trace:
>    <IRQ>  [<ffffffffa4375904>] dump_stack+0x19/0x1b
>    [<ffffffffa436fcaf>] __schedule_bug+0x64/0x72
>    [<ffffffffa437b93a>] __schedule+0x9ba/0xa00
>    [<ffffffffa3cd5326>] __cond_resched+0x26/0x30
>    [<ffffffffa437bc4a>] _cond_resched+0x3a/0x50
>    [<ffffffffa3e22be8>] kmem_cache_alloc_node+0x38/0x200
>    [<ffffffffa423512d>] __alloc_skb+0x5d/0x2d0
>    [<ffffffffc0995320>] sctp_packet_transmit+0x610/0xa20 [sctp]
>    [<ffffffffc098510e>] sctp_outq_flush+0x2ce/0xc00 [sctp]
>    [<ffffffffc098646c>] sctp_outq_uncork+0x1c/0x20 [sctp]
>    [<ffffffffc0977338>] sctp_cmd_interpreter.isra.22+0xc8/0x1460 [sctp]
>    [<ffffffffc0976ad1>] sctp_do_sm+0xe1/0x350 [sctp]
>    [<ffffffffc099443d>] sctp_primitive_ASCONF+0x3d/0x50 [sctp]
>    [<ffffffffc0977384>] sctp_cmd_interpreter.isra.22+0x114/0x1460 [sctp]
>    [<ffffffffc0976ad1>] sctp_do_sm+0xe1/0x350 [sctp]
>    [<ffffffffc097b3a4>] sctp_assoc_bh_rcv+0xf4/0x1b0 [sctp]
>    [<ffffffffc09840f1>] sctp_inq_push+0x51/0x70 [sctp]
>    [<ffffffffc099732b>] sctp_rcv+0xa8b/0xbd0 [sctp]
> 
> As it shows, the first sctp_do_sm() running under atomic context (NET_RX
> softirq) invoked sctp_primitive_ASCONF() that uses GFP_KERNEL flag later,
> and this flag is supposed to be used in non-atomic context only. Besides,
> sctp_do_sm() was called recursively, which is not expected.
> 
> Vlad tried to fix this recursive call in Commit c0786693404c ("sctp: Fix
> oops when sending queued ASCONF chunks") by introducing a new command
> SCTP_CMD_SEND_NEXT_ASCONF. But it didn't work as this command is still
> used in the first sctp_do_sm() call, and sctp_primitive_ASCONF() will
> be called in this command again.
> 
> To avoid calling sctp_do_sm() recursively, we send the next queued ASCONF
> not by sctp_primitive_ASCONF(), but by sctp_sf_do_prm_asconf() in the 1st
> sctp_do_sm() directly.
> 
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/net/sctp/command.h |  1 -
>  net/sctp/sm_sideeffect.c   | 29 -----------------------------
>  net/sctp/sm_statefuns.c    | 35 +++++++++++++++++++++++++++--------
>  3 files changed, 27 insertions(+), 38 deletions(-)
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

