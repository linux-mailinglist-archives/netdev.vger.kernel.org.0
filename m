Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD9F1B5483
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 08:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgDWGBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 02:01:43 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51124 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgDWGBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 02:01:42 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0266C204B4;
        Thu, 23 Apr 2020 08:01:41 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xBidErRNvxDJ; Thu, 23 Apr 2020 08:01:40 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 91CAF201AA;
        Thu, 23 Apr 2020 08:01:40 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 23 Apr 2020 08:01:40 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 23 Apr
 2020 08:01:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id ECF9731800BD;
 Thu, 23 Apr 2020 08:01:39 +0200 (CEST)
Date:   Thu, 23 Apr 2020 08:01:39 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <yuanxzhang@fudan.edu.cn>,
        <kjlu@umn.edu>, Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] xfrm: Fix xfrm_state refcnt leak in xfrm_input()
Message-ID: <20200423060139.GB13121@gauss3.secunet.de>
References: <1587619161-14094-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1587619161-14094-1-git-send-email-xiyuyang19@fudan.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 01:19:20PM +0800, Xiyu Yang wrote:
> xfrm_input() invokes xfrm_state_lookup(), which returns a reference of
> the specified xfrm_state object to "x" with increased refcnt and then
> "x" is escaped to "sp->xvec[]".
> 
> When xfrm_input() encounters error, it calls kfree_skb() to free the
> "skb" memory. Since "sp" comes from one of "skb" fields, this "free"
> behavior causes "sp" becomes invalid, so the refcount for its field
> should be decreased to keep refcount balanced before kfree_skb() calls.
> 
> The reference counting issue happens in several exception handling paths
> of xfrm_input(). When those error scenarios occur such as skb_dst()
> fails, the function forgets to decrease the refcnt increased by
> xfrm_state_lookup() and directly calls kfree_skb(), causing a refcnt
> leak.

kfree_skb() drops these refcounts already, why should we do that here
too?

