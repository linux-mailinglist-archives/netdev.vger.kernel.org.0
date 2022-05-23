Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77282530BD1
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 11:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiEWIFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 04:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbiEWIFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 04:05:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 49FB813D79
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653293132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8QLANUHtDg5rHNyWxynKoLNYEwqZOoBZvZfmfqTfF5U=;
        b=ERnm43wjE/Z9Udbj6uZDDlU0C3mdVUV2+pe9H2+qefn1HKIJ7Jg7b19NKz7oSzouUj3BdW
        J5CNHrSvnYaL9JYRe9btIdN4Q57X9RdsvZttxx2hQZtGXgm0OIhwqOfw3IdF19lFw7hX2w
        7jKFtYX6KW9ESTkUCvqnfzBC6jxCTPE=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-OW8Eyxm1MCCmc8kT-9fpuA-1; Mon, 23 May 2022 04:05:30 -0400
X-MC-Unique: OW8Eyxm1MCCmc8kT-9fpuA-1
Received: by mail-io1-f71.google.com with SMTP id g16-20020a05660226d000b00638d8e1828bso7740762ioo.13
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 01:05:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=8QLANUHtDg5rHNyWxynKoLNYEwqZOoBZvZfmfqTfF5U=;
        b=i85Inf5B/uvliiu6tcSlHuKja1FM9fxpgmbhuRrc9dlSfzYb64pKu0BkLiJj9SdH2A
         lZOK/vE0JxgCiQVqcbxsnfTnZ7+wR71r1/I/dZRkiTnYCWfbq4zt5rWVQEYAZzJiCKNK
         sI+Uf2VELXBYt8CnlkrhGlQD3rplxo4luul1U48C80LK9L8wuKF5pAioYb1vOHWtPcHC
         4/ybbgpgOx/FTZ75fJjhECBQ6FKwKjY444P41nr+G1DeEYdIloUk+oG1d8Bk2ohBcR62
         ij75NfUocA18bP8Vhq3Enw32zi0n71sJQnOJ1KzZBTsPqxr3pTQhLgPREE0RDwjDEmlc
         mL8w==
X-Gm-Message-State: AOAM5326sczA3KlW2xEup/jop+bGGeQxdoGdfBHVORTproUPtfkSODOB
        VhHEOwq6jqZ4bZs6d8Y0bCKyyW99z1wed1TXirSNrlccspX6QLuE9T/LleH5nQfDxXJ/jPC6ljK
        RucBfWV5tURRr8n60NdireMq7urZAfgLt
X-Received: by 2002:a05:6e02:1a4a:b0:2d1:b139:ba20 with SMTP id u10-20020a056e021a4a00b002d1b139ba20mr1255350ilv.43.1653293129852;
        Mon, 23 May 2022 01:05:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEyy9DnP6sipto/ed4zCVgu0nEvyozIAYrVIJLHK25qBlEJlSQJ7A7S7OawRWXi3cAIJRmxutknu8pebK/AcY=
X-Received: by 2002:a05:6e02:1a4a:b0:2d1:b139:ba20 with SMTP id
 u10-20020a056e021a4a00b002d1b139ba20mr1255340ilv.43.1653293129549; Mon, 23
 May 2022 01:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220511103604.37962-1-ihuguet@redhat.com> <20220511103604.37962-3-ihuguet@redhat.com>
 <20220513080216.liqtvnu3twnmvrtu@gmail.com>
In-Reply-To: <20220513080216.liqtvnu3twnmvrtu@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Mon, 23 May 2022 10:05:18 +0200
Message-ID: <CACT4oufhxvHR6x09kkazxXEBpXXjPpzV0k1w6wjh0hT3zfzyUw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] sfc: simplify mtd partitions list handling
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        bhutchings@solarflare.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 10:02 AM Martin Habets <habetsm.xilinx@gmail.com> w=
rote:
>
> On Wed, May 11, 2022 at 12:36:04PM +0200, =C3=8D=C3=B1igo Huguet wrote:
> > efx_mtd_partitions are embedded inside efx_mcdi_mtd_partition structs.
> > They contain a list entry that is appended to efx->mtd_list, which is
> > traversed to perform add/remove/rename/etc operations over all
> > efx_mtd_partitions.
> >
> > However, almost all operations done on a efx_mtd_partition asume that i=
t
> > is actually embedded inside an efx_mcdi_mtd_partition, and the
> > deallocation asume that the first member of the list is located at the
> > beginning of the allocated memory.
> >
> > Given all that asumptions, the possibility of having an
> > efx_mtd_partition not embedded in an efx_mcdi_efx_partition doesn't
> > exist. Neither it does the possibility of being in a memory position
> > other the one allocated for the efx_mcdi_mtd_partition array. Also, the=
y
> > never need to be reordered.
> >
> > Given all that, it is better to get rid of the list and use directly th=
e
> > efx_mcdi_mtd_partition array. This shows more clearly how they lay
> > in memory, list traversal is more obvious and it save a small amount
> > of memory on the list nodes.
>
> I like this. Just 1 comment below.

