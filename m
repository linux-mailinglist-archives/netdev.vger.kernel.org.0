Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6843120A1
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 01:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhBGA5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Feb 2021 19:57:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229621AbhBGA5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Feb 2021 19:57:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 139AC64E8A;
        Sun,  7 Feb 2021 00:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612659421;
        bh=HElelfwEhwItNmYF0g+ADJalr5XrhWxQQ1iNujKzfOM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EppBVZzdIC6SIxplGF1L4YfWat9tGLSB3MwtfZsJliw7s+E2EOqdS0446S+ZL/xie
         Fa2o0a27DAP+U1J0d24kW9GhIrjjjrUXMnC6g3IYmp++WZCsjQb/1Ea3IJgQ6bMlPV
         yVby18cCPtOACNqGP+Fry3omRnjISYFg8JCA3TBGXS5syl/d8tWrvnZ1vkbnxFyNav
         3Ttlj1Vh3A0KdSf2PfF9nskTpXhpdb3UjQNTEAmTzXcgvLLM6DGZDTCgTmq9L7Lpom
         SDqzaT1Oie4xo2EWpBDLylAiRQ+NLShwQPxZtFWIxeoPTzcw4+K0q8eDxlEcqd0+EI
         u/6tv1s6KPYCg==
Date:   Sat, 6 Feb 2021 16:57:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Norbert Slusarek <nslusarek@gmx.net>, alex.popov@linux.com,
        eric.dumazet@gmail.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/vmw_vsock: fix NULL pointer dereference
Message-ID: <20210206165700.23c5ae36@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210205171335.hpzoysoynko4bkhe@steredhat>
References: <trinity-c2d6cede-bfb1-44e2-85af-1fbc7f541715-1612535117028@3c-app-gmx-bap12>
        <20210205171335.hpzoysoynko4bkhe@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Feb 2021 18:13:35 +0100 Stefano Garzarella wrote:
> On Fri, Feb 05, 2021 at 03:25:17PM +0100, Norbert Slusarek wrote:
> >From: Norbert Slusarek <nslusarek@gmx.net>
> >Date: Fri, 5 Feb 2021 13:12:06 +0100
> >Subject: [PATCH] net/vmw_vsock: fix NULL pointer dereference
> >
> >In vsock_stream_connect(), a thread will enter schedule_timeout().
> >While being scheduled out, another thread can enter vsock_stream_connect()
> >as well and set vsk->transport to NULL. In case a signal was sent, the
> >first thread can leave schedule_timeout() and vsock_transport_cancel_pkt()
> >will be called right after. Inside vsock_transport_cancel_pkt(), a null
> >dereference will happen on transport->cancel_pkt.
> >
> >Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
> >Reported-by: Norbert Slusarek <nslusarek@gmx.net>
> >Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
> >---
> > net/vmw_vsock/af_vsock.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >index 6894f21dc147..cb81cfb47a78 100644
> >--- a/net/vmw_vsock/af_vsock.c
> >+++ b/net/vmw_vsock/af_vsock.c
> >@@ -1233,7 +1233,7 @@ static int vsock_transport_cancel_pkt(struct vsock_sock *vsk)
> > {
> > 	const struct vsock_transport *transport = vsk->transport;
> >
> >-	if (!transport->cancel_pkt)
> >+	if (!transport || !transport->cancel_pkt)
> > 		return -EOPNOTSUPP;
> >
> > 	return transport->cancel_pkt(vsk);
> >--
> >2.30.0
> >  
> 
> I can't see this patch on https://patchwork.kernel.org/project/netdevbpf/list/
> 
> Maybe because you forgot to CC the netdev maintainers.
> Please next time use scripts/get_maintainer.pl
> 
> Anyway the patch LGTM, so
> 
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Applied, thanks!
