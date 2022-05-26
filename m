Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19967534A84
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 08:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344813AbiEZGx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 02:53:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238937AbiEZGx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 02:53:27 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2904D473A1;
        Wed, 25 May 2022 23:53:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9B1AE20189;
        Thu, 26 May 2022 08:53:23 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id efhZj5zPXJLr; Thu, 26 May 2022 08:53:23 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2375F200AC;
        Thu, 26 May 2022 08:53:23 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 1357280004A;
        Thu, 26 May 2022 08:53:23 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 26 May 2022 08:53:22 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 26 May
 2022 08:53:22 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 1DA673183D71; Thu, 26 May 2022 08:53:22 +0200 (CEST)
Date:   Thu, 26 May 2022 08:53:22 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     <netdev@vger.kernel.org>, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH ipsec v2] Revert "net: af_key: add check for
 pfkey_broadcast in function pfkey_process"
Message-ID: <20220526065322.GB680067@gauss3.secunet.de>
References: <30ec3274c323de7c3a9b013b9bfb6c3418465d30.1653336079.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <30ec3274c323de7c3a9b013b9bfb6c3418465d30.1653336079.git.mkubecek@suse.cz>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 10:05:24PM +0200, Michal Kubecek wrote:
> This reverts commit 4dc2a5a8f6754492180741facf2a8787f2c415d7.
> 
> A non-zero return value from pfkey_broadcast() does not necessarily mean
> an error occurred as this function returns -ESRCH when no registered
> listener received the message. In particular, a call with
> BROADCAST_PROMISC_ONLY flag and null one_sk argument can never return
> zero so that this commit in fact prevents processing any PF_KEY message.
> One visible effect is that racoon daemon fails to find encryption
> algorithms like aes and refuses to start.
> 
> Excluding -ESRCH return value would fix this but it's not obvious that
> we really want to bail out here and most other callers of
> pfkey_broadcast() also ignore the return value. Also, as pointed out by
> Steffen Klassert, PF_KEY is kind of deprecated and newer userspace code
> should use netlink instead so that we should only disturb the code for
> really important fixes.
> 
> v2: add a comment explaining why is the return value ignored
> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thanks Michal!
