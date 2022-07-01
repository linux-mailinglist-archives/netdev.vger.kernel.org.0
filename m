Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01134563053
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbiGAJgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiGAJgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:36:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C8D5774DC7
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 02:36:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656668210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3dN2Ed9BguDI5gyWO5SlL0rnKl20jgh9B0B8prvlwR0=;
        b=XOTCaOHLSVBMjyiI2aTeDtKk9BFTWgSJmvxjVSCKRxjLBq9dSRv17Lf5YiUGMu4pLWqf8x
        9vHPR7m4VvgnNfKgqjOMDfbhNXzs+aptyBIpFSgPSclqG3tIVZYiBParAr9TOegmqKrzuM
        sWV86QNiu9wgkxUuJ8buyJTFXA/zO+4=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-MCkp50k1MjqMT5Pxe7FAMA-1; Fri, 01 Jul 2022 05:36:49 -0400
X-MC-Unique: MCkp50k1MjqMT5Pxe7FAMA-1
Received: by mail-pl1-f199.google.com with SMTP id o9-20020a170902d4c900b0016a629e2f1bso1209143plg.20
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 02:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3dN2Ed9BguDI5gyWO5SlL0rnKl20jgh9B0B8prvlwR0=;
        b=zJqZ1Utmelz1R8ZCX7Z37SsSxP/2mZOI+1PDYvssPJ/YFDh1RswU2z8T2t0QS7p6GC
         Z/xDRZcgNH1BYiS2NIdLfzat0l7Gu+Vj90MiP1Kw640SdjuqRYI4wjtPi3LdEMasJBC6
         n9M7g5yy4oWc/zHzr1eXahXwvRUxe2rT07U8MK335+S+KsWzseCTqNkiFB/RT9dhrS4F
         V5J9dKnrq8fRtE27XSEG5apf/3IYpEGPaLEgzGR0etyfshk6RHOynWFzUDxFHzG4s7qq
         B9VW5Ry5QeQiEapg0LxesbhBcpdXLMMFcMzNhRJmvP50jzuk8qoJJE7AwCS74nTmrSJU
         kTqg==
X-Gm-Message-State: AJIora9j6yU9GKbYmQFwlFHcAaWvg5IyCHucnRuYaONZ3yoGisv0daCW
        vcQiF9c8A0SEwuoNw66FPVSZ7L4CL+niOtWGI7l7LAs8yzqOT7UqNk75hz+1dwbEziOwS2AZFr4
        wFIBl6mHaHlgG1tXR
X-Received: by 2002:a17:903:24e:b0:16b:9fa2:41e5 with SMTP id j14-20020a170903024e00b0016b9fa241e5mr13769762plh.127.1656668208643;
        Fri, 01 Jul 2022 02:36:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s2tQyLCXMrbx9yXxpYY9TeU2uoF6cGR+tGI1XuAVQyHwDEpf0d8SFWt7v9pCDnMz5Bdj+bww==
X-Received: by 2002:a17:903:24e:b0:16b:9fa2:41e5 with SMTP id j14-20020a170903024e00b0016b9fa241e5mr13769722plh.127.1656668208349;
        Fri, 01 Jul 2022 02:36:48 -0700 (PDT)
Received: from [10.72.13.237] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t129-20020a625f87000000b005259578e8fcsm11802013pfb.181.2022.07.01.02.36.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 02:36:47 -0700 (PDT)
Message-ID: <79e519ec-0129-6a21-11da-44eaff1429fa@redhat.com>
Date:   Fri, 1 Jul 2022 17:36:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v11 25/40] virtio: allow to unbreak/break virtqueue
 individually
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
 <20220629065656.54420-26-xuanzhuo@linux.alibaba.com>
 <20220701022950-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220701022950-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/1 14:31, Michael S. Tsirkin 写道:
> On Wed, Jun 29, 2022 at 02:56:41PM +0800, Xuan Zhuo wrote:
>> This patch allows the new introduced
>> __virtqueue_break()/__virtqueue_unbreak() to break/unbreak the
>> virtqueue.
>>
>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> I wonder how this interacts with the hardening patches.
> Jason?


Consider we've marked it as broken, I think we don't need to care about 
the hardening in this series. Just make it work without hardening.

And I will handle vq reset when rework the IRQ hardening.

Thanks


>
>> ---
>>   drivers/virtio/virtio_ring.c | 24 ++++++++++++++++++++++++
>>   include/linux/virtio.h       |  3 +++
>>   2 files changed, 27 insertions(+)
>>
>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>> index 5ec43607cc15..7b02be7fce67 100644
>> --- a/drivers/virtio/virtio_ring.c
>> +++ b/drivers/virtio/virtio_ring.c
>> @@ -2744,6 +2744,30 @@ unsigned int virtqueue_get_vring_size(struct virtqueue *_vq)
>>   }
>>   EXPORT_SYMBOL_GPL(virtqueue_get_vring_size);
>>   
>> +/*
>> + * This function should only be called by the core, not directly by the driver.
>> + */
>> +void __virtqueue_break(struct virtqueue *_vq)
>> +{
>> +	struct vring_virtqueue *vq = to_vvq(_vq);
>> +
>> +	/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
>> +	WRITE_ONCE(vq->broken, true);
>> +}
>> +EXPORT_SYMBOL_GPL(__virtqueue_break);
>> +
>> +/*
>> + * This function should only be called by the core, not directly by the driver.
>> + */
>> +void __virtqueue_unbreak(struct virtqueue *_vq)
>> +{
>> +	struct vring_virtqueue *vq = to_vvq(_vq);
>> +
>> +	/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
>> +	WRITE_ONCE(vq->broken, false);
>> +}
> I don't think these "Pairs" comments have any value.
>
>
>> +EXPORT_SYMBOL_GPL(__virtqueue_unbreak);
>> +
>>   bool virtqueue_is_broken(struct virtqueue *_vq)
>>   {
>>   	struct vring_virtqueue *vq = to_vvq(_vq);
>> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
>> index 1272566adec6..dc474a0d48d1 100644
>> --- a/include/linux/virtio.h
>> +++ b/include/linux/virtio.h
>> @@ -138,6 +138,9 @@ bool is_virtio_device(struct device *dev);
>>   void virtio_break_device(struct virtio_device *dev);
>>   void __virtio_unbreak_device(struct virtio_device *dev);
>>   
>> +void __virtqueue_break(struct virtqueue *_vq);
>> +void __virtqueue_unbreak(struct virtqueue *_vq);
>> +
>>   void virtio_config_changed(struct virtio_device *dev);
>>   #ifdef CONFIG_PM_SLEEP
>>   int virtio_device_freeze(struct virtio_device *dev);
>> -- 
>> 2.31.0

