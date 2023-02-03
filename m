Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B088689E53
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 16:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjBCPa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 10:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBCPaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 10:30:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE095CDC8
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 07:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675438207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ji+Kr21neMWnHwXdjYIYcfw5LpYaSEJ5KOIkUaSruyE=;
        b=LD24xiw9obvKmdNHN9cCWJghPY25LBezowvL8M6UIGVT8viz8sgELjy29riNcLHSZYF0BR
        kp2OPMITkArfsxDOKKoV8HtmTuKLbbm1aVxU3srltxukJONnvuNGca8YMxY78tWsTEo7jW
        dOXeJ8zRZhyDgCwzBFSz+JczhP90Gno=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-183-LZtb-uDOPPahYPpsQMAE2w-1; Fri, 03 Feb 2023 10:30:05 -0500
X-MC-Unique: LZtb-uDOPPahYPpsQMAE2w-1
Received: by mail-pj1-f72.google.com with SMTP id c8-20020a17090a674800b0022cb9c81fb0so4767288pjm.2
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 07:30:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ji+Kr21neMWnHwXdjYIYcfw5LpYaSEJ5KOIkUaSruyE=;
        b=lLXmoCgKlyuWT5gQ9i1gRoHPcjbYG/8213V2T00q5tyWlj4vYZDbPkEX3Nm3lYDEMs
         ZRj+1fa75pYF4MZrf3enOgFiMvfl8KHe5iqWfkyL3nPdUljuowgGUqsXQYdPJtTHD7IN
         SUSzzjBJlauiTT2p3E6RlesG/AVrAXnQifyvctXaLVhIHi7LsAU0IDZPOJd/un5M2+xT
         b9L5FZQGOW/ISDrkyfOYtyCHhNrGhX8gqkmslwFqw20KLU+Y89RhfEJjttQc/5+rsCSE
         nL9e663ISZaWioqTjbrBZO9Pey+Xh07lAn/py08tSBwW7JBMhEQV3hpD9CUwSIN1geEn
         iPfQ==
X-Gm-Message-State: AO0yUKXNpMOcvu2Yd6/ftV+ZgVy6mNyMJj3Lqz4nL7NQoOYoIwMo3hdH
        l2k8MdJyoqeg7BowYSbbv7clV227eA+qDKwxsuhHtten/3NMtanWXUimyWOEvIoWns/NNwvcU55
        T+02k606HGX/ytbGzg6YHBD9RqsrwS8xh
X-Received: by 2002:a17:903:134e:b0:196:11b4:52b7 with SMTP id jl14-20020a170903134e00b0019611b452b7mr2532617plb.15.1675438204271;
        Fri, 03 Feb 2023 07:30:04 -0800 (PST)
X-Google-Smtp-Source: AK7set9gFtgrAU/4glBUPXqbZjVKDrLTfiX3R+5LSuJAvF0JqOvbPV+aBR8sMndtC5Tas87XZbrFFSHZzNLIwWDz3N4=
X-Received: by 2002:a17:903:134e:b0:196:11b4:52b7 with SMTP id
 jl14-20020a170903134e00b0019611b452b7mr2532613plb.15.1675438203832; Fri, 03
 Feb 2023 07:30:03 -0800 (PST)
MIME-Version: 1.0
References: <20230131160506.47552-1-ihuguet@redhat.com> <20230201080849.10482-1-ihuguet@redhat.com>
 <20230201080849.10482-5-ihuguet@redhat.com> <Y9vEyh8QfDf/6i0i@gmail.com>
