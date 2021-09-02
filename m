Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0CB3FEAF0
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 11:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245031AbhIBJGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 05:06:23 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:60104 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244968AbhIBJGV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 05:06:21 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9EFDC204E0;
        Thu,  2 Sep 2021 11:05:22 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id IYizrHnH6YJ5; Thu,  2 Sep 2021 11:05:21 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DF4A52009B;
        Thu,  2 Sep 2021 11:05:21 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id D9CD680004A;
        Thu,  2 Sep 2021 11:05:21 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 2 Sep 2021 11:05:21 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 2 Sep 2021
 11:05:21 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 1C92931805E1; Thu,  2 Sep 2021 11:05:21 +0200 (CEST)
Date:   Thu, 2 Sep 2021 11:05:21 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     "Dmitry V. Levin" <ldv@altlinux.org>
CC:     Antony Antony <antony.antony@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christian Langrock <christian.langrock@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 ipsec-next] xfrm: Add possibility to set the default
 to block if we have no policy
Message-ID: <20210902090521.GF9115@gauss3.secunet.de>
References: <20210331144843.GA25749@moon.secunet.de>
 <fc1364604051d6be5c4c14817817a004aba539eb.1626592022.git.antony.antony@secunet.com>
 <20210901151402.GA2557@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210901151402.GA2557@altlinux.org>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 06:14:02PM +0300, Dmitry V. Levin wrote:
> 
> The following part of this patch is ABI break:
> 
> > diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
> > index ffc6a5391bb7..6e8095106192 100644
> > --- a/include/uapi/linux/xfrm.h
> > +++ b/include/uapi/linux/xfrm.h
> > @@ -213,6 +213,11 @@ enum {
> >  	XFRM_MSG_GETSPDINFO,
> >  #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
> > 
> > +	XFRM_MSG_SETDEFAULT,
> > +#define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
> > +	XFRM_MSG_GETDEFAULT,
> > +#define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
> > +
> >  	XFRM_MSG_MAPPING,
> >  #define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
> >  	__XFRM_MSG_MAX
> 
> After this change, strace no longer builds with the following diagnostics:
> 
> ../../../src/xlat/nl_xfrm_types.h:162:1: error: static assertion failed: "XFRM_MSG_MAPPING != 0x26"
>   162 | static_assert((XFRM_MSG_MAPPING) == (0x26), "XFRM_MSG_MAPPING != 0x26");

Thanks for the report! In the meantime there is a fix proposed:

https://www.spinics.net/lists/netdev/msg764744.html
