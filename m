Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BBE3A1166
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbhFIKtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:49:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238492AbhFIKta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:49:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623235655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l4wI9TUgwebBtcJu8KunXfdxhxFN31VCnuQ/kJr2Jiw=;
        b=BVwf0W1WNB+TqkJgM4FgQKDFIlWmqn3njJ+ol7q/1z9rsaiEqx/5WV7IDqduF2BdJKT1kw
        gD3ZCFtgYiEwhiPu4pnGlk76faq358sRLmjrXoQeJ4p+IZc4kaoQmDgrUv0BZUm3wbb5Z6
        49ygz39gj4FKrEskN1srwAdkguVtlQs=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-472-lyeQ1iq1PDip4TjuVF9jGg-1; Wed, 09 Jun 2021 06:47:34 -0400
X-MC-Unique: lyeQ1iq1PDip4TjuVF9jGg-1
Received: by mail-qv1-f71.google.com with SMTP id g17-20020a0caad10000b029021886e075f0so17659378qvb.15
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 03:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=l4wI9TUgwebBtcJu8KunXfdxhxFN31VCnuQ/kJr2Jiw=;
        b=iePKEIKOuZtw+BTW0YEW2uTfl/e/REebTjY4axLAo960YpAzfDzMtDmVtfOBbPeYD4
         sIzcM2eHSLYY2XsMpRv8nglpR5TUpImdxs5pUFwMvhN5BBe2cstyuJHyTlmMvjw0haEW
         LVzDLzP+Aukr4mRhfynKzMWtPYMaLwUXg3OA/ClCuOyaoJVqOgJvwBfC5akN+hdj0OWn
         Qaq9jgWkPlRaXr4DJWWq8qphTIhiRVCdPDYSHH+0WWdQOapYFLsW9+Hk3JjDRIcN4rj9
         2Qy8KoxaR1AgsLN71bEcbli+wG3wtsYRfgALw/qgYlTavASryNBzdAh4+HfWSbzdbBuc
         2jhQ==
X-Gm-Message-State: AOAM532tbQVhaePe7r5OeqipT1GG3AtheVkOnnJhWsQGfCvIOTNnVPap
        oZJ2/eDwXjAbK/nTUM7rCsvhK62cS351GR6kkVH0+TMA/kemLNNlKa/GsfEMW7k+NRxJPJk1AGu
        YwIj6MwWAvhzRWFYa
X-Received: by 2002:a0c:83e1:: with SMTP id k88mr5187183qva.40.1623235654156;
        Wed, 09 Jun 2021 03:47:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxyuPdC4YjpCJVo0T592xKUQnvy9FswLTlTEEIRBoGnM06yco8eLchZ9Yx0UBzn05zFEI47w==
X-Received: by 2002:a0c:83e1:: with SMTP id k88mr5187170qva.40.1623235653946;
        Wed, 09 Jun 2021 03:47:33 -0700 (PDT)
Received: from [192.168.0.106] ([24.225.235.43])
        by smtp.gmail.com with ESMTPSA id h6sm3665234qta.65.2021.06.09.03.47.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 03:47:33 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 0/2] net: tipc: fix FB_MTU eat two pages and
 do some code cleanup
To:     menglong8.dong@gmail.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
References: <20210609103251.534270-1-dong.menglong@zte.com.cn>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <672e78df-5bb0-78eb-3022-f942978138f5@redhat.com>
Date:   Wed, 9 Jun 2021 06:47:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609103251.534270-1-dong.menglong@zte.com.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/21 6:32 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
>
> In the first patch, FB_MTU is redefined to make sure data size will not
> exceed PAGE_SIZE. Besides, I removed the alignment for buf_size in
> tipc_buf_acquire, because skb_alloc_fclone will do the alignment job.
>
> In the second patch, I removed align() in msg.c and replace it with
> ALIGN().
>
>
>
>
> Menglong Dong (2):
>    net: tipc: fix FB_MTU eat two pages
>    net: tipc: replace align() with ALIGN in msg.c
>
>   net/tipc/bcast.c |  2 +-
>   net/tipc/msg.c   | 31 ++++++++++++++-----------------
>   net/tipc/msg.h   |  3 ++-
>   3 files changed, 17 insertions(+), 19 deletions(-)
>
NACK.
You must have missed my last mail before you sent out this.  We have to 
define a separate macro for bcast.c, since those buffers sometimes will 
need encryption.
Sorry for the confusion.
///jon

