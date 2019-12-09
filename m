Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 555FC1173E7
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLISRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:17:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33748 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfLISRj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:17:39 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C39391543A7A7;
        Mon,  9 Dec 2019 10:17:38 -0800 (PST)
Date:   Mon, 09 Dec 2019 10:17:38 -0800 (PST)
Message-Id: <20191209.101738.1448001980997003591.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net] sctp: fully initialize v4 addr in some functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <dfabc15c8718ae26d93f4ed1b023baee81eb5c34.1575870354.git.lucien.xin@gmail.com>
References: <dfabc15c8718ae26d93f4ed1b023baee81eb5c34.1575870354.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Dec 2019 10:17:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  9 Dec 2019 13:45:54 +0800

> Syzbot found a crash:
 ...
> The issue was caused by transport->ipaddr set with uninit addr param, which
> was passed by:
> 
>   sctp_transport_init net/sctp/transport.c:47 [inline]
>   sctp_transport_new+0x248/0xa00 net/sctp/transport.c:100
>   sctp_assoc_add_peer+0x5ba/0x2030 net/sctp/associola.c:611
>   sctp_process_param net/sctp/sm_make_chunk.c:2524 [inline]
> 
> where 'addr' is set by sctp_v4_from_addr_param(), and it doesn't initialize
> the padding of addr->v4.
> 
> Later when calling sctp_make_heartbeat(), hbinfo.daddr(=transport->ipaddr)
> will become the part of skb, and the issue occurs.
> 
> This patch is to fix it by initializing the padding of addr->v4 in
> sctp_v4_from_addr_param(), as well as other functions that do the similar
> thing, and these functions shouldn't trust that the caller initializes the
> memory, as Marcelo suggested.
> 
> Reported-by: syzbot+6dcbfea81cd3d4dd0b02@syzkaller.appspotmail.com
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thanks.
