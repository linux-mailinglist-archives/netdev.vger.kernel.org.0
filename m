Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0F4969DCF8
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbjBUJf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjBUJfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:35:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A806222EC
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676972076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eVxCrxXAn3hc/57NPIQoqiKS7loYJZHlmG/lcyLJuCU=;
        b=W6KZIl7k6rvddGvA1IXzbOI32E0FAuoG/1TkGFIGSqxFD/ukWtOnJe4hWDRpd6lBFPrBf3
        Qn2vtfQoJbYivypeQx7BuAuDEJPMweMCYuctUmMbMKwgvMbmmSuuK1bF7ECpF+wL8V0k/x
        Cj6E0syctbx46Uae2ymFsEGh/d4aSRY=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-121-e6bWgMzPOFCj5IhLUSVckw-1; Tue, 21 Feb 2023 04:34:35 -0500
X-MC-Unique: e6bWgMzPOFCj5IhLUSVckw-1
Received: by mail-qv1-f71.google.com with SMTP id x18-20020ad44592000000b00571bb7cdc42so578319qvu.23
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:34:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eVxCrxXAn3hc/57NPIQoqiKS7loYJZHlmG/lcyLJuCU=;
        b=W89No5zwHLK4yq/MRglIET8nrj1Pe9QNUd9/HB4QrGS3TUrKX4V4bmk1sR+wCazF+t
         uN6ZSnooqZARkUIH/hBGMaYGvCWMVoL/ECj333fvHtP68WwiwvAdNzTpuHvWZIqG0OGx
         uYZPzmpROC7w/elXU6wSup3wfaF0GtYNLqQmY4Vk5itLVCiYzUxiEhmleSs13LOyJ9Cv
         IfLBKuVY8MESLKO1wvhh99ZkZweiBv0aXAtEOwlGq9O+PuHgQBglfBid4fhBymzKM4ry
         VwrcjMWsmMM4vHl3rkqU5knElPj8joMASxGYs/N9uY/cz+yH0yK8rnI4cpb+0ylHKWn1
         sBrw==
X-Gm-Message-State: AO0yUKXbhQmoumZgjNJCZ5GL7AZlQDceSXk+lUFKpgP5S6F0X/UQ/yYg
        DQ7p71ivxihnDKX/s6fhhxNaNkenWWA1at3W4pBvtGK+NjzdHtOxwsxwq5WrUlSAByqioxmUMej
        0G/y+vXVxgO1nOlcm
X-Received: by 2002:a05:622a:1002:b0:3b8:5199:f841 with SMTP id d2-20020a05622a100200b003b85199f841mr7288662qte.0.1676972074692;
        Tue, 21 Feb 2023 01:34:34 -0800 (PST)
X-Google-Smtp-Source: AK7set+nG7PTi2OBqnICNinT/VzsN7qeMG1pK+wliixmn/uO8G5I5CTumsIYVx9FEhVR0txtWNJ2mw==
X-Received: by 2002:a05:622a:1002:b0:3b8:5199:f841 with SMTP id d2-20020a05622a100200b003b85199f841mr7288633qte.0.1676972074406;
        Tue, 21 Feb 2023 01:34:34 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id 126-20020a370384000000b0073b338b4eb1sm532116qkd.133.2023.02.21.01.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 01:34:33 -0800 (PST)
Message-ID: <5ad788427171d3c0374f24d4714ba0b429cbcfdf.camel@redhat.com>
Subject: Re: [PATCH v2] bnxt: avoid overflow in bnxt_get_nvram_directory()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Simon Horman <simon.horman@corigine.com>,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Date:   Tue, 21 Feb 2023 10:34:30 +0100
In-Reply-To: <Y/Iuu9SiAxh7qhJM@corigine.com>
References: <20230219084656.17926-1-korotkov.maxim.s@gmail.com>
         <Y/Iuu9SiAxh7qhJM@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-02-19 at 15:14 +0100, Simon Horman wrote:
> On Sun, Feb 19, 2023 at 11:46:56AM +0300, Maxim Korotkov wrote:
> > The value of an arithmetic expression is subject
> > of possible overflow due to a failure to cast operands to a larger data
> > type before performing arithmetic. Used macro for multiplication instea=
d
> > operator for avoiding overflow.
> >=20
> > Found by Security Code and Linux Verification
> > Center (linuxtesting.org) with SVACE.
> >=20
> > Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
> > Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
> > Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
>=20
> I agree that it is correct to use mul_u32_u32() for multiplication
> of two u32 entities where the result is 64bit, avoiding overflow.
>=20
> And I agree that the fixes tag indicates the commit where the code
> in question was introduced.
>=20
> However, it is not clear to me if this is a theoretical bug
> or one that can manifest in practice - I think it implies that
> buflen really can be > 4Gbytes.
>=20
> And thus it is not clear to me if this patch should be for 'net' or
> 'net-next'.

... especially considered that both 'dir_entries' and 'entry_length'
are copied back to the user-space using a single byte each.

Cheers,

Paolo

