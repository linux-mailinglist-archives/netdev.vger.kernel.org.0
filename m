Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA06657337
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 07:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiL1G2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 01:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbiL1G2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 01:28:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5BBCE17
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 22:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672208863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZlnP1UqlCKmbgzFb2zLwCzlOAuPQKVghslrdkVNZdLU=;
        b=BkUBUS16KW+HfPf8DEORcIf5Pbw9ruQe060Ph7VmvYvlfoj8G1IHttYFNHtm21/5WJ/j19
        BhNnX0/KBfqKhHJmMMj3qs1Dz5ohGOL8JwhuHPbDTnDZ0sF8Qc5QQjIetpilSvmlYm68fY
        foojfaGELziy2GRxM4JXG1Nj6DtgY84=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-171-Xps5DcigN2CJEVtgcNzKOg-1; Wed, 28 Dec 2022 01:27:41 -0500
X-MC-Unique: Xps5DcigN2CJEVtgcNzKOg-1
Received: by mail-pl1-f198.google.com with SMTP id f8-20020a170902ce8800b00190c6518e21so11427273plg.1
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 22:27:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlnP1UqlCKmbgzFb2zLwCzlOAuPQKVghslrdkVNZdLU=;
        b=5a0V1hweU/uAMrOn6U8IEExTo2RkbXexMJEvwXMs0mpvubOd0IfIJY9fi7tnOTjc+t
         MkOHLtK2+z20daiyisquHTrSv2X1thg5e/th2aeLGDNqCGUi6Hwlr2Iyz1rvHG20qmOe
         qbNUG9K5mKJgP/0potTApQOtHVfUlbnml3qxDb1PkN3qYePSJ3sLLKUMNONSoR+YcQja
         TfKPeQYX8B804da/AzCXVfGaJP5+Xy+/55LUCzpeG3m5+DyjLzQcS5OsX/UglKXfaMOd
         QXGiseGwEdr2fSf5Dfctxu4LThK8iFczToiEgx0AHjIO/5x7oGdP3XHCnFDX4a8vXrVq
         E8jA==
X-Gm-Message-State: AFqh2krqrZtEsTUif1Y66N93EQtZ+yLeGa7diq2l/Gj8J6ZWejRsOuJd
        dL9VOdtnft1xklFnVdUTIGqT2wNcJ3murCqRxIdaCqI1eDpIT4Jd/5651VceZnO2Vr9MFIL7cwy
        Bf5fgEqL4ggKIbOLs
X-Received: by 2002:aa7:8286:0:b0:57e:c106:d50c with SMTP id s6-20020aa78286000000b0057ec106d50cmr28393444pfm.17.1672208860731;
        Tue, 27 Dec 2022 22:27:40 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuKelDwwTLr4tdjTiO9IGp6t0xbA0Ab4E9tdBpgFImb6D9lDmskDDcitFgjO3jRlGk3x90A1Q==
X-Received: by 2002:aa7:8286:0:b0:57e:c106:d50c with SMTP id s6-20020aa78286000000b0057ec106d50cmr28393428pfm.17.1672208860473;
        Tue, 27 Dec 2022 22:27:40 -0800 (PST)
Received: from [10.72.13.7] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b005811c4245c7sm4771905pfr.126.2022.12.27.22.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 22:27:40 -0800 (PST)
Message-ID: <2af5c632-9d76-fc80-cf54-0b925a8b7069@redhat.com>
Date:   Wed, 28 Dec 2022 14:27:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/9] virtio_net: set up xdp for multi buffer packets
Content-Language: en-US
To:     Heng Qi <hengqi@linux.alibaba.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20221220141449.115918-1-hengqi@linux.alibaba.com>
 <20221220141449.115918-3-hengqi@linux.alibaba.com>
 <82eb2ffc-ce97-0c76-f7bc-8a163968cde7@redhat.com>
 <2704f3ad-9477-c9d2-8eca-01a9fa92732a@linux.alibaba.com>
 <d2b1f378-e30a-2b54-b8da-e9eb874badee@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <d2b1f378-e30a-2b54-b8da-e9eb874badee@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/12/28 11:50, Heng Qi 写道:
>
>
> 在 2022/12/27 下午8:20, Heng Qi 写道:
>>
>>
>> 在 2022/12/27 下午2:32, Jason Wang 写道:
>>>
>>> 在 2022/12/20 22:14, Heng Qi 写道:
>>>> When the xdp program sets xdp.frags, which means it can process
>>>> multi-buffer packets over larger MTU, so we continue to support xdp.
>>>> But for single-buffer xdp, we should keep checking for MTU.
>>>>
>>>> Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
>>>> Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>>> ---
>>>>   drivers/net/virtio_net.c | 4 ++--
>>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>>> index 443aa7b8f0ad..c5c4e9db4ed3 100644
>>>> --- a/drivers/net/virtio_net.c
>>>> +++ b/drivers/net/virtio_net.c
>>>> @@ -3095,8 +3095,8 @@ static int virtnet_xdp_set(struct net_device 
>>>> *dev, struct bpf_prog *prog,
>>>>           return -EINVAL;
>>>>       }
>>>>   -    if (dev->mtu > max_sz) {
>>>> -        NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP");
>>>> +    if (prog && !prog->aux->xdp_has_frags && dev->mtu > max_sz) {
>>>
>>>
>>> Not related to this patch, but I see:
>>>
>>>         unsigned long int max_sz = PAGE_SIZE - sizeof(struct 
>>> padded_vnet_hdr);
>>>
>>> Which is suspicious, do we need to count reserved headroom/tailroom 
>>> as well?
>>
>> This seems to be suspicious. After loading xdp, the size of the 
>> filled avail buffer
>> is (PAGE_SIZE - headroom - tailroom), so the size of the received 
>> used buffer, ie MTU,
>> should also be (PAGE_SIZE - headroom - tailroom).
>
> Hi Jason, this is indeed a problem. After verification, packet drop 
> will indeed occur.  To avoid this,
> the size of MTU should be (PAGE_SIZE - headroom - tailroom - ethhdr = 
> 4096 - 256 -320 - 14 =3506).
> Because when there is xdp, each filling is 3520 (PAGE_SIZE - room), if 
> the value of (MTU + 14) is
> greater than 3520 (because the MTU does not contain the ethernet 
> header), then the packet with a
> length greater than 3520 will come in, so num_buf will still be 
> greater than or equal to 2, and then
> xdp_linearize_page() will be performed and the packet will be dropped 
> because the total length is
> greater than PAGE_SIZE.
>
> I will make a separate bugfix patch to fix this later.


Great.

Thanks


>
> Thanks.
>
>>
>> Thanks.
>>
>>>
>>> Thanks
>>>
>>>
>>>> +        NL_SET_ERR_MSG_MOD(extack, "MTU too large to enable XDP 
>>>> without frags");
>>>>           netdev_warn(dev, "XDP requires MTU less than %lu\n", 
>>>> max_sz);
>>>>           return -EINVAL;
>>>>       }
>

