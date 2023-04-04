Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB926D5C1A
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbjDDJnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbjDDJnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:43:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE2CE7C
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 02:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680601339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P8pH4b9mYpT26D1BxXd4yRO46Gp3Xouwz1tQFN4xO9Q=;
        b=eg6ne62T/Ky2Yucfjvc7wm8DHsrge/L1yChjalAgznMDbn7Q1n0wrY440q6nZKR6rjhLNc
        kL5B1zzq3OB9YV1nG8vKMV9vEpRwnc83XG/g9Wnt3OcjD6vRrTOmuLxAC0m8jNCdOncqOt
        14aCRbtAZHTnnQA9hAhQf87C6f+PZwI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-tyUowQ9-M8G7bL5u2PfqoQ-1; Tue, 04 Apr 2023 05:42:18 -0400
X-MC-Unique: tyUowQ9-M8G7bL5u2PfqoQ-1
Received: by mail-qt1-f199.google.com with SMTP id f36-20020a05622a1a2400b003deb2fa544bso21802402qtb.0
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 02:42:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680601338;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P8pH4b9mYpT26D1BxXd4yRO46Gp3Xouwz1tQFN4xO9Q=;
        b=v4qiQ7P5E+1Q+uD7T6JpmjWPuVSbtB/iIMLaXVIah7NbZD3584R3KsdRed0vYllsO4
         wDzh4ApMliRNsuJ+fkzZII/VOo/+K4kZUgQ57dT1jBUzgxKzaVr/CzIOeEFxK8iImM/i
         SDgnz+NkbRkxolVKDAM4SLPhHqvZrVsncrnPCeCXMVttmWLSRSQwLK3dAGx1J3wYBcxh
         0sFi2jpPao9YisIyLRRDQEr4c0p68/tjF1M+tolPGXe+b8nRkHbCR6Xm0iz37I1a1reG
         7IL/99lni/FBdHcm+mCINViXWYsip/AhebyTPUmuJ9HcjpxxkbPcANgRykd6VdRcdnEV
         yDfQ==
X-Gm-Message-State: AAQBX9e9ImzRXycL05+BslXg3/JWP5oxs13puV811OVPFVb6L2z3VL3g
        lHXlS2OLqw/b5bwFG2hIoj2ckmJwTu904Ox9BI0udGu0zwysUBenPKo2HZKegQmk2NePmX4/uTV
        d3xnYEejF8OTOXH5V
X-Received: by 2002:a05:622a:1ba2:b0:3e3:8e1a:c323 with SMTP id bp34-20020a05622a1ba200b003e38e1ac323mr2182793qtb.2.1680601337954;
        Tue, 04 Apr 2023 02:42:17 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZLQ09RG7FPLHzL7MzCGkIJUXpPUia7HAa29j13Vf9b5sIPaUm2VuOpGoPkGcKbqnqtVYXt6g==
X-Received: by 2002:a05:622a:1ba2:b0:3e3:8e1a:c323 with SMTP id bp34-20020a05622a1ba200b003e38e1ac323mr2182785qtb.2.1680601337730;
        Tue, 04 Apr 2023 02:42:17 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-227-151.dyn.eolo.it. [146.241.227.151])
        by smtp.gmail.com with ESMTPSA id z18-20020a376512000000b0074283b87a4esm3465571qkb.90.2023.04.04.02.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 02:42:17 -0700 (PDT)
Message-ID: <aeb75e09bec3e4459c5ade3c1f1149841ecae82c.camel@redhat.com>
Subject: Re: [PATCH] [net] update xdp_statistics in docs
From:   Paolo Abeni <pabeni@redhat.com>
To:     nick black <dankamongmen@gmail.com>, netdev@vger.kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Date:   Tue, 04 Apr 2023 11:42:14 +0200
In-Reply-To: <a5a8791742d1e77d324d91ea6030bc9647c61148.camel@redhat.com>
References: <20230402084120.3041477-1-dankamongmen@gmail.com>
         <a5a8791742d1e77d324d91ea6030bc9647c61148.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-04-04 at 11:35 +0200, Paolo Abeni wrote:
> On Sun, 2023-04-02 at 04:41 -0400, nick black wrote:
> > Add the three fields from xdp_statistics that were
> > missing in the AF_XDP documentation.
> >=20
> > Signed-off-by: nick black <dankamongmen@gmail.com>
>=20
> I think this kind of changes are best suited for net-next, please set
> the target tree accordingly in next submissions.
>=20
> > ---
> >  Documentation/networking/af_xdp.rst | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git Documentation/networking/af_xdp.rst Documentation/networking=
/af_xdp.rst
> > index 247c6c4127e9..a968de7e902c 100644
> > --- Documentation/networking/af_xdp.rst
> > +++ Documentation/networking/af_xdp.rst
>=20
> There is something strange in your setup, the above should be:
>=20
> --- a/Documentation/networking/af_xdp.rst
> +++ b/Documentation/networking/af_xdp.rst
>=20
> The format you used confuses my scripts. I handled this one manually,
> but please update your setup to stick to the standard layout.

I almost forgot: you should include into the subject a tag identifying
the relevant subsystem/networking area. In this case, a proper subject
could be:

net: doc: update xdp_statistics in docs

Given all the above I think is better if you re-submit addressing my
comments. You can retain Magnus's ack.

Thanks!

Paolo

