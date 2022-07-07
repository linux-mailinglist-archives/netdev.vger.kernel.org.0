Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28687569714
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 02:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiGGA5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 20:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234054AbiGGA5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 20:57:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EFB2CE26
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 17:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1B15B81F5A
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 00:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08439C341C6;
        Thu,  7 Jul 2022 00:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657155464;
        bh=F0wc5XPhzNd/WC6KvA0YonlYn/8KVXft4gqipxqSdX4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=krosuDrUlXtfsZUvV76QJgUOrUuYZzxBE7v4Jc5VXUTAl01ojAeFPyPJ6VY4TQPot
         XJnV04G1x+on+Rr8m+CjPEMEREY9ndPvXmrR9f5W+jrKUc8e5E52inmebP7URsAppK
         y7NHsiqCJShvajrwJ7qvT3rVz873SHC44+QTmCiDA+PrU2Ac3RrQSoZ1oP1RDHtNry
         jidWIrovHRyJr+Baan8lmiqOttNfuQfi7sTYJITOHmpysZ4Tywg/sqEPdjv6yDW3Qg
         5yX7LDBVkNN9wSyiowwLNPcnZNAuVSlnLwrxrCwDwAM1S9M3D3SmCTdYs77QBY32LO
         e5SGz4qpPMWJw==
Date:   Wed, 6 Jul 2022 17:57:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "maloy@donjonn.com" <maloy@donjonn.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com" 
        <syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com>
Subject: Re: [net] tipc: fix uninit-value in tipc_nl_node_reset_link_stats
Message-ID: <20220706175742.4d40a173@kernel.org>
In-Reply-To: <DB9PR05MB7641A853BC76A3DBBF2187BFF1839@DB9PR05MB7641.eurprd05.prod.outlook.com>
References: <20220706034752.5729-1-hoang.h.le@dektech.com.au>
        <20220706133334.0a6acab5@kernel.org>
        <DB9PR05MB7641A853BC76A3DBBF2187BFF1839@DB9PR05MB7641.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jul 2022 00:22:06 +0000 Hoang Huu Le wrote:
> > The bug you're fixing is that the string is not null-terminated,
> > so strcmp() can read past the end of the attribute.
> >   
> No, I'm trying to fix below issues:
> 
> BUG: KMSAN: uninit-value in strlen lib/string.c:495 [inline]
> BUG: KMSAN: uninit-value in strstr+0xb4/0x2e0 lib/string.c:840
>  strlen lib/string.c:495 [inline]
>  strstr+0xb4/0x2e0 lib/string.c:840
>  tipc_nl_node_reset_link_stats+0x41e/0xba0 net/tipc/node.c:2582
> 
> I assume the link name attribute is empty as root cause. 
> So, just checking length is enough for fixing this issue.

I pointed you to the code that does NLA_STRING validation and that
already checks:

	if (attrlen < 1)

what am I missing?
