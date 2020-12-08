Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F26C2D1F27
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 01:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgLHAlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 19:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbgLHAlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 19:41:11 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66961C0611E4
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 16:39:46 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id f16so14352687otl.11
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 16:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U4k5wKBczYHBTO62E0uZ8Zf8NuwGQyb1owA7NqdovSM=;
        b=GkeXKtPADgX0hh+zlMBORIWKeNxE98QJlU+epcTcdDSvMp8N5U0U4Cr9+8vs6kWv6C
         hx6YdtDArg2EEAbiAXqQWqNOX6HpAPfKNp/6X9TXpzK9c6Gweb5FRH58lCmJm5GvMrty
         9TcgLtEVDDS0r/czCCSX6nBlVEKRRB4XMlXeBDbKrjQh/Ttryf9uDk76EvxB1l6oHLur
         1bP9/SEQ2/H5cKCTwbBsgrJjrO+QrqgydjeqN4V7dna3/zKX+FHDJ/jCMbxSZ8smPLp+
         UXHRy1nwc6SotPmQp6YzZpnyfa99UTfXrVR1idsRXYIfcxlbWBVLQo296UiFbb55vNJM
         zQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U4k5wKBczYHBTO62E0uZ8Zf8NuwGQyb1owA7NqdovSM=;
        b=f8bFVfxQA5Aq08UR4yiOEmj6QQZLgHbkCwPJFWLXQTuBwuWqgIrbhJDCKAWi9M9OQd
         PJWw4SzyhhbMtseaCpeJsqTCx9yfnhzeZarNI7LPTSbztIiA+X5/PGpX8hNFlEnZfKX5
         j//Fur4gXpCKPCWuxqj+AuA7qFoauPx3zGWMj675O8G3wUwl5xDWzk8t/Wk/8a/hYkke
         Ia045yimq879feQItZjcqcEAHkaGx5CTHegrJ3JKzWEm88KgZ4RGNsYV2FIoMM8dHBy/
         c+x+f+b313SVo+8bYk/S2YpquFHy8TDhJMol76ojCSodrQAlmjtGT1kub7yKu4N/5Z7o
         i1xw==
X-Gm-Message-State: AOAM530Koa1MNqqvV3lCbJPFa+t+1mDB9WCrfHZ+BMsFj+ssyX4sEY2e
        qwOICjwTAzPX606s6oSUTJY=
X-Google-Smtp-Source: ABdhPJydlze5vCp7cmil/C34PNuT1u22opM6OmcgbCllRmtWcs3UCtZCUA570dmUxT0GQ5l8XVst/g==
X-Received: by 2002:a9d:2de9:: with SMTP id g96mr2368302otb.209.1607387985833;
        Mon, 07 Dec 2020 16:39:45 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id i25sm292033oto.56.2020.12.07.16.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Dec 2020 16:39:45 -0800 (PST)
Subject: Re: [PATCH v1 net-next 01/15] iov_iter: Skip copy in memcpy_to_page
 if src==dst
To:     Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-2-borisp@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f399b37d-872b-c832-be43-c7930b487a16@gmail.com>
Date:   Mon, 7 Dec 2020 17:39:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201207210649.19194-2-borisp@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/20 2:06 PM, Boris Pismenny wrote:
> When using direct data placement the NIC writes some of the payload
> directly to the destination buffer, and constructs the SKB such that it
> points to this data. As a result, the skb_copy datagram_iter call will
> attempt to copy data when it is not necessary.
> 
> This patch adds a check to avoid this copy, and a static_key to enabled
> it when TCP direct data placement is possible.
> 

Why not mark the skb as ZEROCOPY -- an Rx version of the existing
SKBTX_DEV_ZEROCOPY and skb_shared_info->tx_flags? Use that as a generic
way of indicating to the stack what is happening.


