Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C29B6EEE14
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 08:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239421AbjDZGKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 02:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238464AbjDZGKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 02:10:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD1B268A
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 23:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682489416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kxyjFnjkq7aSfRW8/bstsMm10LqeieUGuk8at7t8UME=;
        b=CbJKaRNIKtxthZdgJKKfwYHZ+YcJjkYz6ib4PdRPQVi0nmFm0dXMEAITaw4ThyLniu4pgB
        tbKWcJCLwcuRMTygJGcsmKVdMnpB4X6LMbn+9JQgBmT4LNFwUPxFcm7JYFquBIeYqoenMt
        E80RrlMYUmZ6kwbFtCwfwkVuFfFXjuw=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-GHcg5ucUMqu3O7P7BX1skg-1; Wed, 26 Apr 2023 02:10:14 -0400
X-MC-Unique: GHcg5ucUMqu3O7P7BX1skg-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2a7add46109so27787611fa.1
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 23:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682489411; x=1685081411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kxyjFnjkq7aSfRW8/bstsMm10LqeieUGuk8at7t8UME=;
        b=WKLxtFz4wf1bl+HexwBtpaRurtLyxhFTJCV2ARQ1vlO5mcU9F1FT4HhoCQb3FlUmL+
         4N5pzbG0OAh5CgvLPZ10UUPDIAgLsXTC/LQu8Aj5ZqJfuxmqFIBGxyWdhEEqzBrtPGOJ
         rzoPvfA2YchBLux0lXi5Z8viCzbubJpPbMUd8sy3Vj/IaM1JQ0NQLdyr1MPMaStiKFsC
         a1i3H0YTUwmS6yFFWCGoF3Z0zwn7YD+d5a0jUus+QRidzNKMTMnIAA/A+rEc2Wyq8Mob
         QbWxVNRilbn3PheFTQhvip4WGW7IdKHVFm47ZMQXEURKMVw9FXqTYsXvRu/v6JO/tFME
         KzUw==
X-Gm-Message-State: AAQBX9eKBytjnmhPdaz7H8ZdtWZYztKmGuWLjifIOsntN+sBCXPFyg4E
        34sPGEnCdR8Sd73Ju2pqvTHZN+mXnhPf0VySxkSYATM3hleuA9G1ShWR0RVGHmsGCUFRYobrLoV
        L5s6Q9Z8J6RYbMNJlqebYR9clWkuZ3DtM
X-Received: by 2002:a2e:9357:0:b0:2a8:bd1f:a377 with SMTP id m23-20020a2e9357000000b002a8bd1fa377mr3560576ljh.20.1682489411505;
        Tue, 25 Apr 2023 23:10:11 -0700 (PDT)
X-Google-Smtp-Source: AKy350aVnZTEsQyZXycQdCZAWCO8jAdgqYmWukEebnOcWJrst48VToqw0DfcOhzfmlBBNsuu0UBhEIv5nxguqeIZLC0=
X-Received: by 2002:a2e:9357:0:b0:2a8:bd1f:a377 with SMTP id
 m23-20020a2e9357000000b002a8bd1fa377mr3560563ljh.20.1682489411154; Tue, 25
 Apr 2023 23:10:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230425102250.3847395-1-mie@igel.co.jp>
In-Reply-To: <20230425102250.3847395-1-mie@igel.co.jp>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 26 Apr 2023 14:10:00 +0800
Message-ID: <CACGkMEumt4p7jU+H+T-b9My0buhdS8a-1GCSnWjnCwMAM=wo1Q@mail.gmail.com>
Subject: Re: [PATCH v3] vringh: IOMEM support
To:     Shunsuke Mie <mie@igel.co.jp>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 6:23=E2=80=AFPM Shunsuke Mie <mie@igel.co.jp> wrote=
:
>
> Introduce a new memory accessor for vringh. It is able to use vringh to
> virtio rings located on io-memory region.

Is there a user for this? It would be better if you can describe the
use cases for this. Maybe you can post the user or at least a link to
the git as a reference.

>
> Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
> ---
>
> Changes from v2: https://lore.kernel.org/virtualization/20230202090934.54=
9556-1-mie@igel.co.jp/
> - Focus on an adding io memory APIs
> Remove vringh API unification and some fixes.
> - Rebase on next-20230414
>
>  drivers/vhost/Kconfig  |   6 ++
>  drivers/vhost/vringh.c | 129 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/vringh.h |  33 +++++++++++
>  3 files changed, 168 insertions(+)
>
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index b455d9ab6f3d..4b0dbb4a8ab3 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -6,6 +6,12 @@ config VHOST_IOTLB
>           This option is selected by any driver which needs to support
>           an IOMMU in software.
>
> +config VHOST_RING_IOMEM
> +       tristate
> +       select VHOST_IOMEM
> +       help
> +         This option enables vringh APIs to supports io memory space.

