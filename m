Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8654B303B
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 23:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354001AbiBKWQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 17:16:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239585AbiBKWQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 17:16:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50A3D44
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 14:16:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BAACB82C8C
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 22:16:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6930C340E9;
        Fri, 11 Feb 2022 22:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644617785;
        bh=ghkFKmPDQNGgoX4znZf4f6pbuimKqdNS+OGFsodb+Zg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jkZXLmB39Q6xSVvXUb7RKCEuVJZTHcia+BbEVGhT1VnBo92O+rWdCVet6r/W++XFp
         2gRJiehCVovL74/WPpuXdvV392AYZE86G1g0TxhpuRwQHAToIzidnQps+UU2+6t056
         uNPvoPbyoFIbqntT+echV7UYWFqq4dhBC1Z7g2yllIOGUkiomC4Gf1YB+AokXXAGQd
         9qgrwi6WCdQ/yTj3LpqAOZXjGWRr7oP3txwTc15Buf5gUFEoOX31nDwVSsic5RnCo/
         Cme4rVWQWePQlvFgogoaupE/MZzZ+eC6ZvWJKTL7cUctPW5ptNYHXH6Fj+WBTYh0zM
         YRJDxQNox4k0Q==
Date:   Fri, 11 Feb 2022 14:16:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Subject: Re: [PATCH net-next 4/4] net: introduce a config option to tweak
 MAX_SKB_FRAGS
Message-ID: <20220211141624.14d6f4ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220210175557.1843151-5-eric.dumazet@gmail.com>
References: <20220210175557.1843151-1-eric.dumazet@gmail.com>
        <20220210175557.1843151-5-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 09:55:57 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Currently, MAX_SKB_FRAGS value is 17.
> 
> For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> attempts order-3 allocations, stuffing 32768 bytes per frag.
> 
> But with zero copy, we use order-0 pages.

If I read this right BIG TCP works but for zc cases, without this patch,
but there's little point to applying this patch without BIG TCP.

Shouldn't the BIG TCP work go in first and then we'll worry about how
many frags can each skb carry?
