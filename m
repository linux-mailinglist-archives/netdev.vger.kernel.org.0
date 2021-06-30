Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF6A3B7CC9
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 06:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhF3Eln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 00:41:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229532AbhF3Elm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 00:41:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625027954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wHOZ+gtWL9uGxrX1sBw9xqwYSiAQABfkPYunVlkhgPI=;
        b=DUWViAXns+MEMtNde9p5dQDToNU8OsTRGKFHMi+GFuEXu8X4u+c8NdG2P/ju5czh4KfaMA
        vn1gm5Mvan/X1pM3v8GgUs6JwQVP8ePAZCTi17lNNlReDujCMH5qRstdszCu/96B8kvlW8
        axe1x+Gdef0JEouldH9R0kXMgigYGN4=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428--q8fkwGMNTaZ3Z3GW6iBug-1; Wed, 30 Jun 2021 00:39:12 -0400
X-MC-Unique: -q8fkwGMNTaZ3Z3GW6iBug-1
Received: by mail-pf1-f200.google.com with SMTP id 197-20020a6219ce0000b029030a0d1ff0ffso912722pfz.15
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 21:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wHOZ+gtWL9uGxrX1sBw9xqwYSiAQABfkPYunVlkhgPI=;
        b=ZBDke32TvBL2+DMt2dd2zrYUxSh4wjxOGJuRjRz1sTU61mFGJrO+WefIaF19YJ8tLg
         CaizQj+hKmyv4lvgamlCP/vg/Uyd+Jt3Yh8elaSGnl3bTKnwejgC5e0ojoSgJ3W8AVod
         xZBtt6QqRS/s7HOd4MbvaZNx7OyfOsXFeVCfS2gFo5sU9ZJOzs1lDt0wsEvHwtHrpF7/
         sWWXraQJ2OVPULayR6nd7xlT4fGTE4ha7y3s39VpCuFBmczabHGbq0DqlxlvSHNMMFdx
         XY/Isn6wYp/uoxS3LPLLu8e6I8xuCdcycAfPOYJHCEpN7RzROjOY/uoxtm2Vco2CBqW0
         84Cw==
X-Gm-Message-State: AOAM532ZK4mhfxUF1PoVKqgy8s7J9PFLBUYPFleEcJ620q85F7+tch8h
        etQXLv7iCkkFzwV9ADtULHiMyDGFOLk4smoTfhqyU9oNHeLrd5qZHztIjk4p7jgqvwfcki/HZ2a
        OOmtFt1qwzPMKNEQV
X-Received: by 2002:a62:1408:0:b029:304:1caa:dc36 with SMTP id 8-20020a6214080000b02903041caadc36mr33880781pfu.8.1625027951686;
        Tue, 29 Jun 2021 21:39:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBUfviJ6mckDVMUuMHKOf5PmZvPooVzzaKULwD9L4F4oiaKMOFr/douv2V1RezMXJyhDmzig==
X-Received: by 2002:a62:1408:0:b029:304:1caa:dc36 with SMTP id 8-20020a6214080000b02903041caadc36mr33880763pfu.8.1625027951448;
        Tue, 29 Jun 2021 21:39:11 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q125sm19655479pfb.193.2021.06.29.21.39.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 21:39:10 -0700 (PDT)
Subject: Re: [PATCH v3 3/5] vhost_net: remove virtio_net_hdr validation, let
 tun/tap do it themselves
To:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org
Cc:     =?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org>
 <20210624123005.1301761-3-dwmw2@infradead.org>
 <b339549d-c8f1-1e56-2759-f7b15ee8eca1@redhat.com>
 <bfad641875aff8ff008dd7f9a072c5aa980703f4.camel@infradead.org>
 <1c6110d9-2a45-f766-9d9a-e2996c14b748@redhat.com>
 <72dfecd426d183615c0dd4c2e68690b0e95dd739.camel@infradead.org>
 <80f61c54a2b39cb129e8606f843f7ace605d67e0.camel@infradead.org>
 <99496947-8171-d252-66d3-0af12c62fd2c@redhat.com>
 <cdf3fe3ceff17bc2a5aaf006577c1cb0bef40f3a.camel@infradead.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <500370cc-d030-6c2d-8e96-533a3533a8e2@redhat.com>
