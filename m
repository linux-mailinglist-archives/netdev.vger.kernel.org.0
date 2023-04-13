Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C60FE6E14D2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 21:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjDMTGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 15:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDMTGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 15:06:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14E576B9
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681412736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UCBVyFd5BBmA+6Xv/IIgNhhtsz0B8DYXHt8AQVnFyEY=;
        b=ADZ53R42VBZxh8v38I9Xot5FvqsXejzzFSD5/8ggefm2wP9Pw+WhRxmNjrmerEPI7wJ6zi
        5D7weuwiYNx5XmDxC1mAjQNmOLPxpKMHkCzW8kftROq95hDsSVrjsBuoLVCyvMMW/Lvgi2
        4jn3epuqvvN83ARin0EZJl5XVSK0Mns=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-361-DD6Ii0OLM26JiNVbtiksvw-1; Thu, 13 Apr 2023 15:05:35 -0400
X-MC-Unique: DD6Ii0OLM26JiNVbtiksvw-1
Received: by mail-ed1-f70.google.com with SMTP id f25-20020a50a6d9000000b005049299346fso8200898edc.2
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:05:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681412734; x=1684004734;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UCBVyFd5BBmA+6Xv/IIgNhhtsz0B8DYXHt8AQVnFyEY=;
        b=iq5fsL/MQoFfe6g75Mxui87h28wiQnFmGLbBtDoSvK6DZmy6FscqpEPiPvO1Dsuuyo
         PPNPCzgOHc0JXwIng0VvT8mBklWVfQf0XdpS/+VAV4i/dgi++C/rq97/FPK0/pjc1ij1
         ck31Gto9vo9B6+I/zYYxSnbhmPal6hVoxa3y/mmhtQ4HPNI9ArFd0Kix+ZcYwE+Jy1e/
         KH9AAD6XSVZ7/wZffLSmoVGT6X4DWGOsC3BzufEqLJ0gwRQwv12zIMRY3lbPd6WqNNGu
         BKNuQG06J+KZUMybaWhCaikECZTSCuROIVoLmitKq6G+UoBRBqKWF8VCtmuFBUSPzUNH
         qf4g==
X-Gm-Message-State: AAQBX9eOvlXcyHNeQaDVHstBf5BpCfoqpQrjErTX0YnaoFlRogGkrC3k
        dwEm2Gm4diclzWH8yP7ofx2NfYywTzAYA9s8ig7zvyAYtSVn7VSEHiXFjWBWd+rqUx2uQUXdFo3
        RoUOVJRP3s9tPasf9
X-Received: by 2002:a17:907:7783:b0:92b:f118:ef32 with SMTP id ky3-20020a170907778300b0092bf118ef32mr3344072ejc.48.1681412734063;
        Thu, 13 Apr 2023 12:05:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350b0NoeyqPTndxzzpsGhufBoItrSucdDKVSwz86SIeJfM9Bqvf0Y1jAxX92P52cAl7P9mNqd0A==
X-Received: by 2002:a17:907:7783:b0:92b:f118:ef32 with SMTP id ky3-20020a170907778300b0092bf118ef32mr3344059ejc.48.1681412733732;
        Thu, 13 Apr 2023 12:05:33 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id gz1-20020a170907a04100b0094a6ba1f5ccsm1368474ejc.22.2023.04.13.12.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 12:05:33 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e7d81a89-da60-1da6-7966-7739ad545834@redhat.com>
Date:   Thu, 13 Apr 2023 21:05:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        stable@vger.kernel.org
Subject: Re: [PATCH net 1/1] igc: read before write to SRRCTL register
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
        Stanislav Fomichev <sdf@google.com>
References: <20230413151222.1864307-1-yoong.siang.song@intel.com>
In-Reply-To: <20230413151222.1864307-1-yoong.siang.song@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13/04/2023 17.12, Song Yoong Siang wrote:
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
[...]
> diff --git a/drivers/net/ethernet/intel/igc/igc_base.h b/drivers/net/ethernet/intel/igc/igc_base.h
> index 7a992befca24..b95007d51d13 100644
> --- a/drivers/net/ethernet/intel/igc/igc_base.h
> +++ b/drivers/net/ethernet/intel/igc/igc_base.h
> @@ -87,8 +87,11 @@ union igc_adv_rx_desc {
>   #define IGC_RXDCTL_SWFLUSH		0x04000000 /* Receive Software Flush */
>   
>   /* SRRCTL bit definitions */
> -#define IGC_SRRCTL_BSIZEPKT_SHIFT		10 /* Shift _right_ */
> -#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT		2  /* Shift _left_ */
> +#define IGC_SRRCTL_BSIZEPKT_MASK	GENMASK(6, 0)
> +#define IGC_SRRCTL_BSIZEPKT_SHIFT	10 /* Shift _right_ */
> +#define IGC_SRRCTL_BSIZEHDRSIZE_MASK	GENMASK(13, 8)
> +#define IGC_SRRCTL_BSIZEHDRSIZE_SHIFT	2  /* Shift _left_ */
> +#define IGC_SRRCTL_DESCTYPE_MASK	GENMASK(27, 25)
>   #define IGC_SRRCTL_DESCTYPE_ADV_ONEBUF	0x02000000
>   
>   #endif /* _IGC_BASE_H */
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 25fc6c65209b..de7b21c2ccd6 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -641,7 +641,10 @@ static void igc_configure_rx_ring(struct igc_adapter *adapter,
>   	else
>   		buf_size = IGC_RXBUFFER_2048;
>   
> -	srrctl = IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;
> +	srrctl = rd32(IGC_SRRCTL(reg_idx));
> +	srrctl &= ~(IGC_SRRCTL_BSIZEPKT_MASK | IGC_SRRCTL_BSIZEHDRSIZE_MASK |
> +		  IGC_SRRCTL_DESCTYPE_MASK);
                   ^^
Please fix indention, moving IGC_SRRCTL_DESCTYPE_MASK such that it
aligns with IGC_SRRCTL_BSIZEPKT_MASK.  This make is easier for the eye
to spot that it is part of the negation (~).

> +	srrctl |= IGC_RX_HDR_LEN << IGC_SRRCTL_BSIZEHDRSIZE_SHIFT;
>   	srrctl |= buf_size >> IGC_SRRCTL_BSIZEPKT_SHIFT;
>   	srrctl |= IGC_SRRCTL_DESCTYPE_ADV_ONEBUF;
>   

