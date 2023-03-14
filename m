Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B563C6B8774
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 02:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCNBPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 21:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjCNBPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 21:15:02 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916074A1C5;
        Mon, 13 Mar 2023 18:15:01 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id h8so14930806plf.10;
        Mon, 13 Mar 2023 18:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678756501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SDa6BbIH7Y3VUs5F/kP/wwy9tx6ek2EPSEjYlOG3rt4=;
        b=n9hSIEw2zg4NWFs46OHg2XBaStApSeOCiZLAl0IYwFGq1JTJAb/9MSnKvg8yb6fxhR
         74b4pAbFvDlxodA4TdtWrDfSr5T/lTwWxNIPPlt/2ILflgmbalbV9DPZwah0TTYmwWmu
         zd33FTjEK2jsxF0Ch0BVEbuf7MDc8OTqBu0SOHKpFXupOGMV1a7Y34WlOc1Xr7nDrNOR
         4Ho2WLc4NCJzZQS6/a5r6Ug3zzepgmZgghZeT5C03oF/DnP6MMEjWPh+GN08mO8Toi0d
         PBBuJfpJYKA69n6PDbU/wfbJBMsgNnj534QcXo7fWa7+BshUoP71wEcOv4tISnNTVuIE
         bOfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678756501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SDa6BbIH7Y3VUs5F/kP/wwy9tx6ek2EPSEjYlOG3rt4=;
        b=Jv6/ZKJoi6TobYbGtmofWqdtvQXIXIfO5f9IkYrI6eSwGA3Q0m1F6AiQotopExOYJ0
         14fK2LguHt98HDRv/rl6zv4Fa8L9wh9F90t5iUMfjFh8KnvwbN6Cx6ZMWTP7ORQEWIRF
         neO6PucsXltuvrFh37sspU9b0Uqm10MPhqCwVns2aSGwAbyECstaKW6s8FMrac+IyOdy
         YGtELlg/OcB4YnOc/uL3tY6OL8Pu5O0q8hU0NAZ3FLoK2M2ZS1lzkTObi8sj/JI1+qeR
         oavyVJB1fykwzoZfI1KDBer4dDpN2wPOQ5M3I4YsUDVDK3coH2NAERQYD1nqs6MA4QRT
         vOxQ==
X-Gm-Message-State: AO0yUKVQcdv8ZVBnByIsvjqn+on4wsM0+A/yyFHchQHJTJahqUPv0dj0
        5SvcYEVlmJLJRS00XVXf6v8jYQCLkz+Riox3Ln8=
X-Google-Smtp-Source: AK7set9OrlZDJMtKLveaqiRlFkI0wjed9V+Vw/w1Z1o5dQaSf4mOjk8Zc87magEhKYM6G1J6C7QQ6dT76dm/W/rG6XY=
X-Received: by 2002:a17:903:2c1:b0:19c:d414:fe6e with SMTP id
 s1-20020a17090302c100b0019cd414fe6emr13388793plk.12.1678756501095; Mon, 13
 Mar 2023 18:15:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230313090002.3308025-1-zyytlz.wz@163.com> <ZA8rDCw+mJmyETEx@localhost.localdomain>
 <20230313143054.538565ac@kernel.org> <ZA+etMBFSw/999Aq@codewreck.org>
In-Reply-To: <ZA+etMBFSw/999Aq@codewreck.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Tue, 14 Mar 2023 09:14:48 +0800
Message-ID: <CAJedcCyH_JvVeyFq1i8Udx=W7PO7F+aYeQp+r6dbWQLqMNgy_w@mail.gmail.com>
Subject: Re: [PATCH net v2] 9p/xen : Fix use after free bug in
 xen_9pfs_front_remove due to race condition
To:     asmadeus@codewreck.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Zheng Wang <zyytlz.wz@163.com>, ericvh@gmail.com,
        lucho@ionkov.net, linux_oss@crudebyte.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 1395428693sheep@gmail.com,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<asmadeus@codewreck.org> =E4=BA=8E2023=E5=B9=B43=E6=9C=8814=E6=97=A5=E5=91=
=A8=E4=BA=8C 06:08=E5=86=99=E9=81=93=EF=BC=9A
>
> Jakub Kicinski wrote on Mon, Mar 13, 2023 at 02:30:54PM -0700:
> > On Mon, 13 Mar 2023 14:54:20 +0100 Michal Swiatkowski wrote:
> > > >   for (i =3D 0; i < priv->num_rings; i++) {
> > > > +         /*cancel work*/
> > > It isn't needed I think, the function cancel_work_sync() tells everyt=
hing
> > > here.
> >
> > Note that 9p is more storage than networking, so this patch is likely
> > to go via a different tree than us.
>
> Any review done is useful anyway ;)
>
> Either Eric or me will take the patch, but in the past such fixes have
> sometimes also been taken into the net tree; honestly I wouldn't mind a
> bit more "rule" here as it's a bit weird that some of our patches are Cc
> to fsdevel@ (fs/ from fs/9p) and the other half netdev@ (net/ from
> net/9p), but afaict the MAINTAINERS syntax doesn't have a way of
> excluding e.g. net/9p from the `NETWORKING [GENERAL]` group so I guess
> we just have to live with that.

Dear Dominique,

Sorry for my confusion and thanks for your patient explanation. I'll take c=
are
of it when submitting a fix to the linux kernel in the future.

>
> There's little enough volume and netdev automation sends a mail when a
> patch is picked up, so as long as there's no conflict (large majority of
> the cases) such fixes can go either way as far as I'm concerned.
>
Thanks again for your effort. Hope you have a good day :)

Best regards,
Zheng
