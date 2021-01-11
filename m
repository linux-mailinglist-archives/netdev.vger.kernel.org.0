Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9552F1228
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 13:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbhAKML1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 07:11:27 -0500
Received: from mail-03.mail-europe.com ([91.134.188.129]:44178 "EHLO
        mail-03.mail-europe.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbhAKML0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 07:11:26 -0500
Date:   Mon, 11 Jan 2021 12:09:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1610366997; bh=zUY1WTDEiMVW2+TLKz6QzDCMBOZ6h9D50PRiYZRI15E=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=cAHC/A9CkwDn9wy1cgwJc5gsJHjgqEyimjEimCKPMLzw7DiGk5avDFOZn1TIrlFuI
         wrVyHm9ygMCIVI6uc5nS6rPFcQ3t/QeJqsSojuiGiEX4Dm9QnifesPm7/9x4B0FUsT
         oPx2fWkf/QJCqkYUlUiKKfzM4Z8OAEg1ZmLL2q4Q+L+OdbLHAcjS4dpDsNSTMAEjL4
         KR7aLkhkxfVvg8ity9wkNWXG4uU61DCKoPV3+T9IoN7RMli3ODHhI4VXPkj0NamG8j
         bd19BMSOq+1Dr+Jol9h6diT19mIDqQ6CGdXfFKLEO0xBpac7Q13SdkSy1xzSyd1gRE
         qFDGdo3P3y0gQ==
To:     Steffen Klassert <steffen.klassert@secunet.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Dongseok Yi <dseok.yi@samsung.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        namkyu78.kim@samsung.com,
        'Alexey Kuznetsov' <kuznet@ms2.inr.ac.ru>,
        'Hideaki YOSHIFUJI' <yoshfuji@linux-ipv6.org>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Willem de Bruijn' <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [RFC PATCH net] udp: check sk for UDP GRO fraglist
Message-ID: <20210111120902.2453-1-alobakin@pm.me>
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

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Mon, 11 Jan 2021 09:43:22 +0100

> On Mon, Jan 11, 2021 at 11:02:42AM +0900, Dongseok Yi wrote:
>> On 2021-01-08 22:35, Steffen Klassert wrote:
>>> On Fri, Jan 08, 2021 at 09:52:28PM +0900, Dongseok Yi wrote:
>>>> It is a workaround patch.
>>>>
>>>> UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
>>>> forwarding. Only the header of head_skb from ip_finish_output_gso ->
>>>> skb_gso_segment is updated but following frag_skbs are not updated.
>>>>
>>>> A call path skb_mac_gso_segment -> inet_gso_segment ->
>>>> udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
>>>> does not try to update any UDP/IP header of the segment list.
>>>>
>>>> It might make sense because each skb of frag_skbs is converted to a
>>>> list of regular packets. Header update with checksum calculation may
>>>> be not needed for UDP GROed frag_skbs.
>>>>
>>>> But UDP GRO frag_list is started from udp_gro_receive, we don't know
>>>> whether the skb will be NAT forwarded at that time. For workaround,
>>>> try to get sock always when call udp4_gro_receive -> udp_gro_receive
>>>> to check if the skb is for local.
>>>>
>>>> I'm still not sure if UDP GRO frag_list is really designed for local
>>>> session only. Can kernel support NAT forward for UDP GRO frag_list?
>>>> What am I missing?
>>>
>>> The initial idea when I implemented this was to have a fast
>>> forwarding path for UDP. So forwarding is a usecase, but NAT
>>> is a problem, indeed. A quick fix could be to segment the
>>> skb before it gets NAT forwarded. Alternatively we could
>>> check for a header change in __udp_gso_segment_list and
>>> update the header of the frag_skbs accordingly in that case.
>>
>> Thank you for explaining.
>> Can I think of it as a known issue?
>
> No, it was not known before you reported it.
>
>> I think we should have a fix
>> because NAT can be triggered by user. Can I check the current status?
>> Already planning a patch or a new patch should be written?
>
> We have to do a new patch to fix that issue. If you want do
> do so, go ahead.

This patch is incorrect. I do NAT UDP GRO Fraglists via nftables
(both with and without flow offload) with no issues since March'20.
Packet loss rates are always +/- 0, so I can say it works properly.
I can share any details / dump any runtime data if needed.

Thanks,
Al

