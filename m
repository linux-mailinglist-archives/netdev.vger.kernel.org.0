Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCBF6E5EB2
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 12:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjDRK0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 06:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjDRK00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 06:26:26 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE00665A9
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 03:26:25 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-3293e4b2d32so4361495ab.1
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 03:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681813585; x=1684405585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KrFDaixCBqYb/CP9MBGuAQOUgNRogqABcefWqpbXaKw=;
        b=H/0rv1pIe/a8AaJ1XdvDq2LxtHggUesGAbn4r2QWdiGdKe3b0WIUYOwzuIBNTyHhNm
         ZzyE3ok5hmTaT/2sIP7L+fXzkOM5jX8pzXUV/DOiZtUOPCbevQoW/Nez5ztgZPxXD1Nq
         maTdekeDePSgUJJU5V2+2FLuB6XQJP9HK5ANqy5knAjsaKpFp4kMZnskhUcBtyM7JEmt
         iztPkaHK9AEwSlNMFadw2nC/wirP9rwHuWHiNMMYmrVHXIRPSrV3Ka9w59dOvif6Vq0E
         6k4l+sR+iT3lvSoREeaCiPY3RAMF/CQfsXlo25FPaRRITuVEN+MfIvROLA6vQPoMp9Gp
         VeyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681813585; x=1684405585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrFDaixCBqYb/CP9MBGuAQOUgNRogqABcefWqpbXaKw=;
        b=iZMQXBhMqt9UBz35QmNnwwWTQfQP1U/4o5XMwADNmh+D64f4PKlA3g632iiZdHX1Ui
         oCWeY2getkjAwFBTYLI40xbXhmBdi0lz0WLcXHDGQ5eDAfket9cnecUei2eUGHja0SwF
         kz4miulW+cv7bawlF6mjzUof4TbgF8/RuxQUFnc5u1+WLo/takuyskBWWXYSpScb7zjh
         +DRvBdot/qMHIbBQ4fYvugmOQYr6GUR1peA/IwK/1Kr7srZMuKFJeLCvGL1HvLZahtFZ
         41d8pq1SxnI0e9tqNf/IJD72l9U71PGqQNPqz9i1C+Uq/WagVkI007GiRJJLcl9UaUv9
         wr9Q==
X-Gm-Message-State: AAQBX9fGYROLU66KWVEV3jjSiDyy/JbqQCu8vjWh+g1df3KAkrIKcn3f
        EfzQAUbg63T9P2SD1tkSYT2kMp3Pr4UBZF4K+iKAgA==
X-Google-Smtp-Source: AKy350Z22VZGX+K/O8zpPQFkBZ1RlZhnTFjuzytPQpcoZaTf10Cy6ZTAmiKP5BMRlp6z34BtU++XPbRQ+Ru1TuNm2w4=
X-Received: by 2002:a05:6e02:152:b0:32a:9e86:242f with SMTP id
 j18-20020a056e02015200b0032a9e86242fmr6591775ilr.6.1681813585072; Tue, 18 Apr
 2023 03:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <a5288a1f4b69eb2da3e704d0e1ff082489432d25.1681728988.git.dcaratti@redhat.com>
 <20230417193031.3ab4ee2a@kernel.org>
In-Reply-To: <20230417193031.3ab4ee2a@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 18 Apr 2023 12:26:13 +0200
Message-ID: <CANn89iJ0zy6rr4=O3328heYgiBHNcc9hmAHweTFvAW7iZi8QFw@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: sch_fq: fix integer overflow of "credit"
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Christoph Paasch <cpaasch@apple.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 4:30=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Mon, 17 Apr 2023 13:02:40 +0200 Davide Caratti wrote:
> > +             u32 initial_quantum =3D nla_get_u32(tb[TCA_FQ_INITIAL_QUA=
NTUM]);
> > +
> > +             if (initial_quantum <=3D INT_MAX) {
> > +                     q->initial_quantum =3D initial_quantum;
> > +             } else {
> > +                     NL_SET_ERR_MSG_MOD(extack, "invalid initial quant=
um");
> > +                     err =3D -EINVAL;
> > +             }
>
> Please set the right policy in fq_policy[] instead.

Not sure these policies are available for old kernels (sch_fq was
added in linux-3.12) ?

Or have we backported all this infra already on stable kernels ?

commit d06a09b94c618c96ced584dd4611a888c8856b8d
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Apr 30 22:13:08 2020 +0200

    netlink: extend policy range validation
