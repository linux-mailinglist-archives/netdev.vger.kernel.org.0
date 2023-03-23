Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78B456C63D7
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCWJkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 05:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjCWJjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:39:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F39136EF
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 02:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679564325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wv8z0Oa+BNXMxQvoR0WkvQh5FJ+53xDgUpA+wdsZMxA=;
        b=J/Jwhw6CiDqSm0hrbSCimBkst8dTClMGBzxT63TJLO+vAQaUzHL2yE14ULkHRMbIQK+ep1
        zeHaXEssyUQJoK3Un0K93YvkeskhMv9hpis9MVy6XATpaP0iDwdIqfz7qL6HVeOAzrJymE
        fIgch21vmnoCUVER4yrOFTfMRkVjsrE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636--jDpCRXoOhWkzB3X_EuDwA-1; Thu, 23 Mar 2023 05:38:43 -0400
X-MC-Unique: -jDpCRXoOhWkzB3X_EuDwA-1
Received: by mail-qv1-f71.google.com with SMTP id f3-20020a0cc303000000b005c9966620daso5967114qvi.4
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 02:38:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679564323;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wv8z0Oa+BNXMxQvoR0WkvQh5FJ+53xDgUpA+wdsZMxA=;
        b=iuEAYpajCVJLy18o74TSo7uRkVU/ZEYqsDk1oHNBTrmeB0SgchkbFOnSwAFqIc7WXX
         6wXyuBdUFUCCTV7PS1KF92FXLuUXxBoNAFp9rG2E88OPqHe6/mZAQBaHbyy6tUjRye6E
         1Q+tFgyOd1M2Outj6IG3yHmy8MRQgOzkC+wiAdatH3pDMCFIFyMqb+WRI0vcZBF4V/ck
         6wNr612LY0kNpGczR0GZOcY+93uo3wXgQE5NaA33+BDfNmFnMfceTKbbTVAd/z0hu5yx
         tfqm+APxXZ6bsQuPHzT4i/Vr/vAS9d7rYWE3gbaODihRKQwFYkEMpWZ7dAf53SUTVQ9g
         Rlcw==
X-Gm-Message-State: AO0yUKX+CKYpieJvHeskCqc0dYaSuOtMGAVe6NPWo+gIibRkWUJ+jhfU
        1+TqyBw8WXLA/vee462fgqhx6qYAZ/i4/GcoNiLVweEKdC6Hx1q3/keKiYouIbrwP+wOPhv2bAj
        4oOd27PCt6Q3n7EiC
X-Received: by 2002:a05:622a:284:b0:3bf:d238:6ca with SMTP id z4-20020a05622a028400b003bfd23806camr8824070qtw.68.1679564323360;
        Thu, 23 Mar 2023 02:38:43 -0700 (PDT)
X-Google-Smtp-Source: AK7set99g4T9mj3o49CpahBOOAtxidRMSqg1u94nbjZpIXaZjWImk48PhBoKMemZZJq1z4EVJUoSbQ==
X-Received: by 2002:a05:622a:284:b0:3bf:d238:6ca with SMTP id z4-20020a05622a028400b003bfd23806camr8824056qtw.68.1679564323068;
        Thu, 23 Mar 2023 02:38:43 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id b21-20020ac85415000000b003995f6513b9sm11310043qtq.95.2023.03.23.02.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 02:38:42 -0700 (PDT)
Date:   Thu, 23 Mar 2023 10:38:37 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/8] vhost-vdpa: use bind_mm/unbind_mm device callbacks
Message-ID: <20230323093837.xdv7wkhzizgnihcy@sgarzare-redhat>
References: <20230321154228.182769-1-sgarzare@redhat.com>
 <20230321154228.182769-3-sgarzare@redhat.com>
 <CACGkMEtq8PWL01WBL2Ve-Yr=ZO+su73tKuOh1EBLagkrLdiCaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtq8PWL01WBL2Ve-Yr=ZO+su73tKuOh1EBLagkrLdiCaQ@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 11:01:39AM +0800, Jason Wang wrote:
>On Tue, Mar 21, 2023 at 11:42 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> When the user call VHOST_SET_OWNER ioctl and the vDPA device
>> has `use_va` set to true, let's call the bind_mm callback.
>> In this way we can bind the device to the user address space
>> and directly use the user VA.
>>
>> The unbind_mm callback is called during the release after
>> stopping the device.
>>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>>
>> Notes:
>>     v3:
>>     - added `case VHOST_SET_OWNER` in vhost_vdpa_unlocked_ioctl() [Jason]
>>     v2:
>>     - call the new unbind_mm callback during the release [Jason]
>>     - avoid to call bind_mm callback after the reset, since the device
>>       is not detaching it now during the reset
>>
>>  drivers/vhost/vdpa.c | 31 +++++++++++++++++++++++++++++++
>>  1 file changed, 31 insertions(+)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 7be9d9d8f01c..20250c3418b2 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -219,6 +219,28 @@ static int vhost_vdpa_reset(struct vhost_vdpa *v)
>>         return vdpa_reset(vdpa);
>>  }
>>
>> +static long vhost_vdpa_bind_mm(struct vhost_vdpa *v)
>> +{
>> +       struct vdpa_device *vdpa = v->vdpa;
>> +       const struct vdpa_config_ops *ops = vdpa->config;
>> +
>> +       if (!vdpa->use_va || !ops->bind_mm)
>> +               return 0;
>> +
>> +       return ops->bind_mm(vdpa, v->vdev.mm);
>> +}
>> +
>> +static void vhost_vdpa_unbind_mm(struct vhost_vdpa *v)
>> +{
>> +       struct vdpa_device *vdpa = v->vdpa;
>> +       const struct vdpa_config_ops *ops = vdpa->config;
>> +
>> +       if (!vdpa->use_va || !ops->unbind_mm)
>> +               return;
>> +
>> +       ops->unbind_mm(vdpa);
>> +}
>> +
>>  static long vhost_vdpa_get_device_id(struct vhost_vdpa *v, u8 __user *argp)
>>  {
>>         struct vdpa_device *vdpa = v->vdpa;
>> @@ -709,6 +731,14 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>         case VHOST_VDPA_RESUME:
>>                 r = vhost_vdpa_resume(v);
>>                 break;
>> +       case VHOST_SET_OWNER:
>> +               r = vhost_dev_set_owner(d);
>
>Nit:
>
>I'd stick to the current way of passing the cmd, argp to
>vhost_dev_ioctl() and introduce a new switch after the
>vhost_dev_ioctl().
>
>In this way, we are immune to any possible changes of dealing with
>VHOST_SET_OWNER in vhost core.

Good point, I'll change in v4.

>
>Others look good.

Thanks,
Stefano

