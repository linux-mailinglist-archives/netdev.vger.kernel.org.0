Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD51C6E9015
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 12:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbjDTKZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 06:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234451AbjDTKYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 06:24:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA622D7F
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681986170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHh4Hk5Wr59/VR6ozFS/iFZq7pLvic32jswlAbPFFNU=;
        b=c+zf/oqKrWbC7asJzHP+skopR38D4atanek+Ti/ENHvRyi+C466jVv9fowVTpmF64W0+wE
        2uL12ecHlbo8EyLuK9I/H8utRrPEv4zmyTPVbWns4e87T2H0qBeMZcB5zCmTYdKlfOl/In
        zYxcc09Pw3JSRfVMgdf2Qt7XKIF71FI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-368-1K4aE1vEMg2jHWaV3Oc8jg-1; Thu, 20 Apr 2023 06:22:39 -0400
X-MC-Unique: 1K4aE1vEMg2jHWaV3Oc8jg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAB46101A531;
        Thu, 20 Apr 2023 10:22:38 +0000 (UTC)
Received: from [10.39.208.29] (unknown [10.39.208.29])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D3D114020BEE;
        Thu, 20 Apr 2023 10:22:36 +0000 (UTC)
Message-ID: <b860bd8d-c99b-eeee-b7a3-c58aa79f3146@redhat.com>
Date:   Thu, 20 Apr 2023 12:22:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [RFC 1/2] vduse: validate block features only with block devices
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     xieyongji@bytedance.com, mst@redhat.com, david.marchand@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        xuanzhuo@linux.alibaba.com, eperezma@redhat.com
References: <20230419134329.346825-1-maxime.coquelin@redhat.com>
 <20230419134329.346825-2-maxime.coquelin@redhat.com>
 <CACGkMEtooodqB9pSGTQJx4x55-+RqPhNhT5_4zSDMiCSJXyjVg@mail.gmail.com>
From:   Maxime Coquelin <maxime.coquelin@redhat.com>
In-Reply-To: <CACGkMEtooodqB9pSGTQJx4x55-+RqPhNhT5_4zSDMiCSJXyjVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/23 06:06, Jason Wang wrote:
> On Wed, Apr 19, 2023 at 9:43 PM Maxime Coquelin
> <maxime.coquelin@redhat.com> wrote:
>>
>> This patch is preliminary work to enable network device
>> type support to VDUSE.
>>
>> As VIRTIO_BLK_F_CONFIG_WCE shares the same value as
>> VIRTIO_NET_F_HOST_TSO4, we need to restrict its check
>> to Virtio-blk device type.
>>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@redhat.com>
>> ---
>>   drivers/vdpa/vdpa_user/vduse_dev.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
>> index 0c3b48616a9f..6fa598a03d8e 100644
>> --- a/drivers/vdpa/vdpa_user/vduse_dev.c
>> +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
>> @@ -1416,13 +1416,14 @@ static bool device_is_allowed(u32 device_id)
>>          return false;
>>   }
>>
>> -static bool features_is_valid(u64 features)
>> +static bool features_is_valid(struct vduse_dev_config *config)
>>   {
>> -       if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
>> +       if (!(config->features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
>>                  return false;
>>
>>          /* Now we only support read-only configuration space */
>> -       if (features & (1ULL << VIRTIO_BLK_F_CONFIG_WCE))
>> +       if ((config->device_id == VIRTIO_ID_BLOCK) &&
>> +                       (config->features & (1ULL << VIRTIO_BLK_F_CONFIG_WCE)))
> 
> The reason we filter WCE out is to avoid writable config space which
> might block the driver with a buggy userspace.
> 
> For networking, I guess we should fail if VERSION_1 is not negotiated,
> then we can avoid setting mac addresses via the config space.

  Ok, I will add it to patch 2 in V1.

Thanks,
Maxime

> 
> Thanks
> 
>>                  return false;
>>
>>          return true;
>> @@ -1446,7 +1447,7 @@ static bool vduse_validate_config(struct vduse_dev_config *config)
>>          if (!device_is_allowed(config->device_id))
>>                  return false;
>>
>> -       if (!features_is_valid(config->features))
>> +       if (!features_is_valid(config))
>>                  return false;
>>
>>          return true;
>> --
>> 2.39.2
>>
> 

