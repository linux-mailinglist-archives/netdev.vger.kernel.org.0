Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C785E91E8
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 11:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiIYJko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 05:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiIYJkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 05:40:43 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11417220F8
        for <netdev@vger.kernel.org>; Sun, 25 Sep 2022 02:40:41 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6BD26204A4;
        Sun, 25 Sep 2022 11:40:40 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id EGhZxkdh1bng; Sun, 25 Sep 2022 11:40:39 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EEB8A201A0;
        Sun, 25 Sep 2022 11:40:39 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id D7F3A80004A;
        Sun, 25 Sep 2022 11:40:39 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 25 Sep 2022 11:40:39 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sun, 25 Sep
 2022 11:40:39 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 131E53182DAE; Sun, 25 Sep 2022 11:40:39 +0200 (CEST)
Date:   Sun, 25 Sep 2022 11:40:39 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: Re: [PATCH RFC xfrm-next v3 0/8] Extend XFRM core to allow full
 offload configuration
Message-ID: <20220925094039.GV2602992@gauss3.secunet.de>
References: <cover.1662295929.git.leonro@nvidia.com>
 <Yxm8QFvtMcpHWzIy@unreal>
 <20220921075927.3ace0307@kernel.org>
 <YytLwlvza1ulmyTd@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YytLwlvza1ulmyTd@unreal>
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

On Wed, Sep 21, 2022 at 08:37:06PM +0300, Leon Romanovsky wrote:
> On Wed, Sep 21, 2022 at 07:59:27AM -0700, Jakub Kicinski wrote:
> > On Thu, 8 Sep 2022 12:56:16 +0300 Leon Romanovsky wrote:
> > > I have TX traces too and can add if RX are not sufficient. 
> > 
> > The perf trace is good, but for those of us not intimately familiar
> > with xfrm, could you provide some analysis here?
> 
> The perf trace presented is for RX path of IPsec crypto offload mode. In that
> mode, decrypted packet enters the netdev stack to perform various XFRM specific
> checks.

Can you provide the perf traces and analysis for the TX side too? That
would be interesting in particular, because the policy and state lookups
there happen still in software.

Thanks a lot for your effort on this!
