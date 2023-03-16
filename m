Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8306BCC27
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjCPKMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjCPKMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:12:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1A2B5FEB
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 03:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678961480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eBYYYx6ebaSPMy4LYead5i1f9hXn4823DINswCsrSc8=;
        b=Pqh4h9jblfSfE5EYOlcoggGCvmODNMhQLkCh3rV48bO9eCCX9BNNZYoOgIQceK6kTZxV+s
        NlC8nIAQsAJ2uxCtccq3wpTWo3n0tZ2KCGhETArvkvBUCnX9ydZnADZYbZG8nx2uSoHSwz
        MZggBcObaMWby6C/9RlV/sxHKlecQEc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-60-DSeWHm7yPwK0YdFg1ZULjA-1; Thu, 16 Mar 2023 06:11:19 -0400
X-MC-Unique: DSeWHm7yPwK0YdFg1ZULjA-1
Received: by mail-wr1-f71.google.com with SMTP id y11-20020a056000168b00b002ce179d1b90so173234wrd.23
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 03:11:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678961478;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eBYYYx6ebaSPMy4LYead5i1f9hXn4823DINswCsrSc8=;
        b=ie9bi09wLT+BBuzAJrf/TUvheKjV6csqFwaAxNcQexTaVmFvqLrtSF2hRaYrkmbdH8
         OBs6yzxGHbSnB6FwPZZxd/z+4la3d0CBYcUPylaLAgiyvGfkII6G/Kz9zOaO3glMw06e
         YmZ7/f2wvDeO8/RMxXl3oMSeotqncOgbOSKXtzAOsSY6RoOXuKt2zQUjDrbIZzuX3MsJ
         CizAM5LIM5jyMbqVgxXoGBVRX/pFBIkTVOvJ8TJ4DIGyrXA3bmnqV4FTEkYQs2Uz2jom
         NoLy7RAwC7GLYlJzevBrQTvDXPNf2SstMTs1YW3r+x5WTblrOssCDU7c7STGgcfB575i
         sZ7A==
X-Gm-Message-State: AO0yUKVdw0t2woh37zdCeGwB/65c52+HQ+APF7wuK4gA87RBKUd8wwxT
        Fco+3+nzeh+xCYPuAjYGXWj6xPce3rdUctq38y/R61MPrFP+uGAG3S6FuPQ+aUTmPG/qCZK+Obx
        dWQoB1p6QPazMxP3S
X-Received: by 2002:a05:600c:35cd:b0:3e9:f4c2:b604 with SMTP id r13-20020a05600c35cd00b003e9f4c2b604mr22373473wmq.24.1678961478530;
        Thu, 16 Mar 2023 03:11:18 -0700 (PDT)
X-Google-Smtp-Source: AK7set/Lu433zhP9PilHomJbmSQWYVXOQWWKmTm0C09FAmF8pzNNFzHUbJzlyQH+yr7BXNl3vtwXzw==
X-Received: by 2002:a05:600c:35cd:b0:3e9:f4c2:b604 with SMTP id r13-20020a05600c35cd00b003e9f4c2b604mr22373453wmq.24.1678961478236;
        Thu, 16 Mar 2023 03:11:18 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id o23-20020a05600c511700b003ed29b332b8sm5045142wms.35.2023.03.16.03.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 03:11:17 -0700 (PDT)
Date:   Thu, 16 Mar 2023 11:11:15 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/8] vhost-vdpa: use bind_mm/unbind_mm device callbacks
Message-ID: <CAGxU2F6Pa9Dar0MVvW=qUh0k30pdtbrSy_5u2NuREd8u-id=MA@mail.gmail.com>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-3-sgarzare@redhat.com>
 <CACGkMEttgd82xOxV8WLdSFdfhRLZn68tSaV4APSDh8qXxf4OEw@mail.gmail.com>
 <20230316083122.hliiktgsymrfpozy@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230316083122.hliiktgsymrfpozy@sgarzare-redhat>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 9:31 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Tue, Mar 14, 2023 at 11:48:33AM +0800, Jason Wang wrote:
