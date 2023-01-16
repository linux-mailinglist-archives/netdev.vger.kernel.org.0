Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1B466B9D3
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 10:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjAPJG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 04:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbjAPJGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 04:06:00 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DC11C328
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:03:53 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id 3so28382503vsq.7
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 01:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MgTQvEAmZIX2DLtpHwjmePJXpPq2qRh62LFLWCiTenA=;
        b=q4zl0rySKkPu6J1o09Xzx1RcMPlipwN31DNvTeExik83SH3pvv2+ynKYOknS10rX5p
         t68LV54KkIABc9pAGbDRCVNmCF1LaOjpxDr8eNGv4UALPg2yZzcy+a484gdoOrEmluKi
         2N0Kg6hZVtvF6Hzi9cQEOPqpVw2TtkalkEOzwf1tvNozg2x901/ZoEBkKa6yv5crUuzr
         6RHPIsVzOjkoJyjOmhQp41k8nSOCgz+k6Wt/wLEgc44FotUsIJ+ui22b/AyiohFH2oSE
         TeaCaA1mpixoMO13/wZXqO/VTKtwJ2JRDjCBa7p57PnMFaL5ZvPeMxn++oPMgR0uvWYi
         Ty9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MgTQvEAmZIX2DLtpHwjmePJXpPq2qRh62LFLWCiTenA=;
        b=iRh1s+eFom3oKzJV25c7zzNwjQCkHRHvnocHWr+EtMhHFaswD8dK2O1xf4OQDcZnua
         1wnGd7dGwqFeNlEOi8WWgo7YCwk6tZ7ByK0BDfmnPEQ5nVSK67wR7E7wyZuyzTlwAV3r
         3tK+emr9ADtlWmmkQoOSMSMTIoYCk2ji4hc2twl38hJdQlSEjVQseAHWMI7EJbmJ9WSi
         noz71cb+XDyEUdLvwWcjIBl0oPpEG0p8bXjMUvlNtpqgz2q6un8AJL9nnqCBFt46f/3E
         6GAvrTpPLYJm1pgbRCEynYwHFwbuzHXPwnik363bYFwxWEtN/G0nn+HafkeLsvL/oF40
         Mf/g==
X-Gm-Message-State: AFqh2kqpyFj1nhOtZvcTll0H27xY4ivC19BMFMJFX2LCzO0WsDIGobR7
        AY0LxNyPbOw6Kw1/ewPaw0BUtRuTOA6Tf2B/XtjLd3CmeFXdkg==
X-Google-Smtp-Source: AMrXdXvlpZOxF+DiqI+uJ6CwV/OpWMAcbFkdePW8CwWf5fydOZzJSuCpT2dGXkqJA2p1HL3NSspKPXkEq4xF3mwTam4=
X-Received: by 2002:a05:6102:2853:b0:3d1:d1ff:33ce with SMTP id
 az19-20020a056102285300b003d1d1ff33cemr1505970vsb.37.1673859832801; Mon, 16
 Jan 2023 01:03:52 -0800 (PST)
MIME-Version: 1.0
References: <20230113164849.4004848-1-edumazet@google.com> <Y8Sb7LYDN/xjDBQy@pop-os.localdomain>
 <10aeb2bd-1d82-c547-3277-82ccb487199c@huawei.com>
In-Reply-To: <10aeb2bd-1d82-c547-3277-82ccb487199c@huawei.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Mon, 16 Jan 2023 10:03:16 +0100
Message-ID: <CAG_fn=X8iLhtHfoUXwRD2LDj=qnB6WXKZHWRaiB3Ri61PH6SiQ@mail.gmail.com>
Subject: Re: [PATCH net] net/sched: sch_taprio: fix possible use-after-free
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 3:07 AM shaozhengchao <shaozhengchao@huawei.com> wr=
ote:
>
>
>
> On 2023/1/16 8:35, Cong Wang wrote:
> > On Fri, Jan 13, 2023 at 04:48:49PM +0000, Eric Dumazet wrote:
> >> syzbot reported a nasty crash [1] in net_tx_action() which
> >> made little sense until we got a repro.
> >>
> >> This repro installs a taprio qdisc, but providing an
> >> invalid TCA_RATE attribute.
> >>
> >> qdisc_create() has to destroy the just initialized
> >> taprio qdisc, and taprio_destroy() is called.
> >>
> >> However, the hrtimer used by taprio had already fired,
> >> therefore advance_sched() called __netif_schedule().
> >>
> >> Then net_tx_action was trying to use a destroyed qdisc.
> >>
> >> We can not undo the __netif_schedule(), so we must wait
> >> until one cpu serviced the qdisc before we can proceed.
> >>
> >
> > This workaround looks a bit ugly. I think we _may_ be able to make
> > hrtimer_start() as the last step of the initialization, IOW, move other
> > validations and allocations before it.
> >
> > Can you share your reproducer?
> >
> > Thanks,
> Maybe the issue is the same as
> https://syzkaller.appspot.com/bug?id=3D1ccb246eecb5114c440218336e4c7205ae=
d5f2c8

Most certainly, yes.
I also think there were stall reports with the same stack trace where
qdisc_run was unable to take a freed lock because its value was set to
1 by another task.

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
