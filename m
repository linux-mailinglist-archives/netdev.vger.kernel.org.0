Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403466B8768
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 02:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjCNBHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 21:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjCNBHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 21:07:15 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03FCF867F4;
        Mon, 13 Mar 2023 18:07:15 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id rj10so3229644pjb.4;
        Mon, 13 Mar 2023 18:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678756034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ez3+RDUCElUZ3KRWgoEdBjByADecatFijFRc/79Sbd8=;
        b=Lh3Lk9QByLiTuLo0GbHbPZVn42HpHmiteaozRT0nJMQQVGLbaVAi2eMobpNaTsVZe3
         d9wnBoP9JMuU9GxWhdjPqoUSXxnDkgp/BeURM/0bK5kzz2NA2OqQbq93aj9eujgNhQUW
         1zDyp9awqbn0JCUk8fJYBTK5ZcwHenLWgaBllHCJmC0kDIDoZ/xcQNgrxnqnqsFvRQZR
         vc7/r3P2wxDJ3gnqoKuRFxc1PmAKb9BNDUYQXH68gUp+IMDncgLXQwh4wKgiQVGPTFwA
         022sJAaKT615iNoluKulophjUd6ijME5tFgc2HF2Bki2c9IPHtMfZNqssHTigsX9EImW
         G1zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678756034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ez3+RDUCElUZ3KRWgoEdBjByADecatFijFRc/79Sbd8=;
        b=wAAAGzdga146BigToXlgd5i8eD3cXUnQm9I6IYKdNjZ8ZD5wZayB5jiHEaUutoaXzN
         zo+jolzEGn+knT++UYmFPA4VitualO2zPVDc5xAkOrMNA+qCvmq9nIYJZ5wifNglmD6H
         yENGQYkeYB41IMwupvjEns665jj8/52ltm2KHV/oNcLaPFQvgRcRj2KJIn6fp3kzSQNk
         gX+I4PzqM2p8UbNcPME2jnxE2GtS1ZNRsgC9baF3GX9oBzoP3ZdXnVF/ucI/ox0tABMM
         JQTrkyHbg2g74DHZS0DpWGad83H06c/UFZS7HTFK5hkTrnQTlncO1B9GWeEPk/J1yXCx
         b3uA==
X-Gm-Message-State: AO0yUKWa5yoYb74TiNyECLBBxEKbFybL4b0jQTfnZQuqDzzWYFmJaCBA
        mlJ5l2Z0/Oe5aR3UIHckV55VAm92bgifju8nlGc=
X-Google-Smtp-Source: AK7set+7Dne9RAO1VX9WwTYRe18fqrlT8ElHytfewhbt2jQXXfmgBIYK+Qko1oopb9SOpdgJb45wrlveKEPYLdrfn38=
X-Received: by 2002:a17:902:f985:b0:19f:2802:dabb with SMTP id
 ky5-20020a170902f98500b0019f2802dabbmr3287260plb.12.1678756034505; Mon, 13
 Mar 2023 18:07:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230313090002.3308025-1-zyytlz.wz@163.com> <ZA8rDCw+mJmyETEx@localhost.localdomain>
 <20230313143054.538565ac@kernel.org>
In-Reply-To: <20230313143054.538565ac@kernel.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Tue, 14 Mar 2023 09:07:02 +0800
Message-ID: <CAJedcCwXhrkfVOHz-+N=qZxP465JJ0wSJG37ppOAFNfDt0ABqQ@mail.gmail.com>
Subject: Re: [PATCH net v2] 9p/xen : Fix use after free bug in
 xen_9pfs_front_remove due to race condition
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Zheng Wang <zyytlz.wz@163.com>, ericvh@gmail.com,
        lucho@ionkov.net, asmadeus@codewreck.org, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 1395428693sheep@gmail.com,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2023=E5=B9=B43=E6=9C=8814=E6=97=
=A5=E5=91=A8=E4=BA=8C 05:30=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, 13 Mar 2023 14:54:20 +0100 Michal Swiatkowski wrote:
> > > @@ -274,12 +274,17 @@ static const struct xenbus_device_id xen_9pfs_f=
ront_ids[] =3D {
> > >  static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
> > >  {
> > >     int i, j;
> > > +   struct xen_9pfs_dataring *ring =3D NULL;
> > Move it before int i, j to have RCT.
> >
> > >
> > >     write_lock(&xen_9pfs_lock);
> > >     list_del(&priv->list);
> > >     write_unlock(&xen_9pfs_lock);
> > >
> > >     for (i =3D 0; i < priv->num_rings; i++) {
> > > +           /*cancel work*/
> > It isn't needed I think, the function cancel_work_sync() tells everythi=
ng
> > here.
>
> Note that 9p is more storage than networking, so this patch is likely
> to go via a different tree than us.

Sorry I got confused.

Best regards,
Zheng
