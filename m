Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE1467FC44
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 03:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbjA2CJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 21:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjA2CJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 21:09:51 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7FC2278E
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 18:09:49 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id cl23-20020a17090af69700b0022c745bfdc3so1539966pjb.3
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 18:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62pYiaSz3Ez7MhzdZVyVjMDhrXsIb/EWNQvEmNdHO2k=;
        b=dkMezOLqrYlVr8cYfslOjXqdoVhlySSFnBrmGX+EsZSMZKdmnxLxz13yw1XTh/2xYO
         HWE+KMEC0rqPJk+SWjmNfCl54u/uJITTmlNvmzWJuUu8zUJTUDrLGWXx7J7VKZMDwVrm
         dyRB6uZJzeK5kqMPCW2GlvsEMIaDotUUTs1womDsyqbXwiLjiKfm6UZAPt3mMAr8/19r
         nhgRk2t/Tn/E9i4H8DRcc7c0GFFR4BP+AGa0fjd/qerIw2yHs5YjaxVs6TDNMxUWcmD8
         cC34MeSYy/MrmdeNydi79vM+wpmJX76jh0T/6xamaTXg2+FATff6QyYO7KdgwDmDSGUp
         18rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=62pYiaSz3Ez7MhzdZVyVjMDhrXsIb/EWNQvEmNdHO2k=;
        b=JYlIZ40X49A9+nKKGAceDQEyQYx0UxY2nqaorY+W0jVVZ4BvNWhilERCuy/DyhSQyH
         mpg9NBppQpfsUoNoj5equkyq1t5yJ8Lya2RIYof0fIxfrtFYjI7keZAZUTmXgzqQEmGM
         ij7GgTfjFP7hlQY+xWRTNH3JoE3duP8woNPqjCyHJYKHQlsmOUE/cOaVdnYZbZZ678DV
         +K87c7V8VAlOhlq755YFJDJBSBVfUpjJ05vQjRtDfS3S6RgAlSYzHpyWss6ivU2Jg5qz
         VJC9WKkEP/Ueq30ETZdF92FOS3qutqIPyZymn0ya6zc5VhiD9SPvQ4n4EkmHI9KGTxAR
         q21Q==
X-Gm-Message-State: AO0yUKV3fd4GLXdEKbdJT3iG/Tz5IWNqYYRO5BSIyCatf2iKrxxEu5OA
        pZ69ZVx3x0AaTrMNyq4Nwuc4eg==
X-Google-Smtp-Source: AK7set+t8nZ0tB9VdrSw+hlTymFg26VAa6HwusJxEH3cuYqtUl4xzALwLupKde7tw5CTtUhqPc++Ug==
X-Received: by 2002:a17:903:200a:b0:196:63c8:6aab with SMTP id s10-20020a170903200a00b0019663c86aabmr3506995pla.40.1674958189165;
        Sat, 28 Jan 2023 18:09:49 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id x7-20020a1709029a4700b00192aa53a7d5sm5140194plv.8.2023.01.28.18.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Jan 2023 18:09:49 -0800 (PST)
Date:   Sat, 28 Jan 2023 18:09:45 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Tom Herbert <tom@herbertland.com>
Cc:     "Singhai, Anjali" <anjali.singhai@intel.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@mojatatu.com" <kernel@mojatatu.com>,
        "Chatterjee, Deb" <deb.chatterjee@intel.com>,
        "Limaye, Namrata" <namrata.limaye@intel.com>,
        "khalidm@nvidia.com" <khalidm@nvidia.com>,
        "tom@sipanda.io" <tom@sipanda.io>,
        "pratyush@sipanda.io" <pratyush@sipanda.io>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "stefanc@marvell.com" <stefanc@marvell.com>,
        "seong.kim@amd.com" <seong.kim@amd.com>,
        "mattyk@nvidia.com" <mattyk@nvidia.com>,
        "Daly, Dan" <dan.daly@intel.com>,
        "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
