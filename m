Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FA7539B52
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 04:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiFACmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 22:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233771AbiFACmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 22:42:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B26A15A5B2
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 19:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654051346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WB1eoNVPIkOVFlU558AybWrSuZCEkhfGeXbR5VK67Ks=;
        b=cp5ti+U9KkHxTKvdWu3ggcai7OpXHkwqSGOKQtXm1ubnuL5JfDtm8M9ekhrf3Uw19zcxTF
        JjAgh5zMSFITI2HjfLxI034bbGr4tTevSd9q7eCEETk3+cgOSpTeyAsCDShSyZzXxhz6e+
        wHIpLgpsI6XGfDPTjVev6hDwVAsK+/g=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-bNZi41GcP7mUxq2nQX5IVA-1; Tue, 31 May 2022 22:42:25 -0400
X-MC-Unique: bNZi41GcP7mUxq2nQX5IVA-1
Received: by mail-lf1-f71.google.com with SMTP id k6-20020a0565123d8600b0047863fc54b9so203305lfv.16
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 19:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WB1eoNVPIkOVFlU558AybWrSuZCEkhfGeXbR5VK67Ks=;
        b=AfmdwRwqd3YTiKzmgeGHot0SCgjT0LE2rRdzdOpaWZi8hy/1CmORjeZSzKgZlosXI/
         UzgNB8PaCSYyWQW/7j8Gi5ke4QxtcSkBy/YUxEWowOvH9DSoFJlxr6lNKL46y8xco5ME
         CbtsBfFLHbqfBNRKFPLocM+4KddZU+0ZIF+AhD+Dv5obqXBRrdQHrK4+VkzbU8hD4nkj
         1J5+3R/gy8TFW7vUEVk01CSi5NA3W1kkgvPriv7eD1+B0+q+DVEWGZJTxkl6HZHSiAQT
         St5Wo0mA0Kxv4KHB+Z/PWwp0rnq4UqTJtztIyIYbzgJIs8/tNhlzVOQ6HRqio0FYmU5a
         CoqQ==
X-Gm-Message-State: AOAM530KLmWb67mU/C63J4krIdd2/dATtB0TjswIhfeLJYZ1h5HXyBg4
        R5urm2Zr2LhiAcTFXg/UGVK46qbQ3mmkpYjvFYBVCvDhkF+R7NeOe2dofx2IQSRhOVsMYj+CvEf
        sjq8dQHhI4NzGLzk9Tr5p91VxvuULKUlv
X-Received: by 2002:a05:6512:c0e:b0:478:5a91:20bb with SMTP id z14-20020a0565120c0e00b004785a9120bbmr39100826lfu.587.1654051344023;
        Tue, 31 May 2022 19:42:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxmBp820NSJHDcSD2dOZzrKRPNlKlD6GwXH3X8zApWh8utE/CuOZMV9CsZAbAB4NHKmtcInCEEIporstHBP+gc=
X-Received: by 2002:a05:6512:c0e:b0:478:5a91:20bb with SMTP id
 z14-20020a0565120c0e00b004785a9120bbmr39100798lfu.587.1654051343791; Tue, 31
 May 2022 19:42:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220526124338.36247-1-eperezma@redhat.com> <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220527065442-mutt-send-email-mst@kernel.org> <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
 <PH0PR12MB5481695930E7548BAAF1B0D9DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481695930E7548BAAF1B0D9DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 1 Jun 2022 10:42:12 +0800
Message-ID: <CACGkMEsSKF_MyLgFdzVROptS3PCcp1y865znLWgnzq9L7CpFVQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Implement vdpasim stop operation
To:     Parav Pandit <parav@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 1, 2022 at 4:19 AM Parav Pandit <parav@nvidia.com> wrote:
>
>
> > From: Jason Wang <jasowang@redhat.com>
> > Sent: Sunday, May 29, 2022 11:39 PM
> >
> > On Fri, May 27, 2022 at 6:56 PM Michael S. Tsirkin <mst@redhat.com> wro=
te:
> > >
> > > On Thu, May 26, 2022 at 12:54:32PM +0000, Parav Pandit wrote:
> > > >
> > > >
> > > > > From: Eugenio P=C3=A9rez <eperezma@redhat.com>
> > > > > Sent: Thursday, May 26, 2022 8:44 AM
> > > >
> > > > > Implement stop operation for vdpa_sim devices, so vhost-vdpa will
> > > > > offer
> > > > >
> > > > > that backend feature and userspace can effectively stop the devic=
e.
> > > > >
> > > > >
> > > > >
> > > > > This is a must before get virtqueue indexes (base) for live
> > > > > migration,
> > > > >
> > > > > since the device could modify them after userland gets them. Ther=
e
> > > > > are
> > > > >
> > > > > individual ways to perform that action for some devices
> > > > >
> > > > > (VHOST_NET_SET_BACKEND, VHOST_VSOCK_SET_RUNNING, ...) but
> > there
> > > > > was no
> > > > >
> > > > > way to perform it for any vhost device (and, in particular, vhost=
-vdpa).
> > > > >
> > > > >
> > > > >
> > > > > After the return of ioctl with stop !=3D 0, the device MUST finis=
h
> > > > > any
> > > > >
> > > > > pending operations like in flight requests. It must also preserve
> > > > > all
> > > > >
> > > > > the necessary state (the virtqueue vring base plus the possible
> > > > > device
> > > > >
> > > > > specific states) that is required for restoring in the future. Th=
e
> > > > >
> > > > > device must not change its configuration after that point.
> > > > >
> > > > >
> > > > >
> > > > > After the return of ioctl with stop =3D=3D 0, the device can cont=
inue
> > > > >
> > > > > processing buffers as long as typical conditions are met (vq is
> > > > > enabled,
> > > > >
> > > > > DRIVER_OK status bit is enabled, etc).
> > > >
> > > > Just to be clear, we are adding vdpa level new ioctl() that doesn=
=E2=80=99t map to
> > any mechanism in the virtio spec.
> > > >
> > > > Why can't we use this ioctl() to indicate driver to start/stop the =
device
> > instead of driving it through the driver_ok?
> > > > This is in the context of other discussion we had in the LM series.
> > >
> > > If there's something in the spec that does this then let's use that.
> >
> > Actually, we try to propose a independent feature here:
> >
> > https://lists.oasis-open.org/archives/virtio-dev/202111/msg00020.html
> >
> This will stop the device for all the operations.

Well, the ability to query the virtqueue state was proposed as another
feature (Eugenio, please correct me). This should be sufficient for
making virtio-net to be live migrated.

https://lists.oasis-open.org/archives/virtio-comment/202103/msg00008.html

> Once the device is stopped, its state cannot be queried further as device=
 won't respond.
> It has limited use case.
> What we need is to stop non admin queue related portion of the device.

See above.

Thanks

>
> > Does it make sense to you?
> >
> > Thanks
> >
> > > Unfortunately the LM series seems to be stuck on moving bits around
> > > with the admin virtqueue ...
> > >
> > > --
> > > MST
> > >
>

