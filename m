Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19812695E38
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjBNJIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjBNJHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:07:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FF824485
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:06:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676365546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qiYZoaFQtYPJr1Mf2yOp9DXnBrRhGcBThLmzhDbgG+M=;
        b=Nllv+ta17IXlZ3m+Fgecyetb4ejO2HaIY1bmPLgFJJf7PjmcSauK1QYiwninTI5UD+9L26
        Bw/kVuxP21lfBLSsCXLfxFiu3uEfZXJHVrFWWiOV9UvOA7WqwiyfF7YgIkiV971+V/Q8Hx
        SKolDu9b4UXiwGYcRAZiDqg8iR+6I8I=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-d0f6-OCHMC64QepbNGgdTw-1; Tue, 14 Feb 2023 04:05:45 -0500
X-MC-Unique: d0f6-OCHMC64QepbNGgdTw-1
Received: by mail-qk1-f198.google.com with SMTP id x12-20020a05620a258c00b007051ae500a2so9016315qko.15
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 01:05:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qiYZoaFQtYPJr1Mf2yOp9DXnBrRhGcBThLmzhDbgG+M=;
        b=W9jJWYLQ8G6SIJ3VUBem6mGr7rEvlVt9UK3AjQgWBZO3kwjQbhULRP1feEkJe+YJJ7
         K3+fkFhZPgVvgSRSRvEpo65iXUa74tCUP1Dq3m1AgkDjS+qlzaT+zggEC15xUiri3R8Z
         3D4W8dCeuZPZoaaYirae5/yuNdURw8PcutqUx/uaaBaKXopAGMRDCw00bDhxfwF3r900
         pNL2/klKaOrtp6DfwVvL+AVriEY/lkIO5fxV8kKvDWbMB9muKBJ5tVoAYk3vpH7pKbP/
         AyC+plpXHkm3qq10+fKlCio9kt5xo9GqmGzX9V4LIMhotHB+RMLKs0nL4bTiI5kD6pXv
         LyYQ==
X-Gm-Message-State: AO0yUKVX9hx13ObeksdhFEEijNzCHV50BBl8b2KUk8t+3Y30GDRy8zjq
        sBebaCGimWHGVgtOgBe9HtOGp+mT31EtheybxNKXk/UYRDE66XfjPbest448MeMPxa4G7WnjbPp
        OZ9m5opCrG9ZzYhO/k0a4GQ==
X-Received: by 2002:a05:622a:64e:b0:3b5:87db:f979 with SMTP id a14-20020a05622a064e00b003b587dbf979mr2800347qtb.5.1676365544399;
        Tue, 14 Feb 2023 01:05:44 -0800 (PST)
X-Google-Smtp-Source: AK7set+ylrCpjjAcDGoHOEvBCzZQ5+Tme3doUeMQPqJAmBzN4rzMJwoio0HE3lRVVKtHgvx3LdA8Dg==
X-Received: by 2002:a05:622a:64e:b0:3b5:87db:f979 with SMTP id a14-20020a05622a064e00b003b587dbf979mr2800333qtb.5.1676365544179;
        Tue, 14 Feb 2023 01:05:44 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id n12-20020ac81e0c000000b003b82cb8748dsm10854014qtl.96.2023.02.14.01.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 01:05:43 -0800 (PST)
Message-ID: <7a6c0263d698ccc821b2c7ef38c0063745f44743.camel@redhat.com>
Subject: Re: [PATCH net-next 1/3] net/sched: act_nat: transition to percpu
 stats and rcu
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Date:   Tue, 14 Feb 2023 10:05:41 +0100
In-Reply-To: <20230210202725.446422-2-pctammela@mojatatu.com>
References: <20230210202725.446422-1-pctammela@mojatatu.com>
         <20230210202725.446422-2-pctammela@mojatatu.com>
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
> diff --git a/net/sched/act_nat.c b/net/sched/act_nat.c
> index 74c74be33..fb986d97c 100644
> --- a/net/sched/act_nat.c
> +++ b/net/sched/act_nat.c
> @@ -40,6 +40,7 @@ static int tcf_nat_init(struct net *net, struct nlattr =
*nla, struct nlattr *est,
>  	bool bind =3D flags & TCA_ACT_FLAGS_BIND;
>  	struct nlattr *tb[TCA_NAT_MAX + 1];
>  	struct tcf_chain *goto_ch =3D NULL;
> +	struct tcf_nat_parms *nparm, *oparm;
>  	struct tc_nat *parm;
>  	int ret =3D 0, err;
>  	struct tcf_nat *p;

Please respect the reverse x-mas tree above.

> @@ -289,6 +306,16 @@ static int tcf_nat_dump(struct sk_buff *skb, struct =
tc_action *a,
>  	return -1;
>  }
> =20
> +static void tcf_nat_cleanup(struct tc_action *a)
> +{
> +	struct tcf_nat_parms *parms;
> +	struct tcf_nat *p =3D to_tcf_nat(a);

Same here.

Thanks,

Paolo

