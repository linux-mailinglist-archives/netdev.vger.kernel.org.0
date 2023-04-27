Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128536F024F
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 10:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242556AbjD0IGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 04:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbjD0IGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 04:06:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD502D65
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 01:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682582716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cj2zQAojKeZUHaGZ1dAdEhzXuzQhYnVQUgXnczBjxu8=;
        b=NGOry3XXRNOZ5LlhyimStQHSZBxcw15j0NqVQgNJJ9CF1Am5VNj5NBbt0bMA2bGVPPpq2x
        4LMhppPvionUCdeaW3nj73ZKdT4Rz4LwAUgwjzne+GFkHbInpCb+Pz2bQZWP42ACMekDH1
        QnMBJO+PUCV3vDzgjOwDuDYMk5lJGuU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-Dm7e-PL4MoWgumFK-rbfbg-1; Thu, 27 Apr 2023 04:05:14 -0400
X-MC-Unique: Dm7e-PL4MoWgumFK-rbfbg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-2f4130b899eso145666f8f.1
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 01:05:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682582713; x=1685174713;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cj2zQAojKeZUHaGZ1dAdEhzXuzQhYnVQUgXnczBjxu8=;
        b=LFwvKxKE+DaYgFiBFaQzb369wdUznBCu4D0rKxQDt9VECHRGC1/raxQXr/eQtIpzWY
         IB9ioea21Kun6KMPl2NpwwxzbvuxMNcfCUf1bgfT+O/JYeyrmwuwh7B5keaJUBCg95i9
         y9lHtB+bwiRk5zjDylvb+SMLfnDmjd63/JVQgRQucGgqN8UJ35jPC6GBJXV28QLeQlyZ
         0HYpsS83s1dX0h9D8yNin8YiQBpKuIsYosXQ1i23SHBnoKqAsw71b4WGnoA9w7b+66Q8
         0OHyHsvQ5BJ8WIDUScc/bx1xnlQtEc2VvBgG4FYrk0WqvR3/9LJwXGYMjWtyvWvW5nND
         ZDBw==
X-Gm-Message-State: AC+VfDwmcwlaN1JQ1qWSvmWoX5dFCuaN3TTSjlUinlzGpXHAQZTWRQSb
        jGluEUDxvLJUE9LF3InCzrZ9dvQmmAQb93n4hCMfOA4CkXwtngpfWy8gaQBYc1AJqou9I1NJaq4
        O1fhD4/WUa57LBj8Z
X-Received: by 2002:a5d:595b:0:b0:2e4:aa42:7872 with SMTP id e27-20020a5d595b000000b002e4aa427872mr458478wri.4.1682582713614;
        Thu, 27 Apr 2023 01:05:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4p/RgXJKDKWAtghgiKtxz5Wj4Wp5hOgdJagT52SJ1/MeQ/NeOipA3IsbmLnWj+UwVQd5V3Yg==
X-Received: by 2002:a5d:595b:0:b0:2e4:aa42:7872 with SMTP id e27-20020a5d595b000000b002e4aa427872mr458450wri.4.1682582713270;
        Thu, 27 Apr 2023 01:05:13 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-21.dyn.eolo.it. [146.241.243.21])
        by smtp.gmail.com with ESMTPSA id j14-20020adfea4e000000b002fc3d8c134bsm17851158wrn.74.2023.04.27.01.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 01:05:12 -0700 (PDT)
Message-ID: <e4e4046d53ce61ac0f7db882fa31556e8a9db94b.camel@redhat.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>,
        Vadim Fedorenko <vadfed@meta.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        poros <poros@redhat.com>, mschmidt <mschmidt@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Date:   Thu, 27 Apr 2023 10:05:11 +0200
In-Reply-To: <20230417124942.4305abfa@kernel.org>
References: <20230312022807.278528-1-vadfed@meta.com>
         <20230312022807.278528-3-vadfed@meta.com> <ZA9Nbll8+xHt4ygd@nanopsycho>
         <2b749045-021e-d6c8-b265-972cfa892802@linux.dev>
         <ZBA8ofFfKigqZ6M7@nanopsycho>
         <DM6PR11MB4657120805D656A745EF724E9BBE9@DM6PR11MB4657.namprd11.prod.outlook.com>
         <ZBGOWQW+1JFzNsTY@nanopsycho> <20230403111812.163b7d1d@kernel.org>
         <ZDJulCXj9H8LH+kl@nanopsycho> <20230410153149.602c6bad@kernel.org>
         <ZDwg88x3HS2kd6lY@nanopsycho> <20230417124942.4305abfa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 2023-04-17 at 12:49 -0700, Jakub Kicinski wrote:
> [resend with fixed CC list]
>=20
> On Sun, 16 Apr 2023 18:23:15 +0200 Jiri Pirko wrote:
> > > What is index? I thought you don't want an index and yet there is one=
,
> > > just scoped by random attributes :( =20
> >=20
> > Index internal within a single instance. Like Intel guys, they have 1
> > clock wired up with multiple DPLLs. The driver gives every DPLL index.
> > This is internal, totally up to the driver decision. Similar concept to
> > devlink port index.
>=20
> devlink port index ended up as a pretty odd beast with drivers encoding
> various information into it, using locally grown schemes.
>=20
> Hard no on doing that in dpll, it should not be exposed to the user.

I'm replying here just in case the even the above reply was lost.

I guess the last remark resolved this specific discussion.

@Vadim, @Arkadiusz, even if net-next is currently closed, there are no
restrictions for RFC patches: feel free to share v7 when it fits you
better!

Thanks,

Paolo

