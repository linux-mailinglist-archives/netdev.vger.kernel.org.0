Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBF366DE49
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 13:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbjAQM5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 07:57:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237084AbjAQM4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 07:56:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD503C0B
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 04:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673960153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TlgP8iiqbABAh0wB4hfhbNaQJPj2jTpy7HZYW9d47Pg=;
        b=bktigu7zFvy9nH5VM8tk/vP2APSzKseXL8Ts1k5nunlE8nVO+vme3cVlvQB4mivgKf9msh
        2uBs5tQtZBK9spc4dU6WQYf2Km86ZrWoL1zwZUAgm5wolXXR3/vBOLu5B439yNBL+WThwL
        xsLDXxt9l0PTnHQCj8zyYk+SFoY5Vl8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-38-td_gFrMSNwGtmF9W4Ac2Fw-1; Tue, 17 Jan 2023 07:55:50 -0500
X-MC-Unique: td_gFrMSNwGtmF9W4Ac2Fw-1
Received: by mail-qv1-f71.google.com with SMTP id jh2-20020a0562141fc200b004c74bbb0affso16038088qvb.21
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 04:55:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TlgP8iiqbABAh0wB4hfhbNaQJPj2jTpy7HZYW9d47Pg=;
        b=XCiQtoAlqYoNfh2ViVzuRvxhXNCMmGA0eF86NhOGH5ogYz+VoI782juQymrXl600xH
         tGSfimLGMGNLwouGyNcRjiyx1BR5vialTWiM2LAKYJIW4+ZhoREga3RnsVgA5PsW6zCE
         ugExE7vNYNxvhTwZfEN6OGlXjPzOd7nIZdDoCWfnUkEw6uKCAJ2qpuXCl2C0YJkTQXux
         5p0pBkHc0u6ZqeHhCcoCO9on1ZvxYb+LWffcRe/YmHuMzik3Yf9RUpzZq5mfPl4KFChd
         KtYd1vSA8cjG6vUpts0xazV734M+cWV5PCvIlvNqY05oylJjN3c4a5EBSSb9PV4G8LfQ
         dEmw==
X-Gm-Message-State: AFqh2krGxxGWASCnlu4vVmHU0uLAfrJhgiBVjwTxHlomDivu8Wf78fs+
        d1uDdS28Lmabs1dJP0NcL5+dB9kctuzN3BYVS2UrpIPvKhzELsVYQvWt1WpDDJnlvEpERrf2EGn
        p7jDQVpu26NK7oZQB
X-Received: by 2002:ac8:5157:0:b0:3b6:302b:7dcb with SMTP id h23-20020ac85157000000b003b6302b7dcbmr3258865qtn.61.1673960150197;
        Tue, 17 Jan 2023 04:55:50 -0800 (PST)
X-Google-Smtp-Source: AMrXdXszHTnnN3fuTQiSyWBiGPeSlZAsswor3WbAvFvJE3MIK1YMJ5cy38mM+ut1ki95vqyzLKK+Rw==
X-Received: by 2002:ac8:5157:0:b0:3b6:302b:7dcb with SMTP id h23-20020ac85157000000b003b6302b7dcbmr3258848qtn.61.1673960149970;
        Tue, 17 Jan 2023 04:55:49 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-115-179.dyn.eolo.it. [146.241.115.179])
        by smtp.gmail.com with ESMTPSA id v14-20020a05620a0f0e00b006fbb4b98a25sm20349988qkl.109.2023.01.17.04.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 04:55:49 -0800 (PST)
Message-ID: <4bd311213cb41649215d0cdf9966fc9ed90d7aae.camel@redhat.com>
Subject: Re: [PATCH v2] net: fec: manage corner deferred probe condition
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pierluigi Passaro <pierluigi.p@variscite.com>, andrew@lunn.ch,
        wei.fang@nxp.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
        linux-imx@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.passaro@gmail.com
Date:   Tue, 17 Jan 2023 13:55:45 +0100
In-Reply-To: <20230115213804.26650-1-pierluigi.p@variscite.com>
References: <20230115213804.26650-1-pierluigi.p@variscite.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

Hello,

On Sun, 2023-01-15 at 22:38 +0100, Pierluigi Passaro wrote:
> For dual fec interfaces, external phys can only be configured by fec0.
> When the function of_mdiobus_register return -EPROBE_DEFER, the driver
> is lately called to manage fec1, which wrongly register its mii_bus as
> fec0_mii_bus.
> When fec0 retry the probe, the previous assignement prevent the MDIO bus
> registration.
> Use a static boolean to trace the orginal MDIO bus deferred probe and
> prevent further registrations until the fec0 registration completed
> succesfully.
>=20
> Signed-off-by: Pierluigi Passaro <pierluigi.p@variscite.com>

Here there are a few formal/process-related mistakes:
- wait at least 24h before posting a new version
- please include the target tree name into the subj prefix

this looks like a fix, so it should possibly target net and include a
'Fixes' tag into the SoB area.

Please be sure to read and follow the process documentation and the
netdev specifics bit from the current kernel source.

Thanks,

Paolo

