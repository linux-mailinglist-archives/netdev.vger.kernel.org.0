Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B866566804
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiGEKbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbiGEKbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:31:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCCFF140ED
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 03:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657017073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PFyVmo3W/U4eGvfIkwXUtO/9rUsoM3oDAPa80BChrQE=;
        b=B9e3KIG1ufx0URGkymnEWQ6bu6F5uAUSIc7bu3MxXOx12BaoM86gJRShhe+J7rP52o1tBL
        RZFqLO/7cLglm5YAvF0Uw671fSPeA7eoBJkQk7UMZPuWlRRhxlwMcuxU5Pf6mHM7nXaJVk
        /Ic7Zyf6wW34HCVvr3dTeUhDGo92yiY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-kSNgB9OnPGK6-JjL-rLhwA-1; Tue, 05 Jul 2022 06:31:12 -0400
X-MC-Unique: kSNgB9OnPGK6-JjL-rLhwA-1
Received: by mail-qt1-f197.google.com with SMTP id bs7-20020ac86f07000000b0031d3efbb91aso7840362qtb.21
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 03:31:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=PFyVmo3W/U4eGvfIkwXUtO/9rUsoM3oDAPa80BChrQE=;
        b=RzurVseCZZy0T1JTmI1T0LdmzUnvYtC74J/zxy9rwW/ILXrmaMt5TRZqv0K3DKMVBT
         Ej+H+LdmAVRgIuTvOv5SUefZLBFv3kGhXTB3QL/QldLRPTZ8WqGvK6nmbBtM7/cKtmVE
         xrKiG5WqbUkkh8esywUNUKEp8jHDesnKDzuXMxINmEBzMN6Y22LDQM9/xesnOefcR+go
         XO1lnPXoZm+f5XhGitypd4zYBFz5B0Sse6uNthEd5tHMFDWoPTRRY7bvRYQficOdh4qL
         2DgoDJAy78S/LeE4Fu3rVoxwQ2hBXW4mQ4VLmEHZLGT3IXtqhwN3EMzcIXLiVBbjcqm4
         xsgQ==
X-Gm-Message-State: AJIora/9uPM5LBsKpgWWjuwRM54N1I6SeAciaWO9HbmJC/ntBgBYnVrq
        FcPT0y+EVYN4zTrcqfxMIe69yvti2PQZ4a68sj5KXCsTxRCAKqFolC4Zz90Rso35KF/BIej/xfC
        hw+uKWWGwoTWJRWkt
X-Received: by 2002:a05:6214:2465:b0:472:fcc9:1dcd with SMTP id im5-20020a056214246500b00472fcc91dcdmr5204221qvb.78.1657017072168;
        Tue, 05 Jul 2022 03:31:12 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sWVqjveyPu1tKpVwGio5G3SChbbKm0lyG6eFSaojhLOuJtH9XUz4Vc5LbKw1gHmxGwlhP+nQ==
X-Received: by 2002:a05:6214:2465:b0:472:fcc9:1dcd with SMTP id im5-20020a056214246500b00472fcc91dcdmr5204192qvb.78.1657017071891;
        Tue, 05 Jul 2022 03:31:11 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id d3-20020a05620a240300b006af45243e15sm21884942qkn.114.2022.07.05.03.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 03:31:11 -0700 (PDT)
Message-ID: <248071bc915140d8c58669b288c15c731407fa76.camel@redhat.com>
Subject: Re: [PATCH] net: Shrink sock.sk_err sk_err_soft to u16 from int
From:   Paolo Abeni <pabeni@redhat.com>
To:     Leonard Crestez <cdleonard@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Joanne Koong <joannelkoong@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 05 Jul 2022 12:31:07 +0200
In-Reply-To: <74c6f54cd3869258f4c83b46d9e5b95f7f0dab4b.1656878516.git.cdleonard@gmail.com>
References: <74c6f54cd3869258f4c83b46d9e5b95f7f0dab4b.1656878516.git.cdleonard@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-07-03 at 23:06 +0300, Leonard Crestez wrote:
> These fields hold positive errno values which are limited by
> ERRNO_MAX=4095 so 16 bits is more than enough.
> 
> They are also always positive; setting them to a negative errno value
> can result in falsely reporting a successful read/write of incorrect
> size.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  include/net/sock.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> I ran some relatively complex tests without noticing issues but some corner
> case where this breaks might exist.

Could you please explain in length the rationale behind this change?

Note that this additionally changes the struct sock binary layout,
which in turn in quite relevant for high speed data transfer.

Thanks!

Paolo

