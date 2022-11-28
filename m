Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384AF63A9A2
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 14:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231815AbiK1NeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 08:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiK1NeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 08:34:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53877F42
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 05:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669642402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QmDeGJEZn8PNO8hqCaqURqOEtB0NGOSGdxAbp7PxZz0=;
        b=LLNZzyxxMAh7oF8F37qgaWy02IbkSQTBsJixWP8HECY1vylcBIp1Bv7sZboqkou5aaoDl4
        B9SCa2U8qNfieT/iwU7B9aj95dfmIbpIktRFVhCQ0ol1RmiJPlQpPY31cK7ardEYT1+/1M
        jDFi71VuqiSXBm7lfvrE/KLOeZiXHlk=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-213-6LDXon3wNSevhmZPFtk3Sg-1; Mon, 28 Nov 2022 08:33:20 -0500
X-MC-Unique: 6LDXon3wNSevhmZPFtk3Sg-1
Received: by mail-il1-f198.google.com with SMTP id h20-20020a056e021d9400b00300581edaa5so8786584ila.12
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 05:33:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:in-reply-to
         :mime-version:references:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QmDeGJEZn8PNO8hqCaqURqOEtB0NGOSGdxAbp7PxZz0=;
        b=gyr2e6uQh4s87vvUtqBAnIZYOVPJF86AGGSsy2OayRHIUq1tkCU4PuhQAm5bTiDIxE
         0fGtaQCwjsONcMgcd8GaUNn9+QeSo/Z9Z+1yKRelRjujGEsf3CeTCpSq9H2+2wUxm8dH
         2qr1C41f8tJcVpfRiQjgNxFIvntu4cbK12VhCIKx5P8wTgwsH7pSphewQWrLCYNcdAT/
         u4+INJGTWvh4qVzp0BFmsNRrGfXfERZBtKsI05Yray2gP4lmahkoU10QaHGvUIgj3z2e
         crfvRldGg3juafXy+Ob7Gkq01hg4OCpSaNoPHLuMHmbEYtAYcqT4oohy2PUSUfRs+XWv
         Or3g==
X-Gm-Message-State: ANoB5pnUZ31Ki1exdUKn4pVDqdXuMTsZzSr+uen8XTgUo+yVyGWrVgiG
        eG8lfTTkthWwouVzjjnPoeVHy33nodwDanUhG6C4g8pJTofCbDFp1NAY2UQzKjzs79K6Jh/gDul
        KulzMjBO849aY54XIyANJ2ZVf8qLIDvJa
X-Received: by 2002:a05:6e02:f43:b0:303:814:dc0d with SMTP id y3-20020a056e020f4300b003030814dc0dmr4296916ilj.131.1669642400167;
        Mon, 28 Nov 2022 05:33:20 -0800 (PST)
X-Google-Smtp-Source: AA0mqf69O6uDhQLUole/lRKYPTVThe7HcJ5qiLQIRHucgTusykPCjK+ibrsZJShvuiMUVH0p92/pfAgi1woVDyWUQXE=
X-Received: by 2002:a05:6e02:f43:b0:303:814:dc0d with SMTP id
 y3-20020a056e020f4300b003030814dc0dmr4296906ilj.131.1669642399945; Mon, 28
 Nov 2022 05:33:19 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 28 Nov 2022 05:33:19 -0800
From:   Marcelo Leitner <mleitner@redhat.com>
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZZ0iEsMKuDqdyEV6noeM=dtp9Qqkh6RUp9LzMYtXKcT2A@mail.gmail.com>
 <PH0PR13MB4793DE760F60B63796BF9C5E94139@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZanoC6C6Xb-14fy6em8ZJaFnk+78ufOdb=gBfMn-ce2eA@mail.gmail.com> <FA3E42DF-5CA2-40D4-A448-DE7B73A1AC80@redhat.com>
MIME-Version: 1.0
In-Reply-To: <FA3E42DF-5CA2-40D4-A448-DE7B73A1AC80@redhat.com>
Date:   Mon, 28 Nov 2022 05:33:19 -0800
Message-ID: <CALnP8ZZiw9b_xOzC3FaB8dnSDU1kJkqR6CQA5oJUu_mUj8eOdQ@mail.gmail.com>
Subject: Re: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Tianyu Yuan <tianyu.yuan@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
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

On Mon, Nov 28, 2022 at 02:17:40PM +0100, Eelco Chaudron wrote:
>
>
> On 28 Nov 2022, at 14:11, Marcelo Leitner wrote:
>
> > On Mon, Nov 28, 2022 at 07:11:05AM +0000, Tianyu Yuan wrote:
...
> >>
> >> Furthermore, I think the current stats for each action mentioned in 2)=
 cannot represent the real
> >> hw stats and this is why [ RFC  net-next v2 0/2] (net: flow_offload: a=
dd support for per action
> >> hw stats) will come up.
> >
> > Exactly. Then, when this patchset (or similar) come up, it won't
> > update all actions with the same stats anymore. It will require a set
> > of stats from hw for the gact with PIPE action here. But if drivers
> > are ignoring this action, they can't have specific stats for it. Or am
> > I missing something?
> >
> > So it is better for the drivers to reject the whole flow instead of
> > simply ignoring it, and let vswitchd probe if it should or should not
> > use this action.
>
> Please note that OVS does not probe features per interface, but does it p=
er datapath. So if it=E2=80=99s supported in pipe in tc software, we will u=
se it. If the driver rejects it, we will probably end up with the tc softwa=
re rule only.

Ah right. I remember it will pick 1 interface for testing and use
those results everywhere, which then I don't know if it may or may not
be a representor port or not. Anyhow, then it should use skip_sw, to
try to probe for the offloading part. Otherwise I'm afraid tc sw will
always accept this flow and trick the probing, yes.

  Marcelo

