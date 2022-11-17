Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7588962E787
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 23:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241169AbiKQWAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 17:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241111AbiKQV7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 16:59:52 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9672595B7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 13:58:28 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id v8so2220033qkg.12
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 13:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sdJwHvXndE3LnyuSwNgHfLaxUa5yGh5fKAZ/2I7kMxw=;
        b=Hq8SHtfQDMLJrzI1zZisebHGzHqdL4OgvuhVqmJqF4exqNzl1GwiShmFzcKxci0s/y
         2nsm8XGhEy0YccW0bWQOK2pVfZ2+byGo1j2wjwhculPCpRCo5pjJqj+dtp64qmsTTjke
         moW7TrwAPa1QkM65Y2rCfiLDZ25T78zCqBHQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sdJwHvXndE3LnyuSwNgHfLaxUa5yGh5fKAZ/2I7kMxw=;
        b=qrMzangJC0o+7FZkbFRYV2eByzgCzSgS45NdpWg97EF9I2jmzPWty/WvFohoHBBCk6
         GvDE+Nk8rR7pcV7o5qVjZJD9mXezMFgAQtkYotU2mIntlTn7adV7nKdGyQduB/UmUVld
         JA7+Vg85xoo/WeWBABeFewBehe6lyvMvuTeoWqwYZuBUUYftWnvYjSSpTrarCeefon+k
         gm0uWS6XpBTM7DZsaz49QlLFxymyIX/wjv4lAfIjsbfBFZAgfdiFkr31QYTaB/RAvCEq
         q3IddACCQXdlQM9vxDWAMAYhWKlEGCVF3fG8w/PjZ2hHT1/+kmYEKxt4su/CxlfcVaG6
         DyVQ==
X-Gm-Message-State: ANoB5pl9H9+oyTPEJwklG7T8U3nJbXYuS0OAf/NU1A26sqcABGdum52b
        pCvBQUF4lZQCP7EOYjMXrdJV7Q==
X-Google-Smtp-Source: AA0mqf4F1WSB/TnhqpkihBlK3h3QxuREsXKoZ/dGjhYzWK/h+ls0do4OcG4lzJNsx96nqWOb+v7rkQ==
X-Received: by 2002:a05:620a:530c:b0:6fa:6e0c:ab79 with SMTP id oo12-20020a05620a530c00b006fa6e0cab79mr3651369qkn.74.1668722307650;
        Thu, 17 Nov 2022 13:58:27 -0800 (PST)
Received: from smtpclient.apple (c-73-148-104-166.hsd1.va.comcast.net. [73.148.104.166])
        by smtp.gmail.com with ESMTPSA id j11-20020a05620a410b00b006bba46e5eeasm1261335qko.37.2022.11.17.13.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Nov 2022 13:58:27 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH rcu/dev 1/3] net: Use call_rcu_flush() for qdisc_free_cb
Date:   Thu, 17 Nov 2022 16:58:26 -0500
Message-Id: <DCDBA54C-C35B-497D-BB39-224C88B94660@joelfernandes.org>
References: <CANn89iJuy=PuAiwrjF3qZY0M+86eRQ=o_x-m-eoxOdyAM8yoSg@mail.gmail.com>
Cc:     linux-kernel@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, paulmck@kernel.org, fweisbec@gmail.com
In-Reply-To: <CANn89iJuy=PuAiwrjF3qZY0M+86eRQ=o_x-m-eoxOdyAM8yoSg@mail.gmail.com>
To:     Eric Dumazet <edumazet@google.com>
X-Mailer: iPhone Mail (19G82)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 17, 2022, at 4:44 PM, Eric Dumazet <edumazet@google.com> wrote:
>=20
> =EF=BB=BFOn Wed, Nov 16, 2022 at 7:16 PM Joel Fernandes (Google)
> <joel@joelfernandes.org> wrote:
>>=20
>> In a networking test on ChromeOS, we find that using the new CONFIG_RCU_L=
AZY
>> causes a networking test to fail in the teardown phase.
>>=20
>> The failure happens during: ip netns del <name>
>>=20
>> Using ftrace, I found the callbacks it was queuing which this series fixe=
s. Use
>> call_rcu_flush() to revert to the old behavior. With that, the test passe=
s.
>>=20
>> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
>> ---
>> net/sched/sch_generic.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
>> index a9aadc4e6858..63fbf640d3b2 100644
>> --- a/net/sched/sch_generic.c
>> +++ b/net/sched/sch_generic.c
>> @@ -1067,7 +1067,7 @@ static void qdisc_destroy(struct Qdisc *qdisc)
>>=20
>>        trace_qdisc_destroy(qdisc);
>>=20
>> -       call_rcu(&qdisc->rcu, qdisc_free_cb);
>> +       call_rcu_flush(&qdisc->rcu, qdisc_free_cb);
>> }
>=20
> I took a look at this one.
>=20
> qdisc_free_cb() is essentially freeing : Some per-cpu memory, and the
> 'struct Qdisc'
>=20
> I do not see why we need to force a flush for this (small ?) piece of memo=
ry.

I=E2=80=99ll try to drop that and rerun the test, and get back to you. It co=
uld be that there is a different callback that this flush() is compensating f=
or, or something. I am pretty sure at one point, dropping this patch made th=
e test fail most of the time. Now it passes 100%.

I=E2=80=99ll also attempt to collect a complete trace, maybe I=E2=80=99ll le=
arn some networking code in the process..

Thanks!=
