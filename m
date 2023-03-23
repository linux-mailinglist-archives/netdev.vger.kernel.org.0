Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB216C5E3C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 05:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjCWExN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 00:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjCWExB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 00:53:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8464E7ECF;
        Wed, 22 Mar 2023 21:53:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16EF9623CF;
        Thu, 23 Mar 2023 04:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00A0C433D2;
        Thu, 23 Mar 2023 04:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679547179;
        bh=7BfqstAZyyD9UKiEt7BWWwDiPxvdWe5+eqGDCaj/lIg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kxKkrIPywX4ik00OEx2XmezAExmx2F0GyS6XS+6oS7ciwrvQc/JF75pRPNLx9cBor
         WL3YWvf9LUxSinElzU00BosC4ZOaWWKdhzLnrhImFcklvOoo86N89ak2PI9doxNo4f
         ABYEQjnIl/M/HcZRpTWRtzi2I1hgJ6eUv22rzcnls/PAQnE12fDTDDTV7GLqxE+iVz
         AEopkwqY/E7AIWc4WhEOnQRcWQRIYvLaq3yjTLjxj4uZ40NXBjUtlTvBhOoMyLsjXU
         ZIuB+Nz0ZhDlUBHDl1mpj6ILkjIT850T28V4XAJTIRrEsCkIN4DfWR0YfNRzmT62eI
         cVmZ1GDk7V/4w==
Date:   Wed, 22 Mar 2023 21:52:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <virtualization@lists.linux-foundation.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/8] virtio_net: mergeable xdp: introduce
 mergeable_xdp_prepare
Message-ID: <20230322215257.298b54cb@kernel.org>
In-Reply-To: <215e791d-1802-2419-ff59-49476bcdcd02@huawei.com>
References: <20230322030308.16046-1-xuanzhuo@linux.alibaba.com>
        <20230322030308.16046-3-xuanzhuo@linux.alibaba.com>
        <c7749936-c154-da51-ccfb-f16150d19c62@huawei.com>
        <1679535924.6219428-2-xuanzhuo@linux.alibaba.com>
        <215e791d-1802-2419-ff59-49476bcdcd02@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 12:45:41 +0800 Yunsheng Lin wrote:
> >> Also, it seems better to split the xdp_linearize_page() to two functions
> >> as pskb_expand_head() and __skb_linearize() do, one to expand the headroom,
> >> the other one to do the linearizing.  
> > 
> > No skb here.  
> 
> I means following the semantics of pskb_expand_head() and __skb_linearize(),
> not to combine the headroom expanding and linearizing into one function as
> xdp_linearize_page() does now if we want a better refoctor result.

It's a driver-local function, if I was reading the code and saw
xdp_prepare_mergeable() I'd have thought it's a function from XDP core.
If anything the functions are missing local driver prefix. But it's
not a huge deal (given Michael's ping yesterday asking us if we can
expedite merging..)
