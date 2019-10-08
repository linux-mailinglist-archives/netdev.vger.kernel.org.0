Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04BAACFCF6
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 16:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbfJHO6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 10:58:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35428 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfJHO6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 10:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=r1CXkHFfxR6DDQvYG+ME9upXhl7DLD0AMwOG4chkn/w=; b=kLKaaNlesyt3uQdlaZDaL7Sn2
        izcwLKz5nG21Wzk3BsjIUbbxcMXiej4R6vYNK7ka03xZ4sTYLAMm9AMroXtEQP0TmV11UVzP6VQl2
        Q6hWesDgNroofRUO5z3brr9ZhU2wc0i/Ah/rYU8fVP+PbPvjDYK1fJ0eRbIl4hKdxgIg8PimP4toj
        KtFEgUNHcWoEjttOzzlLxBXnqamwTkUMNZTSqlatCp5y/jHWR+w0hUGycloRSHjUrBIG5nvBx5UY1
        bni4e12Y3n09fP81xTS3i7eZ5+yQ6w9oJS5RAoc9E3ONl3uje8NNknfnrux1P+LStULgT2H4GEMUx
        L0uZBOSlA==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHqwF-0006D8-3N; Tue, 08 Oct 2019 14:58:11 +0000
Subject: Re: [PATCH net-next 2/2] Special handling for IP & MPLS.
To:     Martin Varghese <martinvarghesenokia@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, corbet@lwn.net,
        scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <1da8fb9d3af8dcee1948903ae816438578365e51.1570455278.git.martinvarghesenokia@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d81f77b9-2d43-70df-c11d-1aa8286abffe@infradead.org>
Date:   Tue, 8 Oct 2019 07:58:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1da8fb9d3af8dcee1948903ae816438578365e51.1570455278.git.martinvarghesenokia@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/19 2:49 AM, Martin Varghese wrote:
> From: Martin <martin.varghese@nokia.com>
> 
> Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> 
> Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>

drop one of those.

> ---
>  Documentation/networking/bareudp.txt | 18 ++++++++
>  drivers/net/bareudp.c                | 82 +++++++++++++++++++++++++++++++++---
>  include/net/bareudp.h                |  1 +
>  include/uapi/linux/if_link.h         |  1 +
>  4 files changed, 95 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/networking/bareudp.txt b/Documentation/networking/bareudp.txt
> index d2530e2..4de1022 100644
> --- a/Documentation/networking/bareudp.txt
> +++ b/Documentation/networking/bareudp.txt
> @@ -9,6 +9,15 @@ The Bareudp tunnel module provides a generic L3 encapsulation tunnelling
>  support for tunnelling different L3 protocols like MPLS, IP, NSH etc. inside
>  a UDP tunnel.
>  
> +Special Handling
> +----------------
> +The bareudp device supports special handling for MPLS & IP as they can have
> +multiple ethertypes.
> +MPLS procotcol can have ethertypes 0x8847 (unicast) & 0x8847 (multicast).

                                                         0x8848

> +IP proctocol can have ethertypes 0x0800 (v4) & 0x866 (v6).
> +This special handling can be enabled only for ethertype 0x0800 & 0x88847 with a
> +flag called extended mode.
> +
>  Usage
>  ------
>  
> @@ -21,3 +30,12 @@ This creates a bareudp tunnel device which tunnels L3 traffic with ethertype
>  The device will listen on UDP port 6635 to receive traffic.
>  
>  b. ip link delete bareudp0
> +
> +2. Device creation with extended mode enabled
> +
> +There are two ways to create a bareudp device for MPLS & IP with extended mode
> +enabled

end that sentence with a period. (or full stop)

> +
> +a. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype 0x8847 extmode 1
> +
> +b. ip link add dev  bareudp0 type bareudp dstport 6635 ethertype mpls


-- 
~Randy
