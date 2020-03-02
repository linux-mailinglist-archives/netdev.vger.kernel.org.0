Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94D2E17525A
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 04:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgCBDlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 22:41:22 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:33477 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgCBDlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 22:41:21 -0500
Received: by mail-io1-f68.google.com with SMTP id r15so1339636iog.0
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 19:41:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ujJ/UcMrlb2P+0L1a7TKjWA7eKgj8bA2iwG8BTwFSmQ=;
        b=IqoEXt59JZr0HJh9s8aU04m0O5iINwGwnrYwgzYxHXoEVYW3pv5weXJZdPJb0vyeuv
         jokLeKduXcTtk8NZiBv0NKvjDP0Dpe1UN9e7ilGkHaWbeqtt6LyBcshUwt/I/rkAB8gc
         fS33JtDZ9xbOZms69244x9rKnMbtbhU+dUExwuvoDDDsoOE66tlKyaoQhoIyw6t1xweR
         VQ6SrDuW+lxFWGKulrL1MtWVqEmz0eYJJJnCuqJXVlelf6lw+TpGo4NVU40sxddue3hz
         nd+vJrjtf4X4/5hxG4jMDU1OrCiv1MC3H5VSmMqwrXcWBFoWcGfUfrJwdzSGc1kAx9P4
         tc2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ujJ/UcMrlb2P+0L1a7TKjWA7eKgj8bA2iwG8BTwFSmQ=;
        b=NR8Uq7WioSpSNnr6wjJ9vjGu5dBT48ntLV6tXoEEbYInjXMYSGlnBS4yv3axNO92so
         BRWv6DqtO6yhB/vezW2/10Dw7jXBhRZlLZlVhFWq4IcUZVPqwzxC74E3wubsiP/+6sy4
         qdAJ5e2GIAhKG5lnkrqr+gKOlSqoXyqSyBwRn5Qeq7Nai3AnPEeyJ2oJHJ/xuAy7a81/
         mdMVcHiWksg+maz1pvgkH/+/Zl1oVf1OM27zlkHFnKYog3B/84Vcf08hSkO5366fdMfG
         qYq5XbDSmKwYuG5p4bhraAGKJ0+kL2UffaPxdkkUwHpHbI40cqSX32ywVY7VAxcmLg9n
         rQQw==
X-Gm-Message-State: APjAAAUxVop76JXr/y2XnVcekUnAha356ikvmGb6hBC93v5H6c2fxz/a
        rt9zwENj6dlz/C0LpEL/5mw=
X-Google-Smtp-Source: APXvYqwnYiX/ZT89OsnaS8vPYew5QR8f+GEutJl/UOH38m2NFCaZaP4d3kU5+MvtrcRN6dUUsU4uIg==
X-Received: by 2002:a02:7656:: with SMTP id z83mr12408977jab.81.1583120479184;
        Sun, 01 Mar 2020 19:41:19 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:d978:6c79:25cd:dedf? ([2601:282:803:7700:d978:6c79:25cd:dedf])
        by smtp.googlemail.com with ESMTPSA id j4sm3868661ilf.21.2020.03.01.19.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 19:41:18 -0800 (PST)
Subject: Re: [PATCH RFC v4 bpf-next 08/11] tun: Support xdp in the Tx path for
 skb
To:     Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com, toke@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200227032013.12385-1-dsahern@kernel.org>
 <20200227032013.12385-9-dsahern@kernel.org>
 <0dc6768e-b8fa-f0b3-3c58-5135640f114a@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <65a1141a-efdb-62e2-729b-e69dd6f06eb8@gmail.com>
Date:   Sun, 1 Mar 2020 20:41:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <0dc6768e-b8fa-f0b3-3c58-5135640f114a@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/1/20 8:28 PM, Jason Wang wrote:
>> +static u32 tun_do_xdp_tx_generic(struct tun_struct *tun,
>> +                 struct net_device *dev,
>> +                 struct sk_buff *skb)
>> +{
>> +    struct bpf_prog *xdp_prog;
>> +    u32 act = XDP_PASS;
>> +
>> +    xdp_prog = rcu_dereference(tun->xdp_egress_prog);
>> +    if (xdp_prog) {
>> +        struct xdp_txq_info txq = { .dev = dev };
>> +        struct xdp_buff xdp;
>> +
>> +        skb = tun_prepare_xdp_skb(skb);
>> +        if (!skb) {
>> +            act = XDP_DROP;
>> +            goto out;
>> +        }
>> +
>> +        xdp.txq = &txq;
>> +
>> +        act = do_xdp_generic_core(skb, &xdp, xdp_prog);
>> +        switch (act) {
>> +        case XDP_TX:    /* for Tx path, XDP_TX == XDP_PASS */
>> +            act = XDP_PASS;
>> +            break;
> 
> 
> Jute a note here, I agree for TX XDP it may be better to do this.
> 
> But for offloaded program we need different semantic. Or we can deal
> this with attach types?
> 

This path is for XDP_FLAGS_DRV_MODE. Offloaded programs
(XDP_FLAGS_HW_MODE) will be run in vhost context.
