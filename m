Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDD1B6B1331
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 21:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjCHUgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 15:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjCHUgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 15:36:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D95CD5179
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 12:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678307688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hdk7ckeqLYIwLCDmEyqXJOvt1gf7vv0upLXeTwcvE5I=;
        b=TIq+IIZEEZaP0U6kpqopioNf8OlfTVBYPn91rYRRhAp2qGbvpJracGez0SVPs+CHGPAKE2
        X9KQNgNArJBHz/O8fHe9XzpFBiCjKPgmaU3Pgrl52W5RjhtTFDge0M2MldeUQDtjaL6kGA
        F9xtfuqTIJIjQGlIZdPNuSXMIARabSg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-UvQHd0UiMO22c53RRqR_-A-1; Wed, 08 Mar 2023 15:34:47 -0500
X-MC-Unique: UvQHd0UiMO22c53RRqR_-A-1
Received: by mail-wm1-f70.google.com with SMTP id e17-20020a05600c219100b003e21fa60ec1so1268342wme.2
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 12:34:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678307686;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hdk7ckeqLYIwLCDmEyqXJOvt1gf7vv0upLXeTwcvE5I=;
        b=nkY/GZoUNp1SnrzlnbWTtzDGGjl/6aCDBRBkbwJEaeRndyt2zTrXuxMv19Jc0wPgrd
         tysGPBpDKaepsJ9nFXTdlCmKrfNK5bUhO0TagFvLfq2OiY+UUbbi+8BCq/BVSbYoioaj
         KdJwJ9HonFNrX1gBpxmIAj2MgwwD/wkeROoMqQRyhEX6J0TSOHZ2oqGSUoFeEhxu2w0+
         9w3qCrha8ulUoUU54lUm2ckldZixpeXizegeS7tPn/3K07uVL63eePjVda4p+4bCyPT6
         j0g6s6T8aVrRCyHmc3A2tlJfzbT5Krga6+047TBntBdaQqNqp8bzaAxKpA+A9vqVkFCf
         mqjg==
X-Gm-Message-State: AO0yUKXA5dWBW3cWMwwyBfDO3OLcEhfNZg1la/uLrxw8HEh1VPwib4tq
        FXThNEM6QoMfmPQTvxUEQbPGLZ7r921rBkWCfDgn8rWOkj2GnyuxIHv7Tc6N6EpEga5o9bViRyY
        K0ByEBkvEQGLL+HKi
X-Received: by 2002:adf:e60b:0:b0:2c7:1c72:699f with SMTP id p11-20020adfe60b000000b002c71c72699fmr12351050wrm.4.1678307685838;
        Wed, 08 Mar 2023 12:34:45 -0800 (PST)
X-Google-Smtp-Source: AK7set9FmzZXAuBId0QOA4oZOfelEMo1fHMeBunZRomyT3/1ttx9W0b8OZAA9h7jV06Ay582RhCeug==
X-Received: by 2002:adf:e60b:0:b0:2c7:1c72:699f with SMTP id p11-20020adfe60b000000b002c71c72699fmr12351041wrm.4.1678307685424;
        Wed, 08 Mar 2023 12:34:45 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-28.dyn.eolo.it. [146.241.121.28])
        by smtp.gmail.com with ESMTPSA id p10-20020a5d68ca000000b002c59e001631sm16443877wrw.77.2023.03.08.12.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 12:34:44 -0800 (PST)
Message-ID: <f0c49fb4b682b81d64184d1181bc960728907474.camel@redhat.com>
Subject: Re: [PATCH v4 RESEND] epoll: use refcount to reduce ep_mutex
 contention
From:   Paolo Abeni <pabeni@redhat.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     netdev@vger.kernel.org, Soheil Hassas Yeganeh <soheil@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org
Date:   Wed, 08 Mar 2023 21:34:43 +0100
In-Reply-To: <20230308104054.84612fbe99e8a57ae57b5ff0@linux-foundation.org>
References: <e8228f0048977456466bc33b42600e929fedd319.1678213651.git.pabeni@redhat.com>
         <20230307133057.1904d8ffab2980f8e23ee3cc@linux-foundation.org>
         <f049d74b59323ed2ad16a0b52de86f157ae353ce.camel@redhat.com>
         <20230308104054.84612fbe99e8a57ae57b5ff0@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
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

On Wed, 2023-03-08 at 10:40 -0800, Andrew Morton wrote:
> On Wed, 08 Mar 2023 09:55:31 +0100 Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> > I have a process question: I understand this is queued for the mm-
> > nonmm-unstable branch. Should I send a v5 with the above comments
> > changes or an incremental patch or something completely different?
>=20
> Either is OK.  If it's a v5 I'll usually queue a delta so people who
> have a;ready reviewed can see what changed.  That delta is later
> squashed and I'll use v5's changelog for the whole.

Since even the changelog needs some fixup, I'll send a v5.

Thanks,

Paolo

