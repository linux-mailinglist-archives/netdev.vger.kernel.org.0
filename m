Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74F7E679571
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233411AbjAXKj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:39:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233658AbjAXKjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:39:08 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B05F42BF7
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 02:39:01 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E5FDD20299;
        Tue, 24 Jan 2023 11:38:58 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QKonxQuP3zMu; Tue, 24 Jan 2023 11:38:58 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 74345201D3;
        Tue, 24 Jan 2023 11:38:58 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 65CA380004A;
        Tue, 24 Jan 2023 11:38:58 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 24 Jan 2023 11:38:58 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 11:38:57 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A7AF63182BAE; Tue, 24 Jan 2023 11:38:57 +0100 (CET)
Date:   Tue, 24 Jan 2023 11:38:57 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <eric.dumazet@gmail.com>, Dmitry Safonov <dima@arista.com>
Subject: Re: [PATCH net] xfrm/compat: prevent potential spectre v1 gadget in
 xfrm_xlate32_attr()
Message-ID: <20230124103857.GW665047@gauss3.secunet.de>
References: <20230120130249.3507411-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230120130249.3507411-1-edumazet@google.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 01:02:49PM +0000, Eric Dumazet wrote:
>   int type = nla_type(nla);
> 
>   if (type > XFRMA_MAX) {
>             return -EOPNOTSUPP;
>   }
> 
> @type is then used as an array index and can be used
> as a Spectre v1 gadget.
> 
>   if (nla_len(nla) < compat_policy[type].len) {
> 
> array_index_nospec() can be used to prevent leaking
> content of kernel memory to malicious users.
> 
> Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Dmitry Safonov <dima@arista.com>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>

Applied to the ipsec tree, thanks a lot Eric!
