Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBBA0114B70
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 04:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfLFDcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 22:32:43 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34869 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfLFDcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 22:32:42 -0500
Received: by mail-pf1-f194.google.com with SMTP id b19so2617869pfo.2;
        Thu, 05 Dec 2019 19:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wXs99blA+i0iIjqGzFrum27cREDNDIw0rigJd8VFl5o=;
        b=M9Fp9gtNyHznskp8psxkRLbdb38v3LOZrSnsogcZmut1afyJcvuBYJCmd/o/nG+bQk
         GThJ/IlJIGqZx2pwmEbXZtYMSakznMKhbDA4TeHDD4PngLq+vU7BHlAjEA8dTBAXPoZg
         AEjup6rZoWgoMmmZnsHxnbFwjm8LJB4CByhjAe6pwU8DGY4Sa0HOaNIMpD9n1RKFrzi6
         qd53bwAICkOaE0VgMbUsm8f0dJEFivT3FjKnhU9ZSEj+9wpO9pTY/0Qn+tjeo/L11HXw
         VJhh7ceYDEuzie5gxisNsXdGgMJB90T36jzTQl5nb2eb8lfaMQRvZY2DmEH/002dYl6b
         QKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wXs99blA+i0iIjqGzFrum27cREDNDIw0rigJd8VFl5o=;
        b=VhvmtTGwVSTX6zgQrD+WxrzL3XBYTkIm46Uf4s21rIQd6lc7LTlCZvpO63gi41hmVt
         I6Iv6QfKr+ZNK1qSrbfM4TI/azGf/E8Pq/t37YT9uyaucQm6tSvmpDNcxprxHVs0jwOt
         FF9gaqllPae1dY1SbzjhcdZLH8pqJ/kTLhVwfy9WZzHlALRiXetoeu/rCBY744hUF045
         HhlZmcdv4Ncz5NzPiF1gcSoDgcwtzH/oZxBlIueffhdjcTUHzmumMh5TWTfKIPhD47gw
         Gi3AfOup9dFPDmC4je+qxnI6x2CWpynV/WvjQuC6rTsuDMdiWKPT2hc44bgUoInSYKbg
         Kqcg==
X-Gm-Message-State: APjAAAUaV0bGa1/RiXR5dkbonEr0nHRGN32GzhzVfLRTy7XhYQyr5vZa
        +Zg21cQ+wQY0po5ZQpfKnvgpB90d
X-Google-Smtp-Source: APXvYqzlB1q8GggXzb2/lHaJDpOeKk2cyQUQynuRuMhdD09rX48XB72KriB2C9G2Ih1mAMHlNNDSgQ==
X-Received: by 2002:a63:5a5c:: with SMTP id k28mr1114657pgm.183.1575603161506;
        Thu, 05 Dec 2019 19:32:41 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s130sm13034750pgc.82.2019.12.05.19.32.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 19:32:40 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: fix flow dissection on Tx path
To:     Alexander Lobakin <alobakin@dlink.ru>, Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Muciri Gatimu <muciri@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        John Crispin <john@phrozen.org>,
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
 <20191205125827.GA28269@lunn.ch> <2e03b82a8ec999fade26253ff35077c6@dlink.ru>
 <20191205140132.GD28269@lunn.ch> <72a21c5f03abdc3d2d1c1bb85fd4489d@dlink.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <3cc7a0c3-4eeb-52d5-1777-f646329a9303@gmail.com>
Date:   Thu, 5 Dec 2019 19:32:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <72a21c5f03abdc3d2d1c1bb85fd4489d@dlink.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/2019 6:58 AM, Alexander Lobakin wrote:
> Andrew Lunn wrote 05.12.2019 17:01:
>>> Hi,
>>>
>>> > What i'm missing here is an explanation why the flow dissector is
>>> > called here if the protocol is already set? It suggests there is a
>>> > case when the protocol is not correctly set, and we do need to look
>>> > into the frame?
>>>
>>> If we have a device with multiple Tx queues, but XPS is not configured
>>> or system is running on uniprocessor system, then networking core code
>>> selects Tx queue depending on the flow to utilize as much Tx queues as
>>> possible but without breaking frames order.
>>> This selection happens in net/core/dev.c:skb_tx_hash() as:
>>>
>>> reciprocal_scale(skb_get_hash(skb), qcount)
>>>
>>> where 'qcount' is the total number of Tx queues on the network device.
>>>
>>> If skb has not been hashed prior to this line, then skb_get_hash() will
>>> call flow dissector to generate a new hash. That's why flow dissection
>>> can occur on Tx path.
>>
>>
>> Hi Alexander
>>
>> So it looks like you are now skipping this hash. Which in your
>> testing, give better results, because the protocol is already set
>> correctly. But are there cases when the protocol is not set correctly?
>> We really do need to look into the frame?
> 
> Actually no, I'm not skipping the entire hashing, I'm only skipping
> tag_ops->flow_dissect() (helper that only alters network offset and
> replaces fake ETH_P_XDSA with the actual protocol) call on Tx path,
> because this only breaks flow dissection logics. All skbs are still
> processed and hashed by the generic code that goes after that call.
> 
>> How about when an outer header has just been removed? The frame was
>> received on a GRE tunnel, the GRE header has just been removed, and
>> now the frame is on its way out? Is the protocol still GRE, and we
>> should look into the frame to determine if it is IPv4, ARP etc?
>>
>> Your patch looks to improve things for the cases you have tested, but
>> i'm wondering if there are other use cases where we really do need to
>> look into the frame? In which case, your fix is doing the wrong thing.
>> Should we be extending the tagger to handle the TX case as well as the
>> RX case?
> 
> We really have two options: don't call tag_ops->flow_dissect() on Tx
> (this patch), or extend tagger callbacks to handle Tx path too. I was
> using both of this for several months each and couldn't detect cases
> where the first one was worse than the second.
> I mean, there _might_ be such cases in theory, and if they will appear
> we should extend our taggers. But for now I don't see the necessity to
> do this as generic flow dissection logics works as expected after this
> patch and is completely broken without it.
> And remember that we have the reverse logic on Tx and all skbs are
> firstly queued on slave netdevice and only then on master/CPU port.
> 
> It would be nice to see what other people think about it anyways.

Your patch seems appropriate to me and quite frankly I am not sure why
flow dissection on RX is done at the DSA master device level, where we
have not parsed the DSA tag yet, instead of being done at the DSA slave
network device level. It seems to me that if the DSA master has N RX
queues, we should be creating the DSA slave devices with the same amount
of RX queues and perform RPS there against a standard Ethernet frame
(sans DSA tag).

For TX the story is a little different because we can have multiqueue
DSA slave network devices in order to steer traffic towards particular
switch queues and we could do XPS there that way.

What do you think?
-- 
Florian
