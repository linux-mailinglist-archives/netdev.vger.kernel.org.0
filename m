Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F4263DCA9
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiK3SGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiK3SGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:06:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB7183E8F
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 10:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669831535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6+9pEpSvu2FHz1yS+wCPOcJow4YxC8PEpQzJw4BQdEI=;
        b=ghY9IqyG+Fr0QmIU3C8PvXOztqZbJ3b6vIt/hIQLvj1F4JbCjob7FAHNcOGCgkAR38ZqwM
        +KahmZOgyipKZiHMQu7iFMeZIoEvG9eJXTqYt2S3J0JU/wXE8ZoZtcPZhMq4jrCp7cQDdK
        HeJZ2Du3LPE4wrvqCdZJwrqAIOpGDdg=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-527-VyjDuKNwOZ6JwPtwmYJwtQ-1; Wed, 30 Nov 2022 13:05:05 -0500
X-MC-Unique: VyjDuKNwOZ6JwPtwmYJwtQ-1
Received: by mail-il1-f198.google.com with SMTP id g7-20020a056e021a2700b0030326ba44e4so4348521ile.13
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 10:05:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:in-reply-to
         :mime-version:references:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6+9pEpSvu2FHz1yS+wCPOcJow4YxC8PEpQzJw4BQdEI=;
        b=WnKL5f334QIHbbJyAMKbEOu/Soa0r0mwyvxth/ex+8kev62TrgQhiftKNaS9kMcvrw
         Y2YNqNnlYiPIgUgyHnLRAW1TtHiH3LMC16HrbLt3DET3UgY4d2rFRdLjAis3aljKQWNQ
         0kemWAFDJ+quoTr6/If5xHL3GAXwMwy85Gu1Jxq5X/BWhsq7N9YxwUBMSxSaQ0EQckSZ
         iiT5LOUws9eyNvZw1ApPZjnEcMQXdovv+9dxS4lxWvIM/+ZfPooEyBPe7pl+v9E8+8fd
         NOKd3tEVTRRtF7BMbX1ZQaeo1NAkYcmdxE+oBc8CldeDPHMJvjmC109qos8QDrc1MvSQ
         vs6A==
X-Gm-Message-State: ANoB5pmUywfcv8ORYmKJIB50gZbRXSjld/mG1aXKq++HSDtY6hRPDxoy
        LEpje+PkTqLNJAEx8EvTI5sPR5GH1mS8/8w3tZWi189A0wHlIaVSfh9BfG/EnNc/5vq98NeUZ1U
        8Z/AVjqgaf347Akvf6scxSWsjrbgyEpIw
X-Received: by 2002:a05:6e02:f43:b0:303:814:dc0d with SMTP id y3-20020a056e020f4300b003030814dc0dmr10491921ilj.131.1669831502182;
        Wed, 30 Nov 2022 10:05:02 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6kOznEE5J3QfHq9nIf1Asv3zexr3CZhfJlg1dCSQkCkXnUW5392NxNbk6e9gxR9mt63Cq4X3/BddGP6YRwuVI=
X-Received: by 2002:a05:6e02:f43:b0:303:814:dc0d with SMTP id
 y3-20020a056e020f4300b003030814dc0dmr10491904ilj.131.1669831501902; Wed, 30
 Nov 2022 10:05:01 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 30 Nov 2022 10:05:01 -0800
From:   Marcelo Leitner <mleitner@redhat.com>
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZZ0iEsMKuDqdyEV6noeM=dtp9Qqkh6RUp9LzMYtXKcT2A@mail.gmail.com>
 <PH0PR13MB4793DE760F60B63796BF9C5E94139@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZanoC6C6Xb-14fy6em8ZJaFnk+78ufOdb=gBfMn-ce2eA@mail.gmail.com>
 <FA3E42DF-5CA2-40D4-A448-DE7B73A1AC80@redhat.com> <CALnP8ZZiw9b_xOzC3FaB8dnSDU1kJkqR6CQA5oJUu_mUj8eOdQ@mail.gmail.com>
 <80007094-D864-45F2-ABD5-1D22F1E960F6@redhat.com> <PH0PR13MB47936B3D3C0C0345C666C87194159@PH0PR13MB4793.namprd13.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <PH0PR13MB47936B3D3C0C0345C666C87194159@PH0PR13MB4793.namprd13.prod.outlook.com>
