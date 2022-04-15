Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBE9502E44
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 19:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241342AbiDOROK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 13:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235654AbiDOROJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 13:14:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98CC9BAC5;
        Fri, 15 Apr 2022 10:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A820622FC;
        Fri, 15 Apr 2022 17:11:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0EFC385A5;
        Fri, 15 Apr 2022 17:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650042699;
        bh=otlO/OIUU2fVwhveUnEKAHXGYzMlUOqNqTTdX66MHH4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LhS4HVTwBNomPkag1zawxDlK5ZibI99470h9RFi4UMWobq5PdEipjVHGUKbiS7uZE
         tFVZpN7D1D6WMzLPj3UWXmyh0Am6a/8HWyfQKFnIMp5nkn5LB1GBFS6xe3fEqmu8yQ
         XGHM5L8LQDRYVw3MduEDsgIkcwK6YSy9u6yLTwDQsx5fqZZTNknI4CSgc6C4QbCU8d
         7SMTreUvBdKpj04UEFmUWhFGzplE4y3gMU3t08zk3VAJTj8vyP95QEYAyU+BZQSqUx
         WXv7ttzgyk1DnKAgDRDDQBh3aqBLQ93MsuP44z++fmUhielE+iYM8p0R7jGfisbez+
         1Fi6/CLCeUs6A==
Date:   Fri, 15 Apr 2022 19:11:33 +0200
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Feng Zhou <zhoufeng.zf@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] ip6_gre: Fix skb_under_panic in __gre6_xmit()
Message-ID: <20220415191133.0597a79a@kernel.org>
In-Reply-To: <20220414200854.GA2729@bytedance>
References: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649715555.git.peilin.ye@bytedance.com>
        <9cd9ca4ac2c19be288cb8734a86eb30e4d9e2050.1649715555.git.peilin.ye@bytedance.com>
        <20220414131424.744aa842@kernel.org>
        <20220414200854.GA2729@bytedance>
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

On Thu, 14 Apr 2022 13:08:54 -0700 Peilin Ye wrote:
> > We should also reject using SEQ with collect_md, but that's a separate
> > issue.  
> 
> Could you explain this a bit more?  It seems that commit 77a5196a804e
> ("gre: add sequence number for collect md mode.") added this
> intentionally.

Interesting. Maybe a better way of dealing with the problem would be
rejecting SEQ if it's not set on the device itself.

When the device is set up without the SEQ bit enabled it disables Tx
locking (look for LLTX). This means that multiple CPUs can try to do
the tunnel->o_seqno++ in parallel. Not catastrophic but racy for sure.
