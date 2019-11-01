Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B070AEBEBA
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 08:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730098AbfKAHxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 03:53:38 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:50862 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729455AbfKAHxh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 03:53:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2F561204E0;
        Fri,  1 Nov 2019 08:53:36 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gCyRw0i6cygr; Fri,  1 Nov 2019 08:53:35 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B95D220591;
        Fri,  1 Nov 2019 08:53:35 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 1 Nov 2019
 08:53:35 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 57766318027A;
 Fri,  1 Nov 2019 08:53:35 +0100 (CET)
Date:   Fri, 1 Nov 2019 08:53:35 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     JD <jdtxs00@gmail.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: Followup: Kernel memory leak on 4.11+ & 5.3.x with IPsec
Message-ID: <20191101075335.GG14361@gauss3.secunet.de>
References: <CAMnf+Pg4BLVKAGsr9iuF1uH-GMOiyb8OW0nKQSEKmjJvXj+t1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAMnf+Pg4BLVKAGsr9iuF1uH-GMOiyb8OW0nKQSEKmjJvXj+t1g@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 02:30:27PM -0500, JD wrote:
> 
> Here are some clear steps to reproduce:
> - On your preferred OS, install an IPsec daemon/software
> (strongswan/openswan/whatever)
> - Setup a IKEv2 conn in tunnel mode. Use a RFC1918 private range for
> your client IP pool. e.g: 10.2.0.0/16
> - Enable IP forwarding (net.ipv4.ip_forward = 1)
> - MASQUERADE the 10.2.0.0/16 range using iptables, e.g: "-A
> POSTROUTING -s 10.2.0.0/16 -o eth0 -j MASQUERADE"
> - Connect some IKEv2 clients (any device, any platform, doesn't
> matter) and pass traffic through the tunnel.
> ^^ It speeds up the leak if you have multiple tunnels passing traffic
> at the same time.
> 
> - Observe memory is lost over time and never recovered. Doesn't matter
> if you restart the daemon, bring down the tunnels, or even unload
> xfrm/ipsec modules. The memory goes into the void. Only way to reclaim
> is by restarting completely.
> 
> Please let me know if anything further is needed to diagnose/debug
> this problem. We're stuck with the 4.9 kernel because all newer
> kernels leak memory. Any help or advice is appreciated.

Looks like we forget to free the page that we use for
skb page fragments when deleting the xfrm_state.

Can you please try the patch below? I don't have access
to my test environment today, so this patch is untested.
I'll try to do some tests on Monday.


diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index c6f3c4a1bd99..f3423562d933 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -495,6 +495,8 @@ static void ___xfrm_state_destroy(struct xfrm_state *x)
 		x->type->destructor(x);
 		xfrm_put_type(x->type);
 	}
+	if (x->xfrag.page)
+		put_page(x->xfrag.page);
 	xfrm_dev_state_free(x);
 	security_xfrm_state_free(x);
 	xfrm_state_free(x);