Date:   Wed, 30 Nov 2022 10:05:01 -0800
Message-ID: <CALnP8ZZ3HkYqmrrHsV2skC1fkkZNViLszXkS2sq5wjTw_ZR6hQ@mail.gmail.com>
Subject: Re: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
To:     Tianyu Yuan <tianyu.yuan@corigine.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
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

On Wed, Nov 30, 2022 at 03:36:57AM +0000, Tianyu Yuan wrote:
>
> On Mon, Nov 29, 2022 at 8:35 PM , Eelco Chaudron wrote:
> >
> > On 28 Nov 2022, at 14:33, Marcelo Leitner wrote:
> >
> > > On Mon, Nov 28, 2022 at 02:17:40PM +0100, Eelco Chaudron wrote:
> > >>
> > >>
> > >> On 28 Nov 2022, at 14:11, Marcelo Leitner wrote:
> > >>
> > >>> On Mon, Nov 28, 2022 at 07:11:05AM +0000, Tianyu Yuan wrote:
> > > ...
> > >>>>
> > >>>> Furthermore, I think the current stats for each action mentioned i=
n
> > >>>> 2) cannot represent the real hw stats and this is why [ RFC
> > >>>> net-next v2 0/2] (net: flow_offload: add support for per action hw=
 stats)
> > will come up.
> > >>>
> > >>> Exactly. Then, when this patchset (or similar) come up, it won't
> > >>> update all actions with the same stats anymore. It will require a
> > >>> set of stats from hw for the gact with PIPE action here. But if
> > >>> drivers are ignoring this action, they can't have specific stats fo=
r
> > >>> it. Or am I missing something?
> > >>>
> > >>> So it is better for the drivers to reject the whole flow instead of
> > >>> simply ignoring it, and let vswitchd probe if it should or should
> > >>> not use this action.
> > >>
> > >> Please note that OVS does not probe features per interface, but does=
 it
> > per datapath. So if it=E2=80=99s supported in pipe in tc software, we w=
ill use it. If the
> > driver rejects it, we will probably end up with the tc software rule on=
ly.
> > >
> > > Ah right. I remember it will pick 1 interface for testing and use
> > > those results everywhere, which then I don't know if it may or may no=
t
> > > be a representor port or not. Anyhow, then it should use skip_sw, to
> > > try to probe for the offloading part. Otherwise I'm afraid tc sw will
> > > always accept this flow and trick the probing, yes.
> >
> > Well, it depends on how you look at it. In theory, we should be hardwar=
e
> > agnostic, meaning what if you have different hardware in your system? O=
VS
> > only supports global offload enablement.
> >
> > Tianyu how are you planning to support this from the OVS side? How woul=
d
> > you probe kernel and/or hardware support for this change?
>
> Currently in the test demo, I just extend gact with PIPE (previously only=
 SHOT as default and
> GOTO_CHAIN when chain exists), and then put such a gact with PIPE at the =
first place of each
> filter which will be transacted with kernel tc.
>
> About the tc sw datapath mentioned, we don't have to make changes because=
 gact with PIPE
> has already been supported in current tc implementation and it could act =
like a 'counter' And
> for the hardware we just need to ignore this PIPE and the stats of this a=
ction will still be updated
> in kernel side and sent to userspace.

I can't see how the action would have stats from hw if the driver is
ignoring the action.

But maybe there was a misunderstanding here. I was reading more the
cxgb4 driver here and AFAICT this patch will skip PIPE on the action
validation, but not actually skip the action entirely. Then it will
hit cxgb4_process_flow_actions() and maybe the driver will the right
thing with a dummy action out of the blue. Was this your expectation,
to just ignore it in the validation step, and let it fall through
through the driver? If yes, the comments are misleading, as the NICs
will have to process the packets.

>
> I agree with that the unsupported actions should be rejected by drivers, =
so may another approach
> could work without ignoring PIPE in all the related drivers, that we dire=
ctly make put the flower stats
> from driver into the socket which is used to transact with userspace and =
userspace(e.g. OVS) update
> the flow stats using this stats instead of the parsing the action stats. =
How do you think of this?

I don't understand this approach. Can you please rephrase?

Thanks,
Marcelo

>
> Cheers,
> Tianyu
> >
> > //Eelco
>

