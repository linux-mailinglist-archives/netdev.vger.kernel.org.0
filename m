Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63CF14C345
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 23:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbfFSVrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 17:47:33 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33338 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbfFSVrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 17:47:33 -0400
Received: by mail-io1-f65.google.com with SMTP id u13so1226237iop.0
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 14:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jn7rTsnoTMINgPGQpUAUNP/1ZCSKZbUiyrspL4IPrIQ=;
        b=aoMXkXVUNysZd1OrGPLYLxbG1L1WIqZrN++sOPLGf5wLhzrpv/HyMBSWHaOqdby9L/
         GRzrD2jhF4Tjv7ZXw/krKAuSvvPEri4IfhP184lovzMb9ZZOZWN3flbPXHUbYouRboTB
         N83QI2LaI7RAgFNrEq5pxgZaNPry9y78ug5mxC9CqUBsHfJj3a1ehexiKAmDJDyQ4GAk
         EESxIL14siyPmN+fIxtwntOVZkENSNFLpAnPoENtF1qRC/ScqSKjAZtfYAyceqagTyC4
         aCkmW3jYhKuyEs0eS9BnPVYZe5AKxj4ESv5UR4ZZanEqtF2MORQsBKhoR70thUuG+J12
         tUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jn7rTsnoTMINgPGQpUAUNP/1ZCSKZbUiyrspL4IPrIQ=;
        b=JGFLATLOw4GXy18VONzfV+qECiOq5kUe9CALznbwyUTNB3EgpzU+AuGvAbKnGXFXb1
         v4PfLyKWiZwRVuTDUBoB/L72y4W7Hty3sjIIa7MVsqlfZ/n/dVJGOtm7q7FBiJcAHm1X
         jepbX3TKjG/f+iBj3cx9tY4siWrJ+/huEDFwZWtPyd7C8seFJSKe1V+5Wz5pIRcJ2lK5
         Cwwgs2mQWYIxXbhxdIRQiKiftLLkwuXAgV3fBq8W15K8SCJfHgNSfaCEzXZo9ewJVfno
         rzU6GfFO5+HDEh9Tzb2Zps6i6klGwmVWyFF9rDI6Q/gqNFOOT+JrdL79DnqWVHjbXMdi
         r2vA==
X-Gm-Message-State: APjAAAVpS5l7oqoHXZ7MeeRM9kMeoyKHHcya9RAP8EsH6QuFDGGniSq8
        hr9M7ERcJ+psKDr4DksLCQLi7TU0W4qZ47kLNQ/N5g==
X-Google-Smtp-Source: APXvYqwubEzC2W3o+M/c7dg3wspsTqDJRo7V9LviqwzAh4/9pKsymlPU4a8TvgNldaxNRieGyMcrWmR2PWbukIQGy8o=
X-Received: by 2002:a5e:820a:: with SMTP id l10mr13045052iom.283.1560980852010;
 Wed, 19 Jun 2019 14:47:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190619065510.23514-1-ard.biesheuvel@linaro.org>
 <20190619065510.23514-2-ard.biesheuvel@linaro.org> <20190619.174234.2210089047219514238.davem@davemloft.net>
In-Reply-To: <20190619.174234.2210089047219514238.davem@davemloft.net>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 19 Jun 2019 23:47:19 +0200
Message-ID: <CAKv+Gu9h7tJo=faEOceZ=6Zk1sBOCh-jBa3bgBAd3jr-sATbJQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/1] net: fastopen: robustness and endianness
 fixes for SipHash
To:     David Miller <davem@davemloft.net>
Cc:     "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Dumazet <edumazet@google.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jun 2019 at 23:42, David Miller <davem@davemloft.net> wrote:
>
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Date: Wed, 19 Jun 2019 08:55:10 +0200
>
> > +     ctx->key[0] = (siphash_key_t){
> > +             get_unaligned_le64(primary_key),
> > +             get_unaligned_le64(primary_key + 8)
> > +     };
>
> Please just use normal assignment(s), because not only does this warn
> it looks not so nice.
>

OK

Please disregard the v3 I just sent out, v4 has ordinary assignments.
