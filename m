Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717696E301B
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 11:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjDOJeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 05:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjDOJeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 05:34:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98807F3
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 02:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681551207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yiqPklxUzRy8bqs+v/ZpMBXMKYs89gD+rYERGCmxvBI=;
        b=NSzsuY3nh20hYKR5r63/OntVkBwtUdSwYVQi5ne3bwsnVCvkSyp3REmpdB+pmQh/CQxb3U
        xdt51IRHR5Tp4EFPhnxO0Jc/Opk0PD1Z1dnhJVNyORgLgpmVw0E3RO0NLuy07NCU0cmrd3
        y00iarI++EwbiAty4ByULvjdJMz+hU0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-bUMUKV16PGKmOUcp2VqUow-1; Sat, 15 Apr 2023 05:33:26 -0400
X-MC-Unique: bUMUKV16PGKmOUcp2VqUow-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-94a348facbbso293452866b.1
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 02:33:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681551205; x=1684143205;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yiqPklxUzRy8bqs+v/ZpMBXMKYs89gD+rYERGCmxvBI=;
        b=hgEanJxEu9d03yMw5t64R+Yi2m1KL3OYTzUAm2uoVsfe9+NMI6GUZGSjYpQKTrhnfX
         eyLMZwiL+VKL1ZY3/EYWMLzas+jDKIrgmsBjkaiUqQ2y3Nj2eLyRab63S+Vq20sY8pSK
         JQ5jXJNLJ6DzsKqrf2GYMxzqWIEJ+yhz9gHYxQdO6iHjdSVr/Xp9tf3EYmgqbeTnvumg
         7etAezn3Y1mjvSKPMDRiYinNwcMhhdEKTDR7DNgBT1cf8JwkJMw7yH2yw4jkt5r0luWz
         EdCkvb2YCstQg4KEo4tzHWjk5kJWJtlR/DFFnoTy349vUFMG87C+xF/yhj/x96zYEIM7
         ZaWg==
X-Gm-Message-State: AAQBX9e1xuR043nZhS1SfApTpkmuNZr+0erLowvokY+S9ZSLS2l9HUXM
        QgtkvqDzvP5lC4E+VHGgQXev8HsKqKsaqwXRx5rxwHRjQr7jnZmASTQgIcE/ulKUvMlyl4HisHj
        mfa1n2hVx0M310YCO
X-Received: by 2002:aa7:d04e:0:b0:505:7d54:db93 with SMTP id n14-20020aa7d04e000000b005057d54db93mr8621901edo.21.1681551204995;
        Sat, 15 Apr 2023 02:33:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350YF2Zbojdxq6qbQxtDvNXENyG1SKgwEvrcmid1+4koV/BuLd+OMKg6WCD3kviyV5EY7ijM6YA==
X-Received: by 2002:aa7:d04e:0:b0:505:7d54:db93 with SMTP id n14-20020aa7d04e000000b005057d54db93mr8621886edo.21.1681551204598;
        Sat, 15 Apr 2023 02:33:24 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id o24-20020aa7c7d8000000b005067d089aafsm2138743eds.11.2023.04.15.02.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Apr 2023 02:33:24 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <164fc8a0-0248-76dc-be53-706eb36a9ec2@redhat.com>
Date:   Sat, 15 Apr 2023 11:33:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net
Subject: Re: [PATCH net-next v6 2/3] net: stmmac: add Rx HWTS metadata to XDP
 receive pkt
Content-Language: en-US
To:     Song Yoong Siang <yoong.siang.song@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
References: <20230415064503.3225835-1-yoong.siang.song@intel.com>
 <20230415064503.3225835-3-yoong.siang.song@intel.com>
In-Reply-To: <20230415064503.3225835-3-yoong.siang.song@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 15/04/2023 08.45, Song Yoong Siang wrote:
> Add receive hardware timestamp metadata support via kfunc to XDP receive
> packets.
> 
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> Acked-by: Stanislav Fomichev <sdf@google.com>
> ---
>   drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  3 ++
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 40 ++++++++++++++++++-
>   2 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> index ac8ccf851708..07ea5ab0a60b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
> @@ -94,6 +94,9 @@ struct stmmac_rx_buffer {
>   
>   struct stmmac_xdp_buff {
>   	struct xdp_buff xdp;
> +	struct stmmac_priv *priv;
> +	struct dma_desc *desc;
> +	struct dma_desc *ndesc;
>   };

Thanks for the adjustments.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

