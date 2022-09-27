Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E56F5EBA07
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 07:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiI0FtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 01:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiI0FtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 01:49:08 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541F98FD41
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 22:49:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 20531204B4;
        Tue, 27 Sep 2022 07:49:06 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zZmPQzUuA3VF; Tue, 27 Sep 2022 07:49:05 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id A0FBB2008D;
        Tue, 27 Sep 2022 07:49:05 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 923C280004A;
        Tue, 27 Sep 2022 07:49:05 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 07:49:05 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 27 Sep
 2022 07:49:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C162731829E5; Tue, 27 Sep 2022 07:49:04 +0200 (CEST)
Date:   Tue, 27 Sep 2022 07:49:04 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 7/8] xfrm: add support to HW update soft
 and hard limits
Message-ID: <20220927054904.GM2950045@gauss3.secunet.de>
References: <cover.1662295929.git.leonro@nvidia.com>
 <4d8f2155e79af5a12f6358337bdc0f035f687769.1662295929.git.leonro@nvidia.com>
 <20220925092006.GT2602992@gauss3.secunet.de>
 <YzFBozQTGVbmKcwN@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YzFBozQTGVbmKcwN@unreal>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 09:07:31AM +0300, Leon Romanovsky wrote:
> On Sun, Sep 25, 2022 at 11:20:06AM +0200, Steffen Klassert wrote:
> > On Sun, Sep 04, 2022 at 04:15:41PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Both in RX and TX, the traffic that performs IPsec full offload
> > > transformation is accounted by HW. It is needed to properly handle
> > > hard limits that require to drop the packet.
> > > 
> > > It means that XFRM core needs to update internal counters with the one
> > > that accounted by the HW, so new callbacks are introduced in this patch.
> > > 
> > > In case of soft or hard limit is occurred, the driver should call to
> > > xfrm_state_check_expire() that will perform key rekeying exactly as
> > > done by XFRM core.
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > 
> > This looks good, thanks!
> > 
> > We need this for the other relevant counters too.
> 
> It is in my backlog.

Great, thanks!
