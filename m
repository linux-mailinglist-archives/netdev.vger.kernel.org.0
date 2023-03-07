Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB346AD84D
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 08:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCGH1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 02:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjCGH1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 02:27:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F2A5070E
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 23:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678173978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C0N3yr2D0n//bvmW5AU0UzWXlsnYFe4KuT9Sib39vHo=;
        b=hcyXPuRUroE8eM+QeMPKFOlXk3fbGD17PdJyInZhpigIp+dK3heVkTyhmsrtIaGbQvsTBg
        SDKOG5WBJUSlWAIzIT3Dk51f/ve3D0YyN7tJ2ghP1tkY+/TcxC+jLhsLF1Eykh1NESc1OD
        4zpHaj0gSD30l8Ycn651714awKNGJc0=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-qFim-TkaN9SdzVFVyr4OAQ-1; Tue, 07 Mar 2023 02:26:17 -0500
X-MC-Unique: qFim-TkaN9SdzVFVyr4OAQ-1
Received: by mail-ot1-f70.google.com with SMTP id l18-20020a056830055200b00694313ba5a9so5432088otb.17
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 23:26:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678173976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0N3yr2D0n//bvmW5AU0UzWXlsnYFe4KuT9Sib39vHo=;
        b=YidBUyCHHPkbrTZ/pI8PaayU4SX+CKyuEt99l/mcaoxx+sjfDtzAAmsQh0HB8gbfpO
         trHvRuia6WNwzQjBEuXfhJhehG4HF14mgh111EwL5mSc9/rXggBFYGCxh8xx7mCHeDoZ
         gZs4X9lzNEfNj9cbQEdGM5P9FpeRFJT/anfR2G6DbTW49XZUnq23JW9FM5suH8ZaYyIb
         JTNjB1tZdrCUaizebprVPyr1S7FGdEh9l6ykulESfvfrMo2O8x2oz2mlRgZ2nGpTfPIv
         I2IJvVbNn9YewBOwzbQenfSPDRXhoXPN46Ra3zVANRVcsk4+5nbnzCoKVBZGxbO7f+mr
         zMpQ==
X-Gm-Message-State: AO0yUKWJjQmQDpWVfKuWtW5M/ycru6jwFq29/pHk1RO4je3IySTfKsSP
        wYusA64jRevvt0Hrt2Q3EodJa3Nj3X2/wSRH0e4yEMbHGcwp7fvRhQHX3RPf2sVXKz35s65qt79
        U45jGVKFMVlMtNIyWJidW2/71GcuRqu+Y
X-Received: by 2002:a54:4810:0:b0:384:4e2d:81ea with SMTP id j16-20020a544810000000b003844e2d81eamr4364909oij.9.1678173976344;
        Mon, 06 Mar 2023 23:26:16 -0800 (PST)
X-Google-Smtp-Source: AK7set/yWmAmkrZoh3sXtiWqFkEs+35eUsn8N6EW6JW0lnDZnTBEh/0/0GOdejKcbi4AMupvstMks2xeKIx/FWYm3Wg=
X-Received: by 2002:a54:4810:0:b0:384:4e2d:81ea with SMTP id
 j16-20020a544810000000b003844e2d81eamr4364904oij.9.1678173976152; Mon, 06 Mar
 2023 23:26:16 -0800 (PST)
MIME-Version: 1.0
References: <20230305154942.1770925-1-alvaro.karsz@solid-run.com>
 <CACGkMEuc_MtVpM2bJH20dmXC30Po8Fbd2Y-xv-Q=O13=pLSLpA@mail.gmail.com> <AM0PR04MB4723D2274F037EDD814007A7D4B69@AM0PR04MB4723.eurprd04.prod.outlook.com>
In-Reply-To: <AM0PR04MB4723D2274F037EDD814007A7D4B69@AM0PR04MB4723.eurprd04.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 7 Mar 2023 15:26:05 +0800
Message-ID: <CACGkMEv4Cw+W2KKZXchCLcqo3Gy8HyBokG-Hw3QXnZmmSwW+gw@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: unify notifications coalescing structs
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
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

On Mon, Mar 6, 2023 at 3:48=E2=80=AFPM Alvaro Karsz <alvaro.karsz@solid-run=
.com> wrote:
>
> > Is this too late to be changed?
> >
> > Thanks
>
> You're right.
> What do you suggest, dropping the patch or adding the unified struct with=
out deleting the existing ones?

At least we need to avoid touching existing uAPI structures.

I think we can leave the code as is but we can hear from others.

Thanks

>
>