In-Reply-To: <Y9vEyh8QfDf/6i0i@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 3 Feb 2023 16:29:52 +0100
Message-ID: <CACT4oucr=HYP3bE6VgXu7GJ1SNyQ9rNfT4hjnN+DS2M+trcS2g@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] sfc: remove expired unicast PTP filters
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, richardcochran@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 2, 2023 at 3:12 PM Martin Habets <habetsm.xilinx@gmail.com> wro=
te:
>
> On Wed, Feb 01, 2023 at 09:08:49AM +0100, =C3=8D=C3=B1igo Huguet wrote:
> > Filters inserted to support unicast PTP mode might become unused after
> > some time, so we need to remove them to avoid accumulating many of them=
.
> >
> > Actually, it would be a very unusual situation that many different
> > addresses are used, normally only a small set of predefined
> > addresses are tried. Anyway, some cleanup is necessary because
> > maintaining old filters forever makes very little sense.
> >
> > Reported-by: Yalin Li <yalli@redhat.com>
> > Signed-off-by: =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
> > ---
> >  drivers/net/ethernet/sfc/ptp.c | 121 +++++++++++++++++++++------------
> >  1 file changed, 77 insertions(+), 44 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/=
ptp.c
> > index a3e827cd84a8..dd46ca6c070e 100644
> > --- a/drivers/net/ethernet/sfc/ptp.c
> > +++ b/drivers/net/ethernet/sfc/ptp.c
> > @@ -75,6 +75,9 @@
> >  /* How long an unmatched event or packet can be held */
> >  #define PKT_EVENT_LIFETIME_MS                10
> >
> > +/* How long unused unicast filters can be held */
> > +#define UCAST_FILTER_EXPIRY_JIFFIES  msecs_to_jiffies(30000)
>
> This seems like something that should be tunable, with this as a
> default value.

Not sure how valuable it would be. The filter is not going to expire
while it's in use, and it will expire 30s (or whatever) after last
usage. If it expires, if used again it's reinserted, with only the
penalty of a MCDI call.

I wouldn't make it tunable, but if you insist, how would you do it?
modparam? Other?

> > +
> >  /* Offsets into PTP packet for identification.  These offsets are from=
 the
> >   * start of the IP header, not the MAC header.  Note that neither PTP =
V1 nor
> >   * PTP V2 permit the use of IPV4 options.
> > @@ -220,6 +223,7 @@ struct efx_ptp_timeset {
> >   * @ether_type: Network protocol of the filter (ETHER_P_IP / ETHER_P_I=
PV6)
> >   * @loc_port: UDP port of the filter (PTP_EVENT_PORT / PTP_GENERAL_POR=
T)
> >   * @loc_host: IPv4/v6 address of the filter
> > + * @expiry: time when the filter expires, in jiffies
> >   * @handle: Handle ID for the MCDI filters table
> >   */
> >  struct efx_ptp_rxfilter {
> > @@ -227,6 +231,7 @@ struct efx_ptp_rxfilter {
> >       __be16 ether_type;
> >       __be16 loc_port;
> >       __be32 loc_host[4];
> > +     unsigned long expiry;
> >       int handle;
> >  };
> >
> > @@ -1320,8 +1325,8 @@ static inline void efx_ptp_process_rx(struct efx_=
nic *efx, struct sk_buff *skb)
> >       local_bh_enable();
> >  }
> >
> > -static bool efx_ptp_filter_exists(struct list_head *ptp_list,
> > -                               struct efx_filter_spec *spec)
> > +static struct efx_ptp_rxfilter *
> > +efx_ptp_find_filter(struct list_head *ptp_list, struct efx_filter_spec=
 *spec)
