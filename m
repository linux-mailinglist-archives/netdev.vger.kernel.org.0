Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C21C4A7BAD
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 00:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348081AbiBBX0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 18:26:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51564 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234266AbiBBX0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 18:26:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643844360;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V1irmvN4zP19hk1c37XkrsxWt5n5A/h9HErqCh9egyM=;
        b=aRFrQwzscodg8Mm9sOCbthJiJaV2ivSEqCEnAKK2fokZUO1XUSHL2W3a7V6lflnP9FsIjj
        SsI1VqSeWKwxGFb8EgmSWI+DP/dVSKwPShhjbA3iabflVtiK2dK/D1NuxFI9rIIHvihRwN
        6R93PNiBqfbjGwsQthX9N10RusreRsA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-IkYUec5YPQKQbIH9qVSplg-1; Wed, 02 Feb 2022 18:25:59 -0500
X-MC-Unique: IkYUec5YPQKQbIH9qVSplg-1
Received: by mail-wm1-f71.google.com with SMTP id i204-20020a1c3bd5000000b00352cf8b74dcso644598wma.0
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 15:25:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V1irmvN4zP19hk1c37XkrsxWt5n5A/h9HErqCh9egyM=;
        b=vxuLsU6mgYkMsGvzihQav5rm17g8eBnu87Qr7Xqd0iXOT1r7AMYb+m/VJED7MbkCNt
         8al3MsedoSKCTXj7bdPMY0oI0/UI/MdQmkTyj5rQPD5sUDSXQMiWWQ9pbF5mUoWlPPG9
         diadx/giw/iHDooKCuI02FdFk/iP/zNkJbLo/t3pqkUjjOuHt6JWvZBuP+Or0tuA1OHu
         lI/jGO7nowl/EjID/WWzgEVcQiR7ftKGHbSz6625jJCT0IZqtwZGfbAEhFGlSxY/IS8B
         7OuQlnQ9Q+qcPcF//xEGzAeH6+/QELxBOAyDdcSxUpGYJU0aaH5FJphPAMB2HpfliPDZ
         y1ew==
X-Gm-Message-State: AOAM533IttKPuYGeUFq3eo98a2vdltjGSrXBBuCCFQolUlooLd953Dj5
        a1QVXNdKgHZuKOy/7VsoUrkOYj1FAbRVEMGOXZgcAzJy/WkOm49NtxEomHgl3MZOrH/UOUXfmIh
        KGUIMNDcWNWce/q5P
X-Received: by 2002:adf:d1c1:: with SMTP id b1mr3372353wrd.194.1643844358084;
        Wed, 02 Feb 2022 15:25:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSO9KG6tY7otJ9gS+2Z7WctCTNZopwe1OQIFeR8JPQvW0ZC6+xdYbw6EQuMBsj+bGuZ0jFQw==
X-Received: by 2002:adf:d1c1:: with SMTP id b1mr3372344wrd.194.1643844357867;
        Wed, 02 Feb 2022 15:25:57 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id s22sm5584046wmj.38.2022.02.02.15.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 15:25:57 -0800 (PST)
Date:   Thu, 3 Feb 2022 00:25:55 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next] selftests: fib offload: use sensible tos values
Message-ID: <20220202232555.GC15826@pc-4.home>
References: <5e43b343720360a1c0e4f5947d9e917b26f30fbf.1643826556.git.gnault@redhat.com>
 <54a7071e-71ad-0c7d-ccc4-0f85dbe1e077@linuxfoundation.org>
 <20220202201614.GB15826@pc-4.home>
 <c5be299d-35e9-9ae9-185f-2faa6eccb149@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5be299d-35e9-9ae9-185f-2faa6eccb149@linuxfoundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 02:10:15PM -0700, Shuah Khan wrote:
> On 2/2/22 1:16 PM, Guillaume Nault wrote:
> > On Wed, Feb 02, 2022 at 12:46:10PM -0700, Shuah Khan wrote:
> > > On 2/2/22 11:30 AM, Guillaume Nault wrote:
> > > > Although both iproute2 and the kernel accept 1 and 2 as tos values for
> > > > new routes, those are invalid. These values only set ECN bits, which
> > > > are ignored during IPv4 fib lookups. Therefore, no packet can actually
> > > > match such routes. This selftest therefore only succeeds because it
> > > > doesn't verify that the new routes do actually work in practice (it
> > > > just checks if the routes are offloaded or not).
> > > > 
> > > > It makes more sense to use tos values that don't conflict with ECN.
> > > > This way, the selftest won't be affected if we later decide to warn or
> > > > even reject invalid tos configurations for new routes.
> > > 
> > > Wouldn't it make sense to leave these invalid values in the test though.
> > > Removing these makes this test out of sync withe kernel.
> > 
> > Do you mean keeping the test as is and only modify it when (if) we
> > decide to reject such invalid values?
> 
> This is for sure. Remove the invalid values in sync with the kernel code.
> 
> > Or to write two versions of the
> > test, one with invalid values, the other with correct ones?
> > 
> 
> This one makes sense if it adds value in testing to make sure we continue
> to reject invalid values.
> 
> > I don't get what keeping a test with the invalid values could bring us.
> > It's confusing for the reader, and might break in the future. This
> > patch makes the test future proof, without altering its intent and code
> > coverage. It still works on current (and past) kernels, so I don't see
> > what this patch could make out of sync.
> > 
> 
> If kernel still accepts these values, then the test is valid as long as
> kernel still doesn't flag these values as invalid.
> 
> I might be missing something. Don't you want to test with invalid values
> so make sure they are indeed rejected?

Testing invalid values makes sense, but in another selftest IMHO. This
file is used to test hardware offload behaviour (although it lives
under selftests/net/, it's only called from other scripts living under
selftests/drivers/). Testing for accepted/rejected values should be
done in a network generic selftest, not in driver specific ones.

I'm currently working on a patch series that'd include such tests (as
part of a larger project aimed at fixing conflicting interpretations of
ECN bits). But for fib_offload_lib.sh, I'd really prefer if we could
keep it focused on testing driver features.

> 
> thanks,
> -- Shuah
> 

