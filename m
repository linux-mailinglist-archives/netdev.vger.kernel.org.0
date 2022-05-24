Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 660B55323AF
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 09:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbiEXHJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 03:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbiEXHJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 03:09:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C35787227
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653376153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Jg/VQp3/7T8NXHS/IRW4J+wxsI4fOnWx/NzDoP4bWw=;
        b=Xvo8VQy8os2gj/QGJ1mq6DDqrGJ1m47J4afzzKhWMnsVPhBI4ZLUT/Cfo8ewJfRKtsPmvk
        6DGdPdb2PYaBlwI53HutalWaCMoGPRrgUl9XwiLG1w0FGhWZWiEnGpL8cOQuhWxqJ5CkgK
        0WBc886IjtyK+WvYi2OEQzOXvXhPPD0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-159-jyf3rvybOk6m9bcZLqoZSA-1; Tue, 24 May 2022 03:09:12 -0400
X-MC-Unique: jyf3rvybOk6m9bcZLqoZSA-1
Received: by mail-qt1-f197.google.com with SMTP id 4-20020ac85944000000b002f935868212so3924424qtz.1
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 00:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4Jg/VQp3/7T8NXHS/IRW4J+wxsI4fOnWx/NzDoP4bWw=;
        b=CYohnvX/aeeMosVUHQ2umX4Y06I1TFkf2o5IXUaddmpf9MtutOkoy8lp/b6kuatrOF
         bagN3rutxJxLw6y1AIBmwwQh9qxi91hcRjl7TvUjmulyFT6x6NQZu9GwLX/FvADn2R0g
         g4ApYsSjRcr4de9D8fx0g2yHA5bKIYWXjrgwEJpWrBd1TyWBgfpv7K81qLcexlJDVSCI
         TJ/3XPUgwthrutCyVcDs4eSUowfZI419+4ZHilo0ZBAeOThqMR3n7qUgzAsR0PK1aRXi
         Uu4RQePfNuCDshcSxDeDhotoyITBNUptYx8TKE/cjBNAj0wKtODcJbHMEDeINYWE4PF9
         6VFw==
X-Gm-Message-State: AOAM532bJEaU/QtMGufS1BaEpEB04RV7DVmxQemyrwr2ApGsBmAkJ39r
        bfxKC6gV1iJbIJNvgf4xdqEkbkEnw6Fhk7tzlvW+Rf4KgnXJ4OYc+VL6w/d9lNHkBHh9gvpkWRT
        CmcZY5ov+Qz1jqV1+
X-Received: by 2002:a05:6214:194e:b0:45a:d8e3:2d3f with SMTP id q14-20020a056214194e00b0045ad8e32d3fmr19980113qvk.59.1653376151735;
        Tue, 24 May 2022 00:09:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7GaMbEtJARwuaEZHhi6Q4+UwgAVZKJMVkhQCWvjA6aMpUiA710enlZjHGU7oXX2vN4IPk8A==
X-Received: by 2002:a05:6214:194e:b0:45a:d8e3:2d3f with SMTP id q14-20020a056214194e00b0045ad8e32d3fmr19980097qvk.59.1653376151522;
        Tue, 24 May 2022 00:09:11 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id bs40-20020a05620a472800b006a34918ea64sm6589755qkb.98.2022.05.24.00.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 00:09:10 -0700 (PDT)
Date:   Tue, 24 May 2022 09:09:00 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Longpeng <longpeng2@huawei.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>, dinang@xilinx.com,
        Eli Cohen <elic@nvidia.com>,
        Laurent Vivier <lvivier@redhat.com>, pabloc@xilinx.com,
        "Dawar, Gautam" <gautam.dawar@amd.com>,
        Xie Yongji <xieyongji@bytedance.com>, habetsm.xilinx@gmail.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        tanuj.kamde@amd.com, Wu Zongyong <wuzongyong@linux.alibaba.com>,
        martinpo@xilinx.com, Cindy Lu <lulu@redhat.com>,
        ecree.xilinx@gmail.com, Parav Pandit <parav@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Zhang Min <zhang.min9@zte.com.cn>
Subject: Re: [PATCH 1/4] vdpa: Add stop operation
Message-ID: <20220524070900.ak7a5frwtezjhhrq@sgarzare-redhat>
References: <20220520172325.980884-1-eperezma@redhat.com>
 <20220520172325.980884-2-eperezma@redhat.com>
 <79089dc4-07c4-369b-826c-1c6e12edcaff@oracle.com>
 <CAJaqyWd3BqZfmJv+eBYOGRwNz3OhNKjvHPiFOafSjzAnRMA_tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWd3BqZfmJv+eBYOGRwNz3OhNKjvHPiFOafSjzAnRMA_tQ@mail.gmail.com>
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 09:20:14PM +0200, Eugenio Perez Martin wrote:
>On Sat, May 21, 2022 at 12:13 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>>
>>
>>
>> On 5/20/2022 10:23 AM, Eugenio Pérez wrote:
>> > This operation is optional: It it's not implemented, backend feature bit
>> > will not be exposed.
>> >
>> > Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>> > ---
>> >   include/linux/vdpa.h | 6 ++++++
>> >   1 file changed, 6 insertions(+)
>> >
>> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
>> > index 15af802d41c4..ddfebc4e1e01 100644
>> > --- a/include/linux/vdpa.h
>> > +++ b/include/linux/vdpa.h
>> > @@ -215,6 +215,11 @@ struct vdpa_map_file {
>> >    * @reset:                  Reset device
>> >    *                          @vdev: vdpa device
>> >    *                          Returns integer: success (0) or error (< 0)
>> > + * @stop:                    Stop or resume the device (optional, but it must
>> > + *                           be implemented if require device stop)
>> > + *                           @vdev: vdpa device
>> > + *                           @stop: stop (true), not stop (false)
>> > + *                           Returns integer: success (0) or error (< 0)
>> Is this uAPI meant to address all use cases described in the full blown
>> _F_STOP virtio spec proposal, such as:
>>
>> --------------%<--------------
>>
>> ...... the device MUST finish any in flight
>> operations after the driver writes STOP.  Depending on the device, it
>> can do it
>> in many ways as long as the driver can recover its normal operation 
>> if it
>> resumes the device without the need of resetting it:
>>
>> - Drain and wait for the completion of all pending requests until a
>>    convenient avail descriptor. Ignore any other posterior descriptor.
>> - Return a device-specific failure for these descriptors, so the driver
>>    can choose to retry or to cancel them.
>> - Mark them as done even if they are not, if the kind of device can
>>    assume to lose them.
>> --------------%<--------------
>>
>
>Right, this is totally underspecified in this series.
>
>I'll expand on it in the next version, but that text proposed to
>virtio-comment was complicated and misleading. I find better to get
>the previous version description. Would the next description work?
>
>```
>After the return of ioctl, the device MUST finish any pending operations like
>in flight requests. It must also preserve all the necessary state (the
>virtqueue vring base plus the possible device specific states) that is required
>for restoring in the future.

For block devices wait for all in-flight requests could take several 
time.

Could this be a problem if the caller gets stuck on this ioctl?

If it could be a problem, maybe we should use an eventfd to signal that 
the device is successfully stopped.

Thanks,
Stefano

