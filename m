Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50A56E1FC7
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 11:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbjDNJvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 05:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjDNJvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 05:51:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F895FD3
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 02:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681465825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kD03/VZMnuU+AkWoElhnvOWf3hPE4VUEKVtpsqSBK8c=;
        b=SNpH8lBAzvQJpTJZLUkPMN8depuB8UKF0xqxQjHMKEoN9a3SKYJpm7/KsVzsxfj8c/08Bx
        QiPADj0gY+1aJwXQJ6Cz5q6UVcSFFONi0/jb9s7SQPVwgF+RRdG6e6b2Yw6XLN9Jz6GgBh
        1NxoQZkqZvnd70JiawGPsoYKsNkfeY0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-eISXJCUmNOyzCPML0UpiRA-1; Fri, 14 Apr 2023 05:50:24 -0400
X-MC-Unique: eISXJCUmNOyzCPML0UpiRA-1
Received: by mail-ej1-f71.google.com with SMTP id kr13-20020a1709079a0d00b0093be92e6ff4so6564923ejc.23
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 02:50:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681465823; x=1684057823;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kD03/VZMnuU+AkWoElhnvOWf3hPE4VUEKVtpsqSBK8c=;
        b=cML2UJehzFhGTznRBWSLOoMW0+JkKEfHqi67vcWthJeqJLyTTVIF/yZnXo9tNlPfrO
         iW4FeFwLfbEMFXiWtijwq2/Gl15p9+SKyL9p6dux2it6gEmPbFAeuqRk74wibTNKOBSJ
         Tu/BDVK2UhWGZZo0ZUC6sFpu4NOQ0MAp1qrIamh4E+4z3MCI2T0z6IpTBAwB5ga6aQrk
         kwHs8WHzbphlA2ONTiPdSGVehqmd+1vUP5SEDLueWnklHrb7hGerXyCX2z2hKxjBWQrz
         7qsGCSAwWtaIcWNimL2Gw4xM9aImequIvkS5FlIx2bRoD37ZeDArboN+ob+suTuvXRoR
         hqmA==
X-Gm-Message-State: AAQBX9fgtqr1SUv0w9A760jj5U6sb/tHNVwiiYfXB2aYpFLOjODXv2Ih
        5R1ESxmcADswBfJXQvB7vkV4AGrvxG2eKQJctekV7xYns6fKv1xBEWlw47SIl19WHk2U93Xu4//
        b3K7zb2xMhlLQrasZ
X-Received: by 2002:a17:907:9808:b0:94e:7ddf:3ea4 with SMTP id ji8-20020a170907980800b0094e7ddf3ea4mr4486405ejc.24.1681465823379;
        Fri, 14 Apr 2023 02:50:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350a6+Z5LefT4FRvBDLayHSHXZA3qQHN2R00EVjv3yDfVy5sfO/pP+qKrWWJLMzDXhuVJ7vw4Pw==
X-Received: by 2002:a17:907:9808:b0:94e:7ddf:3ea4 with SMTP id ji8-20020a170907980800b0094e7ddf3ea4mr4486375ejc.24.1681465823000;
        Fri, 14 Apr 2023 02:50:23 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id y20-20020a170906559400b0094a7e4dfed8sm2189942ejp.47.2023.04.14.02.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 02:50:22 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <8214fb10-8caa-4418-8435-85b6ac27b69e@redhat.com>
Date:   Fri, 14 Apr 2023 11:50:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        stable@vger.kernel.org
Subject: Re: [PATCH net v2 1/1] igc: read before write to SRRCTL register
Content-Language: en-US
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        Jithu Joseph <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        Stanislav Fomichev <sdf@google.com>,
        Jacob Keller <jacob.e.keller@intel.com>
