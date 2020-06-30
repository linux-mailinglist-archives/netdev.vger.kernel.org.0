Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F09720F289
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 12:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732444AbgF3KVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 06:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732155AbgF3KVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 06:21:17 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4475AC061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 03:21:17 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id d15so15645065edm.10
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 03:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VDEcFLz30YqPWeehCdfH/9zObPX50Jf3Ja84tGxEzEE=;
        b=uMRIGpKFwE90ZHUaUsOj7aMJPHeHNRnnWv+b2sfPgt15HzPSULS04y8JPnx5P7d8e9
         SnBQ+hO9CH/nqRnR1hrymCxQeafsvtgi0S782kZ4F0jnuuohaL6mDFtOKVjFhbK/JTcQ
         mDAh4976N2ghQ8mCW2hAwn5uIDHVtpzZ2NtQIJSuIMtzatPxFVwiEuH8mUOHkFeSkYBR
         U9mOwSjBWvKrJnEggJzEORLoW4IT4fHoyZxAgJU7TYfnNA3z8Hckrgxlt6Ci7hFuaEa5
         kcjV4yD9d3tLVTvWMqTG5ay6r9HVbDv7YyXDsguaWsr1vRVn5zb6lau4U5T6jmZ/zmE+
         7HGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VDEcFLz30YqPWeehCdfH/9zObPX50Jf3Ja84tGxEzEE=;
        b=G3bQWUdHEYYRlVUkQpL2qcVFjfozQK2GJ4X0SNH5uuLs4wy6QzdhxfI7jHk2V8L44r
         EFrNMFCpqsmPPeX/+jCgPuavj8KCsXLENhr/fzcHsC5MaBTojAO1/gpWfoOoUT1ra4yW
         eL1gKY9spn6LGsey5H1yX46ZK1B9+0geAoD7HtxHxOQ98qGLCoCcHKhRSIP9uNXH4vXi
         zeIc7eMnoHkzrgOjr+OmTocuOVu5gREwQDK6ytnIZOXHN9AhUnCb+fQjRfWJctxzPsE1
         xL2MboB0Pj9aB93BXxanHiQ1lv+/sgo8EkH7sx5FpK4+n7uXYUhGzvhYulWBdXLhYefB
         hHSA==
X-Gm-Message-State: AOAM532QWbhVbNOyExvB05fBlKkGO5J4tQDq+z/y1t1e5Hu1t07ilRnq
        2rlTULvBaFQk97BOacL6E4o=
X-Google-Smtp-Source: ABdhPJwgBOg0ryeL1g+r8dTcBokZ9U1MRaHtsxBXWtDN8TsFV5tybkgJmdZub/q696c3nRHCGWWG1w==
X-Received: by 2002:a50:9dc4:: with SMTP id l4mr22916367edk.52.1593512475945;
        Tue, 30 Jun 2020 03:21:15 -0700 (PDT)
Received: from ?IPv6:2a0f:6480:3:1:a1d3:9662:48a:6b14? ([2a0f:6480:3:1:a1d3:9662:48a:6b14])
        by smtp.gmail.com with ESMTPSA id q7sm1725137ejo.22.2020.06.30.03.21.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 03:21:15 -0700 (PDT)
Subject: Re: [PATCH v3] IPv4: Tunnel: Fix effective path mtu calculation
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
References: <20200625224435.GA2325089@tws>
 <20200629232235.6047a9c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oliver Herms <oliver.peter.herms@gmail.com>
Message-ID: <20e25b9c-db3c-e6cd-f383-aa4ac84a2177@gmail.com>
Date:   Tue, 30 Jun 2020 12:21:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200629232235.6047a9c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.06.20 08:22, Jakub Kicinski wrote:
> On Fri, 26 Jun 2020 00:44:35 +0200 Oliver Herms wrote:
>> The calculation of the effective tunnel mtu, that is used to create
>> mtu exceptions if necessary, is currently not done correctly. This
>> leads to unnecessary entries in the IPv6 route cache for any
>> packet send through the tunnel.
>>
>> The root cause is, that "dev->hard_header_len" is subtracted from the
>> tunnel destionations path mtu. Thus subtracting too much, if
>> dev->hard_header_len is filled in. This is that case for SIT tunnels
>> where hard_header_len is the underlyings dev hard_header_len (e.g. 14
>> for ethernet) + 20 bytes IP header (see net/ipv6/sit.c:1091).
> 
> It seems like SIT possibly got missed in evolution of the ip_tunnel
> code? It seems to duplicate a lot of code, including pmtu checking.
> Doesn't call ip_tunnel_init()...

Are you open for patches cleaning this up?

> 
> My understanding is that for a while now tunnels are not supposed to use
> dev->hard_header_len to reserve skb space, and use dev->needed_headroom, 
> instead. sit uses hard_header_len and doesn't even copy needed_headroom
> of the lower device.
> 
>> However, the MTU of the path is exclusive of the ethernet header
>> and the 20 bytes for the IP header are being subtracted separately
>> already. Thus hard_header_len is removed from this calculation.
>>
>> For IPIP and GRE tunnels this doesn't change anything as
>> hard_header_len is zero in those cases anyways.
> 
> This statement is definitely not true. Please see the calls to
> ether_setup() in ip_gre.c, and the implementation of this function
Right. I have to admit I've only checked for L3 tunnels using printk
on dev->hard_header_len. Showing 0 for IPIP and GRE.

So shall I file a patch that changes hard_header_len for SIT tunnels to 0?
