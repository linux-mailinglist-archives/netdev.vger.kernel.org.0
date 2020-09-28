Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05AFD27A6BC
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 07:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgI1FHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 01:07:31 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39482 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgI1FHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 01:07:31 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2371E2049A;
        Mon, 28 Sep 2020 07:07:29 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RtOjFdq8NlJC; Mon, 28 Sep 2020 07:07:28 +0200 (CEST)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 98897200AA;
        Mon, 28 Sep 2020 07:07:28 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 28 Sep 2020 07:07:28 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 28 Sep
 2020 07:07:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 82E3D318470F;
 Mon, 28 Sep 2020 07:07:27 +0200 (CEST)
Date:   Mon, 28 Sep 2020 07:07:27 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     syzbot <syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <syzkaller-bugs@googlegroups.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH] xfrm: Use correct address family in xfrm_state_find
Message-ID: <20200928050727.GE20687@gauss3.secunet.de>
References: <0000000000009fc91605afd40d89@google.com>
 <20200925030759.GA17939@gondor.apana.org.au>
 <20200925044256.GA18246@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200925044256.GA18246@gondor.apana.org.au>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 02:42:56PM +1000, Herbert Xu wrote:
> Resend with proper subject.
>  
> ---8<---
> The struct flowi must never be interpreted by itself as its size
> depends on the address family.  Therefore it must always be grouped
> with its original family value.
> 
> In this particular instance, the original family value is lost in
> the function xfrm_state_find.  Therefore we get a bogus read when
> it's coupled with the wrong family which would occur with inter-
> family xfrm states.
> 
> This patch fixes it by keeping the original family value.
> 
> Note that the same bug could potentially occur in LSM through
> the xfrm_state_pol_flow_match hook.  I checked the current code
> there and it seems to be safe for now as only secid is used which
> is part of struct flowi_common.  But that API should be changed
> so that so that we don't get new bugs in the future.  We could
> do that by replacing fl with just secid or adding a family field.
> 
> Reported-by: syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com
> Fixes: 48b8d78315bf ("[XFRM]: State selection update to use inner...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied, thanks a lot Herbert!
