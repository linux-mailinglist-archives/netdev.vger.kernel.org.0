Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383B66178A8
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 09:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiKCI1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 04:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKCI06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 04:26:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE7E65B1
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 01:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667463957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ESwUy2eq+4xGlz2gugPeoCeYS+tEl3uNRsE/pkcv4uU=;
        b=hRPiGh8g1xFkbcaOhevBZe/wv6jlx9eslU6SsG5Lr+srIFrTrqJtRz6hcS/V0C7kN4mNEo
        dL+dq3dt0a3mzTY/Oi2j4nOrv2iKMC3w3SyN7dYIG3pnZIu+7K5cAH0VBNz5kDfjH+Xk8l
        3L019I11T2Fqeeokd86l6Mrnz55vbRQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-170-jQfrisq4NPygTClzMYjDWg-1; Thu, 03 Nov 2022 04:25:54 -0400
X-MC-Unique: jQfrisq4NPygTClzMYjDWg-1
Received: by mail-qk1-f198.google.com with SMTP id x22-20020a05620a259600b006b552a69231so1378862qko.18
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 01:25:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ESwUy2eq+4xGlz2gugPeoCeYS+tEl3uNRsE/pkcv4uU=;
        b=Q/IYSSFu5Teu2SDlmtpgEY4RceelWphkXx6YDEArdZ9uZvQxH7xYJvb/XHzF9ASq+X
         xat/PPR/mNajifhTqT4bugDa4NV0QWJH5Y4wNblrxrbLd3AeJ4LvkfHjkM0hLayoPpAQ
         YNoEdhHLc5qV7qNUTYEQDHu1zxDhB7lHv4Zb6WjJsXByJ7/kquCtprEDknZ/bZUTK0Kj
         WemdmmJD7so+45kHNoJumFevoKb+QaGIf9fW9o2AcRXQY9E7VQZn3RJHb6SPlzWuy5wt
         RC/Ds9eaURE2hnw8JlHsGPhlXPjQbHgzLAx2c0f9q7kXn7x/5QsNWztMWAAKOz1NBZSc
         Twjw==
X-Gm-Message-State: ACrzQf1fRsfOOVnD+7UIoSD0UtySEhzDBME0CqmpKXCGRzIlRr0irKrA
        HnowFjyzS9VwzFOWACsT2AuA+otgSluRaWHTWwY3difymZW7spUHH/I1SddCGkOJhQ141sCxfAd
        ClhZe6itw5UzG30/G
X-Received: by 2002:ad4:5dee:0:b0:4b4:b8a:78db with SMTP id jn14-20020ad45dee000000b004b40b8a78dbmr25706652qvb.12.1667463954007;
        Thu, 03 Nov 2022 01:25:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5lfV1vi64B14zB3N7D3MkOiVDGIgQ3osl+x4gB5yM3fepRQCIsPO64MdGMmDacIaHFZ9iXbg==
X-Received: by 2002:ad4:5dee:0:b0:4b4:b8a:78db with SMTP id jn14-20020ad45dee000000b004b40b8a78dbmr25706639qvb.12.1667463953770;
        Thu, 03 Nov 2022 01:25:53 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-100-54.dyn.eolo.it. [146.241.100.54])
        by smtp.gmail.com with ESMTPSA id o23-20020ac85557000000b0035badb499c7sm133825qtr.21.2022.11.03.01.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 01:25:53 -0700 (PDT)
Message-ID: <477a37b80b01d5eaa895effa20df29bcf02f65b6.camel@redhat.com>
Subject: Re: [PATCH] uapi: Add missing linux/stddef.h header file to in.h
From:   Paolo Abeni <pabeni@redhat.com>
To:     Yang Jihong <yangjihong1@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, keescook@chromium.org,
        gustavoars@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org, acme@kernel.org
Date:   Thu, 03 Nov 2022 09:25:49 +0100
In-Reply-To: <20221031095517.100297-1-yangjihong1@huawei.com>
References: <20221031095517.100297-1-yangjihong1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-10-31 at 17:55 +0800, Yang Jihong wrote:
> commit 5854a09b4957 ("net/ipv4: Use __DECLARE_FLEX_ARRAY() helper") does not
> include "linux/stddef.h" header file, and tools headers update linux/in.h copy,
> BPF prog fails to be compiled:
> 
>     CLNG-BPF [test_maps] bpf_flow.bpf.o
>     CLNG-BPF [test_maps] cgroup_skb_sk_lookup_kern.bpf.o
>   In file included from progs/cgroup_skb_sk_lookup_kern.c:9:
>   /root/linux/tools/include/uapi/linux/in.h:199:3: error: type name requires a specifier or qualifier
>                   __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
>                   ^
>   /root/linux/tools/include/uapi/linux/in.h:199:32: error: type specifier missing, defaults to 'int' [-Werror,-Wimplicit-int]
>                   __DECLARE_FLEX_ARRAY(__be32, imsf_slist_flex);
>                                                ^
>   2 errors generated.
> 
> To maintain consistency, add missing header file to kernel.
> Fixes: 5854a09b4957 ("net/ipv4: Use __DECLARE_FLEX_ARRAY() helper")
> 
> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>

The 'Fixes' tag must be separated by the commit message by a blank
line, and you need to remove the empty line between 'Fixes' and SoB.

Additionally, on repost, please specify the target tree in the patch
subj, and wrap the commit message text to 75 chars per line (that does
not apply to the build output).

Thanks,

Paolo

