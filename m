Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09C56C4383
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 07:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjCVGsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 02:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCVGsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 02:48:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF31230E1
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 23:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679467676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sYOPP+9P7Le7F9N6j4TeqCEynqu+TVvV7W2tjFR6KTw=;
        b=Eddry59SUdwKIl83bHv5RpW4/cusoxWQg9aaE7c3pkoUJ0Irw6o5VgMgvJK3TG5dS9SqcJ
        ZMEqR52O2BptmlXDHCCJkNPhpm7VOaBtWsOx/51AVAkhqm6ICLbR8DumrcRjVscrj+vwh6
        PPV53QN6siFjT3/KtLyfEeMqCi5NbVw=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-Spw6UOrQM-SvSaQCGRQwag-1; Wed, 22 Mar 2023 02:47:54 -0400
X-MC-Unique: Spw6UOrQM-SvSaQCGRQwag-1
Received: by mail-pf1-f199.google.com with SMTP id d12-20020a056a0024cc00b006256990dddeso8654362pfv.9
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 23:47:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679467674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sYOPP+9P7Le7F9N6j4TeqCEynqu+TVvV7W2tjFR6KTw=;
        b=r21/QbiXFMLxKj7CJxvg7TDRCGCtvWQWFlsNvfN5HsoFP9VLfgd1y0DO5Kz52xWjPM
         lqXYrHcW+6CETC045UUrKBTGx53SWsQTAmFWQdNpYVDrw+kFZ284eLlU9pj0j+tWDDZT
         jlAOuEXxKmatoKk+ssyDP51wUfFNyYOpoSpGJI2M1IEOMh2Y02Sns116MdhuWN3JHmqU
         cHQKAz1Sg53h7KQyxW2s3bRjZYhFZlUYBzrQP5BDO1r8180kOCLuvVel6I8yddG9+6OQ
         EEURG/zZdQHhiGf3bGLRERTHB+NDL2IcfbnP1mIaxxUzwHS6MmDN+Z9vEkXZeY2dOLfP
         lOkA==
X-Gm-Message-State: AO0yUKWArZdqDgXa16ULrzzoLLJFqDLKKVFUbivXU9T1W/jIfL6p+lSp
        lIygzZo7K8Ov1vxbem9TbzPIhnhGN3ah3YZ/1/4PoTgUj8US61XmBj4gAYaMef0XwGOaFiBQWw/
        X2gFdC2DocngWn085L5lzMV7RqwaAocSm
X-Received: by 2002:a05:6a00:1792:b0:625:644c:65f2 with SMTP id s18-20020a056a00179200b00625644c65f2mr1353222pfg.3.1679467673778;
        Tue, 21 Mar 2023 23:47:53 -0700 (PDT)
X-Google-Smtp-Source: AK7set8u5XQQIKw3UPLU7ocGKVVXplPsXVSljyNMCE7wBykZtpPhfOWkZ/MMq9zpMJuoOLejXqkiiwKs57uj0RHWp34=
X-Received: by 2002:a05:6a00:1792:b0:625:644c:65f2 with SMTP id
 s18-20020a056a00179200b00625644c65f2mr1353211pfg.3.1679467673492; Tue, 21 Mar
 2023 23:47:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230308113254.18866-1-ihuguet@redhat.com> <ddf82062-8755-1980-aba7-927742fed230@gmail.com>
In-Reply-To: <ddf82062-8755-1980-aba7-927742fed230@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Wed, 22 Mar 2023 07:47:42 +0100
Message-ID: <CACT4oucW_A1PyQYszxxvnuG8uhkdzdeUjJpoyTwn-+vQBPJgsQ@mail.gmail.com>
Subject: Re: [PATCH net] sfc: ef10: don't overwrite offload features at NIC reset
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     habetsm.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        Tianhao Zhao <tizhao@redhat.com>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 8, 2023 at 4:53=E2=80=AFPM Edward Cree <ecree.xilinx@gmail.com>=
 wrote:
>
> On 08/03/2023 11:32, =C3=8D=C3=B1igo Huguet wrote:
> > At NIC reset, some offload features related to encapsulated traffic
> > might have changed (this mainly happens if the firmware-variant is
> > changed with the sfboot userspace tool). Because of this, features are
> > checked and set again at reset time.
> >
> > However, this was not done right, and some features were improperly
> > overwritten at NIC reset:
> > - Tunneled IPv6 segmentation was always disabled
> > - Features disabled with ethtool were reenabled
> > - Features that becomes unsupported after the reset were not disabled
> >
> > Also, cleanup a bit the setting of other features not related to
> > encapsulation. Now that Siena devices are unsupported, some checks are
> > unnecessary because they're always supported in all ef10 models.
>
> Could you clarify what checks were removed?  All I can see is the
>  'NETIF_F_TSO6 requires NETIF_F_IPV6_CSUM' check, and Siena already
>  supported NETIF_F_IPV6_CSUM (it's only Falcon that didn't).
> Or are you also referring to some items moving from efx.c to the
>  definition of EF10_OFFLOAD_FEATURES?  That's fine and matches more
>  closely to what we do for ef100, but again the commit message could
>  explain this better.
> In any case this should really be two separate patches, with the
>  cleanup part going to net-next.
> That said, the above is all nit-picky, and the fix looks good, so:
> Acked-by: Edward Cree <ecree.xilinx@gmail.com>
>

Hi. Kindly asking about the state of this patch, it is acked since 2
weeks ago and it appears in patchwork as "changes requested". Is there
something else I need to do? Thanks!

--=20
=C3=8D=C3=B1igo Huguet