Date:   Wed, 30 Jun 2021 12:39:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cdf3fe3ceff17bc2a5aaf006577c1cb0bef40f3a.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/29 下午6:49, David Woodhouse 写道:
> On Tue, 2021-06-29 at 11:43 +0800, Jason Wang wrote:
>>> The kernel on a c5.metal can transmit (AES128-SHA1) ESP at about
>>> 1.2Gb/s from iperf, as it seems to be doing it all from the iperf
>>> thread.
>>>
>>> Before I started messing with OpenConnect, it could transmit 1.6Gb/s.
>>>
>>> When I pull in the 'stitched' AES+SHA code from OpenSSL instead of
>>> doing the encryption and the HMAC in separate passes, I get to 2.1Gb/s.
>>>
>>> Adding vhost support on top of that takes me to 2.46Gb/s, which is a
>>> decent enough win.
>>
>> Interesting, I think the latency should be improved as well in this
>> case.
> I tried using 'ping -i 0.1' to get an idea of latency for the
> interesting VoIP-like case of packets where we have to wake up each
> time.
>
> For the *inbound* case, RX on the tun device followed by TX of the
> replies, I see results like this:
>
>       --- 172.16.0.2 ping statistics ---
>       141 packets transmitted, 141 received, 0% packet loss, time 14557ms
>       rtt min/avg/max/mdev = 0.380/0.419/0.461/0.024 ms
>
>
> The opposite direction (tun TX then RX) is similar:
>
>       --- 172.16.0.1 ping statistics ---
>       295 packets transmitted, 295 received, 0% packet loss, time 30573ms
>       rtt min/avg/max/mdev = 0.454/0.545/0.718/0.024 ms
>
>
> Using vhost-net (and TUNSNDBUF of INT_MAX-1 just to avoid XDP), it
> looks like this. Inbound:
>
>       --- 172.16.0.2 ping statistics ---
>       139 packets transmitted, 139 received, 0% packet loss, time 14350ms
>       rtt min/avg/max/mdev = 0.432/0.578/0.658/0.058 ms
>
> Outbound:
>
>       --- 172.16.0.1 ping statistics ---
>       149 packets transmitted, 149 received, 0% packet loss, time 15391ms
>       rtt mn/avg/max/mdev = 0.496/0.682/0.935/0.036 ms
>
>
> So as I expected, the throughput is better with vhost-net once I get to
> the point of 100% CPU usage in my main thread, because it offloads the
> kernel←→user copies. But latency is somewhat worse.
>
> I'm still using select() instead of epoll() which would give me a
> little back — but only a little, as I only poll on 3-4 fds, and more to
> the point it'll give me just as much win in the non-vhost case too, so
> it won't make much difference to the vhost vs. non-vhost comparison.
>
> Perhaps I really should look into that trick of "if the vhost TX ring
> is already stopped and would need a kick, and I only have a few packets
> in the batch, just write them directly to /dev/net/tun".


That should work on low throughput.


>
> I'm wondering how that optimisation would translate to actual guests,
> which presumably have the same problem. Perhaps it would be an
> operation on the vhost fd, which ends up processing the ring right
> there in the context of *that* process instead of doing a wakeup?


It might improve the latency in an ideal case but several possible issues:

1) this will blocks vCPU running until the sent is done
2) copy_from_user() may sleep which will block the vcpu thread further


>
> FWIW if I pull in my kernel patches and stop working around those bugs,
> enabling the TX XDP path and dropping the virtio-net header that I
> don't need, I get some of that latency back:
>
>       --- 172.16.0.2 ping statistics ---
>       151 packets transmitted, 151 received, 0% packet loss, time 15599ms
>       rtt min/avg/max/mdev = 0.372/0.550/0.661/0.061 ms
>
>       --- 172.16.0.1 ping statistics ---
>       214 packets transmitted, 214 received, 0% packet loss, time 22151ms
>       rtt min/avg/max/mdev = 0.453/0.626/0.765/0.049 ms
>
> My bandwidth tests go up from 2.46Gb/s with the workarounds, to
> 2.50Gb/s once I enable XDP, and 2.52Gb/s when I drop the virtio-net
> header. But there's no way for userspace to *detect* that those bugs
> are fixed, which makes it hard to ship that version.


Yes, that's sad. One possible way to advertise a VHOST_NET_TUN flag via 
VHOST_GET_BACKEND_FEATURES?

Thanks


>

