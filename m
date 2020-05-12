Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D55C01CFF0F
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 22:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731087AbgELULu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 16:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELULt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 16:11:49 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BC1C061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 13:11:49 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id z9so4978492qvi.12
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 13:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r6BQYqYGVUBk32e1XgEe9MX6Sfr55ATfLzmJL9Wsqfo=;
        b=hqXC1DvmQSRci0iiENZcb076iEMAfdWjlH/Jk56trf9Czv3BZ3L3Zw+b/tkKWJkr8p
         /9dVWNWqeFIBiwurdX+TPg3TZrrO1dAH1Mx9mrg86TYeU4kVS80OITMwaQK2LRlo1Zez
         I6ar/RJRcFFIJgeZa+UkmwAlgpYwlt0GEbT32v8xcie/02+w1oEr1c58Ka2L/utSI8WX
         k/YvePcK4Yr52KBUkBg+Rd8UPpXY4q70k1vEhDO689RSZn+0eXKa7jiGjALT+ojrvHmx
         3LNjPg0JF7uLiz7t3E/Cytzm4J7mxM/i/s80Cif8JcyAugUXIgmlV9i1NOwAjpoQTwFq
         GuyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r6BQYqYGVUBk32e1XgEe9MX6Sfr55ATfLzmJL9Wsqfo=;
        b=bXRYKd/vQ4n+o4qIP4fzhQW48rCK17VVGJXpvltdXudnr7SyzTrFEoVglo92KM8/nr
         3wEPpVSn2z5yCQnOkNyupSAFzyvpiCbmJGFciT8alJP0Gyn32zQhUNwL4pLQXnt/g8f9
         lxXDkFZ3SMEINMoaC47DlUYq6w7fKfAuyiLAt37XIxlObVUd3gdf7JXYLNLoZYv09y3D
         c5KUwcWriDH/J/XFAP36x1cVEUnOsc5PTsCSrmo1RpGIJvxb7FV2iVTz9AlfJhN1rWkG
         d5bb6F94bRP4JF8gg2axEB4G5hTEIZxr8+nFAQZ/jcKSUHsiLr2j/eys5GSi1XNRuR5f
         bi2g==
X-Gm-Message-State: AOAM5308KRINELO9YJioF5ANHxG0X8doticL1/Af8ROrXdi3oAW2CN0t
        AvxfwaQyENH4B+ddr2lI2Lw=
X-Google-Smtp-Source: ABdhPJz0FeeyC46jkS1ntMfo4bnH1gLSwzobxEQp/L/THKPz+zvSR2qRvn/8u1ot0/k+Y/brko1U0w==
X-Received: by 2002:ad4:4b61:: with SMTP id m1mr1221839qvx.235.1589314308914;
        Tue, 12 May 2020 13:11:48 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:40b2:61fc:4e6d:6e7b? ([2601:282:803:7700:40b2:61fc:4e6d:6e7b])
        by smtp.googlemail.com with ESMTPSA id n123sm12158485qkf.23.2020.05.12.13.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 13:11:48 -0700 (PDT)
Subject: Re: [PATCH v4 bpf-next 09/15] net: Support xdp in the Tx path for
 packets as an skb
To:     Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200427224633.15627-1-dsahern@kernel.org>
 <20200427224633.15627-10-dsahern@kernel.org>
 <f4a4d21a-90b7-0f88-3f99-1961d264bafd@iogearbox.net>
 <52e49a06-8bd9-1286-da7a-624472eb020d@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f8b6c6fe-2eef-3539-395f-694cfbdcc8a5@gmail.com>
Date:   Tue, 12 May 2020 14:11:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <52e49a06-8bd9-1286-da7a-624472eb020d@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 6:17 PM, David Ahern wrote:
>> Overall, for the regular stack, I expect the performance of XDP egress
>> to be
>> worse than e.g. tc egress, for example, when TSO is disabled but not GSO
>> then
>> you parse the same packet multiple times given post-GSO whereas with tc
>> egress
>> it would operate just fine on a GSO skb. Plus all the limitations
>> generic XDP
>> has with skb_cloned(skb), skb_is_nonlinear(skb), etc, where we need to
>> linearize
>> so calling it 'XDP egress' might lead to false assumptions. Did you do a
>> comparison
>> on that as well?
> 

After another round of staring at the code and running various tests, I
will concede the skb path for a few reasons:

1. all appropriate hooks for running an XDP egress program on skbs are
very close to the same point where the tc hook is,

2. the changes needed to handle xdp programs on skbs combined with the
performance impacts those changes bring (e.g., cloned skb, nonlinear skb
disabling GSO, etc), and

3. xdp programs and cls-bpf programs can share data (ie., maps) and
program can be similar enough that the overhead of 2 programs with
separate attach points is reasonable (e.g., I was able to adapt a
firewall so that it works for both paths and the only difference is
setting data and data_end based on context).

What that means is that an xdp_egress program would only apply to
xdp_frames redirected from another interface.

