Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F296F0427
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 12:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243288AbjD0KZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 06:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbjD0KZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 06:25:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C332C449D
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 03:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682591077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pAwgPYWKrjk5uKKrf7uAG4dZtsynahbqrf9TvQ+uveg=;
        b=dBAZDrqBiKS2QXSrPQh2CKsYZJRZ9S6JWJpOnl/b2aGK36TtbQ7JS/fAV+GLr5v59EfMxR
        Hl6Ii9DIS6CPwvdrfdPWvhjDz457CUWfrAycRG/8holhngxEPsSiOqh2QRvBeGox5wlpef
        AAy33RnoRvpOMiRiG9RzYc5SaE3Fb3c=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-8cWTNUVeMfi2ypkOy6Snkg-1; Thu, 27 Apr 2023 06:24:36 -0400
X-MC-Unique: 8cWTNUVeMfi2ypkOy6Snkg-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-74deffa28efso64864185a.1
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 03:24:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682591076; x=1685183076;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pAwgPYWKrjk5uKKrf7uAG4dZtsynahbqrf9TvQ+uveg=;
        b=F78a263Er3mfkm7UtrL7t2eDagnc2OdEgY9BOwP8zImLAYQu1POmgnknD4E8A0/m+g
         joI+dxWuDBWEBpR0MMH/kqy2tAxiWGKIk3jWlexvfVq/9e0wdOkRnVTyGMK3j9Lr0xrO
         e1ZxdALnGncLgkSIdF6BFfy4TLLbFcyC0LU8ahxGulDgti12XggYQsacRe8rKudowl13
         JKfculmS6jkl3GFbPqtCd0OqXyP5BTQk6HoV5Nrq+jIu883tY9Qi/0tK3tVqK4gwPilh
         N5i03GdNAOqBoqj36auLUTeKyFH5TkqBx2UyH63SIt/QCBfPLi+XgohpBTQP/XO5G6pU
         WrVQ==
X-Gm-Message-State: AC+VfDywm3VgIpz5AzdnRp390RxnkWzrZpfOIovIy7/mhFXH9D1wEVF8
        b7v4qJy9GoYrEQ8s68IEpeB5ZVwtPY+I9W/zKuiHUGTR8IBEei8MOK+PWIywsMbzr+D1xT+NbM3
        moZdVG3o9PksSJJK9
X-Received: by 2002:a05:6214:5299:b0:616:73d9:b9c9 with SMTP id kj25-20020a056214529900b0061673d9b9c9mr949909qvb.0.1682591076346;
        Thu, 27 Apr 2023 03:24:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7aTUqvCh7qGG+cSoTV6l/bBIvPFOXPPziCXWcx8SDNxLgTw1LE4VVpum7u0C5IHuWMluIszQ==
X-Received: by 2002:a05:6214:5299:b0:616:73d9:b9c9 with SMTP id kj25-20020a056214529900b0061673d9b9c9mr949881qvb.0.1682591075945;
        Thu, 27 Apr 2023 03:24:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-21.dyn.eolo.it. [146.241.243.21])
        by smtp.gmail.com with ESMTPSA id o20-20020a0cf4d4000000b005f66296da7bsm5564272qvm.94.2023.04.27.03.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 03:24:35 -0700 (PDT)
Message-ID: <f525d5b887888f6c00633d4187836da0fb31f2cf.camel@redhat.com>
Subject: Re: [PATCH net 1/1] i40e: fix PTP pins verification
From:   Paolo Abeni <pabeni@redhat.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, netdev@vger.kernel.org,
        Andrii Staikov <andrii.staikov@intel.com>,
        Sunitha Mekala <sunithax.d.mekala@intel.com>
Date:   Thu, 27 Apr 2023 12:24:32 +0200
In-Reply-To: <ZEksrgKGRAS0zbgO@hoboy.vegasvil.org>
References: <20230425170406.2522523-1-anthony.l.nguyen@intel.com>
         <20230426071812.GK27649@unreal> <ZEksrgKGRAS0zbgO@hoboy.vegasvil.org>
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

On Wed, 2023-04-26 at 06:52 -0700, Richard Cochran wrote:
> On Wed, Apr 26, 2023 at 10:18:12AM +0300, Leon Romanovsky wrote:
> > On Tue, Apr 25, 2023 at 10:04:06AM -0700, Tony Nguyen wrote:
> > > From: Andrii Staikov <andrii.staikov@intel.com>
> > >=20
> > > Fix PTP pins verification not to contain tainted arguments. As a new =
PTP
> > > pins configuration is provided by a user, it may contain tainted
> > > arguments that are out of bounds for the list of possible values that=
 can
> > > lead to a potential security threat. Change pin's state name from 'in=
valid'
> > > to 'empty' for more clarification.
> >=20
> > And why isn't this handled in upper layer which responsible to get
> > user input?
>=20
> It is.
>=20
> long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long ar=
g)
> {
> 	...
>=20
> 	switch (cmd) {
>=20
> 	case PTP_PIN_SETFUNC:
> 	case PTP_PIN_SETFUNC2:
> 		if (copy_from_user(&pd, (void __user *)arg, sizeof(pd))) {
> 			err =3D -EFAULT;
> 			break;
> 		}
> 		...
>=20
> 		pin_index =3D pd.index;
> 		if (pin_index >=3D ops->n_pins) {
> 			err =3D -EINVAL;
> 			break;
> 		}
>=20
> 		...
> 	}
> 	...
> }

Given the above, I don't see why/how this patch is necessary? @Tony,
@Andrii: could you please give a better/longer description of the issue
addressed here?

Thanks!

Paolo

