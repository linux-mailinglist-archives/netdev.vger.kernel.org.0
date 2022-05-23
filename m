Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B80531395
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236292AbiEWNfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 09:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236294AbiEWNfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 09:35:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B33D2275E1
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 06:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653312942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8c2zoLQL1fQT0gHH2dJM2YqDfdDFpygc8onqT1U47Dw=;
        b=c3T6RQt5EGcSXje2f+TGDDJApTxauyRHd+w5YOH6T8YyoBsv3afjEgeDPtde85NgwvRzcp
        cf5eKWgeptw4ZfAiuiCAmgZIpgqDTfyDxkNKryx3wriaDhrOw0alUeaDo/FgOzzAXcExrt
        9vwvfwVFuAHqyIu8gbzUZ/qBaMjTfcw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-khJtMCl7Osu0FQx-o6WL4w-1; Mon, 23 May 2022 09:35:41 -0400
X-MC-Unique: khJtMCl7Osu0FQx-o6WL4w-1
Received: by mail-qk1-f197.google.com with SMTP id q5-20020a05620a0d8500b004738c1b48beso11376037qkl.7
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 06:35:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8c2zoLQL1fQT0gHH2dJM2YqDfdDFpygc8onqT1U47Dw=;
        b=SEfBp5oAuovLBdnLxVbhAtcgHcqNCDM/FbnpT/LC6z+nHIoP6oraoWlYobeQQNrGCR
         vp9zFyjlqk82RXgIavn+UjR53cO/2Qu9NrsE0kAbIpVH+CrTiSyvRwbzSePi6yc+RHMf
         9bazPESxch8jxJF9n6A4dPy9PK+T2W+ixgCjyEUrto2I18G2PRRXfuSGw/Y0RHxPA0rj
         yYqfBFxmd9vr0MeRIaw+3k/B7rCqvBYfxU2xYAAInSk4xoV2sQzUh75Pqnktxk6c7eIF
         klLU9/Nx68XdqFMPqEsx6hc2FW6XMu1XDIOrwtspU2duzuQz2L8zfYkKGCqdyNIZeRJB
         3kPw==
X-Gm-Message-State: AOAM5336UmZhLqqQ+cjWzs2JwfmVYZOtKHdX1ZrEwjwEuYbQ4stulPfq
        7RhJrMoNrYFyY3ybTYD+8Ak9GJKQOUjNakQzuCxB23M84+BqCqZFM3V1zrHzIceDPlUxMiEy2TM
        viRbSz1pwhCT1wWzU
X-Received: by 2002:a05:620a:4091:b0:6a0:54cf:c0ed with SMTP id f17-20020a05620a409100b006a054cfc0edmr13913331qko.578.1653312940949;
        Mon, 23 May 2022 06:35:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw7aaYQSIoBF2JTokQMX1mwzzn3ulfSPWVZXo4pRiLF8pGAji9/Pxyw849JUfw99Dnqvcc5Qw==
X-Received: by 2002:a05:620a:4091:b0:6a0:54cf:c0ed with SMTP id f17-20020a05620a409100b006a054cfc0edmr13913312qko.578.1653312940682;
        Mon, 23 May 2022 06:35:40 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id w36-20020a05622a192400b002f39b99f69dsm4199479qtc.55.2022.05.23.06.35.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 06:35:40 -0700 (PDT)
Message-ID: <b26b64d8-9569-8d1d-aef5-3d01c819267c@redhat.com>
Date:   Mon, 23 May 2022 09:35:38 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next v3] bond: add mac filter option for balance-xor
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     toke@redhat.com, Long Xin <lxin@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <b32eb6656d5a54c0cde6277e9fc5c249c63489ca.1652463336.git.jtoppins@redhat.com>
 <4c9db6ac-aa24-2ca2-3e44-18cfb23ac1bc@blackwall.org>
 <da6bbb3b-344c-f032-fe03-5e8c8ac3c388@blackwall.org>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <da6bbb3b-344c-f032-fe03-5e8c8ac3c388@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/15/22 02:32, Nikolay Aleksandrov wrote:
> On 15/05/2022 00:41, Nikolay Aleksandrov wrote:
>> On 13/05/2022 20:43, Jonathan Toppins wrote:
>>> Implement a MAC filter that prevents duplicate frame delivery when
>>> handling BUM traffic. This attempts to partially replicate OvS SLB
>>> Bonding[1] like functionality without requiring significant change
>>> in the Linux bridging code.
>>>
>>> A typical network setup for this feature would be:
>>>
>>>              .--------------------------------------------.
>>>              |         .--------------------.             |
>>>              |         |                    |             |
>>>         .-------------------.               |             |
>>>         |    | Bond 0  |    |               |             |
>>>         | .--'---. .---'--. |               |             |
>>>    .----|-| eth0 |-| eth1 |-|----.    .-----+----.   .----+------.
>>>    |    | '------' '------' |    |    | Switch 1 |   | Switch 2  |
>>>    |    '---,---------------'    |    |          +---+           |
>>>    |       /                     |    '----+-----'   '----+------'
>>>    |  .---'---.    .------.      |         |              |
>>>    |  |  br0  |----| VM 1 |      |      ~~~~~~~~~~~~~~~~~~~~~
>>>    |  '-------'    '------'      |     (                     )
>>>    |      |        .------.      |     ( Rest of Network     )
>>>    |      '--------| VM # |      |     (_____________________)
>>>    |               '------'      |
>>>    |  Host 1                     |
>>>    '-----------------------------'
>>>
>>> Where 'VM1' and 'VM#' are hosts connected to a Linux bridge, br0, with
>>> bond0 and its associated links, eth0 & eth1, provide ingress/egress. One
>>> can assume bond0, br1, and hosts VM1 to VM# are all contained in a
>>> single box, as depicted. Interfaces eth0 and eth1 provide redundant
>>> connections to the data center with the requirement to use all bandwidth
>>> when the system is functioning normally. Switch 1 and Switch 2 are
>>> physical switches that do not implement any advanced L2 management
>>> features such as MLAG, Cisco's VPC, or LACP.
>>>
>>> Combining this feature with vlan+srcmac hash policy allows a user to
>>> create an access network without the need to use expensive switches that
>>> support features like Cisco's VCP.
>>>
>>> [1] https://docs.openvswitch.org/en/latest/topics/bonding/#slb-bonding
>>>
>>> Co-developed-by: Long Xin <lxin@redhat.com>
>>> Signed-off-by: Long Xin <lxin@redhat.com>
>>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>>> ---
>>>
>>> Notes:
>>>      v2:
>>>       * dropped needless abstraction functions and put code in module init
>>>       * renamed variable "rc" to "ret" to stay consistent with most of the
>>>         code
>>>       * fixed parameter setting management, when arp-monitor is turned on
>>>         this feature will be turned off similar to how miimon and arp-monitor
>>>         interact
>>>       * renamed bond_xor_recv to bond_mac_filter_recv for a little more
>>>         clarity
>>>       * it appears the implied default return code for any bonding recv probe
>>>         must be `RX_HANDLER_ANOTHER`. Changed the default return code of
>>>         bond_mac_filter_recv to use this return value to not break skb
>>>         processing when the skb dev is switched to the bond dev:
>>>           `skb->dev = bond->dev`
>>>      
>>>      v3: Nik's comments
>>>       * clarified documentation
>>>       * fixed inline and basic reverse Christmas tree formatting
>>>       * zero'ed entry in mac_create
>>>       * removed read_lock taking in bond_mac_filter_recv
>>>       * made has_expired() atomic and removed critical sections
>>>         surrounding calls to has_expired(), this also removed the
>>>         use-after-free that would have occurred:
>>>             spin_lock_irqsave(&entry->lock, flags);
>>>                 if (has_expired(bond, entry))
>>>                     mac_delete(bond, entry);
>>>             spin_unlock_irqrestore(&entry->lock, flags); <---
>>>       * moved init/destroy of mac_filter_tbl to bond_open/bond_close
>>>         this removed the complex option dependencies, the only behavioural
>>>         change the user will see is if the bond is up and mac_filter is
>>>         enabled if they try and set arp_interval they will receive -EBUSY
>>>       * in bond_changelink moved processing of mac_filter option just below
>>>         mode processing
>>>
>>>   Documentation/networking/bonding.rst  |  20 +++
>>>   drivers/net/bonding/Makefile          |   2 +-
>>>   drivers/net/bonding/bond_mac_filter.c | 201 ++++++++++++++++++++++++++
>>>   drivers/net/bonding/bond_mac_filter.h |  37 +++++
>>>   drivers/net/bonding/bond_main.c       |  30 ++++
>>>   drivers/net/bonding/bond_netlink.c    |  13 ++
>>>   drivers/net/bonding/bond_options.c    |  81 +++++++++--
>>>   drivers/net/bonding/bonding_priv.h    |   1 +
>>>   include/net/bond_options.h            |   1 +
>>>   include/net/bonding.h                 |   3 +
>>>   include/uapi/linux/if_link.h          |   1 +
>>>   11 files changed, 373 insertions(+), 17 deletions(-)
>>>   create mode 100644 drivers/net/bonding/bond_mac_filter.c
>>>   create mode 100644 drivers/net/bonding/bond_mac_filter.h
>>>
>>
> [snip]
> 
> The same problem solved using a few nftables rules (in case you don't want to load eBPF):
> $ nft 'add table netdev nt'
> $ nft 'add chain netdev nt bond0EgressFilter { type filter hook egress device bond0 priority 0; }'
> $ nft 'add chain netdev nt bond0IngressFilter { type filter hook ingress device bond0 priority 0; }'
> $ nft 'add set netdev nt macset { type ether_addr; flags timeout; }'
> $ nft 'add rule netdev nt bond0EgressFilter set update ether saddr timeout 5s @macset'
> $ nft 'add rule netdev nt bond0IngressFilter ether saddr @macset counter drop'

So I did some testing on this nft solution and it performs largely the 
same as the bonding solution except for handling rule1 of the OVS SLB[1] 
for multicast[2] and broadcast[3] traffic. If this can be corrected then 
I think it would be a possible solution otherwise the bonding solution 
fits the requirements better.

-Jon

[1] https://docs.openvswitch.org/en/latest/topics/bonding/#slb-bonding
[2] 
https://gitlab.com/liali666/virtual-networking/-/blob/master/tests/test-0012-ovs-rule1-multicast
[3] 
https://gitlab.com/liali666/virtual-networking/-/blob/master/tests/test-0011-ovs-rule1-broadcast

