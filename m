Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03BC76389D
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfGIP2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:28:47 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:43005 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfGIP2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:28:47 -0400
Received: by mail-oi1-f194.google.com with SMTP id s184so15651223oie.9
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 08:28:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k11beIh+mUjVLzYG9THhXh88Pf5mHCqf97+Kp/bxHkE=;
        b=N/7ZwPCiEJlL+yoo63zqYiU+RpumHUh9bArBI57HqhGYRMJZaXdttI1tJDSSFRoSul
         y+5CLsGubhJl3f5nR/0dMgiasfPGRz79Py4BRUsGSUUsACwJB3xGbAe3pGDiIyLHee6k
         FugCCA4edRGkmWnNpWJp1naq0m5tZXPhA4CNpf1Qeh9X1u+lBKNzfzyJlSOP6t63UpZV
         K1gs2K36FMfK4uNqfzxLruRYRIMY5o2bbrbDoL1ZSbTz5pMGVXKPjeLt8IXUBkeNBebU
         En6Rqtcx6Qak/LHlMpqS4TrBJ1Kkv2qJ5SYn/QZ2qn1Az+tx+fxvw6aMrOLaMxGy+nrG
         5rMw==
X-Gm-Message-State: APjAAAUAZzYoKAFhvheFAezVxFSCpbrHYJ2X6VUo5q1Kgnthfx5FQEkV
        ujgTkSfYvHPTgpX/+R5ZjjScaKAniODiq1u5+O4SNw==
X-Google-Smtp-Source: APXvYqwXmYEUATic8aoRa6uuGEzFcLGIMajJ90MRTAqjf1CxVNXS/27MerL9PRMpWx7rulTwbBXomnDo0kW9L3DEY2U=
X-Received: by 2002:aca:75c2:: with SMTP id q185mr362076oic.103.1562686126177;
 Tue, 09 Jul 2019 08:28:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190709111124.31127-1-omosnace@redhat.com> <20190709143832.hej23rahmb4basy6@gondor.apana.org.au>
In-Reply-To: <20190709143832.hej23rahmb4basy6@gondor.apana.org.au>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Tue, 9 Jul 2019 17:28:35 +0200
Message-ID: <CAFqZXNs2XysEWVzmfXSczH-+oX5iwwRC3+9fL3tWYEfDRbqLig@mail.gmail.com>
Subject: Re: [PATCH] crypto: user - make NETLINK_CRYPTO work inside netns
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Stephan Mueller <smueller@chronox.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Don Zickus <dzickus@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 9, 2019 at 4:38 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jul 09, 2019 at 01:11:24PM +0200, Ondrej Mosnacek wrote:
> > Currently, NETLINK_CRYPTO works only in the init network namespace. It
> > doesn't make much sense to cut it out of the other network namespaces,
> > so do the minor plumbing work necessary to make it work in any network
> > namespace. Code inspired by net/core/sock_diag.c.
> >
> > Tested using kcapi-dgst from libkcapi [1]:
> > Before:
> >     # unshare -n kcapi-dgst -c sha256 </dev/null | wc -c
> >     libkcapi - Error: Netlink error: sendmsg failed
> >     libkcapi - Error: Netlink error: sendmsg failed
> >     libkcapi - Error: NETLINK_CRYPTO: cannot obtain cipher information for hmac(sha512) (is required crypto_user.c patch missing? see documentation)
> >     0
> >
> > After:
> >     # unshare -n kcapi-dgst -c sha256 </dev/null | wc -c
> >     32
> >
> > [1] https://github.com/smuellerDD/libkcapi
> >
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
>
> Should we really let root inside a namespace manipulate crypto
> algorithms which are global?

I admit I'm not an expert on Linux namespaces, but aren't you
confusing network and user namespaces? Unless I'm mistaken, these
changes only affect _network_ namespaces (which only isolate the
network stuff itself) and the semantics of the netlink_capable(skb,
CAP_NET_ADMIN) calls remain unchanged - they check if the opener of
the socket has the CAP_NET_ADMIN capability within the global _user_
namespace.

>
> I think we should only allow the query operations without deeper
> surgery.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