> >  {
> >       struct efx_ptp_rxfilter *rxfilter;
> >
> > @@ -1329,10 +1334,19 @@ static bool efx_ptp_filter_exists(struct list_h=
ead *ptp_list,
> >               if (rxfilter->ether_type =3D=3D spec->ether_type &&
> >                   rxfilter->loc_port =3D=3D spec->loc_port &&
> >                   !memcmp(rxfilter->loc_host, spec->loc_host, sizeof(sp=
ec->loc_host)))
> > -                     return true;
> > +                     return rxfilter;
> >       }
> >
> > -     return false;
> > +     return NULL;
> > +}
> > +
> > +static inline void efx_ptp_remove_one_filter(struct efx_nic *efx,
> > +                                          struct efx_ptp_rxfilter *rxf=
ilter)
>
> As others noted, don't use inline in .c files.
>
> > +{
> > +     efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
> > +                               rxfilter->handle);
> > +     list_del(&rxfilter->list);
> > +     kfree(rxfilter);
> >  }
> >
> >  static void efx_ptp_remove_filters(struct efx_nic *efx,
> > @@ -1341,10 +1355,7 @@ static void efx_ptp_remove_filters(struct efx_ni=
c *efx,
> >       struct efx_ptp_rxfilter *rxfilter, *tmp;
> >
> >       list_for_each_entry_safe(rxfilter, tmp, ptp_list, list) {
> > -             efx_filter_remove_id_safe(efx, EFX_FILTER_PRI_REQUIRED,
> > -                                       rxfilter->handle);
> > -             list_del(&rxfilter->list);
> > -             kfree(rxfilter);
> > +             efx_ptp_remove_one_filter(efx, rxfilter);
> >       }
> >  }
> >
> > @@ -1358,23 +1369,24 @@ static void efx_ptp_init_filter(struct efx_nic =
*efx,
> >                          efx_rx_queue_index(queue));
> >  }
> >
> > -static int efx_ptp_insert_filter(struct efx_nic *efx,
> > -                              struct list_head *ptp_list,
> > -                              struct efx_filter_spec *spec)
> > +static struct efx_ptp_rxfilter *
> > +efx_ptp_insert_filter(struct efx_nic *efx, struct list_head *ptp_list,
> > +                   struct efx_filter_spec *spec)
>
> This API change and the following ones are all for very little gain,
> they are just do set the new expiry attribute. And in the end the
> pointers all get converted back to an integer return code.
> In stead, just pass expiry as a new argument to efx_ptp_insert_ipv4_filte=
r()
> and efx_ptp_insert_ipv6_filter().
>
> >  {
> >       struct efx_ptp_rxfilter *rxfilter;
> >       int rc;
> >
> > -     if (efx_ptp_filter_exists(ptp_list, spec))
> > -             return 0;
> > +     rxfilter =3D efx_ptp_find_filter(ptp_list, spec);
> > +     if (rxfilter)
> > +             return rxfilter;
> >
> >       rc =3D efx_filter_insert_filter(efx, spec, true);
> >       if (rc < 0)
> > -             return rc;
> > +             return ERR_PTR(rc);
> >
> >       rxfilter =3D kzalloc(sizeof(*rxfilter), GFP_KERNEL);
> >       if (!rxfilter)
> > -             return -ENOMEM;
> > +             return ERR_PTR(-ENOMEM);
> >
> >       rxfilter->handle =3D rc;
> >       rxfilter->ether_type =3D spec->ether_type;
> > @@ -1382,12 +1394,12 @@ static int efx_ptp_insert_filter(struct efx_nic=
 *efx,
> >       memcpy(rxfilter->loc_host, spec->loc_host, sizeof(spec->loc_host)=
);
> >       list_add(&rxfilter->list, ptp_list);
> >
> > -     return 0;
> > +     return rxfilter;
> >  }
> >
> > -static int efx_ptp_insert_ipv4_filter(struct efx_nic *efx,
> > -                                   struct list_head *ptp_list,
> > -                                   __be32 addr, u16 port)
> > +static struct efx_ptp_rxfilter *
> > +efx_ptp_insert_ipv4_filter(struct efx_nic *efx, struct list_head *ptp_=
list,
> > +                        __be32 addr, u16 port)
> >  {
> >       struct efx_filter_spec spec;
> >
> > @@ -1396,9 +1408,9 @@ static int efx_ptp_insert_ipv4_filter(struct efx_=
nic *efx,
> >       return efx_ptp_insert_filter(efx, ptp_list, &spec);
> >  }
> >
> > -static int efx_ptp_insert_ipv6_filter(struct efx_nic *efx,
> > -                                   struct list_head *ptp_list,
> > -                                   struct in6_addr *addr, u16 port)
> > +static struct efx_ptp_rxfilter *
> > +efx_ptp_insert_ipv6_filter(struct efx_nic *efx, struct list_head *ptp_=
list,
> > +                        struct in6_addr *addr, u16 port)
> >  {
> >       struct efx_filter_spec spec;
> >
> > @@ -1407,7 +1419,8 @@ static int efx_ptp_insert_ipv6_filter(struct efx_=
nic *efx,
> >       return efx_ptp_insert_filter(efx, ptp_list, &spec);
> >  }
> >
> > -static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
> > +static struct efx_ptp_rxfilter *
> > +efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
> >  {
> >       const u8 addr[ETH_ALEN] =3D PTP_ADDR_ETHER;
> >       struct efx_filter_spec spec;
> > @@ -1422,7 +1435,7 @@ static int efx_ptp_insert_eth_multicast_filter(st=
ruct efx_nic *efx)
> >  static int efx_ptp_insert_multicast_filters(struct efx_nic *efx)
> >  {
> >       struct efx_ptp_data *ptp =3D efx->ptp_data;
> > -     int rc;
> > +     struct efx_ptp_rxfilter *rc;
> >
> >       if (!ptp->channel || !list_empty(&ptp->rxfilters_mcast))
> >               return 0;
> > @@ -1432,12 +1445,12 @@ static int efx_ptp_insert_multicast_filters(str=
uct efx_nic *efx)
> >        */
> >       rc =3D efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_mcast,
> >                                       htonl(PTP_ADDR_IPV4), PTP_EVENT_P=
ORT);
> > -     if (rc < 0)
> > +     if (IS_ERR(rc))
> >               goto fail;
> >
> >       rc =3D efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_mcast,
> >                                       htonl(PTP_ADDR_IPV4), PTP_GENERAL=
_PORT);
> > -     if (rc < 0)
> > +     if (IS_ERR(rc))
> >               goto fail;
> >
> >       /* if the NIC supports hw timestamps by the MAC, we can support
> > @@ -1448,16 +1461,16 @@ static int efx_ptp_insert_multicast_filters(str=
uct efx_nic *efx)
> >
> >               rc =3D efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_mc=
ast,
> >                                               &ipv6_addr, PTP_EVENT_POR=
T);
> > -             if (rc < 0)
> > +             if (IS_ERR(rc))
> >                       goto fail;
> >
> >               rc =3D efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_mc=
ast,
> >                                               &ipv6_addr, PTP_GENERAL_P=
ORT);
> > -             if (rc < 0)
> > +             if (IS_ERR(rc))
> >                       goto fail;
> >
> >               rc =3D efx_ptp_insert_eth_multicast_filter(efx);
> > -             if (rc < 0)
> > +             if (IS_ERR(rc))
> >                       goto fail;
> >       }
> >
> > @@ -1465,7 +1478,7 @@ static int efx_ptp_insert_multicast_filters(struc=
t efx_nic *efx)
> >
> >  fail:
> >       efx_ptp_remove_filters(efx, &ptp->rxfilters_mcast);
> > -     return rc;
> > +     return PTR_ERR(rc);
> >  }
> >
> >  static bool efx_ptp_valid_unicast_event_pkt(struct sk_buff *skb)
> > @@ -1484,7 +1497,7 @@ static int efx_ptp_insert_unicast_filter(struct e=
fx_nic *efx,
> >                                        struct sk_buff *skb)
> >  {
> >       struct efx_ptp_data *ptp =3D efx->ptp_data;
> > -     int rc;
> > +     struct efx_ptp_rxfilter *rxfilter;
> >
> >       if (!efx_ptp_valid_unicast_event_pkt(skb))
> >               return -EINVAL;
> > @@ -1492,28 +1505,36 @@ static int efx_ptp_insert_unicast_filter(struct=
 efx_nic *efx,
> >       if (skb->protocol =3D=3D htons(ETH_P_IP)) {
> >               __be32 addr =3D ip_hdr(skb)->saddr;
> >
> > -             rc =3D efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_uc=
ast,
> > -                                             addr, PTP_EVENT_PORT);
> > -             if (rc < 0)
> > +             rxfilter =3D efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilt=
ers_ucast,
> > +                                                   addr, PTP_EVENT_POR=
T);
> > +             if (IS_ERR(rxfilter))
> >                       goto fail;
> >
> > -             rc =3D efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_uc=
ast,
> > -                                             addr, PTP_GENERAL_PORT);
> > -             if (rc < 0)
> > +             rxfilter->expiry =3D jiffies + UCAST_FILTER_EXPIRY_JIFFIE=
S;
> > +
> > +             rxfilter =3D efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilt=
ers_ucast,
> > +                                                   addr, PTP_GENERAL_P=
ORT);
> > +             if (IS_ERR(rxfilter))
> >                       goto fail;
> > +
> > +             rxfilter->expiry =3D jiffies + UCAST_FILTER_EXPIRY_JIFFIE=
S;
> >       } else if (efx_ptp_use_mac_tx_timestamps(efx)) {
> >               /* IPv6 PTP only supported by devices with MAC hw timesta=
mp */
> >               struct in6_addr *addr =3D &ipv6_hdr(skb)->saddr;
> >
> > -             rc =3D efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_uc=
ast,
> > -                                             addr, PTP_EVENT_PORT);
> > -             if (rc < 0)
> > +             rxfilter =3D efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilt=
ers_ucast,
> > +                                                   addr, PTP_EVENT_POR=
T);
> > +             if (IS_ERR(rxfilter))
> >                       goto fail;
> >
> > -             rc =3D efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_uc=
ast,
> > -                                             addr, PTP_GENERAL_PORT);
> > -             if (rc < 0)
> > +             rxfilter->expiry =3D jiffies + UCAST_FILTER_EXPIRY_JIFFIE=
S;
> > +
> > +             rxfilter =3D efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilt=
ers_ucast,
> > +                                                   addr, PTP_GENERAL_P=
ORT);
> > +             if (IS_ERR(rxfilter))
> >                       goto fail;
> > +
> > +             rxfilter->expiry =3D jiffies + UCAST_FILTER_EXPIRY_JIFFIE=
S;
> >       } else {
> >               return -EOPNOTSUPP;
> >       }
> > @@ -1522,7 +1543,18 @@ static int efx_ptp_insert_unicast_filter(struct =
efx_nic *efx,
> >
> >  fail:
> >       efx_ptp_remove_filters(efx, &ptp->rxfilters_ucast);
> > -     return rc;
> > +     return PTR_ERR(rxfilter);
> > +}
> > +
> > +static void efx_ptp_drop_expired_unicast_filters(struct efx_nic *efx)
> > +{
> > +     struct efx_ptp_data *ptp =3D efx->ptp_data;
> > +     struct efx_ptp_rxfilter *rxfilter, *tmp;
> > +
> > +     list_for_each_entry_safe(rxfilter, tmp, &ptp->rxfilters_ucast, li=
st) {
> > +             if (time_is_before_jiffies(rxfilter->expiry))
>
> Shouldn't this be time_is_after_jiffies?

No, if time_is_before_jiffies means that jiffies are higher than the
value of expiry, so filter needs to be removed.

>
> > +                     efx_ptp_remove_one_filter(efx, rxfilter);
> > +     }
> >  }
> >
> >  static int efx_ptp_start(struct efx_nic *efx)
> > @@ -1616,6 +1648,7 @@ static void efx_ptp_worker(struct work_struct *wo=
rk)
> >       }
> >
> >       efx_ptp_drop_time_expired_events(efx);
> > +     efx_ptp_drop_expired_unicast_filters(efx);
>
> This grabs locks in efx_mcdi_filter_remove_safe(), which is bad because
> that will delay processing that is done below. So do this at the end of
> the function.
>
> Martin
>
> >
> >       __skb_queue_head_init(&tempq);
> >       efx_ptp_process_events(efx, &tempq);
> > --
> > 2.34.3
>


--=20
=C3=8D=C3=B1igo Huguet

