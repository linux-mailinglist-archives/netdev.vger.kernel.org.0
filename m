Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6784B6B79D0
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjCMOCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjCMOCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:02:12 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ED27041B;
        Mon, 13 Mar 2023 07:01:34 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u5so13033514plq.7;
        Mon, 13 Mar 2023 07:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678716093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xqxxP+NmXLp8umJHs6SnxZxdSNjdtg4YX/6KjcEE3WY=;
        b=V69HZWslPHyyyl7CN1Zbwb3h5Vu/x7rPAeqzyyr03nJOhQCLh0Q6Q6mfjVwMf5XiCv
         Gt8ehRPBpCDvMbzdWlYM7W/ZjQrb96PnbKONR8GMvqt/vcZk24b7Q/Zw9UxUmDTOoCGm
         mziI+x4jS1t1jRSk2dTGimraXG7gtfOwp4XbcORHo22xbHqknRSD0WDU9CtLgVdHcGMq
         tjyHR1Mp/rMOt+oUSoTCp7wRqhVPNO8Gc4o6Rgdei71IOHPsFnI8YbccrRGjfrFMOsgk
         H02WR5TN4NQAk0m7QTCNudm1SNWxRtDZg+O8wmQSA9SRnNZUZaSXNBn2G5gUPGmEVnZI
         AXhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678716093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xqxxP+NmXLp8umJHs6SnxZxdSNjdtg4YX/6KjcEE3WY=;
        b=cvC0Q3WTNhsWzNACAUj4/Wz5ujziiJIzunNcf+SrzoK0Idi1bzZXDLtPhuJE1Wrm2a
         5M3oul6T5+MUf22mxKTru4vbtzTSVquSMXwEPGOX1myzgShJUWgiBAMGfPlmD8Yd4VF0
         8MVUjeqm44+JTtdRowxz1qE0YzPbvb876CnCpBgFbAr0gzu0DJdyr5Rd7vpA+VhMwED1
         AC2K8yRbElcM+aQW91jhfJqfs1SNukrYPq8FMvktFJ/qQfU/PCwZlSbBsU5Vzrz1r5+/
         +6mo4HVXV3E28Bhw+2jn2EA5QI4lRP4oyfZcSelvaKX+5BlSeSR7DlsqTMj0E0NUrsyn
         emuA==
X-Gm-Message-State: AO0yUKVQtUcbGVKD+9Q/ajxH2WsqKu30uK6Nm8IG9cEeM5CiGlo2dT4D
        mbI30ZdIfjdmyFtTT1XDP2PuDs509AfVBo6yDj0=
X-Google-Smtp-Source: AK7set93wvcJ2lqVoJK9m9f5Ty8L6w8MePLZRLCU6iIxSR5R10O+/E1J/u3z+VonBCSK40kBB5W6s5V5FerEQx0wL7M=
X-Received: by 2002:a17:903:3410:b0:19f:3cc1:e3c3 with SMTP id
 ke16-20020a170903341000b0019f3cc1e3c3mr1852337plb.12.1678716092879; Mon, 13
 Mar 2023 07:01:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230313090002.3308025-1-zyytlz.wz@163.com> <ZA8rDCw+mJmyETEx@localhost.localdomain>
In-Reply-To: <ZA8rDCw+mJmyETEx@localhost.localdomain>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Mon, 13 Mar 2023 22:01:21 +0800
Message-ID: <CAJedcCwgvo3meC=k_nPYrRzEj7Hzcy8kqrvHqHLvmPWLjCq_3Q@mail.gmail.com>
Subject: Re: [PATCH net v2] 9p/xen : Fix use after free bug in
 xen_9pfs_front_remove due to race condition
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, ericvh@gmail.com, lucho@ionkov.net,
        asmadeus@codewreck.org, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        1395428693sheep@gmail.com, alex000young@gmail.com
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

Michal Swiatkowski <michal.swiatkowski@linux.intel.com> =E4=BA=8E2023=E5=B9=
=B43=E6=9C=8813=E6=97=A5=E5=91=A8=E4=B8=80 21:54=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Mar 13, 2023 at 05:00:02PM +0800, Zheng Wang wrote:
> > In xen_9pfs_front_probe, it calls xen_9pfs_front_alloc_dataring
> > to init priv->rings and bound &ring->work with p9_xen_response.
> >
> > When it calls xen_9pfs_front_event_handler to handle IRQ requests,
> > it will finally call schedule_work to start the work.
> >
> > When we call xen_9pfs_front_remove to remove the driver, there
> > may be a sequence as follows:
> >
> > Fix it by finishing the work before cleanup in xen_9pfs_front_free.
> >
> > Note that, this bug is found by static analysis, which might be
> > false positive.
> >
> > CPU0                  CPU1
> >
> >                      |p9_xen_response
> > xen_9pfs_front_remove|
> >   xen_9pfs_front_free|
> > kfree(priv)          |
> > //free priv          |
> >                      |p9_tag_lookup
> >                      |//use priv->client
> >
> > Fixes: 71ebd71921e4 ("xen/9pfs: connect to the backend")
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > ---
> > v2:
> > - fix type error of ring found by kernel test robot
> > ---
> >  net/9p/trans_xen.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
> > index c64050e839ac..83764431c066 100644
> > --- a/net/9p/trans_xen.c
> > +++ b/net/9p/trans_xen.c
> > @@ -274,12 +274,17 @@ static const struct xenbus_device_id xen_9pfs_fro=
nt_ids[] =3D {
> >  static void xen_9pfs_front_free(struct xen_9pfs_front_priv *priv)
> >  {
> >       int i, j;
> > +     struct xen_9pfs_dataring *ring =3D NULL;
> Move it before int i, j to have RCT.
>
> >
> >       write_lock(&xen_9pfs_lock);
> >       list_del(&priv->list);
> >       write_unlock(&xen_9pfs_lock);
> >
> >       for (i =3D 0; i < priv->num_rings; i++) {
> > +             /*cancel work*/
> It isn't needed I think, the function cancel_work_sync() tells everything
> here.
>

Get it, will remove it in the next version of patch.

Best regards,
Zheng
