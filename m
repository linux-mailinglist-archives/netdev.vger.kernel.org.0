Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 233A66EADEF
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 17:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232798AbjDUPWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbjDUPWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:22:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFCFBBB8
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 08:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682090508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bV3+z6rtbbJUMmWirLJPv/yXzRzWHs3phmkvDcxvyeU=;
        b=fVEw+JzzFwdFi1HgsDQnsqlybUib2dlv/Vn9+ybf6H1cbr1Z0aCjPDGCS9VLgjmv/l9iYi
        +04Lv8wlb+qCDxmP7Beb+PV/+WTvxNDwujQCb0oFhIdtkTijoAZXd1cVSuoOeI+Z/gwmXl
        EF9ButPKG3mriK8z7qawxTp5jpVXP/U=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-fkCBMetnPL6b4cTIdnS9UQ-1; Fri, 21 Apr 2023 11:21:46 -0400
X-MC-Unique: fkCBMetnPL6b4cTIdnS9UQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-5ef67855124so1700236d6.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 08:21:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682090506; x=1684682506;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bV3+z6rtbbJUMmWirLJPv/yXzRzWHs3phmkvDcxvyeU=;
        b=XCDRYsmHuyvys5J2Bytlkwu8r+qoq0xJVHXcpN8Syi8/MP0WIR5M9LDQ6qtc66p+um
         dqfXa1nVPNMYRJDHXNdXzGgDg1qZU3zzENmSfEdfd4h54jCle0rh3FIkQMcT9uPvoVB4
         I7mZQXFrQPUQ8blcvuLDAPKlNPLp85ZwNaAuiN0+oIOO9BbsbvD6w51AqA9QWU7Vhidv
         sp1mtwaBWD4h1uJ4lbI51fg+s0u5DYd/tlPNvTECha9atXQqZ1UqQLgmeZeaT5L3QKQO
         1w3bbrg0ggg5mKI3fjX5Vb7NT9TE5gZtFpigOl6k1Bx0Wvmf3lV91f0wS/Mr29Jt33q3
         ZA2g==
X-Gm-Message-State: AAQBX9dx3rClULBpQZN9ex3VLYSqPPZQc1RakUNMIs2UDmF6paJJwRBr
        Wb+9m7CJIJIEYceone47Vpvc/GBNHETfmYOWlOVlvWxYDNQwOCNJSxpTpIpG6AK1h7ANeTKYU3/
        sZuCyUoIk95BViPg7jA7QzvYq
X-Received: by 2002:a05:6214:5195:b0:5aa:14b8:e935 with SMTP id kl21-20020a056214519500b005aa14b8e935mr8350600qvb.2.1682090506073;
        Fri, 21 Apr 2023 08:21:46 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZALuD3Gf10VEvdYkyDYiNugt9bAK1L/C4dhh6hk3ziiEONxcmLeDmczdzViPk/BpBdKClcDw==
X-Received: by 2002:a05:6214:5195:b0:5aa:14b8:e935 with SMTP id kl21-20020a056214519500b005aa14b8e935mr8350571qvb.2.1682090505809;
        Fri, 21 Apr 2023 08:21:45 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-230-170.dyn.eolo.it. [146.241.230.170])
        by smtp.gmail.com with ESMTPSA id x16-20020a0ce250000000b005ef6b124d39sm1245723qvl.5.2023.04.21.08.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 08:21:45 -0700 (PDT)
Message-ID: <cb01d9cacd8631aaf05a22fe7e9a8662ef875ce4.camel@redhat.com>
Subject: Re: [PATCH net-next 5/5] net: optimize napi_threaded_poll() vs
 RPS/RFS
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Date:   Fri, 21 Apr 2023 17:21:42 +0200
In-Reply-To: <CANn89i+94vKLZ9ijgf+vzVcoBV4fNo3z1aF_Djbr-kC65qxzZA@mail.gmail.com>
References: <20230421094357.1693410-1-edumazet@google.com>
         <20230421094357.1693410-6-edumazet@google.com>
         <d84e9f5056c4945cb4cfcc68c89986d3094b95b7.camel@redhat.com>
         <CANn89i+94vKLZ9ijgf+vzVcoBV4fNo3z1aF_Djbr-kC65qxzZA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-04-21 at 16:06 +0200, Eric Dumazet wrote:
> On Fri, Apr 21, 2023 at 3:10=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> w=
rote:
> >=20
> > Hello,
> >=20
> > thank you for the extremely fast turnaround!
> >=20
> > On Fri, 2023-04-21 at 09:43 +0000, Eric Dumazet wrote:
> > > We use napi_threaded_poll() in order to reduce our softirq dependency=
.
> > >=20
> > > We can add a followup of 821eba962d95 ("net: optimize napi_schedule_r=
ps()")
> > > to further remove the need of firing NET_RX_SOFTIRQ whenever
> > > RPS/RFS are used.
> > >=20
> > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > ---
> > >  include/linux/netdevice.h |  3 +++
> > >  net/core/dev.c            | 12 ++++++++++--
> > >  2 files changed, 13 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index a6a3e9457d6cbc9fcbbde96b43b4b21878495403..08fbd4622ccf731daaee3=
4ad99773d6dc2e82fa6 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -3194,7 +3194,10 @@ struct softnet_data {
> > >  #ifdef CONFIG_RPS
> > >       struct softnet_data     *rps_ipi_list;
> > >  #endif
> > > +
> > >       bool                    in_net_rx_action;
> > > +     bool                    in_napi_threaded_poll;
> >=20
> > If I'm correct only one of the above 2 flags can be set to true at any
> > give time. I'm wondering if could use a single flag (possibly with a
> > rename - say 'in_napi_polling')?
>=20
> Well, we can _not_ use the same flag, because we do not want to
> accidentally enable
> the part in ____napi_schedule()

I see, thanks for the pointer.
>=20
> We could use a bit mask with 2 bits, but I am not sure it will help reada=
bility.

Agreed, it's better to use 2 separate bool.

LGTM,

Acked-by: Paolo Abeni <pabeni@redhat.com>

(for pw's sake ;)


