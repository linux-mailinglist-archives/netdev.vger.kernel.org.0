Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735D73B1425
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 08:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhFWGtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 02:49:13 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:33294 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWGtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 02:49:13 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 8CEB080004E;
        Wed, 23 Jun 2021 08:46:55 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 08:46:55 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 23 Jun
 2021 08:46:55 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B107F31803BD; Wed, 23 Jun 2021 08:46:54 +0200 (CEST)
Date:   Wed, 23 Jun 2021 08:46:54 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
CC:     <netdev@vger.kernel.org>, <jarod@redhat.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <secdev@chelsio.com>
Subject: Re: [PATCH net] xfrm: Fix xfrm offload fallback fail case
Message-ID: <20210623064654.GG40979@gauss3.secunet.de>
References: <20210622035531.3780-1-ayush.sawal@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210622035531.3780-1-ayush.sawal@chelsio.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 09:25:31AM +0530, Ayush Sawal wrote:
> In case of xfrm offload, if xdo_dev_state_add() of driver returns
> -EOPNOTSUPP, xfrm offload fallback is failed.
> In xfrm state_add() both xso->dev and xso->real_dev are initialized to
> dev and when err(-EOPNOTSUPP) is returned only xso->dev is set to null.
> 
> So in this scenario the condition in func validate_xmit_xfrm(),
> if ((x->xso.dev != dev) && (x->xso.real_dev == dev))
>                 return skb;
> returns true, due to which skb is returned without calling esp_xmit()
> below which has fallback code. Hence the CRYPTO_FALLBACK is failing.
> 
> So fixing this with by keeping x->xso.real_dev as NULL when err is
> returned in func xfrm_dev_state_add().
> 
> Fixes: bdfd2d1fa79a ("bonding/xfrm: use real_dev instead of slave_dev")
> Signed-off-by: Ayush Sawal <ayush.sawal@chelsio.com>

Applied, thanks Ayush!
