Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBD0663C6B
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbjAJJLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237888AbjAJJK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:10:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B732313F76
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673341797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nFZq3SBTamcigdoRRzwUBgH0qMCHNW5u+QNOnJDejsg=;
        b=evC4QuAtEe612IlfckZF7JLSQwDkST2A536wbLMgDX253b8qpHccp2aHwxJE2MBDUwteiG
        /y9uRQ6sfdksJnsCQKUNhii4lNXKIOrMOyD4bb7VRdEwqKF/pKGpdIF9zD/FX7ZMy6AjEI
        Xdgc5MAbaWCe1wg+ojeCRrYDJJg/Fag=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-104-Wi3ouCKePfeWL0Kyz4Acsg-1; Tue, 10 Jan 2023 04:09:55 -0500
X-MC-Unique: Wi3ouCKePfeWL0Kyz4Acsg-1
Received: by mail-wm1-f69.google.com with SMTP id w8-20020a1cf608000000b003d9bb726833so2314254wmc.6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:09:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFZq3SBTamcigdoRRzwUBgH0qMCHNW5u+QNOnJDejsg=;
        b=u2qfLri6I0yz0UZNuL0F+rK5qvR8nm8aUsljK6tChLGcW+r5Wbhl7yx2aC7az/mAwT
         gnE0zV59eA3ih3MreeKWen1QUXGC5vb0SIQQIYMkhz4kDCoWgXYbAiUWluuwxwkXdGxh
         4gOrko3WsEf+n3QXxDGCqVoEvF2utdoS0PnCtP+XLm8bg3rYGUU5ow3r76aUjWDYO4EP
         ktGy3auqUKtJU7Msr4yToObnSZB9RoS9jUebiAr6EDDJOVb+TFYiVsJiJ/00hl/fE5va
         8yYNjGUSmzEkjPk0MfJDGX9tH17/Z3Smj8hUU4QemygAguSKK7tUzE5wZkWt3jwGD29C
         QuLw==
X-Gm-Message-State: AFqh2krxUV0+LEuz4+yjd/slApn4JJVZvW9YeCE0YJXPVTVMWohmZ4O/
        J0vRMFb4ovPkGVp16icmK54swdg2v8Qq+TzUeCt0AFdrmFqQcpPxbB1wA7QYsOXWgs0J4as3fLp
        Ixee4+11bEx3+3Ul4
X-Received: by 2002:a05:600c:3509:b0:3cf:93de:14e8 with SMTP id h9-20020a05600c350900b003cf93de14e8mr47958096wmq.39.1673341794401;
        Tue, 10 Jan 2023 01:09:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvfb+XUyd5fZy4DDEnZMUpPLI1dduu2YXlSl93iWEfpajdh8yoBABE7esjWXtnv5mGLjD8T8w==
X-Received: by 2002:a05:600c:3509:b0:3cf:93de:14e8 with SMTP id h9-20020a05600c350900b003cf93de14e8mr47958079wmq.39.1673341794186;
        Tue, 10 Jan 2023 01:09:54 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c4fcb00b003c6f3f6675bsm20163165wmq.26.2023.01.10.01.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 01:09:53 -0800 (PST)
Date:   Tue, 10 Jan 2023 10:09:51 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        sujuan.chen@mediatek.com, daniel@makrotopia.org
Subject: Re: [PATCH net-next] net: ethernet: mtk_wed: get rid of queue lock
 for rx queue
Message-ID: <Y70rX3Nzi7A6y0Lr@lore-desk>
References: <bff65ff7f9a269b8a066cae0095b798ad5b37065.1673102426.git.lorenzo@kernel.org>
 <be4814483f1b320eaaa49ba8d59d81b2a51f932b.camel@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oc5Qg6t9czEUtuGn"
Content-Disposition: inline
In-Reply-To: <be4814483f1b320eaaa49ba8d59d81b2a51f932b.camel@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--oc5Qg6t9czEUtuGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, 2023-01-07 at 15:41 +0100, Lorenzo Bianconi wrote:
> > mtk_wed_wo_queue_rx_clean and mtk_wed_wo_queue_refill routines can't run
> > concurrently so get rid of spinlock for rx queues.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> My understanding is that mtk_wed_wo_queue_refill will only be called
> during init and by the tasklet. The mtk_wed_wo_queue_rx_clean function
> is only called during deinit and only after the tasklet has been
> disabled. That is the reason they cannot run at the same time correct?

correct

>=20
> It would be nice if you explained why they couldn't run concurrently
> rather than just stating it is so in the patch description. It makes it
> easier to verify assumptions that way. Otherwise the patch itself looks
> good to me.

ack, right. I will update the commit message in v2.

Regards,
Lorenzo

>=20
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
>=20

--oc5Qg6t9czEUtuGn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY70rXwAKCRA6cBh0uS2t
rOYNAQC8RwM53XJbQCS3gJbTqtlXnqh7biLj9QoJoMRpi83CagD+OeW7phaQRt4B
faiNku9mCM4L2h8ZhsdKw2gfn81ubwU=
=BQ0w
-----END PGP SIGNATURE-----

--oc5Qg6t9czEUtuGn--

