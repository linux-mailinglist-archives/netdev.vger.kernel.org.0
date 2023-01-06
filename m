Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 692576603D9
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjAFQDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjAFQDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:03:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B686145E
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 08:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673020955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j90Xt8Ts2ietXcz4j40MnjOFaTO/oFytbPV2LKL2Wi0=;
        b=KHY0OXdGtnYPAPnGjeV3xiVmMqNDsNlXKvlsnokdwtiEUp4AlVbIRyM5N/OKC8QA+fgdK4
        RJjihs2S51rhyTkAJEeZxOmNxCntbvxm4AFowP1XujwL/MP7oZv457GT0NtVVJgYGjN9Ur
        zddbRhtgRI0icIJE7/PbnlZV7CY3dYU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-74-Nv-BxhEEPLCbLr0LuxaqNg-1; Fri, 06 Jan 2023 11:02:33 -0500
X-MC-Unique: Nv-BxhEEPLCbLr0LuxaqNg-1
Received: by mail-ed1-f69.google.com with SMTP id e6-20020a056402190600b0048ee2e45daaso1489859edz.4
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 08:02:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j90Xt8Ts2ietXcz4j40MnjOFaTO/oFytbPV2LKL2Wi0=;
        b=0DCa7ACmbeTlmvwZMzDhuyHjfdbJ27Xvisewsuoy1R4XTDPvJVcfD2K3DmCn5h+x4M
         QFM+ABdIWj6LsGC/dyddGBkms/PBOtRlcfuIOnvk2g+AStFXY6mTcWRWiP1FL845sZZ9
         mtefiaRYs13KtZywRuDwlYYIuBJNkiF6Vh9s1rWPAU/IN3EMxqe8DVbDhFUE1SIrpVjc
         jh7lqmvqXYoq8ytEjvV4k8+LQ+LqsbLDz77pck3B0HqjgRhz+ZTvKxr+nK22rnmcNIsH
         AurFk/cEIKI8NZobBZebuR2to3IvlamnfKTCvRq/MEQTcTvy8E0DqzMGHLrFDqEfBB4m
         WUAA==
X-Gm-Message-State: AFqh2ko9j5aSrW53pApv1CfeQfSruvKCbP66t3hNdVf7lWp/53qtfyYD
        Vr+PErhOaVORVUrF6OCgZ2wBhMtAP+O/tQzfl9C4e4yRnVmTkZckxBXnh7vfr+/dRJgXMmQay4+
        9pu1ijrSyeotjbZ5z
X-Received: by 2002:a17:906:4d58:b0:7c4:fa17:7204 with SMTP id b24-20020a1709064d5800b007c4fa177204mr46361160ejv.7.1673020951997;
        Fri, 06 Jan 2023 08:02:31 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvAYBNiA7yroTtW6RPSpXLwl1eWMuSX8g6bgY8m4+1NUX/HURvRXweMT7CqUdyiWbn2Pbb/DA==
X-Received: by 2002:a17:906:4d58:b0:7c4:fa17:7204 with SMTP id b24-20020a1709064d5800b007c4fa177204mr46361146ejv.7.1673020951800;
        Fri, 06 Jan 2023 08:02:31 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id sh39-20020a1709076ea700b0084c62b9eb57sm519802ejc.144.2023.01.06.08.02.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 08:02:31 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <c5896729-2114-6d4c-e581-d9209c5a8972@redhat.com>
Date:   Fri, 6 Jan 2023 17:02:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 21/24] page_pool: Pass a netmem to init_callback()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-22-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-22-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/01/2023 22.46, Matthew Wilcox (Oracle) wrote:
> Convert the only user of init_callback.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   include/net/page_pool.h | 2 +-
>   net/bpf/test_run.c      | 4 ++--
>   net/core/page_pool.c    | 2 +-
>   3 files changed, 4 insertions(+), 4 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

