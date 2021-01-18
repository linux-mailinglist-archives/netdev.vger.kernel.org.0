Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1937A2F9F59
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 13:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391174AbhARMS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 07:18:57 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:22140 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391242AbhARMSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 07:18:30 -0500
Date:   Mon, 18 Jan 2021 12:17:34 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610972263; bh=7UZIzTfB4fZUh0LfKdB0wEPFEMIHF3bWhX9FdPzdAaE=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=pcbve/zhJHHnPC6G87DsIHZRVvmDTB8sQVPS5IYdVMFRiFrdHcucxG5d1vC33OiFj
         A1ROQje7/utT1Wfvbtyo8Gz0h8L7MZRkaKL5rrXrC4eqhEB/AXYeUjaHRgHyOIU1Dm
         kmh/Gcg791KRxhy024EoqB1ObMAJEzWnhMczxBgYldR7r8XjCJqkz5LHok9EjL++FL
         KtinPlnkc4UpXSvRfCChIQku105/c5BuaBre29OXI65rQsSLfpgvawoeC0TBeIdNvc
         EQoCAj/EyrvocL6Gz6uMR5k9FNAywEOMVKN5cqYiKfcvW5CL4Lg1IM5lcu7BTQ6n7H
         KJ9D9mI3reEWw==
To:     Steffen Klassert <steffen.klassert@secunet.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Dongseok Yi <dseok.yi@samsung.com>,
        "David S. Miller" <davem@davemloft.net>, namkyu78.kim@samsung.com,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net v2] udp: ipv4: manipulate network header of NATed UDP GRO fraglist
Message-ID: <20210118121707.2130-1-alobakin@pm.me>
In-Reply-To: <20210118063759.GK3576117@gauss3.secunet.de>
References: <CGME20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2@epcas2p1.samsung.com> <1610716836-140533-1-git-send-email-dseok.yi@samsung.com> <20210115171203.175115-1-alobakin@pm.me> <20210118063759.GK3576117@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Steffen Klassert <steffen.klassert@secunet.com>
> Date: Mon, 18 Jan 2021 07:37:59 +0100
>
> On Fri, Jan 15, 2021 at 05:12:33PM +0000, Alexander Lobakin wrote:
>> From: Dongseok Yi <dseok.yi@samsung.com>
>> Date: Fri, 15 Jan 2021 22:20:35 +0900
>>
>>> UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
>>> forwarding. Only the header of head_skb from ip_finish_output_gso ->
>>> skb_gso_segment is updated but following frag_skbs are not updated.
>>>
>>> A call path skb_mac_gso_segment -> inet_gso_segment ->
>>> udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
>>> does not try to update UDP/IP header of the segment list but copy
>>> only the MAC header.
>>>
>>> Update dport, daddr and checksums of each skb of the segment list
>>> in __udp_gso_segment_list. It covers both SNAT and DNAT.
>>>
>>> Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
>>> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
>>> ---
>>> v1:
>>> Steffen Klassert said, there could be 2 options.
>>> https://lore.kernel.org/patchwork/patch/1362257/
>>> I was trying to write a quick fix, but it was not easy to forward
>>> segmented list. Currently, assuming DNAT only.
>>>
>>> v2:
>>> Per Steffen Klassert request, move the procedure from
>>> udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.
>>>
>>> To Alexander Lobakin, I've checked your email late. Just use this
>>> patch as a reference. It support SNAT too, but does not support IPv6
>>> yet. I cannot make IPv6 header changes in __udp_gso_segment_list due
>>> to the file is in IPv4 directory.
>>
>> I used another approach, tried to make fraglist GRO closer to plain
>> in terms of checksummming, as it is confusing to me why GSO packet
>> should have CHECKSUM_UNNECESSARY.
>
> This is intentional. With fraglist GRO, we don't mangle packets
> in the standard (non NAT) case. So the checksum is still correct
> after segmentation. That is one reason why it has good forwarding
> performance when software segmentation is needed. Checksuming
> touches the whole packet and has a lot of overhead, so it is
> heplfull to avoid it whenever possible.
>
> We should find a way to do the checksum only when we really
> need it. I.e. only if the headers of the head skb changed.

I suggest to do memcmp() between skb_network_header(skb) and
skb_network_header(skb->frag_list) with the len of
skb->data - skb_network_header(skb). This way we will detect changes
in IPv4/IPv6 and UDP headers.
If so, copy the full headers and fall back to the standard checksum,
recalculation, else use the current path.

Al

