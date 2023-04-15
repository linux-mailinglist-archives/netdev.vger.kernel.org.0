Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710B56E3021
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 11:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbjDOJff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 05:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDOJfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 05:35:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24243C13
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 02:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681551284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZxPnWAcQVBNBNS9KRY2KFLNjYwkNYHKUC4oRsplfh2c=;
        b=UYWTlVgkphQlkSTddG2aOLCk4mcA0eJRNbkWa3J/1+cnT0SbIs+Qx5as4PMq71cXbvBjeq
        b7WXbbBTW9hNkEdC60gcp95B6zYPGv6tgewOXdT6qVt5MMNs+zR2cL6pItjcJGil/QhUdQ
        DTpkBWgXqIlDT5lH068vW8BDw3kTCWE=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-lr12U3eSPIy92HR50yq0gQ-1; Sat, 15 Apr 2023 05:34:43 -0400
X-MC-Unique: lr12U3eSPIy92HR50yq0gQ-1
Received: by mail-ej1-f71.google.com with SMTP id ud12-20020a170907c60c00b0093c44a07ad1so7417390ejc.2
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 02:34:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681551282; x=1684143282;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxPnWAcQVBNBNS9KRY2KFLNjYwkNYHKUC4oRsplfh2c=;
        b=DdZ1m1L5ZK2G4EgRfIiG6pcjVc3bXZcQcIJD5CqP/xDiEd0XhULS1SduwJXC7J8aug
         1ijABGu0ntRBwo5lD6hi8uI3TQtz4MPInwQUseT40I7pr1OPZZWOF/rGIkVSSkyLymKR
         Nyqy4tZwOGriXpoF1iazjYqy3uS4UlKlIFaNrBZJ7UgJBn/e40nxMmQmKiJIkSwLOA36
         +HiTXOrTtdYS+wnGgAMnNizke2wKMsGA+m2oMwDbkxOCBgdGfZS//KMruiMQZM5s0JW4
         E+MOOLtRfw8TW8Htlcf/GaVDVn7202MLem5AZPiNOb/pZqiFSSs/3p09K2zDJSEJQM56
         Qcdw==
X-Gm-Message-State: AAQBX9ftsS4n8W3Ry5ek6Ai3tcrhOhK1XqBOVqTm+FNMHt1sLuxiCwuE
        YFT2GZ96ABh31j3GsrskUV4AQrGUI9a2b8SxcgpqYK2/PM8EEWfeiYkJUWC6UhRMlurScf/40j6
        RAc8uuHaxYCXoVnDn
X-Received: by 2002:a17:906:6bd0:b0:94e:f969:fb3e with SMTP id t16-20020a1709066bd000b0094ef969fb3emr1661563ejs.43.1681551282639;
        Sat, 15 Apr 2023 02:34:42 -0700 (PDT)
X-Google-Smtp-Source: AKy350ahABqOGqRCJSwv9+bd3MwJOCg8HOEo/vfDe75jx4W55RgExcuyfQKh2L9CES3tCsodbIai/w==
X-Received: by 2002:a17:906:6bd0:b0:94e:f969:fb3e with SMTP id t16-20020a1709066bd000b0094ef969fb3emr1661531ejs.43.1681551282362;
        Sat, 15 Apr 2023 02:34:42 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id b22-20020a1709062b5600b009306ebc79d3sm3549540ejg.59.2023.04.15.02.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Apr 2023 02:34:41 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <eb277f26-932b-d1b5-ec67-5aee2bd0a287@redhat.com>
Date:   Sat, 15 Apr 2023 11:34:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net
Subject: Re: [PATCH net-next v6 3/3] net: stmmac: add Rx HWTS metadata to XDP
 ZC receive pkt
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
 <20230415064503.3225835-4-yoong.siang.song@intel.com>
In-Reply-To: <20230415064503.3225835-4-yoong.siang.song@intel.com>
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
> Add receive hardware timestamp metadata support via kfunc to XDP Zero Copy
> receive packets.
> 
> Signed-off-by: Song Yoong Siang<yoong.siang.song@intel.com>
> ---
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c | 22 +++++++++++++++++++
>   1 file changed, 22 insertions(+)

LGTM

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

