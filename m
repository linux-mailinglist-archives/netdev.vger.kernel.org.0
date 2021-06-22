Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25B93AFABE
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 03:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhFVCAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 22:00:40 -0400
Received: from novek.ru ([213.148.174.62]:38250 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229663AbhFVCAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 22:00:36 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id BC6685006D2;
        Tue, 22 Jun 2021 04:56:24 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru BC6685006D2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1624326986; bh=ngYBKqQHwva41GA1mYdUHQ+H9OGWQApvACV/JSk1gQg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=D1TmovyTNK4N25ntl+FcBCYLhx0FsdvvpRlNQzok7nzYlwnQ+0UHJSadg2NivTEy4
         VDiiReXQzUl8KJGczhhWqxIfpODRYzg8pS7wrL6DvS749uAf2bvVFVewSkj6eCBI3F
         J/BvI3P4obQMW4m09i6dRkuZlALiNB/851UaiXqA=
Subject: Re: [PATCH net] ip6_tunnel: fix GRE6 segmentation
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <20210622015254.1967716-1-kuba@kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <a3b17b07-2d7a-7bdc-b533-0f55a72f0b54@novek.ru>
Date:   Tue, 22 Jun 2021 02:58:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210622015254.1967716-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.06.2021 02:52, Jakub Kicinski wrote:
> Commit 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
> moved assiging inner_ipproto down from ipxip6_tnl_xmit() to
> its callee ip6_tnl_xmit(). The latter is also used by GRE.
> 
> Since commit 38720352412a ("gre: Use inner_proto to obtain inner
> header protocol") GRE had been depending on skb->inner_protocol
> during segmentation. It sets it in gre_build_header() and reads
> it in gre_gso_segment(). Changes to ip6_tnl_xmit() overwrite
> the protocol, resulting in GSO skbs getting dropped.
> 
> Note that inner_protocol is a union with inner_ipproto,
> GRE uses the former while the change switched it to the latter
> (always setting it to just IPPROTO_GRE).
> 
> Restore the original location of skb_set_inner_ipproto(),
> it is unclear why it was moved in the first place.
> 
> Fixes: 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
Tested-by: Vadim Fedorenko <vfedorenko@novek.ru>
