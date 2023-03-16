Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79BA6BC934
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjCPIcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjCPIca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:32:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A285D8B9
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678955488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/1UEGyWZZrbvStEgLaSVShuWDRxe0yPRa+3kY6NxaI=;
        b=IYJprkW1OtGCrEF2tI/Z48yXTIZTz1RV8Ys1KgziE+F6Spy8wYk5KyvU/G00TEf+LSxOi6
        EoDiEYpSUsvIZji2VjKObgxeUmt9QR+Q1/ZPsz8OW5VoMTSCT0uTuP0Yg9mLypM4BGZWSR
        urjd+943k1XIGiGc1s8dDiFSomMDxc4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-vbBx4kBwMn-NzNk1A44IPQ-1; Thu, 16 Mar 2023 04:31:27 -0400
X-MC-Unique: vbBx4kBwMn-NzNk1A44IPQ-1
Received: by mail-wr1-f70.google.com with SMTP id 7-20020a5d47a7000000b002be0eb97f4fso119541wrb.8
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:31:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678955486;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X/1UEGyWZZrbvStEgLaSVShuWDRxe0yPRa+3kY6NxaI=;
        b=iVELUvDAQAMjcnfPXcFW3+3wwmvYZW7HOb3hR2ECWQbITiHCdV0eUAQ6/PtBNUICiv
         t2iJnh0m1SV1iqTqQFy40C7IjhjQJvLj9rrwHQ9lZbPgMyUsbHxQ/YY/UfL1uSGUVtLU
         4Gft+qikf7kOxoEiOS7rl13feAzEXrk80WkLhwKc1eAxOP3QwwIV4kinIU7ewUUXRPeJ
         +npbsljCHlcMFOf9Nkacz04i7OXEou4I9AOXvDzVv+kznkYur1xF7pUSCAR+4rXip3cF
         u6Lh4OFtWbeHkD2rxCO/hkHrrLJKAqE5WuqaG5MtFw63jIom6jndDY7U52IzuOMDvvRi
         qyaA==
X-Gm-Message-State: AO0yUKUUkHwi5wX75erZdNu4sFCgFCiRmiJYFK+oBxTUCMwso8DHiIyV
        rCwqc1eM4qnvMP+/2nHpNfSN5VNIZk5poYeX6R4+H7+Lr07fTCCe+3f3XN3WXUVqJv9yh86LbMG
        9OdJGSBw5Z8qYpc2D
X-Received: by 2002:a5d:5955:0:b0:2cf:e29f:d7f5 with SMTP id e21-20020a5d5955000000b002cfe29fd7f5mr3576303wri.25.1678955486052;
        Thu, 16 Mar 2023 01:31:26 -0700 (PDT)
X-Google-Smtp-Source: AK7set8XgT/fkEa6oyHpuwgit2NX40Fpv+7C8AxfojZlS6SqwfkBRFQgzp3vx+Buq6H4mrLWafU74w==
X-Received: by 2002:a5d:5955:0:b0:2cf:e29f:d7f5 with SMTP id e21-20020a5d5955000000b002cfe29fd7f5mr3576292wri.25.1678955485799;
        Thu, 16 Mar 2023 01:31:25 -0700 (PDT)
Received: from sgarzare-redhat (host-82-57-51-170.retail.telecomitalia.it. [82.57.51.170])
        by smtp.gmail.com with ESMTPSA id c10-20020adffb0a000000b002d1bfe3269esm1518738wrr.59.2023.03.16.01.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 01:31:25 -0700 (PDT)
Date:   Thu, 16 Mar 2023 09:31:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        eperezma@redhat.com, netdev@vger.kernel.org, stefanha@redhat.com,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/8] vhost-vdpa: use bind_mm/unbind_mm device callbacks
Message-ID: <20230316083122.hliiktgsymrfpozy@sgarzare-redhat>
References: <20230302113421.174582-1-sgarzare@redhat.com>
 <20230302113421.174582-3-sgarzare@redhat.com>
 <CACGkMEttgd82xOxV8WLdSFdfhRLZn68tSaV4APSDh8qXxf4OEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEttgd82xOxV8WLdSFdfhRLZn68tSaV4APSDh8qXxf4OEw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:48:33AM +0800, Jason Wang wrote:
>On Thu, Mar 2, 2023 at 7:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
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
>>     v2:
>>     - call the new unbind_mm callback during the release [Jason]
>>     - avoid to call bind_mm callback after the reset, since the device
>>       is not detaching it now during the reset
>>
>>  drivers/vhost/vdpa.c | 30 ++++++++++++++++++++++++++++++
>>  1 file changed, 30 insertions(+)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index dc12dbd5b43b..1ab89fccd825 100644
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
>> @@ -711,6 +733,13 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>                 break;
>>         default:
>>                 r = vhost_dev_ioctl(&v->vdev, cmd, argp);
>> +               if (!r && cmd == VHOST_SET_OWNER) {
>> +                       r = vhost_vdpa_bind_mm(v);
>> +                       if (r) {
>> +                               vhost_dev_reset_owner(&v->vdev, NULL);
>> +                               break;
>> +                       }
>> +               }
>
>Nit: is it better to have a new condition/switch branch instead of
>putting them under default? (as what vring_ioctl did).

Yep, I agree!

I'll change it.

Thanks,
Stefano

