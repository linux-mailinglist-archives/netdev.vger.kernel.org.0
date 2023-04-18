Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCD56E5730
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 03:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbjDRB4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 21:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjDRB4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 21:56:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F559769D;
        Mon, 17 Apr 2023 18:55:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7486062BCF;
        Tue, 18 Apr 2023 01:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 435E8C433EF;
        Tue, 18 Apr 2023 01:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681782871;
        bh=34P0NtihnnKfz477IsAMctQ/pLvbKFNzLBx7JaoIYl8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iMgFF4RCqcxwsBBPLWq4eFrgdBkVMrKhs8plXoMbKsMOg/BqbygYjJpgMe9ry1nkP
         Zw3Uo33JuTvNMp/ygca7VwgdqP2M0TwYLR8UxydQxBwKBVy0IOoEhy2qrFH6hLaMiZ
         TQ4fAO6ixlRHfdx2OcNVgLTFl63gTvApYiHP7EM3aLfP3QtlidKz52AGFPFLpVkw/M
         IIrog5jBuRsSrMwGpC0PKqMDwKSppCk1ljVNekiD2FbDjk+lk9wF8+VuPBvZ4Wkrcn
         JAOtGHamei2bhFr0MxKky0Lnu1M10mPMPOTW1zGcgX41NP/FfMwbFJzV058e7u/d7r
         grnIitYPy5xnA==
Date:   Mon, 17 Apr 2023 18:54:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH net v1] virtio_net: bugfix overflow inside
 xdp_linearize_page()
Message-ID: <20230417185430.6b3ad2b9@kernel.org>
In-Reply-To: <20230414060835.74975-1-xuanzhuo@linux.alibaba.com>
References: <20230414060835.74975-1-xuanzhuo@linux.alibaba.com>
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

On Fri, 14 Apr 2023 14:08:35 +0800 Xuan Zhuo wrote:
> Here we copy the data from the original buf to the new page. But we
> not check that it may be overflow.
> 
> As long as the size received(including vnethdr) is greater than 3840
> (PAGE_SIZE -VIRTIO_XDP_HEADROOM). Then the memcpy will overflow.
> 
> And this is completely possible, as long as the MTU is large, such
> as 4096. In our test environment, this will cause crash. Since crash is
> caused by the written memory, it is meaningless, so I do not include it.
> 
> Fixes: 72979a6c3590 ("virtio_net: xdp, add slowpath case for non contiguous buffers")
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

Applied, thanks! Commit 853618d5886b in net.
