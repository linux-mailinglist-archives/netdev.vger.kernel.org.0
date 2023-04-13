Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0B76E127D
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjDMQkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjDMQkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:40:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D876B8A6A;
        Thu, 13 Apr 2023 09:40:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6777663FDC;
        Thu, 13 Apr 2023 16:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CEFC433D2;
        Thu, 13 Apr 2023 16:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681404005;
        bh=izUZnBlpqKhrOemjMQlQ/aNyVeCCaykBq9pZH8LYzrE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mV172mFxB6ZMZj/kTDxvU7GqmLSM12EClHuQSW9+FuPWrJS/8sOoVp1TRoMGOQhzg
         tgrAzRwK0kn1rShHFmuT2uOliRUnt//OiRyUzH7CTqpqpwNnzYT1ShurwRaspSx5sq
         rErIjVUEdJKqX43Eszo93ZV3/wxPW9KTZDXD7F7Xio39CkEKpzg6LtqNbuYxsZzXNw
         D9rc9DtIFZFtftUAYjjsxwG5JwpiLFYXLN4hTj85yeshtmq6gWbfCwb0ICNytfaww4
         s1W6K9wEhE1BF97kaZZVIuH1svXoX0QMuwzArhkqJ5PKzrKY9tQ+NeTifiSm0uxT9f
         3gMT0Nfl+4zlw==
Date:   Thu, 13 Apr 2023 09:40:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Long Li <longli@microsoft.com>,
        "ssengar@linux.microsoft.com" <ssengar@linux.microsoft.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3,net-next, 2/4] net: mana: Refactor RX buffer
 allocation code to prepare for various MTU
Message-ID: <20230413094003.3fa4cd8c@kernel.org>
In-Reply-To: <20230413163059.GS17993@unreal>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
        <1681334163-31084-3-git-send-email-haiyangz@microsoft.com>
        <20230413130428.GO17993@unreal>
        <PH7PR21MB3116194E8F7D56EB434B56A6CA989@PH7PR21MB3116.namprd21.prod.outlook.com>
        <20230413163059.GS17993@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 19:30:59 +0300 Leon Romanovsky wrote:
> > So the page pool is optimized for the XDP, and that sentence is applicable to drivers
> > that have set up page pool for XDP optimization.  
> 
> "but it can fallback on the regular page allocator APIs."

The XDP thing is historic AFAIU, page_pool has been expanded to cover
all uses cases, and is "just better" (tm) than using page allocator
directly. Maybe we should update the doc.
