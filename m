Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5B53D4135
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 21:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhGWTRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 15:17:48 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:39663 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhGWTRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 15:17:47 -0400
Received: by mail-pj1-f45.google.com with SMTP id k4-20020a17090a5144b02901731c776526so10489948pjm.4
        for <netdev@vger.kernel.org>; Fri, 23 Jul 2021 12:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jwa5ti/ORoAwUR5iyL8Ob16r47r/8vJd+eK+diYFsCs=;
        b=DsEyMCXG15PKEebJ5beQfWy0P4ChmNQJnznZfz6AZGh18a5N6bCsSA9r0lXIDuyMnX
         MWv3u5ZJnPdBGPoCRzDL39zBZxnP+0R60KqMUtIiz90/EvhClUu8gIA0CSNRwzs3l80J
         5AbEELFYAv2YepTIXTP8ROeAkF99zC8532G1nPteJIaOLMfUIlmUOCRidMIYngnr17Az
         DK9J6ynOJyx5s7Ok4CAsl4BjdgYwi3iuspc6eNclHCeof0x6H0Qk76SxmqcXVGFp2JuG
         ezOhNT+DljELD1tDgJd2mIa7K6svANNM/yIGg+F7rnVs796ngCvehxebV+H0Bahw6Cu7
         A2Ww==
X-Gm-Message-State: AOAM532+DTwN3ofCe05CRsYtZrW5pM84IZSn4G9Y9QK77x5WKB97AKAC
        sQtHHCZgtraupb7X+7kN3BA=
X-Google-Smtp-Source: ABdhPJwu04p+vMma++kGC8BhDw5Ta5Sy6G1a5C5fSsuYcx73W4xK6RtWNMXyQdz9JDtulNOJeXOrYg==
X-Received: by 2002:a65:4307:: with SMTP id j7mr6238422pgq.387.1627070299141;
        Fri, 23 Jul 2021 12:58:19 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:a676:ed9f:319b:a155? ([2601:647:4802:9070:a676:ed9f:319b:a155])
        by smtp.gmail.com with ESMTPSA id b3sm35814048pfi.179.2021.07.23.12.58.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jul 2021 12:58:18 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 00/36] nvme-tcp receive and tarnsmit offloads
To:     Christoph Hellwig <hch@lst.de>, Boris Pismenny <borisp@nvidia.com>
Cc:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com, smalin@marvell.com,
        boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Boris Pismenny <borisp@mellanox.com>
References: <20210722110325.371-1-borisp@nvidia.com>
 <20210723055626.GA32126@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <02c4e0af-0ae9-f4d9-d2ad-65802bdf036a@grimberg.me>
Date:   Fri, 23 Jul 2021 12:58:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210723055626.GA32126@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> * Add transmit offload patches
> 
> But to be honest, the previous one was already mostly unreviewable,
> but this is now far beyond this.   Please try to get anything that
> is generally useful first in smaller series and the come back with
> a somewhat reviewable series.  That also means that at least for the
> code I care about (nvme) the patches should be grouped together,
> and actually provide meaningful functionality in each patch.  Right
> now even trying to understand what you add to the nvme code requires
> me to jump all over a gigantic series.

I agree as well. It is difficult to review.
The order should be:
1. ulp_ddp interface
2. nvme-tcp changes
3. mlx5e changes

Also even beyond grouping patches together I have 2 requests:
1. Please consolidate ddp routines under a single ifdef (also minimize
the ifdef in call-sites).
2. When consolidating functions, try to do this as prep patches
documenting in the change log that it is preparing to add ddp. Its
difficult digesting both at times.
