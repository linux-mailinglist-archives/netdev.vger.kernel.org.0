Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 029C4786F5
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 10:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbfG2IDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 04:03:43 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51364 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbfG2IDn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 04:03:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id A91E620251;
        Mon, 29 Jul 2019 10:03:42 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id z3XHQg18Gcm1; Mon, 29 Jul 2019 10:03:42 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 43F7220082;
        Mon, 29 Jul 2019 10:03:42 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.468.0; Mon, 29 Jul 2019
 10:03:41 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id D9F5231805DA;
 Mon, 29 Jul 2019 10:03:41 +0200 (CEST)
Date:   Mon, 29 Jul 2019 10:03:41 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] net: xfrm: possible null-pointer dereferences in
 xfrm_policy()
Message-ID: <20190729080341.GJ2879@gauss3.secunet.de>
References: <464bb93d-75b2-c21b-ee32-25a10ff61622@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <464bb93d-75b2-c21b-ee32-25a10ff61622@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 29, 2019 at 11:43:49AM +0800, Jia-Ju Bai wrote:
> In xfrm_policy(), the while loop on lines 3802-3830 ends when dst->xfrm is
> NULL.

We don't have a xfrm_policy() function, and as said already the
line numbers does not help much as long as you don't say which
tree/branch this is and which commit is the head commit.

> Then, dst->xfrm is used on line 3840:
>     xfrm_state_mtu(dst->xfrm, mtu);
>         if (x->km.state != XFRM_STATE_VALID...)
>         aead = x->data;
> 
> Thus, possible null-pointer dereferences may occur.

I guess you refer to xfrm_bundle_ok(). The dst pointer
is reoaded after the loop, so the dereferenced pointer
is not the one that had NULL at dst->xfrm.

> 
> These bugs are found by a static analysis tool STCheck written by us.
> 
> I do not know how to correctly fix these bugs, so I only report them.

I'd suggest you to manually review the reports of your
tool and to fix the tool accordingly.
