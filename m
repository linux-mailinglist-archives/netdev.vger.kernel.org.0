Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA82A2A53EE
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387656AbgKCVGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:06:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388085AbgKCVGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 16:06:01 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA24205ED;
        Tue,  3 Nov 2020 21:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437561;
        bh=gzsal+fbN4PJa2ZLri5dbncG1W0gFkL4fI8TPJdRhVI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LYrucxedOpQevCw8esz+RXprOoPKUYdDn9B3kfgxbjcSLzWgv8l5kAa/vjBPGetE5
         ekV+XkI+m/cBHFrR+5Wt352d+PCO8gtwCd1bjF2yxKCEYGwn+VYCfyUp5W/7uz1uRt
         dXQFhwGOnYkDAe4uKyiMtJT7MKS8zxHA7M9kjGak=
Date:   Tue, 3 Nov 2020 13:05:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     LIU Yulong <liuyulong.xa@gmail.com>
Cc:     netdev@vger.kernel.org, LIU Yulong <i@liuyulong.me>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH v2] net: bonding: alb disable balance for IPv6 multicast
 related mac
Message-ID: <20201103130559.0335c353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604303803-30660-1-git-send-email-i@liuyulong.me>
References: <1603850163-4563-1-git-send-email-i@liuyulong.me>
        <1604303803-30660-1-git-send-email-i@liuyulong.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 15:56:43 +0800 LIU Yulong wrote:
> According to the RFC 2464 [1] the prefix "33:33:xx:xx:xx:xx" is defined to
> construct the multicast destination MAC address for IPv6 multicast traffic.
> The NDP (Neighbor Discovery Protocol for IPv6)[2] will comply with such
> rule. The work steps [6] are:
>   *) Let's assume a destination address of 2001:db8:1:1::1.
>   *) This is mapped into the "Solicited Node Multicast Address" (SNMA)
>      format of ff02::1:ffXX:XXXX.
>   *) The XX:XXXX represent the last 24 bits of the SNMA, and are derived
>      directly from the last 24 bits of the destination address.
>   *) Resulting in a SNMA ff02::1:ff00:0001, or ff02::1:ff00:1.
>   *) This, being a multicast address, can be mapped to a multicast MAC
>      address, using the format 33-33-XX-XX-XX-XX
>   *) Resulting in 33-33-ff-00-00-01.
>   *) This is a MAC address that is only being listened for by nodes
>      sharing the same last 24 bits.
>   *) In other words, while there is a chance for a "address collision",
>      it is a vast improvement over ARP's guaranteed "collision".
> Kernel related code can be found at [3][4][5].

Please make sure you keep maintainers CCed on your postings, adding bond
maintainers now.

> +static inline bool is_ipv6_multicast_ether_addr(const u8 *addr)
> +{
> +	return (addr[0] == 0x33) && (addr[1] == 0x33);
> +}

nit: brackets are not necessary here.
