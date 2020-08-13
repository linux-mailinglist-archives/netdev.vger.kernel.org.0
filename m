Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16026244038
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 23:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgHMVBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 17:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgHMVBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 17:01:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D05720715;
        Thu, 13 Aug 2020 21:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597352514;
        bh=XYjE4M7c87GPxUaODyYmsXo++g7jdEEJTfG6obbcGQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1KC18ENBKL28GM7Ij9JNqUP1ucQbzQhDoJnXrqH13qjWZM6FiPaS3TdHl8ClfzADV
         81cZQRc69nExWH4h4aHFTscM6D3u5p/2UjWN5MYceIfVlewbTIpZy+uLGpv6o1Xhgc
         d0riwa5/ZQyv+SPqUZBDia1Oq1vKfXeot7lUV6IU=
Date:   Thu, 13 Aug 2020 14:01:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, Thomas Ptacek <thomas@sockpuppet.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net v4] net: xdp: account for layer 3 packets in generic
 skb handler
Message-ID: <20200813140152.1aab6068@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200813195816.67222-1-Jason@zx2c4.com>
References: <20200813195816.67222-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Aug 2020 21:58:16 +0200 Jason A. Donenfeld wrote:
> - cls_bpf does not support the same feature set as XDP, and operates at
>   a slightly different stage in the networking stack.

Please elaborate.

> I had originally dropped this patch, but the issue kept coming up in
> user reports, so here's a v4 of it. Testing of it is still rather slim,
> but hopefully that will change in the coming days.

Here an alternative patch, untested:

diff --git a/net/core/dev.c b/net/core/dev.c
index d3d53dc601f9..7f68831bdd4f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5434,6 +5434,11 @@ static int generic_xdp_install(struct net_device *dev, struct netdev_bpf *xdp)
        struct bpf_prog *new = xdp->prog;
        int ret = 0;
 
+       if (!dev->hard_header_len) {
+               NL_SET_ERR_MSG(xdp->extack, "generic XDP not supported on L3 devices, please use cls_bpf");
+               return -EINVAL;
+       }
+
        if (new) {
                u32 i;
 
