Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0EB574500
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbiGNGTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbiGNGTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:19:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 040E51EEC9
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 23:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657779567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YSAUcCw+BVVj7SL3EFhD2Ia/nz9NzQL6FhyoJSb9EDw=;
        b=LiAsRa9w26LjX8FVkL60PDT8GhRkA1YHLVb7h44Cf2BcYnjyCeBmzWs5r2fN9RQBgaKlTM
        nDof9BhdRZfPN/2TXsSlXZEwslRknP2jDl5sSw2YvjluDE0+r8qHnO+jPsWrK6w1yJjx7T
        8urS/oQo31PklSo8t0OOBwaHEoKYtiw=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-KDiHC1JsMBqc_gpV-02Nug-1; Thu, 14 Jul 2022 02:19:25 -0400
X-MC-Unique: KDiHC1JsMBqc_gpV-02Nug-1
Received: by mail-pj1-f71.google.com with SMTP id q8-20020a17090a304800b001ef82a71a9eso868935pjl.3
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 23:19:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YSAUcCw+BVVj7SL3EFhD2Ia/nz9NzQL6FhyoJSb9EDw=;
        b=glLD7bG9TdjHYWt+8e6pxPalpihy6kaY0z6UiDU16T1l0BixdCrX27K7N91COBOJSC
         JOvcSidd/s2lH4ZHQThSJa6iOvY0bJQFhw8SIcKXT9pBm/ofG5mcY3YV8QBV5gXcgdr9
         uZo3ghy7dAxtT4JagZee5Vm/fHXEh3wOhXQCwBeSLfXXEQelBbvFkX42aHTMGVOYJE4G
         cJdr/zlFFYX0RwS/VPxfNoOKDeSRkKjTq8GObVExcBrlrqb2bwDYBK661qHQovrFCzHZ
         KVqrU7funkwjJVUMgJy2oRymFqsMywfayLYSPmmQdmRWqwsPpnIH9GkywmkPCynGTUSM
         aJDg==
X-Gm-Message-State: AJIora/TbGR9Bf8TPnpWFJPYpXga8zV3Kq+kdBb13mcpB5AdqFF2EB0W
        yqJeafMYIT/H4KmAWEk8VZI2PFUZkmga7s21ZB0owyCuKKaODGCrEbFt2nLLXpcNK1FX/qcu52S
        1MvKXo3Aqu0qhoFDf
X-Received: by 2002:a17:90b:2241:b0:1f0:2fa5:184f with SMTP id hk1-20020a17090b224100b001f02fa5184fmr14379931pjb.97.1657779564334;
        Wed, 13 Jul 2022 23:19:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sL/XG3riG2ObmMrVF+Y5ekbQT6YwYihdbnkHMcrW2c8Ks8pbP26wDt0Yqy1CxOTenFZZW+uA==
X-Received: by 2002:a17:90b:2241:b0:1f0:2fa5:184f with SMTP id hk1-20020a17090b224100b001f02fa5184fmr14379917pjb.97.1657779564076;
        Wed, 13 Jul 2022 23:19:24 -0700 (PDT)
Received: from [10.72.12.153] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l13-20020a17090a598d00b001ef86a1330csm564866pji.34.2022.07.13.23.19.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jul 2022 23:19:23 -0700 (PDT)
Message-ID: <55c50d9a-1612-ed2c-55f4-58a5c545b662@redhat.com>
Date:   Thu, 14 Jul 2022 14:19:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH v2] net: virtio_net: notifications coalescing support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220712112210.2852777-1-alvaro.karsz@solid-run.com>
 <20220713200203.4eb3a64e@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220713200203.4eb3a64e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/14 11:02, Jakub Kicinski 写道:
>> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
>> index 3f55a4215f1..29ced55514d 100644
>> --- a/include/uapi/linux/virtio_net.h
>> +++ b/include/uapi/linux/virtio_net.h
> Is it typical for virtio to add the structures to uAPI even tho the
> kernel does not consume them? I presume so, just wanted to flag it.
>

Yes, Qemu will sync and use Linux uapi headers like this.

Thanks

