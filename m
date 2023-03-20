Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159AA6C2060
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjCTSvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjCTSux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:50:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4EA3ABE
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679337749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=isnRFciqZ5AqBvIpyhsEw00Lp7lbCnxM3glPD1hRE1s=;
        b=Sn92fvkZLJ/D0rWfLqsi9TuotPOrUIbG3Lgx7/GEjVAEtscYaL+OBI0gYnBGiQntiO8HdH
        07HJ+z/+FTLqZgvYboG6W5hDecO41pEymHU/aHlfOJexd8OP/E4NmsGXkErpsNAaK5TY2l
        WKop07K0Z5GHYx3kMkGE21AXUSnXZdY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-497-Wu3KIdMxOueB799PL7nBdg-1; Mon, 20 Mar 2023 14:42:25 -0400
X-MC-Unique: Wu3KIdMxOueB799PL7nBdg-1
Received: by mail-ed1-f70.google.com with SMTP id t14-20020a056402240e00b004fb36e6d670so18612237eda.5
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:42:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679337744;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=isnRFciqZ5AqBvIpyhsEw00Lp7lbCnxM3glPD1hRE1s=;
        b=acnnP2f8LHli78eqm0Au6PeV/hoa6taYiQcJM43HaqQ5DCaxAA5ej3bk0vhwHrr5aj
         0vyvbpnVjNwBJT8HYn3avdpaOxgDL6C4gDuHB1lhaw6JMmHZRGMRdx4X1p8FizbxRMD0
         0dP8ZilOHW+5Y1nTguP09XAcEN0MIwfAldkpOh1772DY0f3bl0GqDkS4U68p2Kcjstxy
         OEBVFyPGVVLeD/9z2Nk8FVzXT46Ok+Sa3DjXc1anGygSuJpDdyatasxaNKmELLtBmh2q
         ItQIFPKWBOOQzOyxGUmt+VLDYdPgkVVPSCJRsvMES/G252Vzbd7JhojytqGfvoyBjnpn
         6O+Q==
X-Gm-Message-State: AO0yUKVetIROtrrHI0vzr22MkLhi4gG1pMrIaHqlSkB2hG/W3p3niNyL
        /UjExoPm+P3wmKojOf60/sVqnnCnO7YGKM/zC6wStt3tdc9JNCb8YiS8moDfMlVgDLKN0nIDY5z
        tlTnbzTyr2x7YqKsr
X-Received: by 2002:a17:907:7050:b0:932:b7ce:27b4 with SMTP id ws16-20020a170907705000b00932b7ce27b4mr60801ejb.27.1679337744683;
        Mon, 20 Mar 2023 11:42:24 -0700 (PDT)
X-Google-Smtp-Source: AK7set+BEgcGehPqZ2Bum2ZHowR7GqySzgHhwXwhHcdGlZqXQtrEdVC8Ntpmjeef2K2jOfZ66WbhMQ==
X-Received: by 2002:a17:907:7050:b0:932:b7ce:27b4 with SMTP id ws16-20020a170907705000b00932b7ce27b4mr60777ejb.27.1679337744401;
        Mon, 20 Mar 2023 11:42:24 -0700 (PDT)
Received: from [192.168.42.100] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id hf8-20020a1709072c4800b0092b65c54379sm4761658ejc.104.2023.03.20.11.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 11:42:23 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <f42ff647-11b2-4f09-7652-ad85d35b5617@redhat.com>
Date:   Mon, 20 Mar 2023 19:42:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com
Subject: Re: [PATCH bpf-next V1 1/7] xdp: bpf_xdp_metadata use EOPNOTSUPP for
 no driver support
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
References: <167906343576.2706833.17489167761084071890.stgit@firesoul>
 <167906359575.2706833.545256364239637451.stgit@firesoul>
 <ZBTZ7J9B6yXNJO1m@google.com>
In-Reply-To: <ZBTZ7J9B6yXNJO1m@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17/03/2023 22.21, Stanislav Fomichev wrote:
> On 03/17, Jesper Dangaard Brouer wrote:
>> When driver doesn't implement a bpf_xdp_metadata kfunc the fallback
>> implementation returns EOPNOTSUPP, which indicate device driver doesn't
>> implement this kfunc.
> 
>> Currently many drivers also return EOPNOTSUPP when the hint isn't
>> available, which is inconsistent from an API point of view. Instead
>> change drivers to return ENODATA in these cases.
> 
>> There can be natural cases why a driver doesn't provide any hardware
>> info for a specific hint, even on a frame to frame basis (e.g. PTP).
>> Lets keep these cases as separate return codes.
> 
>> When describing the return values, adjust the function kernel-doc layout
>> to get proper rendering for the return values.
> 
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> I don't remember whether the previous discussion ended in something?
> IIRC Martin was preferring to use xdp-features for this instead?
> 

IIRC Martin asked for a second vote/opinion to settle the vote.
The xdp-features use is orthogonal and this patch does not prohibit the
later implementation of xdp-features, to detect if driver doesn't
implement kfuncs via using global vars.  Not applying this patch leaves
the API in an strange inconsistent state, because of an argument that in
the *future* we can use xdp-features to solve *one* of the discussed
use-cases for another return code.
I argued for a practical PTP use-case where not all frames contain the
PTP timestamp.  This patch solve this use-case *now*, so I don't see why
we should stall solving this, because of a "future" feature we might
never get around to implement, which require the user to use global vars.


> Personally I'm fine with having this convention, but I'm not sure how well
> we'll be able to enforce them. (In general, I'm not a fan of userspace
> changing it's behavior based on errno. If it's mostly for
> debugging/development - seems ok)
>

We enforce the API by documenting the return behavior, like below.  If a 
driver violate this, then we will fix the driver code with a fixes tag.

My ask is simply let not have ambiguous return codes.


>> ---
>>   Documentation/networking/xdp-rx-metadata.rst     |    7 +++++--
>>   drivers/net/ethernet/mellanox/mlx4/en_rx.c       |    4 ++--
>>   drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |    4 ++--
>>   drivers/net/veth.c                               |    4 ++--
>>   net/core/xdp.c                                   |   10 ++++++++--
>>   5 files changed, 19 insertions(+), 10 deletions(-)
> 
[...]
>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index 8d3ad315f18d..7133017bcd74 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -705,7 +705,10 @@ __diag_ignore_all("-Wmissing-prototypes",
>>    * @ctx: XDP context pointer.
>>    * @timestamp: Return value pointer.
>>    *
>> - * Returns 0 on success or ``-errno`` on error.
>> + * Return:
>> + * * Returns 0 on success or ``-errno`` on error.
>> + * * ``-EOPNOTSUPP`` : means device driver does not implement kfunc
>> + * * ``-ENODATA``    : means no RX-timestamp available for this frame
>>    */
>>   __bpf_kfunc int bpf_xdp_metadata_rx_timestamp(const struct xdp_md 
>> *ctx, u64 *timestamp)
>>   {
>> @@ -717,7 +720,10 @@ __bpf_kfunc int 
>> bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx, u64 *tim
>>    * @ctx: XDP context pointer.
>>    * @hash: Return value pointer.
>>    *
>> - * Returns 0 on success or ``-errno`` on error.
>> + * Return:
>> + * * Returns 0 on success or ``-errno`` on error.
>> + * * ``-EOPNOTSUPP`` : means device driver doesn't implement kfunc
>> + * * ``-ENODATA``    : means no RX-hash available for this frame
>>    */
>>   __bpf_kfunc int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, 
>> u32 *hash)
>>   {
> 
> 