Message-ID: <20230128180945.6b4d6cb1@hermes.local>
In-Reply-To: <CALx6S36akGgRKohduW-aApgRCbZqjJ5uDzTeGQpD=pPietN2Dg@mail.gmail.com>
References: <20230124170346.316866-1-jhs@mojatatu.com>
        <20230126153022.23bea5f2@kernel.org>
        <CAM0EoMnHcR9jFVtLt+L1FPRY5BK7_NgH3gsOZxQrXzEkaR1HYQ@mail.gmail.com>
        <20230127091815.3e066e43@kernel.org>
        <CAAFAkD80UtwX3PgmYsw3=_wmOEaEZEdui6uHf2FtG1OvDd5s4g@mail.gmail.com>
        <CO1PR11MB49933B0E4FC6752D8C439B3593CD9@CO1PR11MB4993.namprd11.prod.outlook.com>
        <CALx6S36akGgRKohduW-aApgRCbZqjJ5uDzTeGQpD=pPietN2Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 28 Jan 2023 13:17:35 -0800
Tom Herbert <tom@herbertland.com> wrote:

> On Fri, Jan 27, 2023 at 5:34 PM Singhai, Anjali
> <anjali.singhai@intel.com> wrote:
> >
> > P4 is definitely the language of choice for defining a Dataplane in HW =
for IPUs/DPUs/FNICs and Switches. As a vendor I can definitely say that the=
 smart devices implement a very programmable ASIC as each customer Dataplan=
e defers quite a bit and P4 is the language of choice for specifying the Da=
taplane definitions. A lot of customer deploy proprietary protocols that ru=
n in HW and there is no good way right now in kernel to support these propr=
ietary protcols. If we enable these protocol in the kernel it takes a huge =
effort and they don=E2=80=99t evolve well.
> > Being able to define in P4 and offload into HW using tc mechanism reall=
y helps in supporting the customer's Dataplane and protcols without having =
to wait months and years to get the kernel updated. Here is a link to our I=
PU offering that is P4 programmable =20
>=20
> Anjali,
>=20
> P4 may be the language of choice for programming HW datapath, however
> it's not the language of choice for programming SW datapaths-- that's
> C over XDP/eBPF. And while XDP/eBPF also doesn't depend on kernel
> updates, it has a major advantage over P4 in that it doesn't require
> fancy hardware either.
>=20
> Even at full data center deployment of P4 devices, there will be at
> least an order of magnitude more deployment of SW programmed
> datapaths; and unless someone is using P4 hardware, there's zero value
> in rewriting programs in P4 instead of C. IMO, we will never see
> networking developers moving to P4 en masse-- P4 will always be a
> niche market relative to the programmable datapath space and the skill
> sets required to support serious scalable deployment. That being said,
> there will be a nontrivial contingent of users who need to run the
> same programs in both SW and HW environments. Expecting them to
> maintain two very different code bases to support two disparate models
> is costly and prohibitive to them. So for their benefit, we need a
> solution to reconcile these two models. P4TC is one means to
> accomplish that.
>=20
> We want to consider both the permutations: 1) compile C code to run in
> P4 hardware 2) compile P4 to run in SW. If we establish a common IR,
> then we can generalize the problem: programmer writes their datapath
> in the language of their choosing (P4, C, Python, Rust, etc.), they
> compile the program to whatever backend they are using (HW, SW,
> XDP/eBPF, etc.). The P4TC CLI serves as one such IR as there's nothing
> that prevents someone from compiling a program from another language
> to the CLI (for instance, we've implemented the compiler to output the
> parser CLI from PANDA-C). The CLI natively runs in kernel SW, and with
> the right hooks could be offloaded to HW-- not just P4 hardware but
> potentially other hardware targets as well.

Rather than more kernel network software, if instead this was
targeting userspace or eBPF for the SW version; then there would
be less exposed security risk and also less long term technical debt
here.
