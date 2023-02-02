Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5E7687643
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 08:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjBBHK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 02:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjBBHK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 02:10:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E7E26AC
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 23:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675321704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tOgdwxH3be6yY54yAAxrb0Ltk0Hn7i1/zPv6hboQuvU=;
        b=eVSJ/VwibQawdNzN1ZkFkdfCWx1bADBW/sUXxfU58i2G0FGCZ6ptNsJ0+A5kkIsADww6uB
        Bmxfq755zSwaS2Prhpc7mQ2zrNJTHp0Gn2HYb0PlfsrLAp1YzaBq4H2LVs24E4CeU10ruw
        2SgMMOxapdd04zUzcCYOxlKOYajcbvg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-656-ivg6oMSlN-2uAI88FWQaFQ-1; Thu, 02 Feb 2023 02:08:23 -0500
X-MC-Unique: ivg6oMSlN-2uAI88FWQaFQ-1
Received: by mail-pl1-f197.google.com with SMTP id m12-20020a1709026bcc00b001963da9cc71so541923plt.11
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 23:08:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tOgdwxH3be6yY54yAAxrb0Ltk0Hn7i1/zPv6hboQuvU=;
        b=UElG2VTOzINUOTR8Y6OZtw1W9l9O4I2H5BSGEZOgn/Lplu2k5xoZeg83sC7Fc3ZzTb
         JWZoim1WjIN2D2bE1ke7C23hzHdCt94wwlZpxO3PW4VCha9dvwp9btY9syjIYLv1jAuy
         VgL0rXryR+i4vLe7MOm/7eQW6nblO6KEJbq+/4RP5RI46g9X9CYtQpKWEOpOLj4aImlS
         YAUcUoSX6tjvxPnptTjDbBFejEo1G6wKDLbg9+MqjfVXIv6DboMGMJpyuFKWxZW9SvIQ
         fX9QDKCBIDC1Murxq+MtnZJG+8r4hoaRSiZ6HUMxGoQeCZKOMPWO2dT2mFzZvzMP8xpu
         Vqjg==
X-Gm-Message-State: AO0yUKVi9wg6mcPQasvWSivHofA9f3LNeBg2J8JoUg+xA69hXeKRjb4N
        vLi7/fIFN41H5u8KD6ajMbvAe+SgpK7J7cck+NrRn9SOV2vF6awRjxO1nIGpivcp6eGMpwxVbCP
        lTgoI4ifG+UZLmOL5OT7nO5pSDfLnhtZm
X-Received: by 2002:a17:90a:1747:b0:228:d64f:ddbe with SMTP id 7-20020a17090a174700b00228d64fddbemr360252pjm.40.1675321702117;
        Wed, 01 Feb 2023 23:08:22 -0800 (PST)
X-Google-Smtp-Source: AK7set+4aGppCPoWE9xbeaY7OzyssNVxzzwDmrRUSEcUsFvR+Bw9gAO+Po0b36z+gdGvYaNarCXElHYjDpmkkL1aicU=
X-Received: by 2002:a17:90a:1747:b0:228:d64f:ddbe with SMTP id
 7-20020a17090a174700b00228d64fddbemr360239pjm.40.1675321701738; Wed, 01 Feb
 2023 23:08:21 -0800 (PST)
MIME-Version: 1.0
References: <20230131160506.47552-1-ihuguet@redhat.com> <20230201080849.10482-1-ihuguet@redhat.com>
 <20230201110541.1cf6ba7f@kernel.org>
In-Reply-To: <20230201110541.1cf6ba7f@kernel.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 2 Feb 2023 08:08:10 +0100
Message-ID: <CACT4oueX=MyKoUmzUs5Cdc0k5SuhavY=Toe_EGPgPOA8rVCmRw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] sfc: support unicast PTP
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 1, 2023 at 8:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  1 Feb 2023 09:08:45 +0100 =C3=8D=C3=B1igo Huguet wrote:
> > v2: fixed missing IS_ERR
> >     added doc of missing fields in efx_ptp_rxfilter
>
> 1. don't repost within 24h, *especially* if you're reposting
> because of compilation problems
>
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html

Sorry, I wasn't aware of this.

> 2. please don't repost in a thread, it makes it harder for me
> to maintain a review queue

What do you mean? I sent it with `git send-email --in-reply-to`, I
thought this was the canonical way to send a v2 and superseed the
previous version.

> 3. drop the pointless inline in the source file in patch 4
>
> +static inline void efx_ptp_remove_one_filter(struct efx_nic *efx,
> +                                            struct efx_ptp_rxfilter *rxf=
ilter)

This is the second time I get pushback because of this. Could you
please explain the rationale of not allowing it?

I understand that the compiler probably will do the right thing with
or without the `inline`, and more being in the same translation unit.
Actually, I checked the style guide [1] and I thought it was fine like
this: it says that `inline` should not be abused, but it's fine in
cases like this one. Quotes from the guide:
  "Generally, inline functions are preferable to macros resembling function=
s"
  "A reasonable rule of thumb is to not put inline at functions that
have more than 3 lines of code in them"

I have the feeling that if I had made it as a macro it had been
accepted, but inline not, despite the "prefer inline over macro".

I don't mind changing it, but I'd like to understand it so I can
remember the next time. And if it's such a hard rule that it's
considered a "fail" in the patchwork checks, maybe it should be
documented somewhere.

Thanks!

[1] https://www.kernel.org/doc/html/latest/process/coding-style.html


--=20
=C3=8D=C3=B1igo Huguet

