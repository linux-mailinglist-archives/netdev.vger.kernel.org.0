Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02121412EA5
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 08:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhIUGfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 02:35:13 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:60118 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhIUGfL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 02:35:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6025A2053D;
        Tue, 21 Sep 2021 08:33:39 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SObhG05uXcpE; Tue, 21 Sep 2021 08:33:38 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 947B0201D5;
        Tue, 21 Sep 2021 08:33:38 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 8CF1180004A;
        Tue, 21 Sep 2021 08:33:38 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 21 Sep 2021 08:33:38 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Tue, 21 Sep
 2021 08:33:37 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id A4C18318251B; Tue, 21 Sep 2021 08:33:37 +0200 (CEST)
Date:   Tue, 21 Sep 2021 08:33:37 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Paul Cercueil <paul@crapouillou.net>
CC:     <antony.antony@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christian Langrock <christian.langrock@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <list@opendingux.net>
Subject: Re: [PATCH v2 ipsec-next] xfrm: Add possibility to set the default
 to block if we have no policy
Message-ID: <20210921063337.GF36125@gauss3.secunet.de>
References: <20210331144843.GA25749@moon.secunet.de>
 <fc1364604051d6be5c4c14817817a004aba539eb.1626592022.git.antony.antony@secunet.com>
 <PNDPZQ.CY1U6WXEZERM3@crapouillou.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <PNDPZQ.CY1U6WXEZERM3@crapouillou.net>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 19, 2021 at 11:40:37PM +0100, Paul Cercueil wrote:
> Hi,
> 
> I think this patch was merged in v5.15-rc1, right?
> 
> "strace" fails to build because of this:
> 
> In file included from print_fields.h:12,
>                 from defs.h:1869,
>                 from netlink.c:10:
> static_assert.h:20:25: error: static assertion failed: "XFRM_MSG_MAPPING !=
> 0x26"
>   20 | # define static_assert _Static_assert
>      | ^~~~~~~~~~~~~~
> xlat/nl_xfrm_types.h:162:1: note: in expansion of macro 'static_assert'
>  162 | static_assert((XFRM_MSG_MAPPING) == (0x26), "XFRM_MSG_MAPPING !=
> 0x26");
>      | ^~~~~~~~~~~~~
> make[5]: *** [Makefile:5834: libstrace_a-netlink.o] Error 1

Thanks for the report!

This is already fixed in the ipsec tree with:

commit 844f7eaaed9267ae17d33778efe65548cc940205
Author: Eugene Syromiatnikov <esyr@redhat.com>
Date:   Sun Sep 12 14:22:34 2021 +0200

    include/uapi/linux/xfrm.h: Fix XFRM_MSG_MAPPING ABI breakage

    Commit 2d151d39073a ("xfrm: Add possibility to set the default to block
    if we have no policy") broke ABI by changing the value of the XFRM_MSG_MAPPING
    enum item, thus also evading the build-time check
    in security/selinux/nlmsgtab.c:selinux_nlmsg_lookup for presence of proper
    security permission checks in nlmsg_xfrm_perms.  Fix it by placing
    XFRM_MSG_SETDEFAULT/XFRM_MSG_GETDEFAULT to the end of the enum, right before
    __XFRM_MSG_MAX, and updating the nlmsg_xfrm_perms accordingly.

    Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
    References: https://lore.kernel.org/netdev/20210901151402.GA2557@altlinux.org/
    Signed-off-by: Eugene Syromiatnikov <esyr@redhat.com>
    Acked-by: Antony Antony <antony.antony@secunet.com>
    Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
    Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

It will likely go upstream this week.

Thanks!
