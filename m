Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8F91D1DD3
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390269AbgEMSpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:45:46 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38905 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390103AbgEMSpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 14:45:43 -0400
Received: by mail-pg1-f193.google.com with SMTP id u5so141840pgn.5;
        Wed, 13 May 2020 11:45:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oGExS5qpyhaJE9sRdyvo65rhkDZrEjTLCCqtKDwIC/k=;
        b=TS/6HqhyaUBitGN4hJlVvmHSFhkuo70+216kyjBQDE1WZjef3NGT/YuohVXnCKZr7z
         K4PJgBtP1wkjYZNeHCOUTKvZeggbMRYrUPv0kGtbOUxxXjB0868SRXo5nj2JebjktftL
         IvFmHQJqsyhNa8c5iPBpd2+wzW660tNQcojBVoZiRfU5OQi/BBL8H9pan2p7VymaHAko
         wN1u32p6TWkDOYso15HTxqJL2328FnrUWVcyLCaXGnAsP+fN/vTBcapBq/2ZVUH2B6AY
         +NlLPGmghXU30Cq1kmHJcpUU1RbuVGxR1r3omjcrYaogMV8KW2lJad5a5hzsFuqNzKKL
         X/SQ==
X-Gm-Message-State: AOAM5338Ixu2NVbtVMVyhA5hkSRag2/BM++OtuHK2zdZiRvOSVvkWnr8
        Mmya9dyMxMYZK56jbGtBOn4=
X-Google-Smtp-Source: ABdhPJxuCtZ6LqG/D7UsLLlMEE3Gj8Q00WqSwzmkuBnzsqf4vGt4xYIyJ/k3v57Ipr7A3TPHVfXEFQ==
X-Received: by 2002:a62:7d91:: with SMTP id y139mr631244pfc.172.1589395542971;
        Wed, 13 May 2020 11:45:42 -0700 (PDT)
Received: from ?IPv6:2601:647:4802:9070:59e0:deac:a73c:5d11? ([2601:647:4802:9070:59e0:deac:a73c:5d11])
        by smtp.gmail.com with ESMTPSA id g10sm238580pfk.103.2020.05.13.11.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 11:45:41 -0700 (PDT)
Subject: Re: remove kernel_setsockopt and kernel_getsockopt
To:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-nvme@lists.infradead.org, linux-sctp@vger.kernel.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        drbd-dev@lists.linbit.com, linux-cifs@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        cluster-devel@redhat.com, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, Vlad Yasevich <vyasevich@gmail.com>,
        linux-kernel@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, ocfs2-devel@oss.oracle.com
References: <20200513062649.2100053-1-hch@lst.de>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <2c9a28f7-4268-2295-0d64-ada9178a5553@grimberg.me>
Date:   Wed, 13 May 2020 11:45:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200513062649.2100053-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Hi Dave,
> 
> this series removes the kernel_setsockopt and kernel_getsockopt
> functions, and instead switches their users to small functions that
> implement setting (or in one case getting) a sockopt directly using
> a normal kernel function call with type safety and all the other
> benefits of not having a function call.
> 
> In some cases these functions seem pretty heavy handed as they do
> a lock_sock even for just setting a single variable, but this mirrors
> the real setsockopt implementation - counter to that a few kernel
> drivers just set the fields directly already.
> 
> Nevertheless the diffstat looks quite promising:
> 
>   42 files changed, 721 insertions(+), 799 deletions(-)

For the nvme-tcp bits,

Acked-by: Sagi Grimberg <sagi@grimberg.me>
