Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 596AB1AE672
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 22:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbgDQUGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 16:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730573AbgDQUGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 16:06:11 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F292AC061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 13:06:10 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id s63so3815125qke.4
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 13:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sb2CJkg4L11DR8GWZW44h9LoaTOkAn/1QdR8OM5t8ss=;
        b=PpKXWm4iiD/MHdSKvgjlXpMR39wSaIST3J8EcOSi04SriEWfNCTwE5WsTm91MD3AOs
         64Q7eHKFJgBZzToX2efREuXa/qpaZjuipStih3NoaTkLTmV8WbSoocoCsDSosxugO1+M
         ItclOfZCQeNry3TdfINb5y/O61CpWB7B75CmXGfc4M96cNv3wiUF+aazUzXFVaSMlObu
         xcibs+vqJQW0bpU4k52zrIhmvaYU1/J8D6C/+O67L8hQ4/fZRuiQ58BZfPlVr9Pe8+2M
         RODZ2B8NvhNKIL921L9wN9J/A8H2SGcl6370IFIiG8belC68qnu0IRgonwczTuIbXKuG
         RWRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sb2CJkg4L11DR8GWZW44h9LoaTOkAn/1QdR8OM5t8ss=;
        b=Qe3jT5sj38oQvkTPrvHvm/ybzLbEUIRxNYKU49U0Ros6Vz1TRYs92nSPxCtJQ6fTQc
         iUgsyh4Plk4tr3tr2/vVygfWmNwimw4AOyA6e7cGotzKjfS6+umppmTxrMr7I2jxe8CZ
         FaUDwdpImxp0J7ZWl2JmwXL2a2PeBH9P05qQmckljzs2TLTgXaBRFGw22fuxVRP3c3rX
         KGkNuYZwwCuEySDmIppb4FF5nwrfhWFc6zFdliYsk5cSSK/7A2imPYX4AOBdRGu6Es4H
         XUDykT5ctMT3kR/nc3xK6X+jbFijIVUz2264hLMxF3FzOUOoTDoJtQ+ZeT/z6WioNQpd
         TfDQ==
X-Gm-Message-State: AGi0PuZrO7/qcPdMe+BeAXrawQ5FJ1RRS068UA1sABXdBei689p4BFyQ
        Lsn7glKAdQKGsDCtReFUhL0=
X-Google-Smtp-Source: APiQypIkK2Ob9xKCQKhlq4cvRVQPS7ZdhOniHQ4MRYBU7M7A6H/s4dTW6Y181FP3dkqljqTVUkqOKw==
X-Received: by 2002:ae9:e20d:: with SMTP id c13mr4706441qkc.241.1587153970014;
        Fri, 17 Apr 2020 13:06:10 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:b4ef:508c:423e:3e6a? ([2601:282:803:7700:b4ef:508c:423e:3e6a])
        by smtp.googlemail.com with ESMTPSA id y18sm7801qty.41.2020.04.17.13.06.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Apr 2020 13:06:09 -0700 (PDT)
Subject: Re: [PATCH RFC-v5 bpf-next 09/12] dev: Support xdp in the Tx path for
 xdp_frames
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200413171801.54406-1-dsahern@kernel.org>
 <20200413171801.54406-10-dsahern@kernel.org> <87imhzlea3.fsf@toke.dk>
 <1a15e955-7018-cb86-e090-e2024f3e0dc9@gmail.com> <877dyelb0p.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f312b469-803e-bb15-935c-68f41ebbb4ab@gmail.com>
Date:   Fri, 17 Apr 2020 14:06:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <877dyelb0p.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/20 3:25 AM, Toke Høiland-Jørgensen wrote:
>> not sure I understand. This is the redirect case. ie.., On rx a program
>> is run, XDP_REDIRECT is returned and the packet is queued. Once the
>> queue fills or flush is done, bq_xmit_all is called to send the
>> frames.
> I just meant that eventually we'd want to populate xdp_txq_info with a
> TX HWQ index (and possibly other stuff), right? So how do you figure
> we'd get that information at this call site?

same way it is done for skb's.

1. Add queue_mapping to struct xdp_frame

2. Update ndo_select_queue for xdp_frames

net_device_ops has ndo_select_queue which can be extended to handle
xdp_frames with a reasonable level of work (e.g., lowest bit in the
pointer is a flag signaling skb or xdp_frame). Right now, all queue
selection for xdp frames is buried in ndo_xdp_xmit and is cpu id based.
Move that code to ndo_select_queue (or make an xdp variant).

3. Refactor netdev_core_pick_tx. Move the guts of netdev_core_pick_tx -
the queue id selection - to a separate helper.

4. bq_xmit_all calls the new helper to set the tx queue for all frames.

5. Pass the queue index to the egress bpf program and make it writable
for steering.

6. ndo_xdp_xmit implementation use the index from the xdp_frame just
like ndo_start_xmit uses the mapping from the skb.

Just a bit of code movement and refactoring.
