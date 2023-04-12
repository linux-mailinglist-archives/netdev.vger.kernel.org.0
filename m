Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECED6DF30A
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 13:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjDLLSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 07:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjDLLSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 07:18:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD45D900A
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681298218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ehvr1d/jbxZ+YWSEUG0+v0Njo7GXylIVh8YAQAeYlBM=;
        b=ZyH+vfuEBKNDVTkfcNXC1RtWrcRUVC8vyeguvIK5MWOkHSljBRugVND90FlNkYzAvh5RP7
        KuqVGFV5HK/xefIkcyaCzcyGwl7D6Sy2mJYxcoCRFS+MBQde/HQckbHNWN8UHkNFsg8C6R
        OwKkuhovVIK1cg8+7NJ85oaMlh7RiUQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-222-z6zfURcAOve4eRJ_uCeMWQ-1; Wed, 12 Apr 2023 07:16:56 -0400
X-MC-Unique: z6zfURcAOve4eRJ_uCeMWQ-1
Received: by mail-ed1-f72.google.com with SMTP id m20-20020a50d7d4000000b00501dfd867a4so6353702edj.20
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 04:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681298215; x=1683890215;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ehvr1d/jbxZ+YWSEUG0+v0Njo7GXylIVh8YAQAeYlBM=;
        b=77zqPGWAyPdw2YPUbRbHA8Q5n3QJhIIRGMJry+v33DGBeTgOoDuCF8FYS7V3WoKs5J
         YnHQFmoNvTyrDxfZAskRVSDfzKTl9qLn3l/GOP08kmjJCf1GBGEW543frZj+Dh0YQVHf
         OwtI74D9vx9ZZrL8zpXsplVz6O5ti1wK1ZHyYlHkxQADxbKQB+qqdSfaOmMOnkXvQXXf
         9iSXcxZGiFD812Yrpq5CeT8TaZ72iEKZV4ME7o6M49wUqpIakQTfHg3u2OAaqzth5dMB
         6WKxoslPBkC3yFj4FCJ/PmstQFZlhoIsbBanIQhDuJx3P8Eb9g+fXBEopDMuTZyHrLLQ
         fQKQ==
X-Gm-Message-State: AAQBX9dl5njtwcdBLiwoGkclzd6NX1wgTKe1016mtGkbLSZS73GyNpzx
        Zu4zgQtfMA/0xGAgMYuiXa/hQ22nCUPturRdgVF7+emc2jHZfQrDA4j4S5/E88z907pZqM4qq5F
        xPFrbfsAONcOPdWmi
X-Received: by 2002:a17:906:fae0:b0:931:624b:680c with SMTP id lu32-20020a170906fae000b00931624b680cmr5523412ejb.29.1681298215781;
        Wed, 12 Apr 2023 04:16:55 -0700 (PDT)
X-Google-Smtp-Source: AKy350aU/WJ/sIwojTfk8adw2TCi9w7hbQ5lTxFZjvt+7P+pwVRe6sbMuWkO8uddJ/I5SF7pwr+ocA==
X-Received: by 2002:a17:906:fae0:b0:931:624b:680c with SMTP id lu32-20020a170906fae000b00931624b680cmr5523398ejb.29.1681298215440;
        Wed, 12 Apr 2023 04:16:55 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id hz16-20020a1709072cf000b0094e09ceafc9sm1978330ejc.44.2023.04.12.04.16.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 04:16:54 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <474201b2-d98c-f3ab-aed9-b008bb188d0b@redhat.com>
Date:   Wed, 12 Apr 2023 13:16:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH bpf V7 3/7] xdp: rss hash types representation
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
References: <168098183268.96582.7852359418481981062.stgit@firesoul>
 <168098189148.96582.2939096178283411428.stgit@firesoul>
 <ZDQlYqwmyG4Y73Vb@corigine.com>
In-Reply-To: <ZDQlYqwmyG4Y73Vb@corigine.com>
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



On 10/04/2023 17.04, Simon Horman wrote:
> On Sat, Apr 08, 2023 at 09:24:51PM +0200, Jesper Dangaard Brouer wrote:
>> The RSS hash type specifies what portion of packet data NIC hardware used
>> when calculating RSS hash value. The RSS types are focused on Internet
>> traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get hash
>> value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
>> primarily TCP vs UDP, but some hardware supports SCTP.
>>
>> Hardware RSS types are differently encoded for each hardware NIC. Most
>> hardware represent RSS hash type as a number. Determining L3 vs L4 often
>> requires a mapping table as there often isn't a pattern or sorting
>> according to ISO layer.
>>
>> The patch introduce a XDP RSS hash type (enum xdp_rss_hash_type) that
>> contain combinations to be used by drivers, which gets build up with bits
>> from enum xdp_rss_type_bits. Both enum xdp_rss_type_bits and
>> xdp_rss_hash_type get exposed to BPF via BTF, and it is up to the
>> BPF-programmer to match using these defines.
>>
>> This proposal change the kfunc API bpf_xdp_metadata_rx_hash() adding
>> a pointer value argument for provide the RSS hash type.
>>
>> Change function signature for all xmo_rx_hash calls in drivers to make it
>> compile. The RSS type implementations for each driver comes as separate
>> patches.
>>
>> Fixes: 3d76a4d3d4e5 ("bpf: XDP metadata RX kfuncs")
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
>> Acked-by: Stanislav Fomichev <sdf@google.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx4/en_rx.c       |    3 +
>>   drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |    3 +
>>   drivers/net/veth.c                               |    3 +
>>   include/linux/netdevice.h                        |    3 +
>>   include/net/xdp.h                                |   45 ++++++++++++++++++++++
>>   net/core/xdp.c                                   |   10 ++++-
>>   6 files changed, 62 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>> index 4b5e459b6d49..73d10aa4c503 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
>> @@ -681,7 +681,8 @@ int mlx4_en_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
>>   	return 0;
>>   }
>>   
>> -int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
>> +int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
>> +			enum xdp_rss_hash_type *rss_type)
>>   {
>>   	struct mlx4_en_xdp_buff *_ctx = (void *)ctx;
>>   
> 
> Hi Jesper,
> 
> I think you also need to update the declaration of mlx4_en_xdp_rx_hash()
> in mlx4_en.h.
> 

Thanks a lot for spotting this. fixed in V8.
--Jesper

