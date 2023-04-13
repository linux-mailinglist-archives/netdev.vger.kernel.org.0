Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE306E0947
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjDMItV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjDMItU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:49:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3950F7DA5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681375716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S450bQMrto2xRsQHWdapZwjWZbDyLMaBHfwKca+z6z8=;
        b=dMVkNC/WE/r8n6rNhe5dbgpgcJPmDYxJ178BTSaKDe3AEii+WKbQfeRHNaOlTtYwLEx+AA
        jz0UDrstwZJr85F22ybQEHYIVAPidYsjZKkSQgYC4Yl6GnwbgT+8iwaT1usO1hN/uwZ3uU
        NyxGnslOq6miIyPOdIAV7YwkYHNbyyQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-8DZrj8jUNfKlq62WvzNZEA-1; Thu, 13 Apr 2023 04:48:35 -0400
X-MC-Unique: 8DZrj8jUNfKlq62WvzNZEA-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3e699015faeso5140401cf.0
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:48:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681375714; x=1683967714;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S450bQMrto2xRsQHWdapZwjWZbDyLMaBHfwKca+z6z8=;
        b=XZemQ1BEgoXwEHCl7UBBUq6N0oHZ8XL1n9ZawJrADzNRiriAJ4bak4wJPv3pCu2WuF
         qNmSxrpTSRYqCwy2ViVyWevNhO5B5U/dK/57aI5rX77itnVWRJ2MHdC3jaR4/V61Gg7h
         72jUouPV993mSbzKF7Wl1P8PxDdivq0mII9TAGl2HeeqYEFbGYRo16YeMuQ1Y3Ldg0A+
         LR7tlKoYYVeVQ1jYd6tYdHeSoWEU/sLhdn2pWR+9fd3iOgCqWXr7E4j5Ah0saOi3X5nS
         evymGkz3iF/Cw2yMkzpsJ2WxKNks1vYTH0fhR37jEguuB0wAbSOxgejsJz3BquCgcBwY
         dgkA==
X-Gm-Message-State: AAQBX9e6QO3IDZLNoew3mOYbW/dwZyf7BOos/QEcS6/QERqxsOn5FWfM
        6vqFX4s2t/tQ/aXO5+KZnoa8cXxNraMyGm/eqTlkA2Z8RVkze0o63wbeT4eyF6PnD2Af0mnwZDm
        YWFVPXHew5E8je5hyPUX20K2K
X-Received: by 2002:a05:622a:1811:b0:3e6:8da4:427 with SMTP id t17-20020a05622a181100b003e68da40427mr2035518qtc.6.1681375714535;
        Thu, 13 Apr 2023 01:48:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZvpkLXcpxfpcQJnPzv1jSCQsKaVCoqLNnVXPzq18QpgwVLLjM2m6JSo8LwnWdmIMgpXFCYFA==
X-Received: by 2002:a05:622a:1811:b0:3e6:8da4:427 with SMTP id t17-20020a05622a181100b003e68da40427mr2035508qtc.6.1681375714329;
        Thu, 13 Apr 2023 01:48:34 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-183.dyn.eolo.it. [146.241.232.183])
        by smtp.gmail.com with ESMTPSA id o19-20020ac84293000000b003e390b48958sm346979qtl.55.2023.04.13.01.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 01:48:33 -0700 (PDT)
Message-ID: <2ca7e92e555a3ec8e797cda33e4ef69ecbc9fd66.camel@redhat.com>
Subject: Re: [PATCH v4] skbuff: Fix a race between coalescing and releasing
 SKBs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Liang Chen <liangchen.linux@gmail.com>, kuba@kernel.org,
        ilias.apalodimas@linaro.org, edumazet@google.com, hawk@kernel.org
Cc:     davem@davemloft.net, alexander.duyck@gmail.com,
        linyunsheng@huawei.com, netdev@vger.kernel.org
Date:   Thu, 13 Apr 2023 10:48:31 +0200
In-Reply-To: <20230413081812.11768-1-liangchen.linux@gmail.com>
References: <20230413081812.11768-1-liangchen.linux@gmail.com>
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

Hi,

On Thu, 2023-04-13 at 16:18 +0800, Liang Chen wrote:
> Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page =
pool")
>=20
> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

I'm sorry for nit-picking, but you must avoid empty lines in the tags
area, between the Fixes and SoB tags.

Thanks!

Paolo

