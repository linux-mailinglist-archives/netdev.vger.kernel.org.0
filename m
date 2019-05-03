Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43114130DE
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbfECPFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:05:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55344 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfECPFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 11:05:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id y2so7176797wmi.5
        for <netdev@vger.kernel.org>; Fri, 03 May 2019 08:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LRVpocRv021GjVSUFKpIJlP4sqbbyUGhOzdY3CqzUZQ=;
        b=Oc/90YjddXiPMQouv0MCkEgNG5KLf9mu2MqCxqFjQuo9XJb3HewC2Rz0XZSzwiPe7T
         y4sNGW5W/rIEOK7xHAeD4/iih+/eCOzVh/aDLSKbW5CT9PpyQOLbhSG5OQ8lHDqKjFfY
         Yxpoye9zpY5msjmN9GyZK0WtOv9OAbd3N16P9hZYMrJqjsWvCTHnNdgIp43u127KumXX
         PggWFmypLw5hIo8NtemZ27z99lxoIpqSJ1lJPX8ImYdphqIwiyIEnz+g1KOqadBb+4rk
         /gspd0fYSBKmKc/drMAzkCipU9UlvQDqG3XuDdxtE4e/esazY5ZCVUoFVNymxlmM751z
         xjFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=LRVpocRv021GjVSUFKpIJlP4sqbbyUGhOzdY3CqzUZQ=;
        b=XEY4sfO5Tk8ZU+gERHJ+sqXDUTCForcCh7ET8emoj7LuSeef/S+I5RXxYqlJLJDnZ6
         WG3zFh9fMad6z9Da5KDak1NtEGxlmiXb5kqpxVPMLA23100KFe/OYn0wPXjmXTsG1P8w
         ThvQEuHZDYyhgLd6B6I2RR0T4qN7ZKXPN3QhMOeWUc7ltko8di47bza7XiUTsbVdyn1Y
         PpwiQ+7gVDyhOiPTP+05v0HrigczPHBwtb95iVY/2yIHpfKcv0CKG6wTY1cwkKmAOu8Y
         RrQQ1tVnqctdwax4R9SuwRFRI3jlGgILjX/0PuxjkUfCoD/21r1VgfJ1GJadcjHnvkgr
         9NtA==
X-Gm-Message-State: APjAAAW78eKBfW3PYtwia5kbWFgXWs9vx5VyVm7klXc2zgQN89//xMKJ
        GznT/zT/9v+J6PWTv7aGPYJci2wDYZU=
X-Google-Smtp-Source: APXvYqzNvKi+so1HcnwD2Gt1/CCSIu4YbHdUcDHUwsjWtDWTqxm/uCNKw00EGT5X1nI5KOUVLirvJA==
X-Received: by 2002:a05:600c:2118:: with SMTP id u24mr6480340wml.24.1556895336043;
        Fri, 03 May 2019 07:55:36 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:9d85:cd02:d5cd:3fb? ([2a01:e35:8b63:dc30:9d85:cd02:d5cd:3fb])
        by smtp.gmail.com with ESMTPSA id 130sm3138048wmd.15.2019.05.03.07.55.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 07:55:34 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] ip6: fix skb leak in ip6frag_expire_frag_queue()
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stfan Bader <stefan.bader@canonical.com>,
        Peter Oskolkov <posk@google.com>,
        Florian Westphal <fw@strlen.de>
References: <20190503114721.10502-1-edumazet@google.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <6852d902-8896-a057-5755-807d432fbc09@6wind.com>
Date:   Fri, 3 May 2019 16:55:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503114721.10502-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/05/2019 à 13:47, Eric Dumazet a écrit :
> Since ip6frag_expire_frag_queue() now pulls the head skb
> from frag queue, we should no longer use skb_get(), since
> this leads to an skb leak.
> 
> Stefan Bader initially reported a problem in 4.4.stable [1] caused
> by the skb_get(), so this patch should also fix this issue.
> 
> 296583.091021] kernel BUG at /build/linux-6VmqmP/linux-4.4.0/net/core/skbuff.c:1207!
> [296583.091734] Call Trace:
> [296583.091749]  [<ffffffff81740e50>] __pskb_pull_tail+0x50/0x350
> [296583.091764]  [<ffffffff8183939a>] _decode_session6+0x26a/0x400
> [296583.091779]  [<ffffffff817ec719>] __xfrm_decode_session+0x39/0x50
> [296583.091795]  [<ffffffff818239d0>] icmpv6_route_lookup+0xf0/0x1c0
> [296583.091809]  [<ffffffff81824421>] icmp6_send+0x5e1/0x940
> [296583.091823]  [<ffffffff81753238>] ? __netif_receive_skb+0x18/0x60
> [296583.091838]  [<ffffffff817532b2>] ? netif_receive_skb_internal+0x32/0xa0
> [296583.091858]  [<ffffffffc0199f74>] ? ixgbe_clean_rx_irq+0x594/0xac0 [ixgbe]
> [296583.091876]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_defrag_ipv6]
> [296583.091893]  [<ffffffff8183d431>] icmpv6_send+0x21/0x30
> [296583.091906]  [<ffffffff8182b500>] ip6_expire_frag_queue+0xe0/0x120
> [296583.091921]  [<ffffffffc04eb27f>] nf_ct_frag6_expire+0x1f/0x30 [nf_defrag_ipv6]
> [296583.091938]  [<ffffffff810f3b57>] call_timer_fn+0x37/0x140
> [296583.091951]  [<ffffffffc04eb260>] ? nf_ct_net_exit+0x50/0x50 [nf_defrag_ipv6]
> [296583.091968]  [<ffffffff810f5464>] run_timer_softirq+0x234/0x330
> [296583.091982]  [<ffffffff8108a339>] __do_softirq+0x109/0x2b0
> 
> Fixes: d4289fcc9b16 ("net: IP6 defrag: use rbtrees for IPv6 defrag")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Stfan Bader <stefan.bader@canonical.com>
nit: the 'e' is missing in Stefan ;-)