> >On Thu, Mar 2, 2023 at 7:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >>
> >> When the user call VHOST_SET_OWNER ioctl and the vDPA device
> >> has `use_va` set to true, let's call the bind_mm callback.
> >> In this way we can bind the device to the user address space
> >> and directly use the user VA.
> >>
> >> The unbind_mm callback is called during the release after
> >> stopping the device.
> >>
> >> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> >> ---
> >>
> >> Notes:
> >>     v2:
> >>     - call the new unbind_mm callback during the release [Jason]
> >>     - avoid to call bind_mm callback after the reset, since the device
> >>       is not detaching it now during the reset
> >>
> >>  drivers/vhost/vdpa.c | 30 ++++++++++++++++++++++++++++++
> >>  1 file changed, 30 insertions(+)
> >>
> >> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> >> index dc12dbd5b43b..1ab89fccd825 100644
> >> --- a/drivers/vhost/vdpa.c
> >> +++ b/drivers/vhost/vdpa.c
> >> @@ -219,6 +219,28 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
> >>         return vdpa_reset(vdpa);
> >>  }
> >>
> >> +static long vhost_vdpa_bind_mm(struct vhost_vdpa *v)
> >> +{
> >> +       struct vdpa_device *vdpa = v->vdpa;
> >> +       const struct vdpa_config_ops *ops = vdpa->config;
> >> +
> >> +       if (!vdpa->use_va || !ops->bind_mm)
> >> +               return 0;
> >> +
> >> +       return ops->bind_mm(vdpa, v->vdev.mm);
> >> +}
> >> +
> >> +static void vhost_vdpa_unbind_mm(struct vhost_vdpa *v)
> >> +{
> >> +       struct vdpa_device *vdpa = v->vdpa;
> >> +       const struct vdpa_config_ops *ops = vdpa->config;
> >> +
> >> +       if (!vdpa->use_va || !ops->unbind_mm)
> >> +               return;
> >> +
> >> +       ops->unbind_mm(vdpa);
> >> +}
> >> +
> >>  static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
> >>  {
> >>         struct vdpa_device *vdpa = v->vdpa;
> >> @@ -711,6 +733,13 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
> >>                 break;
> >>         default:
> >>                 r = vhost_dev_ioctl(&v->vdev, cmd, argp);
> >> +               if (!r && cmd == VHOST_SET_OWNER) {
> >> +                       r = vhost_vdpa_bind_mm(v);
> >> +                       if (r) {
> >> +                               vhost_dev_reset_owner(&v->vdev, NULL);
> >> +                               break;
> >> +                       }
> >> +               }
> >
> >Nit: is it better to have a new condition/switch branch instead of
> >putting them under default? (as what vring_ioctl did).
>
> Yep, I agree!
>
> I'll change it.

Or maybe I can simply add `case VHOST_SET_OWNER` on this switch and call
vhost_dev_set_owner() and vhost_vdpa_bind_mm(), I mean something like
this:

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 331d4a718bf6..20250c3418b2 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -731,15 +731,16 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
        case VHOST_VDPA_RESUME:
                r = vhost_vdpa_resume(v);
                break;
+       case VHOST_SET_OWNER:
+               r = vhost_dev_set_owner(d);
+               if (r)
+                       break;
+               r = vhost_vdpa_bind_mm(v);
+               if (r)
+                       vhost_dev_reset_owner(d, NULL);
+               break;
        default:
                r = vhost_dev_ioctl(&v->vdev, cmd, argp);
-               if (!r && cmd == VHOST_SET_OWNER) {
-                       r = vhost_vdpa_bind_mm(v);
-                       if (r) {
-                               vhost_dev_reset_owner(&v->vdev, NULL);
-                               break;
-                       }
-               }
                if (r == -ENOIOCTLCMD)
                        r = vhost_vdpa_vring_ioctl(v, cmd, argp);
                break;

WDYT?

Thanks,
Stefano

