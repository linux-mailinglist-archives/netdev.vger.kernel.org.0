Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0104695EE2
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjBNJXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjBNJXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:23:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9CB30CF
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676366546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PRKY0rQD7qs3ZUzQ/RMoLUFCdL3z6QLNRR5+1r9GefU=;
        b=NLG4D9OgZq486ANj3htb1oT6Gks02R4i67Kvd1kDiD8zBfQOJiywNsP0t5LmNWDCt/Vv8R
        t3s1wbTTstc9gWAjbG7oWgDmPqRu25iwiQX1DUoz8vDFy6jyMG6cbT7bPTH6btPwZZ48eD
        Rw5SURx0Ta2jfnyDNiS5dsVODTNxzts=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-64-_LDsfRdtNdWkeCENMsEJWg-1; Tue, 14 Feb 2023 04:22:25 -0500
X-MC-Unique: _LDsfRdtNdWkeCENMsEJWg-1
Received: by mail-qt1-f199.google.com with SMTP id n1-20020ac85a01000000b003ba2a2c50f9so9091175qta.23
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:22:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676366544;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PRKY0rQD7qs3ZUzQ/RMoLUFCdL3z6QLNRR5+1r9GefU=;
        b=ZS/PSQPP64ceNV/2eufVUfQE0m3fYWY4eKuil9Kx8TdudyTAVJegYvqVlErs0DK07i
         9Qpa39W/jRqpgYQIiqO7YEQAY0Kv8VPfbxt0JMVwHhVG4G6KzTdKz1T/LboTxfeZweUK
         Y9JWLtfm8rES3qqmqfo07q1irp3cKlWmSeDGnch6LaYz15fSrAx1AGz1bq5sEGE612Qd
         RPwwi8mO7qaKIXRrbfQ2ASYLEKVvJbxHj6+rJdNzJDME3HBIkollg1tYwrCUuH+NPaL5
         8/Hm+4KyEFpsurxW3l5K9uiJZQ/KgG+Fcz/1mzYq++sIKfWoyBGG71kcQgn7r60EKGrE
         yiog==
X-Gm-Message-State: AO0yUKW4cw3LIqpGxIGXgfrY+OfNLbM4b920OHEjsMZrmo4XBZt2iC3o
        1ty9nQvuyA+SkCIv6nTcsoMPXnXgxwtvqUdjhP3Be1RXX9F15EdDOqs0SOaMkKzSmZud0M6eUUo
        4PEAap7XTQZ+Iut+K
X-Received: by 2002:a05:622a:14cb:b0:3a5:f916:1d2c with SMTP id u11-20020a05622a14cb00b003a5f9161d2cmr3107739qtx.5.1676366544695;
        Tue, 14 Feb 2023 01:22:24 -0800 (PST)
X-Google-Smtp-Source: AK7set+qfTrssCjB6hajCOSTU7fgJ1cbKJpe3yixSDQhf91EI3JycSgMzCNIP5LCex1uPAVsEqUl6w==
X-Received: by 2002:a05:622a:14cb:b0:3a5:f916:1d2c with SMTP id u11-20020a05622a14cb00b003a5f9161d2cmr3107715qtx.5.1676366544346;
        Tue, 14 Feb 2023 01:22:24 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id r129-20020a37a887000000b006cec8001bf4sm11504728qke.26.2023.02.14.01.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 01:22:23 -0800 (PST)
Message-ID: <8b99e6732da7820457d3c0dde841d25fefb8c30a.camel@redhat.com>
Subject: Re: [PATCH net-next 3/3] net/sched: act_gate: use percpu stats
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Date:   Tue, 14 Feb 2023 10:22:20 +0100
In-Reply-To: <20230210202725.446422-4-pctammela@mojatatu.com>
References: <20230210202725.446422-1-pctammela@mojatatu.com>
         <20230210202725.446422-4-pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-02-10 at 17:27 -0300, Pedro Tammela wrote:
>=20
> diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
> index 9b8def0be..684b7a79f 100644
> --- a/net/sched/act_gate.c
> +++ b/net/sched/act_gate.c
> @@ -120,10 +120,10 @@ TC_INDIRECT_SCOPE int tcf_gate_act(struct sk_buff *=
skb,
>  {
>  	struct tcf_gate *gact =3D to_gate(a);
> =20
> -	spin_lock(&gact->tcf_lock);
> -
>  	tcf_lastuse_update(&gact->tcf_tm);
> -	bstats_update(&gact->tcf_bstats, skb);
> +	tcf_action_update_bstats(&gact->common, skb);
> +
> +	spin_lock(&gact->tcf_lock);

I think that RCU-ifying the 'current_gate_status' field, setting its
value with  WRITE_ONCE (both in _init and in gate_timer_func()) and
finally accessing it here with READ_ONCE, you could move pretty much
everything except the code touching *_octets update outside the
spinlock.

I'm not sure how much that will be relevant - e.g. how frequently we
expect to hit the=20

	if (gact->current_max_octets >=3D 0) {

code path.

For sure the current code allocates per_cpu stats, but they are never
used.

Cheers,

Paolo

