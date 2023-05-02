Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD3B6F4682
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 16:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbjEBO6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 10:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbjEBO6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 10:58:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C550212A
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 07:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683039442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rsaMqlatQkViiSAZhVQs9Ou1oKGXkWWetutoefwbQVE=;
        b=SlHRLPUCF+EGceEg1NddgqhwUw8oIeCOnhMkHTVB55Q06gOOmGuBr60RROxC+StHj+l7CH
        7vji06HZu3/lksi4RajE7DAoVPsGoYE9zwQQKj+AB5ZfsSi6GcPzbXV5PuJ9k/F+J6/8em
        DtpA/gNp61wbnOdZ9yhVCJJDFxjxmik=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-340-GfRtutppNA2YJGBXM9HGlg-1; Tue, 02 May 2023 10:57:21 -0400
X-MC-Unique: GfRtutppNA2YJGBXM9HGlg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-74deffa28efso18931785a.1
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 07:57:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683039440; x=1685631440;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rsaMqlatQkViiSAZhVQs9Ou1oKGXkWWetutoefwbQVE=;
        b=bLQF6ik7gZfpmaL0hWNQlQrKlvCDCmQ1DwR3+C2/1QmbYymwm1l+ZrdEVR7gz6T7gn
         Wcb+UypeqgZM57zVnPvEV9wa1VeMo+aroJKTzgKvv9PptZQ+9zICbgDR5ryF7MR6N7Da
         y1qSHT8TKSQo3Zi5NvM5mchmEghI1r+KZx8QNv7gBCfMRuip/KYzi1+Fb9Fox7xETulN
         lPUpt9N3eNBsGbGPk9TfQTJeHcv3T0rZTWIlEyus0IQYSNvJy2+NcIMqvMtQ49cbfxKt
         3FWlmStlKqEDR/7IgMmFual4fa09PKpmpvs/+Mx0eTW+aAyW+cbejv9BUB0hEvRry5zU
         LY+A==
X-Gm-Message-State: AC+VfDxMj0KOBYmeHZTtMSK5HrtPfGjZpgSUzVOFpMk9DgH/ENRfSvDb
        GQNo8xpy7s2u1iskPgH6S+IeTxPiA+hJSugOcatm/NCxNdklIiBwryOesLmCPG8TAn/1kXiWSHK
        hfSCGU/mQ0iPmFwIe
X-Received: by 2002:a05:622a:1999:b0:3ef:3204:5148 with SMTP id u25-20020a05622a199900b003ef32045148mr4092130qtc.1.1683039440376;
        Tue, 02 May 2023 07:57:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6/v3ngpB8491voBWNoyCSdVlwYeBi2PE8UWLD9AvMJNnNw0kgRgwPaHdmqv0nLOMFA91IsMQ==
X-Received: by 2002:a05:622a:1999:b0:3ef:3204:5148 with SMTP id u25-20020a05622a199900b003ef32045148mr4092048qtc.1.1683039439385;
        Tue, 02 May 2023 07:57:19 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-253-104.dyn.eolo.it. [146.241.253.104])
        by smtp.gmail.com with ESMTPSA id y26-20020a05620a0e1a00b0074f4edb7007sm7249541qkm.112.2023.05.02.07.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 07:57:19 -0700 (PDT)
Message-ID: <d35637b26f7d5632f221e337dca2bd12c5008b86.camel@redhat.com>
Subject: Re: [PATCH] pds_core: add stub macros for pdsc_debufs_* when !
 CONFIG_DEBUG_FS
From:   Paolo Abeni <pabeni@redhat.com>
To:     Tom Rix <trix@redhat.com>, shannon.nelson@amd.com,
        brett.creeley@amd.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 02 May 2023 16:57:16 +0200
In-Reply-To: <20230502145220.2927464-1-trix@redhat.com>
References: <20230502145220.2927464-1-trix@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-05-02 at 10:52 -0400, Tom Rix wrote:
> When CONFIG_DEBUG_FS is not defined there is this representative link err=
or
> ld: drivers/net/ethernet/amd/pds_core/main.o: in function `pdsc_remove':
> main.c:(.text+0x35c): undefined reference to `pdsc_debugfs_del_dev
>=20
> Avoid these link errors when CONFIG_DEBUG_FS is not defined by
> providing some empty macros.
>=20
> Signed-off-by: Tom Rix <trix@redhat.com>

There is already a patch pending on the same topic:

https://patchwork.kernel.org/user/todo/netdevbpf/?series=3D744165


and probably a different approach will be preferred:

https://lore.kernel.org/all/84bc488b-5b4b-49ec-7e1a-3a88f92476f6@amd.com/

Cheers,

Paolo

