Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4BF488D79
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 01:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235699AbiAJAX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 19:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbiAJAX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 19:23:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFAEC06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 16:23:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C556BB80EB3
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 00:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD95C36AEB;
        Mon, 10 Jan 2022 00:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641774204;
        bh=SqXWxaYQIEtfV69IPVrg3nyV2yceEhQ13jx0cvyXYao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iV/R4wGHJcYEzkeszFWnn+GphRj5RSFjRMwysL5YxDeMN+l/C/7cxJ9XmG6CLW713
         BN0N05HCtQTAVtiXHD0uVw6uDSqf3eihH/gZ3sJBktXy2y26kClQlMK1sWc7JgrwCM
         zhZ5jq0Bks9H2QMhg9TkKVXehLEFFfWJF1jyvsoMQopXMLp9CyrQZq1Fh9xBIfW/ic
         uciDdiH86jz/JwDQiqCVp5nb7gnJpcVYETidJMiwkxtupvp4MK6tzDfP6eh5JGLAeZ
         rmT8ivX92qLxJLlnx6avZQwyAzcU5CkOHu6R1kUIDS5hKnLH73Y8s/YK/K7wYa7Kxo
         rOxXGcbNd2oKQ==
Date:   Sun, 9 Jan 2022 16:23:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, wenxu <wenxu@ucloud.cn>,
        Varun Prakash <varun@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Vlad Buslov <vladbu@nvidia.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH net 0/4] ipv4: Fix accidental RTO_ONLINK flags passed to
 ip_route_output_key_hash()
Message-ID: <20220109162322.4fc665bc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <cover.1641407336.git.gnault@redhat.com>
References: <cover.1641407336.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jan 2022 20:56:16 +0100 Guillaume Nault wrote:
> The IPv4 stack generally uses the last bit of ->flowi4_tos as a flag
> indicating link scope for route lookups (RTO_ONLINK). Therefore, we
> have to be careful when copying a TOS value to ->flowi4_tos. In
> particular, the ->tos field of IPv4 packets may have this bit set
> because of ECN. Also tunnel keys generally accept any user value for
> the tos.
> 
> This series fixes several places where ->flowi4_tos was set from
> non-sanitised values and the flowi4 structure was later used by
> ip_route_output_key_hash().
> 
> Note that the IPv4 stack usually clears the RTO_ONLINK bit using
> RT_TOS(). However this macro is based on an obsolete interpretation of
> the old IPv4 TOS field (RFC 1349) and clears the three high order bits.
> Since we don't need to clear these bits and since it doesn't make sense
> to clear only one of the ECN bits, this patch series uses INET_ECN_MASK
> instead.
> 
> All patches were compile tested only.

Does not apply cleanly to net any more, could you respin?
