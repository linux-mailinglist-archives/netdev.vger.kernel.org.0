Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D78114B69
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 04:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfLFD2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 22:28:38 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34200 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfLFD2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 22:28:38 -0500
Received: by mail-pg1-f193.google.com with SMTP id r11so2586022pgf.1;
        Thu, 05 Dec 2019 19:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g7BCeZW0eolz9mWYsM2Q9t0SlTAX6lptP6pm+0Vxcs8=;
        b=fDzeh5ehTw0M3ztiABA4jATIwp0MVhQmyDl6Q2TBPc+domKJvbjT4U65uaHkNbJXZS
         s+NKpsh+esuL6WVcDGh+XGQAN/mh+Z8E51/MEUsro5dPRA998pOAr2eUXhfZc5p80hoa
         oYs4MaMPwcifZ7tWvXdr3BuQuVB7BaLB2itv/MmhT6fLf/RM1LeXl01gXxBU1EAKyUK2
         3CxGMriJMDY6jZCASUPwTDVqceXS1PZSG02N3vvC05TefQVWxd5wWKNiEq+BZucqXa2C
         KvDJWK/yWytMmKJeL1E7nxyjBZkijFKc/KlXlbOzZKLC5GuiI7heu8xVgnvyGWwgMqIx
         zaqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=g7BCeZW0eolz9mWYsM2Q9t0SlTAX6lptP6pm+0Vxcs8=;
        b=TkFXytnbNzyu86+/aaiE4T0cn+FMmUxWM3ZJQyNK0C6syPXY/fytMkYpx23ywyJOKp
         gaX0vVJr17iDIGCKPlhTSI4uLgijfOVLLyxCfhvJDY16jo5bP+37eWqFL0Zgdon+7vxi
         4kwSOegAt9Am6tP8P6e+apYnKxOxMebcRuvAr28bGK/u+F7GmoIG3KRk3F44+v0+Nddk
         ukWS8hlJEdw9NZHi4e9nykpwbJ/Z6zNmu0X2/Smk3xFiWi2k7sewlT5NoGtLZT1u4uhu
         AgJ/o5lYLdnj/61WSiaZ9m5cvP/UV0TN1I85A9IjRhDozjga9sxEGQurcu1eBa2SGjZY
         1uOw==
X-Gm-Message-State: APjAAAUdQAT3e1Re2zswi99STtg3+F4lDk2anxSy62yqAHqvAYn1kJC5
        qD2KdJh9KEZIXcyqLdfzZKb+ck/J
X-Google-Smtp-Source: APXvYqyk/nqNluKyrK647I+ClZ58nNnLGPJ9B8OC2lyoF6nFm2dhR9HS4p9Xf5AC1zBvch2u06Ig9g==
X-Received: by 2002:a63:d551:: with SMTP id v17mr1134830pgi.365.1575602917284;
        Thu, 05 Dec 2019 19:28:37 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x186sm13378911pfx.105.2019.12.05.19.28.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 19:28:36 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: fix flow dissection on Tx path
To:     Alexander Lobakin <alobakin@dlink.ru>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Muciri Gatimu <muciri@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        John Crispin <john@phrozen.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191205100235.14195-1-alobakin@dlink.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <5d3d0907-4f99-ccda-82f4-12e514c5edb2@gmail.com>
Date:   Thu, 5 Dec 2019 19:28:32 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191205100235.14195-1-alobakin@dlink.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/2019 2:02 AM, Alexander Lobakin wrote:
> Commit 43e665287f93 ("net-next: dsa: fix flow dissection") added an
> ability to override protocol and network offset during flow dissection
> for DSA-enabled devices (i.e. controllers shipped as switch CPU ports)
> in order to fix skb hashing for RPS on Rx path.
> 
> However, skb_hash() and added part of code can be invoked not only on
> Rx, but also on Tx path if we have a multi-queued device and:
>  - kernel is running on UP system or
>  - XPS is not configured.
> 
> The call stack in this two cases will be like: dev_queue_xmit() ->
> __dev_queue_xmit() -> netdev_core_pick_tx() -> netdev_pick_tx() ->
> skb_tx_hash() -> skb_get_hash().
> 
> The problem is that skbs queued for Tx have both network offset and
> correct protocol already set up even after inserting a CPU tag by DSA
> tagger, so calling tag_ops->flow_dissect() on this path actually only
> breaks flow dissection and hashing.
> 
> This can be observed by adding debug prints just before and right after
> tag_ops->flow_dissect() call to the related block of code:
> 
> Before the patch:
> 
> Rx path (RPS):
> 
> [   19.240001] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
> [   19.244271] tag_ops->flow_dissect()
> [   19.247811] Rx: proto: 0x0800, nhoff: 8	/* ETH_P_IP */
> 
> [   19.215435] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
> [   19.219746] tag_ops->flow_dissect()
> [   19.223241] Rx: proto: 0x0806, nhoff: 8	/* ETH_P_ARP */
> 
> [   18.654057] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
> [   18.658332] tag_ops->flow_dissect()
> [   18.661826] Rx: proto: 0x8100, nhoff: 8	/* ETH_P_8021Q */
> 
> Tx path (UP system):
> 
> [   18.759560] Tx: proto: 0x0800, nhoff: 26	/* ETH_P_IP */
> [   18.763933] tag_ops->flow_dissect()
> [   18.767485] Tx: proto: 0x920b, nhoff: 34	/* junk */
> 
> [   22.800020] Tx: proto: 0x0806, nhoff: 26	/* ETH_P_ARP */
> [   22.804392] tag_ops->flow_dissect()
> [   22.807921] Tx: proto: 0x920b, nhoff: 34	/* junk */
> 
> [   16.898342] Tx: proto: 0x86dd, nhoff: 26	/* ETH_P_IPV6 */
> [   16.902705] tag_ops->flow_dissect()
> [   16.906227] Tx: proto: 0x920b, nhoff: 34	/* junk */
> 
> After:
> 
> Rx path (RPS):
> 
> [   16.520993] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
> [   16.525260] tag_ops->flow_dissect()
> [   16.528808] Rx: proto: 0x0800, nhoff: 8	/* ETH_P_IP */
> 
> [   15.484807] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
> [   15.490417] tag_ops->flow_dissect()
> [   15.495223] Rx: proto: 0x0806, nhoff: 8	/* ETH_P_ARP */
> 
> [   17.134621] Rx: proto: 0x00f8, nhoff: 0	/* ETH_P_XDSA */
> [   17.138895] tag_ops->flow_dissect()
> [   17.142388] Rx: proto: 0x8100, nhoff: 8	/* ETH_P_8021Q */
> 
> Tx path (UP system):
> 
> [   15.499558] Tx: proto: 0x0800, nhoff: 26	/* ETH_P_IP */
> 
> [   20.664689] Tx: proto: 0x0806, nhoff: 26	/* ETH_P_ARP */
> 
> [   18.565782] Tx: proto: 0x86dd, nhoff: 26	/* ETH_P_IPV6 */
> 
> In order to fix that we can add the check 'proto == htons(ETH_P_XDSA)'
> to prevent code from calling tag_ops->flow_dissect() on Tx.
> I also decided to initialize 'offset' variable so tagger callbacks can
> now safely leave it untouched without provoking a chaos.
> 
> Fixes: 43e665287f93 ("net-next: dsa: fix flow dissection")
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