I will prepare a new version, dropping the previous patch

>
> > Signed-off-by: =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
> > ---
> >  drivers/net/ethernet/sfc/ef10.c       | 12 ++++++--
> >  drivers/net/ethernet/sfc/efx.h        |  4 +--
> >  drivers/net/ethernet/sfc/efx_common.c |  3 --
> >  drivers/net/ethernet/sfc/mtd.c        | 42 ++++++++++-----------------
> >  drivers/net/ethernet/sfc/net_driver.h |  9 ++++--
> >  5 files changed, 33 insertions(+), 37 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc=
/ef10.c
> > index 15a229731296..b5284fa529b7 100644
> > --- a/drivers/net/ethernet/sfc/ef10.c
> > +++ b/drivers/net/ethernet/sfc/ef10.c
> > @@ -3584,10 +3584,16 @@ static int efx_ef10_mtd_probe(struct efx_nic *e=
fx)
> >               return 0;
> >       }
> >
> > -     rc =3D efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts)=
);
> > -fail:
> > +     rc =3D efx_mtd_add(efx, parts, n_parts);
> >       if (rc)
> > -             kfree(parts);
> > +             goto fail;
> > +     efx->mcdi_mtd_parts =3D parts;
> > +     efx->n_mcdi_mtd_parts =3D n_parts;
> > +
> > +     return 0;
> > +
> > +fail:
> > +     kfree(parts);
> >       return rc;
> >  }
> >
> > diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/=
efx.h
> > index c05a83da9e44..2ab9ba691b0d 100644
> > --- a/drivers/net/ethernet/sfc/efx.h
> > +++ b/drivers/net/ethernet/sfc/efx.h
> > @@ -181,8 +181,8 @@ void efx_update_sw_stats(struct efx_nic *efx, u64 *=
stats);
> >
> >  /* MTD */
> >  #ifdef CONFIG_SFC_MTD
> > -int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
> > -             size_t n_parts, size_t sizeof_part);
> > +int efx_mtd_add(struct efx_nic *efx, struct efx_mcdi_mtd_partition *pa=
rts,
> > +             size_t n_parts);
> >  static inline int efx_mtd_probe(struct efx_nic *efx)
> >  {
> >       return efx->type->mtd_probe(efx);
> > diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethern=
et/sfc/efx_common.c
> > index f6577e74d6e6..8802790403e9 100644
> > --- a/drivers/net/ethernet/sfc/efx_common.c
> > +++ b/drivers/net/ethernet/sfc/efx_common.c
> > @@ -987,9 +987,6 @@ int efx_init_struct(struct efx_nic *efx,
> >       INIT_LIST_HEAD(&efx->node);
> >       INIT_LIST_HEAD(&efx->secondary_list);
> >       spin_lock_init(&efx->biu_lock);
> > -#ifdef CONFIG_SFC_MTD
> > -     INIT_LIST_HEAD(&efx->mtd_list);
> > -#endif
> >       INIT_WORK(&efx->reset_work, efx_reset_work);
> >       INIT_DELAYED_WORK(&efx->monitor_work, efx_monitor);
> >       efx_selftest_async_init(efx);
> > diff --git a/drivers/net/ethernet/sfc/mtd.c b/drivers/net/ethernet/sfc/=
mtd.c
> > index 273c08e5455f..4d06e8a9a729 100644
> > --- a/drivers/net/ethernet/sfc/mtd.c
> > +++ b/drivers/net/ethernet/sfc/mtd.c
> > @@ -12,6 +12,7 @@
> >
> >  #include "net_driver.h"
> >  #include "efx.h"
> > +#include "mcdi.h"
> >
> >  #define to_efx_mtd_partition(mtd)                            \
> >       container_of(mtd, struct efx_mtd_partition, mtd)
> > @@ -48,18 +49,16 @@ static void efx_mtd_remove_partition(struct efx_mtd=
_partition *part)
> >               ssleep(1);
> >       }
> >       WARN_ON(rc);
> > -     list_del(&part->node);
> >  }
> >
> > -int efx_mtd_add(struct efx_nic *efx, struct efx_mtd_partition *parts,
> > -             size_t n_parts, size_t sizeof_part)
> > +int efx_mtd_add(struct efx_nic *efx, struct efx_mcdi_mtd_partition *pa=
rts,
> > +             size_t n_parts)
> >  {
> >       struct efx_mtd_partition *part;
> >       size_t i;
> >
> >       for (i =3D 0; i < n_parts; i++) {
> > -             part =3D (struct efx_mtd_partition *)((char *)parts +
> > -                                                 i * sizeof_part);
> > +             part =3D &parts[i].common;
> >
> >               part->mtd.writesize =3D 1;
> >
> > @@ -78,47 +77,38 @@ int efx_mtd_add(struct efx_nic *efx, struct efx_mtd=
_partition *parts,
> >
> >               if (mtd_device_register(&part->mtd, NULL, 0))
> >                       goto fail;
> > -
> > -             /* Add to list in order - efx_mtd_remove() depends on thi=
s */
> > -             list_add_tail(&part->node, &efx->mtd_list);
> >       }
> >
> >       return 0;
> >
> >  fail:
> > -     while (i--) {
> > -             part =3D (struct efx_mtd_partition *)((char *)parts +
> > -                                                 i * sizeof_part);
> > -             efx_mtd_remove_partition(part);
> > -     }
> > +     while (i--)
> > +             efx_mtd_remove_partition(&parts[i].common);
> > +
> >       /* Failure is unlikely here, but probably means we're out of memo=
ry */
> >       return -ENOMEM;
> >  }
> >
> >  void efx_mtd_remove(struct efx_nic *efx)
> >  {
> > -     struct efx_mtd_partition *parts, *part, *next;
> > +     int i;
> >
> >       WARN_ON(efx_dev_registered(efx));
> >
> > -     if (list_empty(&efx->mtd_list))
> > -             return;
> > -
> > -     parts =3D list_first_entry(&efx->mtd_list, struct efx_mtd_partiti=
on,
> > -                              node);
> > +     for (i =3D 0; i < efx->n_mcdi_mtd_parts; i++)
> > +             efx_mtd_remove_partition(&efx->mcdi_mtd_parts[i].common);
> >
> > -     list_for_each_entry_safe(part, next, &efx->mtd_list, node)
> > -             efx_mtd_remove_partition(part);
> > -
> > -     kfree(parts);
> > +     kfree(efx->mcdi_mtd_parts);
> > +     efx->mcdi_mtd_parts =3D NULL;
> > +     efx->n_mcdi_mtd_parts =3D 0;
>
> It is safer to first set to NULL/0 before freeing the memory.
> With this sequence bad things can happen if the thread gets descheduled
> right after the kfree.

To prevent this we'd also need to use memory barriers. I don't think
we need them because all usages of these fields are done under the
rtnl lock. I won't apply this change in the new version because I find
it useless, but please explain me the reason if you disagree.

>
> Martin
>
> >  }
> >
> >  void efx_mtd_rename(struct efx_nic *efx)
> >  {
> > -     struct efx_mtd_partition *part;
> > +     int i;
> >
> >       ASSERT_RTNL();
> >
> > -     list_for_each_entry(part, &efx->mtd_list, node)
> > -             efx->type->mtd_rename(part);
> > +     for (i =3D 0; i < efx->n_mcdi_mtd_parts; i++)
> > +             efx->type->mtd_rename(&efx->mcdi_mtd_parts[i].common);
> >  }
> > diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethern=
et/sfc/net_driver.h
> > index 318db906a154..5d20b25b0e82 100644
> > --- a/drivers/net/ethernet/sfc/net_driver.h
> > +++ b/drivers/net/ethernet/sfc/net_driver.h
> > @@ -107,6 +107,8 @@ struct hwtstamp_config;
> >
> >  struct efx_self_tests;
> >
> > +struct efx_mcdi_mtd_partition;
> > +
> >  /**
> >   * struct efx_buffer - A general-purpose DMA buffer
> >   * @addr: host base address of the buffer
> > @@ -865,7 +867,8 @@ enum efx_xdp_tx_queues_mode {
> >   * @irq_zero_count: Number of legacy IRQs seen with queue flags =3D=3D=
 0
> >   * @irq_level: IRQ level/index for IRQs not triggered by an event queu=
e
> >   * @selftest_work: Work item for asynchronous self-test
> > - * @mtd_list: List of MTDs attached to the NIC
> > + * @mcdi_mtd_parts: Array of MTDs attached to the NIC
> > + * @n_mcdi_mtd_parts: Number of MTDs attached to the NIC
> >   * @nic_data: Hardware dependent state
> >   * @mcdi: Management-Controller-to-Driver Interface state
> >   * @mac_lock: MAC access lock. Protects @port_enabled, @phy_mode,
> > @@ -1033,7 +1036,8 @@ struct efx_nic {
> >       struct delayed_work selftest_work;
> >
> >  #ifdef CONFIG_SFC_MTD
> > -     struct list_head mtd_list;
> > +     struct efx_mcdi_mtd_partition *mcdi_mtd_parts;
> > +     unsigned int n_mcdi_mtd_parts;
> >  #endif
> >
> >       void *nic_data;
> > @@ -1134,7 +1138,6 @@ static inline unsigned int efx_port_num(struct ef=
x_nic *efx)
> >  }
> >
> >  struct efx_mtd_partition {
> > -     struct list_head node;
> >       struct mtd_info mtd;
> >       const char *dev_type_name;
> >       const char *type_name;
> > --
> > 2.34.1
>


--=20
=C3=8D=C3=B1igo Huguet

