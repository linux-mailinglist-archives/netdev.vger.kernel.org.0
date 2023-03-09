Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3F6A6B2102
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjCIKNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbjCIKNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:13:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425C4E63D2
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 02:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678356743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fNhyl5nLlnyao0Jebk/F3jcGB6Y3b/fgQ8clJeVg2oQ=;
        b=jKQklrn2+JMoOvxtJyzuv+jZZhoBcHzwQcfneznjKnIRwmrHjp4T+PDlotzt0mRotB6/Og
        L13qUDkG8Ek7WLM1oWvnWJ60IejDTqfAM7L/P7erxALKsNlv/ec0jKWjnVkbl9cmHeR6b1
        pU0tZShq3VRARX0BzKOrVbmtNC+kgMU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-Nw15-zyvMUyqkI3o6VdxkA-1; Thu, 09 Mar 2023 05:12:21 -0500
X-MC-Unique: Nw15-zyvMUyqkI3o6VdxkA-1
Received: by mail-wm1-f70.google.com with SMTP id m28-20020a05600c3b1c00b003e7d4662b83so2202360wms.0
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 02:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678356740;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fNhyl5nLlnyao0Jebk/F3jcGB6Y3b/fgQ8clJeVg2oQ=;
        b=PDpBIPWLZP3fJy5eAI1fl/3TBElZbMpWMpsoHCAfUBwInp1U6+EjkAo8K5HpvtQNOE
         e/HW7yg0uFf/6JYRA3dUWmJU9pU2ekQXp6rAaUldiiogFsk3c2dJTuiXRDeiQgyVXCKz
         +OybygSwd1OHO2w8xLNH5soD1MIPwW5Y+O5+mUCXSHHH8bb3ys/90jB4mOiD0W2TIdvf
         xdfiA5mKJBW/pHVYLL8rtCcppkHayYhzm+tueRQxFhJ32Vz1wtpUEVaU+ZwWmaz7YyaE
         gxC22KpHbe4SH/BHW9600qFH6yawftVY4z9RbKEwu/mpCSg0GuSpb03xvxEHC8WBHo8a
         6dzQ==
X-Gm-Message-State: AO0yUKVhKLIsEysHIlIJoJVpgfY4h2mIJ1dxqDzBgkxXPUMk7lFppMFj
        oOSm0wJ+8sDxgV3fy1ARIzqQ6MMRhy/lVbpQXD/70slVbzy0jvHiyEF2q+MsClw8P5TMMesktm+
        59BFfpwMUIEh7xAxmpZt8rZc4
X-Received: by 2002:a5d:4b51:0:b0:2c7:d80:ffc4 with SMTP id w17-20020a5d4b51000000b002c70d80ffc4mr11930640wrs.7.1678356740699;
        Thu, 09 Mar 2023 02:12:20 -0800 (PST)
X-Google-Smtp-Source: AK7set901q/BMX+bTCV6GlvgTc3najCBZgnQUDViuzSltwnSQjiYIfP634B8py+fM5JSdfsqw62VAw==
X-Received: by 2002:a5d:4b51:0:b0:2c7:d80:ffc4 with SMTP id w17-20020a5d4b51000000b002c70d80ffc4mr11930630wrs.7.1678356740432;
        Thu, 09 Mar 2023 02:12:20 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-28.dyn.eolo.it. [146.241.121.28])
        by smtp.gmail.com with ESMTPSA id s11-20020a5d510b000000b002c55b0e6ef1sm17836487wrt.4.2023.03.09.02.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 02:12:20 -0800 (PST)
Message-ID: <5432f8f2da54d0ffc4e4e28fb88ac14f5bb682de.camel@redhat.com>
Subject: Re: [PATCH net-next] net: mvpp2: Defer probe if MAC address source
 is not yet ready
From:   Paolo Abeni <pabeni@redhat.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Date:   Thu, 09 Mar 2023 11:12:18 +0100
In-Reply-To: <20230307192927.512757-1-miquel.raynal@bootlin.com>
References: <20230307192927.512757-1-miquel.raynal@bootlin.com>
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

On Tue, 2023-03-07 at 20:29 +0100, Miquel Raynal wrote:
> NVMEM layouts are no longer registered early, and thus may not yet be
> available when Ethernet drivers (or any other consumer) probe, leading
> to possible probe deferrals errors. Forward the error code if this
> happens. All other errors being discarded, the driver will eventually
> use a random MAC address if no other source was considered valid (no
> functional change on this regard).
>=20
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

The patch LGTM, but if feels like a fix more than a new feature re-
factor. Any special reason to target the net-next tree?

Thanks!

Paolo

