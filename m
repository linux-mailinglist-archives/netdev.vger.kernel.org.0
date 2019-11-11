Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9BCBF6E88
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbfKKG2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:28:36 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:51392 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbfKKG2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 01:28:36 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 49895204EF;
        Mon, 11 Nov 2019 07:28:34 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 3BZZWIpmLEeH; Mon, 11 Nov 2019 07:28:33 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D2AC92027C;
        Mon, 11 Nov 2019 07:28:33 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 11 Nov 2019
 07:28:33 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3936C3180071;
 Mon, 11 Nov 2019 07:28:32 +0100 (CET)
Date:   Mon, 11 Nov 2019 07:28:32 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     JD <jdtxs00@gmail.com>
CC:     <netdev@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: Re: Followup: Kernel memory leak on 4.11+ & 5.3.x with IPsec
Message-ID: <20191111062832.GP13225@gauss3.secunet.de>
References: <CAMnf+Pg4BLVKAGsr9iuF1uH-GMOiyb8OW0nKQSEKmjJvXj+t1g@mail.gmail.com>
 <20191101075335.GG14361@gauss3.secunet.de>
 <f5d26eeb-02b5-20f4-14f5-e56721c97eb8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f5d26eeb-02b5-20f4-14f5-e56721c97eb8@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 04, 2019 at 12:25:37PM -0600, JD wrote:
> 
> Hello Steffen,
> 
> I left the stress test running over the weekend and everything still looks
> great. Your patch definitely resolves the leak.

I've just applied the patch below to the IPsec tree.

Thanks again for reporting and testing!

Subject: [PATCH] xfrm: Fix memleak on xfrm state destroy

We leak the page that we use to create skb page fragments
when destroying the xfrm_state. Fix this by dropping a
page reference if a page was assigned to the xfrm_state.

Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
Reported-by: JD <jdtxs00@gmail.com>
Reported-by: Paul Wouters <paul@nohats.ca>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_state.c | 2 ++
 1 file changed, 2 insertions(+)

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
-- 
2.17.1

