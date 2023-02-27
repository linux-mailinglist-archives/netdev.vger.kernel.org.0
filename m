Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C446A4FA5
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 00:27:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjB0X1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 18:27:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjB0X1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 18:27:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDE021299
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 15:27:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05D4C60A48
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 23:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15746C433D2;
        Mon, 27 Feb 2023 23:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677540462;
        bh=6/TbNA+lMB9z0/5W1jUdCiw4uuIhRwRC3dSa+niFppI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WNjrVVf1TqG8qvre8/ZA/P92egCLguCC8xLJTkhcepnfY+YazgI6slpdfxBYAHp2P
         bvMkLh6vTIy3qA4L7+DXanPCraFhLxbnYm9I5uUzlL9FkTSUXVUJIY5yolYfhdZkoq
         C5zfjSCeyxIceOgU3BoLQT6k7S97d6OTxp3ErB6Rb/dqO9hMrM00wyS1u5lmtzL+SH
         3bF9r3yVoQYUmCTeSRCv0gy/VNzzsrRCvWtH9dJ6J+dOYR7prspZyyLdoEOkJydP64
         QtQwIhaT2w3QSVN1v84qb6rtkbGNOIG2cvEjlsbcyj3yXljnEVxq9uvLURBd6/TeP9
         F5ZZLdoLE1qSg==
Date:   Mon, 27 Feb 2023 15:27:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     edumazet@google.com
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, shakeelb@google.com,
        soheil@google.com
Subject: Re: [PATCH net] net: avoid indirect memory pressure calls
Message-ID: <20230227152741.4a53634b@kernel.org>
In-Reply-To: <20230224184606.7101-1-fw@strlen.de>
References: <20230224184606.7101-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 19:46:06 +0100 Florian Westphal wrote:
> There is a noticeable tcp performance regression (loopback or cross-netns),
> seen with iperf3 -Z (sendfile mode) when generic retpolines are needed.
> 
> With SK_RECLAIM_THRESHOLD checks gone number of calls to enter/leave
> memory pressure happen much more often. For TCP indirect calls are
> used.
> 
> We can't remove the if-set-return short-circuit check in
> tcp_enter_memory_pressure because there are callers other than
> sk_enter_memory_pressure.  Doing a check in the sk wrapper too
> reduces the indirect calls enough to recover some performance.
> 
> Before,
> 0.00-60.00  sec   322 GBytes  46.1 Gbits/sec                  receiver
> 
> After:
> 0.00-60.04  sec   359 GBytes  51.4 Gbits/sec                  receiver
> 
> "iperf3 -c $peer -t 60 -Z -f g", connected via veth in another netns.
> 
> Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Looks acceptable, Eric?