There's no specific Kconfig for all the existing accessors. Any reason
I/O memory is special or do you care about the size of the module?

> +
>  config VHOST_RING
>         tristate
>         select VHOST_IOTLB
> diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
> index 955d938eb663..ce5a88eecc05 100644
> --- a/drivers/vhost/vringh.c
> +++ b/drivers/vhost/vringh.c
> @@ -1604,4 +1604,133 @@ EXPORT_SYMBOL(vringh_need_notify_iotlb);
>
>  #endif
>

[...]

>
> base-commit: d3f2cd24819158bb70701c3549e586f9df9cee67
> prerequisite-patch-id: 760abbe8c981c52ccc421b8139e8999ab71619aa
> prerequisite-patch-id: 99d8679ab4569545c8af401e84142c66312e953e
> prerequisite-patch-id: aca81516aba75b58c8422d37c2dc7db2f61ffe92
> prerequisite-patch-id: 3d76136200c4e55ba2c41681325f242859dd6dbd
> prerequisite-patch-id: 47a994feb68d95412d81b0fd1fa27bc7ba05ae18
> prerequisite-patch-id: a2f7fc3f35358f70b6dad4c919ce293b10295c4f
> prerequisite-patch-id: 70e2ee32b945be96a0388f0ff564651ac9335220
> prerequisite-patch-id: 2023690f9c47017b56d7f036332a5ca3ece6bde8
> prerequisite-patch-id: 211e113fec6c450d13fbdb437ecfad67dec0a157
> prerequisite-patch-id: f2bcd3168933886e4cd4c39e47446d1bd7cb2691
> prerequisite-patch-id: 37b131560808733a0b8878e85a3d2a46d6ab02ca
> prerequisite-patch-id: 79b0219a715cb5ace227d55666d62fdb2dcc6ffe
> prerequisite-patch-id: 30f1740cd48a19aa1c3c93e625c740cae2845478
> prerequisite-patch-id: 31989e4a521f2fc6f68c4ccdb6960035e87666a7
> prerequisite-patch-id: 3948bb3e0c045e2ffff06a714d17bab16c94775d
> prerequisite-patch-id: cf28e0115b9111bcb77aa9c710d98b2be93c7e89
> prerequisite-patch-id: ebf2349c0ae1296663854eee2da0b43fe8972f9b
> prerequisite-patch-id: fc570921d885a2a6000800b4022321e63f1650a5
> prerequisite-patch-id: 1fd5219fef17c2bf2d76000207b25aae58c368f3
> prerequisite-patch-id: 34e5f078202762fe69df471e97b51b1341cbdfa9
> prerequisite-patch-id: 7fa5151b9e0488b48c2b9d1219152cfb047d6586
> prerequisite-patch-id: 33cca272767af04ae9abe7af2f6cbb9972cc0b77
> prerequisite-patch-id: bb1a6befc899dd97bcd946c2d76ce73675a1fa45
> prerequisite-patch-id: 10be04dd92fa451d13676e91d9094b63cd7fbcf8
> prerequisite-patch-id: 87b86eb4ce9501bba9c04ec81094ac9202392431
> prerequisite-patch-id: a5ced28762bf6bd6419dae0e4413d02ccafd72c2
> prerequisite-patch-id: 2db4c9603e00d69bb0184dabcc319e7f74f30305
> prerequisite-patch-id: 41933f9d53e5e9e02efd6157b68ee7d92b10cfa2
> prerequisite-patch-id: df3295b4cdde3a45eaf4c40047179698a4224d05
> prerequisite-patch-id: 9e2fca9ab0ba2b935daa96f1745ff4c909792231
> prerequisite-patch-id: 8948378099ba4d61e10a87e617d69ed2fc4104ae
> prerequisite-patch-id: 5e7466f3f0d74880d1a574a1bd91b12091dcf3f5
> prerequisite-patch-id: 902899e1cd53b7fcc7971f630aed103830fc3e3d
> prerequisite-patch-id: 42126b180500f9ff123db78748972c6ece18ac57
> prerequisite-patch-id: 5236a03ef574074f3c1009a52612051862b31eff
> prerequisite-patch-id: adae1aa80df65bd02a9e3f4db490cf801c1c6119
> prerequisite-patch-id: 22806fcabb973ee5f04ee6212db6161aab5bcbfc
> prerequisite-patch-id: 6eb14cfdc2cf31e90556f6afe7361427a332e8dc

These seem meaningless?

Thanks

> --
> 2.25.1
>

