Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071466ADF5D
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 13:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjCGM6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 07:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbjCGM6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 07:58:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542E0509AC
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 04:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678193831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+DD1n1ZqC0cPSsfNCSwBbvIvgKgWohidMiihDgckDd4=;
        b=JfxhZ2yxWa2vfHKGf9uaLcgGADIuLShNzAtXcVioSrc+P9+ycFO+4Q1QcIKDvBByDjiRke
        orjyRvs8aY1lWfsdAGhJeOKvdDqRWGG1fpznejByRaHFQtGbfh7EHAibFx38+WpL/mO9oz
        4VTHuYYcbBZLK4rm8FWVDzrrs7uonT4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-3j6XKEU3N2GA_LsymBx5sw-1; Tue, 07 Mar 2023 07:57:10 -0500
X-MC-Unique: 3j6XKEU3N2GA_LsymBx5sw-1
Received: by mail-wr1-f71.google.com with SMTP id d14-20020adfa34e000000b002bfc062eaa8so2193547wrb.20
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 04:57:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678193829;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+DD1n1ZqC0cPSsfNCSwBbvIvgKgWohidMiihDgckDd4=;
        b=MSMXE2TEfLxHHlbtPGKf7/bzv/UYgna3uQ5cMQ0wmNiDPY45EmEPn+PP8se4BDCX/5
         xcuKbwUs+l5sRRx/coU/dElbNM9th1LDjxlIiin+XpM/puHf7Vde5JMk2Bc76MDD8Egk
         ZnKRPPGw60xLkJ122EXVU28DZTDqM35VYbgt6o37M11O2wPZQT/6reeHFC02ZLZNE5El
         9JkaSQuvATxnj32aeS4iyv9fuaQuaRyY0bmsMHd2y6EP97tVFGrR/NixtHbnCB4ig4dr
         m74HJW1oV5yRFDm2D7k8E4f0PSqyrZhmZsY22dY+g0M+/P1G3KHD9mPHC6KhQ5oTpEE8
         8ZfA==
X-Gm-Message-State: AO0yUKVN94Li6vEEhkEtIeiVZmEkO7Tb0fBd4GuSgA5LYKwAslvfGeLl
        w3KwidUV9O4tix7YSENBV9QXwEY+BbNfpm/Yr/XxOCOyCTCsAnXh57wqPCvpwk8vkiqFCagQl57
        0MF/rLMt1jEzkRt2isPKPbL5z
X-Received: by 2002:a05:600c:1d03:b0:3ea:840c:e8ff with SMTP id l3-20020a05600c1d0300b003ea840ce8ffmr11569302wms.3.1678193829238;
        Tue, 07 Mar 2023 04:57:09 -0800 (PST)
X-Google-Smtp-Source: AK7set8Cvl1jwhUH2gPf2Ts+kJr/a2wl0SB3eMY/6BNMFKs2XFVTgpZGHk5CSZ1Dv4Ug+hj/2HtfJQ==
X-Received: by 2002:a05:600c:1d03:b0:3ea:840c:e8ff with SMTP id l3-20020a05600c1d0300b003ea840ce8ffmr11569291wms.3.1678193828983;
        Tue, 07 Mar 2023 04:57:08 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-28.dyn.eolo.it. [146.241.121.28])
        by smtp.gmail.com with ESMTPSA id s25-20020a05600c319900b003db03725e86sm12859377wmp.8.2023.03.07.04.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 04:57:08 -0800 (PST)
Message-ID: <66e565ba357feb2b4411828c65624986eaefb393.camel@redhat.com>
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com
Date:   Tue, 07 Mar 2023 13:57:07 +0100
In-Reply-To: <20230307100424.2037-1-pablo@netfilter.org>
References: <20230307100424.2037-1-pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-07 at 11:04 +0100, Pablo Neira Ayuso wrote:
> Hi,
>=20
> The following patchset contains Netfilter fixes for net:
>=20
> 1) Restore ctnetlink zero mark in events and dump, from Ivan Delalande.
>=20
> 2) Fix deadlock due to missing disabled bh in tproxy, from Florian Westph=
al.
>=20
> 3) Safer maximum chain load in conntrack, from Eric Dumazet.
>=20
> Please, pull these changes from:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git
>=20
> Thanks.
>=20
> ----------------------------------------------------------------
>=20
> The following changes since commit 528125268588a18a2f257002af051b62b14bb2=
82:
>=20
>   Merge branch 'nfp-ipsec-csum' (2023-03-03 08:28:44 +0000)
>=20
> are available in the Git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD

It's not clear to me the root cause, but pulling from the above ref.
yields nothing. I have to replace 'HEAD' with main to get the expected
patches.

Cheers,

Paolo

