Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DD72D2D40
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgLHObn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgLHObm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:31:42 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6461AC061749
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 06:31:02 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id a16so24890311ejj.5
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 06:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=oW/0Def7+syZBHy2KEEtk4RcVTNw5OOV1PYvwMkOqxA=;
        b=QkQK4aZ97qoLladTirg8VOwoThhsx/hiD0TJqyhfoxqq2jmowi5gq2CUC0phSfFzwi
         jJ89ILZ1nddu9jOmP0AWFa792RcOOoXNUTZKtes7Q7JGnivMsG1f2VBWsh4UP7xes986
         HdJEcNJuEkwbAys/DryjdvYOTSCodnk0ngUD/w8ZppQtZeUd3KweNJM57/64VM2AedEO
         EZeF7esrzpxnjrpB89gtpUAJzGSr7DKIKve6RuG+S9/kc11mnL2tgm18SEEP78E9rYmP
         i82jFL1a5/jD7HSTWfvSZR27cdBICQuCpiPxqFS0atjr2Sz+McmTtopEPzPjOXHGs0YP
         UC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oW/0Def7+syZBHy2KEEtk4RcVTNw5OOV1PYvwMkOqxA=;
        b=ack2SoU+WHit8E9smDQmtoz20nFsQAsXSDVq6JDrzs6jp3XMQyd+wUgoc27E+WIggM
         uLPrCOwKtFo1Fugo6LUNpWnYJYyxEIzreOlrHBRZz5/kWifD+ctYxAHwPGAS7JKiLoLT
         ifnxaNz8APUf5NPP4Pr2T6spSdocn/4PI4DrMLDD9TANppkDvvcaWJP6mYertUh6YKSq
         PFOYhvLc9mWc1bFQxYnEzx8eLz4SMNNz/YfSdSK5mTz4Bya3s5HtLUOZvbzhdqqMiYmB
         CZLkhl/ALRWUgwG9Owb21GtS1GyI/pUP0iLnVD1pi6e5jIdvfOyuLeu6n5oB5uCZoSru
         nvdg==
X-Gm-Message-State: AOAM5327903EDr8+iOVtYnsqD7gA83/BPidq6jzS9jERClHKi5ovkJLL
        k97K7WfeWRUuP26WtnKypsg=
X-Google-Smtp-Source: ABdhPJy/7c06e+YRuNmU/KgnwjADm+SYBPre9cKBVuDYInQdk4C3RUeUEmhTvIcEMDRL3YVPh3sTHw==
X-Received: by 2002:a17:906:17d0:: with SMTP id u16mr23099000eje.452.1607437861169;
        Tue, 08 Dec 2020 06:31:01 -0800 (PST)
Received: from [132.68.43.153] ([132.68.43.153])
        by smtp.gmail.com with ESMTPSA id d18sm8707633edz.14.2020.12.08.06.30.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 06:31:00 -0800 (PST)
Subject: Re: [PATCH v1 net-next 01/15] iov_iter: Skip copy in memcpy_to_page
 if src==dst
To:     David Ahern <dsahern@gmail.com>,
        Boris Pismenny <borisp@mellanox.com>, kuba@kernel.org,
        davem@davemloft.net, saeedm@nvidia.com, hch@lst.de,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        viro@zeniv.linux.org.uk, edumazet@google.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>, borisp@nvidia.com
References: <20201207210649.19194-1-borisp@mellanox.com>
 <20201207210649.19194-2-borisp@mellanox.com>
 <f399b37d-872b-c832-be43-c7930b487a16@gmail.com>
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <eb974de5-01c7-a4e1-b08d-d2e64bfed4a8@gmail.com>
Date:   Tue, 8 Dec 2020 16:30:58 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <f399b37d-872b-c832-be43-c7930b487a16@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 08/12/2020 2:39, David Ahern wrote:
> On 12/7/20 2:06 PM, Boris Pismenny wrote:
>> When using direct data placement the NIC writes some of the payload
>> directly to the destination buffer, and constructs the SKB such that it
>> points to this data. As a result, the skb_copy datagram_iter call will
>> attempt to copy data when it is not necessary.
>>
>> This patch adds a check to avoid this copy, and a static_key to enabled
>> it when TCP direct data placement is possible.
>>
> Why not mark the skb as ZEROCOPY -- an Rx version of the existing
> SKBTX_DEV_ZEROCOPY and skb_shared_info->tx_flags? Use that as a generic
> way of indicating to the stack what is happening.
>
>

[Re-sending as the previous one didn't hit the mailing list]

Interesting idea. But, unlike SKBTX_DEV_ZEROCOPY this SKB can be inspected/modified by the stack without the need to copy things out. Additionally, the SKB may contain both data that is already placed in its final destination buffer (PDU data) and data that isn't (PDU header); it doesn't matter. Therefore, labeling the entire SKB as zerocopy doesn't convey the desired information. Moreover, skipping copies in the stack to receive zerocopy SKBs will require more invasive changes.

Our goal in this approach was to provide the smallest change that enables the desired functionality while preserving the performance of existing flows that do not care for it. An alternative approach, that doesn't affect existing flows at all, which we considered was to make a special version of memcpy_to_page to be used by DDP providers (nvme-tcp). This alternative will require creating corresponding special versions for users of this function such skb_copy_datagram_iter. Thit is more invasive, thus in this patchset we decided to avoid it.
