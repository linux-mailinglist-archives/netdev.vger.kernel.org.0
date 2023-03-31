Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D98F6D19BA
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjCaIZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbjCaIYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:24:45 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9949B44C
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:24:23 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8C57B20712;
        Fri, 31 Mar 2023 10:24:21 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rfXhCz1_VVKQ; Fri, 31 Mar 2023 10:24:21 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 200BE205ED;
        Fri, 31 Mar 2023 10:24:21 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 1ACBF80004A;
        Fri, 31 Mar 2023 10:24:21 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 31 Mar 2023 10:24:20 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Fri, 31 Mar
 2023 10:24:20 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 236AF3182CA9; Fri, 31 Mar 2023 10:24:20 +0200 (CEST)
Date:   Fri, 31 Mar 2023 10:24:20 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Tobias Brunner <tobias@strongswan.org>
CC:     <netdev@vger.kernel.org>, <devel@linux-ipsec.org>,
        Hyunwoo Kim <v4bel@theori.io>,
        Tudor Ambarus <tudordana@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [devel-ipsec] [PATCH ipsec] xfrm: Don't allow optional
 intermediate templates that changes the address family
Message-ID: <ZCaYtGUY6F+g/0tc@gauss3.secunet.de>
References: <ZCZ79IlUW53XxaVr@gauss3.secunet.de>
 <c06ff911-8ffb-0f5c-5863-d48dbf1dd084@strongswan.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c06ff911-8ffb-0f5c-5863-d48dbf1dd084@strongswan.org>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=0.0 required=5.0 tests=SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 10:19:33AM +0200, Tobias Brunner wrote:
> > When an optional intermediate template changes the address family,
> > it is unclear which family the next template should have. This can
> > lead to misinterpretations of IPv4/IPv6 addresses. So reject
> > optional intermediate templates on insertion time.
> 
> This change breaks the installation of IPv4-in-IPv6 (or vice-versa) policies
> with IPComp, where the optional IPComp template and SA is installed with
> tunnel mode (while the ESP template/SA that follows is installed in
> transport mode) and the address family is that of the SA not that of the
> policy.
> 
> Note that mixed-family scenarios with IPComp are currently broken due to an
> address family issue, but that's a problem in xfrm_tmpl_resolve_one() that
> occurs later when packets are actually matched against policies. There is a
> simple patch for it that I haven't got around to submit to the list yet.

Grmpf, I did a lot of tests, but not IPComp. This means, it might be
not so easy to fix the memory corruption I tried to fix with this.

Thanks for the heads up!
