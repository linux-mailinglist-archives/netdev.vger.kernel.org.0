Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F986699898
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBPPSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBPPSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:18:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09C99743
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:17:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676560671;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Hu0NDPUgPtJQPv1XAu2IlR0R1Izce8nrz7t5aM+xvQk=;
        b=A+zw6tZGQ6oh6ufpMVqEFt40N+MvDrIhj7XFEMz2C/obGiafOfN6H4/Dsz929ZFNn3k3Da
        p+tXB1a+wchwMcGsmmgkEGdS0DYmfMcBOV8/Ln3HyIKd+ZXQV3lu7pUSeeAl743kl20BIG
        9y/3/3Aq/xTzLOz9ud5E3MdCF36rpt0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-500-095dqRutP1SvUwm6MsT1NA-1; Thu, 16 Feb 2023 10:17:50 -0500
X-MC-Unique: 095dqRutP1SvUwm6MsT1NA-1
Received: by mail-ed1-f70.google.com with SMTP id i36-20020a0564020f2400b004ad793116d5so450158eda.23
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:17:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hu0NDPUgPtJQPv1XAu2IlR0R1Izce8nrz7t5aM+xvQk=;
        b=v5EQWfgUX/QCaUH0PjdTJKAG92C56AzRbxzn+K7JwU/SxwA4tZaDm3pSk08RqBDd5G
         RtUOpWUVGfT7VkxpiYVRUSXjRBIEU3lyTEM7VI3o7ZYniVDmznV8aueQ0aiP3MVnO91q
         Kj5+dTkS/A6Cx6Or1cSy97SQeGPDm5jwR46ATFM976c68X8xeZWybcoUzQkInWEvHU1U
         OFJezRoKqRvUnUzcnhh0CEoYWjWPB6vfK0WxOkEi17M0kAhLVyihZN2te1QV6VMYVBtM
         ObqGem0INYx2uk8a0rkM7IF4SHe9Dpiu3EM9XJa/+NBxPcB6SZ8Zt3vOra+lraM30CdR
         cz1g==
X-Gm-Message-State: AO0yUKXdPgs+sNz4CNxjkIjEpwIkbrqkMI2Ra0LiCNg9ExFuF+mNxFFb
        DHJcS1vMgqBTzc+KLzwhrB5vO8jOtuhjx0vYwNLKwvHcI+W15lepys0hFoNhSKuHuTNLYGhQCmo
        SHzfj9hhvnAmiDmPnRNxRyQ==
X-Received: by 2002:aa7:cfc6:0:b0:4ab:2503:403a with SMTP id r6-20020aa7cfc6000000b004ab2503403amr5969372edy.34.1676560668571;
        Thu, 16 Feb 2023 07:17:48 -0800 (PST)
X-Google-Smtp-Source: AK7set/e0ygiKMDvoNKR1sy40kN4i/T2Q1Ay4lVRellixuesMpm665RS/+dBn5HBdKLkS/bSjZzPIQ==
X-Received: by 2002:aa7:cfc6:0:b0:4ab:2503:403a with SMTP id r6-20020aa7cfc6000000b004ab2503403amr5969337edy.34.1676560668263;
        Thu, 16 Feb 2023 07:17:48 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id t9-20020a50d709000000b004a249a97d84sm995434edi.23.2023.02.16.07.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:17:47 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <9a7a44a6-ec0c-e5e9-1c94-ccc0d1755560@redhat.com>
Date:   Thu, 16 Feb 2023 16:17:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Cc:     brouer@redhat.com, bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        martin.lau@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, ast@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        yoong.siang.song@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Subject: Re: [xdp-hints] Re: [Intel-wired-lan] [PATCH bpf-next V1] igc: enable
 and fix RX hash usage by netstack
To:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <167604167956.1726972.7266620647404438534.stgit@firesoul>
 <6a5ded96-2425-ff9b-c1b1-eca1c103164c@molgen.mpg.de>
 <b6143e67-a0f1-a238-f901-448b85281154@intel.com>
Content-Language: en-US
In-Reply-To: <b6143e67-a0f1-a238-f901-448b85281154@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/02/2023 16.13, Alexander Lobakin wrote:
> From: Paul Menzel <pmenzel@molgen.mpg.de>
> Date: Tue, 14 Feb 2023 16:00:52 +0100
>>
>> Am 10.02.23 um 16:07 schrieb Jesper Dangaard Brouer:
>>> When function igc_rx_hash() was introduced in v4.20 via commit 0507ef8a0372
>>> ("igc: Add transmit and receive fastpath and interrupt handlers"), the
>>> hardware wasn't configured to provide RSS hash, thus it made sense to not
>>> enable net_device NETIF_F_RXHASH feature bit.
>>>
[...]
>>
>>> hash value doesn't include UDP port numbers. Not being PKT_HASH_TYPE_L4, have
>>> the effect that netstack will do a software based hash calc calling into
>>> flow_dissect, but only when code calls skb_get_hash(), which doesn't
>>> necessary happen for local delivery.
>>
>> Excuse my ignorance, but is that bug visible in practice by users
>> (performance?) or is that fix needed for future work?
> 
> Hash calculation always happens when RPS or RFS is enabled. So having no
> hash in skb before hitting the netstack slows down their performance.
> Also, no hash in skb passed from the driver results in worse NAPI bucket
> distribution when there are more traffic flows than Rx queues / CPUs.
> + Netfilter needs hashes on some configurations.
> 

Thanks Olek for explaining that.

My perf measurements show that the expensive part is that netstack will
call the flow_dissector code, when the hardware RX-hash is missing.

>>
>>> Fixes: 2121c2712f82 ("igc: Add multiple receive queues control
>>> supporting")
>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> [...]
> 
> Nice to see that you also care about (not) using short types on the stack :)

As can be seen by godbolt.org exploration[0] I have done, the stack
isn't used for storing the values.

  [0] 
https://github.com/xdp-project/xdp-project/tree/master/areas/hints/godbolt/

I have created three files[2] with C-code that can be compiled via 
https://godbolt.org/.  The C-code contains a comment with the ASM code 
that was generated with -02 with compiler x86-64 gcc 12.2.

The first file[01] corresponds to this patch.

  [01] 
https://github.com/xdp-project/xdp-project/blob/master/areas/hints/godbolt/igc_godbolt01.c
  [G01] https://godbolt.org/z/j79M9aTsn

The second file igc_godbolt02.c [02] have changes in [diff02]

  [02] 
https://github.com/xdp-project/xdp-project/blob/master/areas/hints/godbolt/igc_godbolt02.c
  [G02] https://godbolt.org/z/sErqe4qd5
  [diff02] https://github.com/xdp-project/xdp-project/commit/1f3488a932767

The third file igc_godbolt03.c [03] have changes in [diff03]

  [03] 
https://github.com/xdp-project/xdp-project/blob/master/areas/hints/godbolt/igc_godbolt03.c
  [G03] https://godbolt.org/z/5K3vE1Wsv
  [diff03] https://github.com/xdp-project/xdp-project/commit/aa9298f68705

Summary, the only thing we can save is replacing some movzx
(zero-extend) with mov instructions.

>>
>> [1]: https://notabs.org/coding/smallIntsBigPenalty.htm
> 
> Thanks,
> Olek
> 

