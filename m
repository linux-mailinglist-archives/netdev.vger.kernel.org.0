Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C951D1BAB
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 18:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389765AbgEMQ6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 12:58:53 -0400
Received: from verein.lst.de ([213.95.11.211]:47611 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbgEMQ6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 12:58:53 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A458168B05; Wed, 13 May 2020 18:58:50 +0200 (CEST)
Date:   Wed, 13 May 2020 18:58:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: cleanly handle kernel vs user buffers for
 ->msg_control
Message-ID: <20200513165850.GA26121@lst.de>
References: <20200511115913.1420836-1-hch@lst.de> <20200511115913.1420836-4-hch@lst.de> <c88897b9-7afb-a6f6-08f1-5aaa36631a25@gmail.com> <20200513160938.GA22381@lst.de> <b9728e02-e317-2aa6-9ed4-723ee3abfb78@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9728e02-e317-2aa6-9ed4-723ee3abfb78@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 09:18:36AM -0700, Eric Dumazet wrote:
> Please try the following syzbot repro, since it crashes after your patch.

Doesn't crash here, but I could totally see why it could depending
in the stack initialization.  Please try the patch below - these
msghdr intance were something I missed because they weren't using
any highlevel recvmsg interfaces.  I'll do another round of audits
to see if there is anything else.


diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
index 18d05403d3b52..a0e50cc57e545 100644
--- a/net/ipv6/ipv6_sockglue.c
+++ b/net/ipv6/ipv6_sockglue.c
@@ -1075,6 +1075,7 @@ static int do_ipv6_getsockopt(struct sock *sk, int level, int optname,
 		msg.msg_control = optval;
 		msg.msg_controllen = len;
 		msg.msg_flags = flags;
+		msg.msg_control_is_user = true;
 
 		lock_sock(sk);
 		skb = np->pktoptions;