References: <20230414020915.1869456-1-yoong.siang.song@intel.com>
In-Reply-To: <20230414020915.1869456-1-yoong.siang.song@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/04/2023 04.09, Song Yoong Siang wrote:
> igc_configure_rx_ring() function will be called as part of XDP program
> setup. If Rx hardware timestamp is enabled prio to XDP program setup,
> this timestamp enablement will be overwritten when buffer size is
> written into SRRCTL register.
> 
> Thus, this commit read the register value before write to SRRCTL
> register. This commit is tested by using xdp_hw_metadata bpf selftest
> tool. The tool enables Rx hardware timestamp and then attach XDP program
> to igc driver. It will display hardware timestamp of UDP packet with
> port number 9092. Below are detail of test steps and results.
> 
> Command on DUT:
>    sudo ./xdp_hw_metadata <interface name>
> 
> Command on Link Partner:
>    echo -n skb | nc -u -q1 <destination IPv4 addr> 9092
> 
> Result before this patch:
>    skb hwtstamp is not found!
> 
> Result after this patch:
>    found skb hwtstamp = 1677800973.642836757
> 
> Optionally, read PHC to confirm the values obtained are almost the same:
> Command:
>    sudo ./testptp -d /dev/ptp0 -g
> Result:
>    clock time: 1677800973.913598978 or Fri Mar  3 07:49:33 2023
> 
> Fixes: fc9df2a0b520 ("igc: Enable RX via AF_XDP zero-copy")
> Cc: <stable@vger.kernel.org> # 5.14+
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> ---

Reviewed-by: Jesper Dangaard Brouer <brouer@redhat.com>

> v2 changelog:
>   - Fix indention
> ---
>   drivers/net/ethernet/intel/igc/igc_base.h | 7 +++++--
>   drivers/net/ethernet/intel/igc/igc_main.c | 5 ++++-
>   2 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_base.h b/drivers/net/ethernet/intel/igc/igc_base.h
> index 7a992befca24..b95007d51d13 100644
> --- a/drivers/net/ethernet/intel/igc/igc_base.h
> +++ b/drivers/net/ethernet/intel/igc/igc_base.h
> @@ -87,8 +87,11 @@ union igc_adv_rx_desc {
>   #define IGC_RXDCTL_SWFLUSH		0x04000000 /* Receive Software Flush */
>   
>   /* SRRCTL bit definitions */

I have checked Foxville manual for SRRCTL (Split and Replication Receive
Control) register and below GENMASKs looks correct.

> -#define IGC_SRRCTL_BSIZEPKT_SHIFT		10 /* Shift _right_ */
> -#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT		2  /* Shift _left_ */
> +#define IGC_SRRCTL_BSIZEPKT_MASK	GENMASK(6, 0)
> +#define IGC_SRRCTL_BSIZEPKT_SHIFT	10 /* Shift _right_ */

Shift due to 1 KB resolution of BSIZEPKT (manual field BSIZEPACKET)

> +#define IGC_SRRCTL_BSIZEHDRSIZE_MASK	GENMASK(13, 8)
> +#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT	2  /* Shift _left_ */

This shift is suspicious, but as you inherited it I guess it works.
I did the math, and it happens to work, knowing (from manual) value is
in 64 bytes resolution.

> +#define IGC_SRRCTL_DESCTYPE_MASK	GENMASK(27, 25)
>   #define IGC_SRRCTL_DESCTYPE_ADV_ONEBUF	0x02000000

Given you have started using GENMASK(), then I would have updated 
IGC_SRRCTL_DESCTYPE_ADV_ONEBUF to be expressed like:

  #define IGC_SRRCTL_DESCTYPE_ADV_ONEBUF 
FIELD_PREP(IGC_SRRCTL_DESCTYPE_MASK, 0x1)

Making it easier to see code is selecting:
  001b = Advanced descriptor one buffer.

And not (as I first though):
  010b = Advanced descriptor header splitting.


>   #endif /* _IGC_BASE_H */
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 25fc6c65209b..88fac08d8a14 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -641,7 +641,10 @@ static void igc_configure_rx_ring(struct igc_adapter *adapter,
>   	else
>   		buf_size = IGC_RXBUFFER_2048;
>   
> -	srrctl = IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;
> +	srrctl = rd32(IGC_SRRCTL(reg_idx));
> +	srrctl &= ~(IGC_SRRCTL_BSIZEPKT_MASK | IGC_SRRCTL_BSIZEHDRSIZE_MASK |
> +		    IGC_SRRCTL_DESCTYPE_MASK);
> +	srrctl |= IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;
>   	srrctl |= buf_size >> IGC_SRRCTL_BSIZEPKT_SHIFT;
>   	srrctl |= IGC_SRRCTL_DESCTYPE_ADV_ONEBUF;
>   

