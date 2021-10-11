Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98310428CF6
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 14:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbhJKM1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 08:27:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35724 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235215AbhJKM1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 08:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633955113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T3zAWzIKdBqZq9Xwiz2ll75TQr/yx0cu//oyDWg5EQ8=;
        b=XWXlgmsP+qg/RAtlnOqYVXfUTKL3sXCwzJ30Z372u0jGQ4tD+B7QI/mKJcD2WaeEC1YVey
        bJZ+9e9kGcwP5YffgP1607r1vopMnXEyK7pScY6uBqg6Oy3N3gI7bBKD4kNKBNYqKf2YD/
        vIbDoIo/tC8rL+2J1OJP4r55ro+EJ/g=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-levhF6KoPAOBfpxVngaFYA-1; Mon, 11 Oct 2021 08:25:12 -0400
X-MC-Unique: levhF6KoPAOBfpxVngaFYA-1
Received: by mail-ed1-f69.google.com with SMTP id x5-20020a50f185000000b003db0f796903so15713748edl.18
        for <netdev@vger.kernel.org>; Mon, 11 Oct 2021 05:25:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T3zAWzIKdBqZq9Xwiz2ll75TQr/yx0cu//oyDWg5EQ8=;
        b=XM18+Noy0devfRwOnmvz9hasPyGB8Fcyg1YPkh6J7O9CDSq/DwkxFJMO6YPMy1eD/A
         +vHM7Xn8l3dAu5DiQCSq0KqR9wsaMoEmd75/8ExbVr2wdWCdYJc2qG20jKKg4NxblS4d
         l7lJW8NwYwZvaae+ZiSnGqXxBzdzkO6K+vzLAZ07YAelyIxmFSL0FcvLJ6LWR6XkT6uU
         ftPNgq6FAQpyYmkzLJUK/iqjgtoc976slMDHfT+GsmwgEQMCZijZs5K2ZkJvUDkYjTRv
         DE5MrqXC50wA8W5EYHI2Qpw+m/FpWUcNHlBAcYiUINhvM+ebi0jzFZxkTCzbDlC8Jhc9
         d4Hw==
X-Gm-Message-State: AOAM5328kH4Ht3rQTpNcuT+jTRt3g00uUb6qzPtEo73xonx2Ds2fNnZL
        gS1m4zDMe+nFJw4sG9Po/zvoyGltnqYytNah7M7Xppfcpmx+GKVF6jQZEuPFEc3TEfTgReIb7/q
        DoAoMrtfX4xKHL0Wp
X-Received: by 2002:a17:906:7c4:: with SMTP id m4mr25582742ejc.553.1633955111394;
        Mon, 11 Oct 2021 05:25:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMkKRUivOyezCE/Qq49qiXBy/5IKJPHBk/2vxQg4LVt9cwI4vY6x2I3qgFIDLIirERgFgLzg==
X-Received: by 2002:a17:906:7c4:: with SMTP id m4mr25582712ejc.553.1633955111251;
        Mon, 11 Oct 2021 05:25:11 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id p25sm2162321edt.23.2021.10.11.05.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 05:25:10 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        akpm@linux-foundation.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, peterz@infradead.org,
        yuzhao@google.com, will@kernel.org, willy@infradead.org,
        jgg@ziepe.ca, mcroce@microsoft.com, willemb@google.com,
        cong.wang@bytedance.com, pabeni@redhat.com, haokexin@gmail.com,
        nogikh@google.com, elver@google.com, memxor@gmail.com,
        vvs@virtuozzo.com, linux-mm@kvack.org, edumazet@google.com,
        alexander.duyck@gmail.com, dsahern@gmail.com
Subject: Re: [PATCH net-next -v5 3/4] mm: introduce __get_page() and
 __put_page()
To:     John Hubbard <jhubbard@nvidia.com>,
        Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
References: <20211009093724.10539-1-linyunsheng@huawei.com>
 <20211009093724.10539-4-linyunsheng@huawei.com>
 <62106771-7d2a-3897-c318-79578360a88a@nvidia.com>
Message-ID: <89bcc42a-ad95-e729-0748-bf394bf770be@redhat.com>
Date:   Mon, 11 Oct 2021 14:25:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <62106771-7d2a-3897-c318-79578360a88a@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 09/10/2021 21.49, John Hubbard wrote:
> So in case it's not clear, I'd like to request that you drop this one
> patch from your series.

In my opinion as page_pool maintainer, you should also drop patch 4/4 
from this series.

I like the first two patches, and they should be resend and can be 
applied without too much further discussion.

--Jesper

