Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F04DA6C6410
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjCWJxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 05:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCWJwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:52:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960C835ED7
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 02:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679565014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XERu7jFbdY1Uu35G9bxCU6ajLW1FJ5w92clS/0dwz/w=;
        b=RtmiUK3D8eWXxtflAkIp+HuEP++vacv5GBhagWsycFOSNg189oOeufwdZZt9JUkb+jVj0b
        jU+Wpvu9pktndQhwIKE8wF19Gd9UwbnM3ekfBJIYwkwPd0CnCec8ScARLsFuNv1f2Cw4xi
        sWBZ5WEQOIkUm1sxYCe+b0tJwe1vTuk=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-261-_xtw-DUmPuiUJYEPm3fJUg-1; Thu, 23 Mar 2023 05:50:12 -0400
X-MC-Unique: _xtw-DUmPuiUJYEPm3fJUg-1
Received: by mail-qv1-f69.google.com with SMTP id y19-20020ad445b3000000b005a5123cb627so10583899qvu.20
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 02:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679565012;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XERu7jFbdY1Uu35G9bxCU6ajLW1FJ5w92clS/0dwz/w=;
        b=qvRjRmKm05n9VacfVAHfje+ibedXqi/TgGHNOVMmiPJMsZ5x4hMJ91jNsH/xv5zoPv
         vBgLdVRQtTV2g6bDumEeN0SETWDdL+44Na8T4A9w0WqnLO+eJHN16TLQ0NBKeckFDJv9
         PClRZiIEf4wHKL0eBoa0KSdk4OwsTR4AXs3A35lhSO4m/j8AqAkNFW67AUKk92DQohuV
         hd8IeP0pcNdtnV3GtjxigK+RAK6IAUQPnp8hPcXnlu3gFUVpdsqAmH9zl5jL5E+RlaG8
         oI2zWzacEXOSfmS2P6eoriX0Ff8prOhR/kypapu3wVJFPv2tQXHj518AnI72eJOT51U9
         ZvoQ==
X-Gm-Message-State: AO0yUKWNI0XHp2aHZjdYs+as47kX6hzW2SV8ILwhNtSVOMtBor2feiYh
        B35a6yQNNTe9qiw+cm9Zq4tYoXckiQ46hwqx21RWAnkACOe4K/zqkUS0hSztfV8Zi/A8IhGVVlX
        Zd93br5ok0a+m0NKX
X-Received: by 2002:a05:6214:23c7:b0:56e:abb8:b656 with SMTP id hr7-20020a05621423c700b0056eabb8b656mr7134174qvb.7.1679565012267;
        Thu, 23 Mar 2023 02:50:12 -0700 (PDT)
X-Google-Smtp-Source: AK7set+QwTH7mkA2d88CDuEA5u4qe58JMiq4f/fwPX1oT/BguD3EV9srXmDNSfnJZru9uKMxtXB43w==
X-Received: by 2002:a05:6214:23c7:b0:56e:abb8:b656 with SMTP id hr7-20020a05621423c700b0056eabb8b656mr7134160qvb.7.1679565011978;
        Thu, 23 Mar 2023 02:50:11 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-98.retail.telecomitalia.it. [82.53.134.98])
        by smtp.gmail.com with ESMTPSA id 4-20020a05620a048400b007468bf8362esm7179339qkr.66.2023.03.23.02.50.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 02:50:11 -0700 (PDT)
Date:   Thu, 23 Mar 2023 10:50:06 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, linux-kernel@vger.kernel.org,
        eperezma@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vdpa_sim: add support for user VA
Message-ID: <20230323095006.jvbbdjvkdvhzcehz@sgarzare-redhat>
References: <20230321154804.184577-1-sgarzare@redhat.com>
 <20230321154804.184577-4-sgarzare@redhat.com>
 <CACGkMEtbrt3zuqy9YdhNyE90HHUT1R=HF-YRAQ6b4KnW_SdZ-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtbrt3zuqy9YdhNyE90HHUT1R=HF-YRAQ6b4KnW_SdZ-w@mail.gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 11:42:07AM +0800, Jason Wang wrote:
>On Tue, Mar 21, 2023 at 11:48 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>>
>> The new "use_va" module parameter (default: true) is used in
>> vdpa_alloc_device() to inform the vDPA framework that the device
>> supports VA.
>>
>> vringh is initialized to use VA only when "use_va" is true and the
>> user's mm has been bound. So, only when the bus supports user VA
>> (e.g. vhost-vdpa).
>>
>> vdpasim_mm_work_fn work is used to serialize the binding to a new
>> address space when the .bind_mm callback is invoked, and unbinding
>> when the .unbind_mm callback is invoked.
>>
>> Call mmget_not_zero()/kthread_use_mm() inside the worker function
>> to pin the address space only as long as needed, following the
>> documentation of mmget() in include/linux/sched/mm.h:
>>
>>   * Never use this function to pin this address space for an
>>   * unbounded/indefinite amount of time.
>
>I wonder if everything would be simplified if we just allow the parent
>to advertise whether or not it requires the address space.
>
>Then when vhost-vDPA probes the device it can simply advertise
>use_work as true so vhost core can use get_task_mm() in this case?

IIUC set user_worker to true, it also creates the kthread in the vhost
core (but we can add another variable to avoid this).

My biggest concern is the comment in include/linux/sched/mm.h.
get_task_mm() uses mmget(), but in the documentation they advise against
pinning the address space indefinitely, so I preferred in keeping
mmgrab() in the vhost core, then call mmget_not_zero() in the worker
only when it is running.

In the future maybe mm will be used differently from parent if somehow
it is supported by iommu, so I would leave it to the parent to handle
this.

Thanks,
Stefano

