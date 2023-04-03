Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0E86D4B49
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbjDCPBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjDCPBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:01:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6C06A77;
        Mon,  3 Apr 2023 08:01:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75D3E61F63;
        Mon,  3 Apr 2023 15:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF16C433EF;
        Mon,  3 Apr 2023 15:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680534073;
        bh=iMU/5vE8/yWcytMIGqIXztHZFTa+dOLbAYWiHVmL730=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YYUnu4qcRmmZdQJJa3LpcRBwNO5tAa3CNEuRzsWO6IMCunikNmmLRNBNoP1xBCaaW
         9gkTKAdNNf4cRv84vaW69OfjCYd9k74bvcV1njpM1kGS4lEZwtv/eR0EyKYlVfRDlA
         hk08m7AMSCwUFlT4Be4B9JgQcRywBtbPW3rBrFN9PTEK95IXSJY/k4TLX3J1SS/mbI
         7elcYC9C68z22yzt5dUanaODPYJ8lDUXjyf7SjoNDe7HAr1gQ728Cy5m0iXR9QYaiU
         ZOqxWTKQdZBLXCQo7yhupqfF+4UcNU7L3aY3rW0bw4CEZn8ZTMt9zzmDHps6QlHEif
         6l7pGN7Re5vsA==
Date:   Mon, 3 Apr 2023 20:31:07 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andersson@kernel.org, luca@z3ntu.xyz,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: qrtr: Fix an uninit variable access bug in
 qrtr_tx_resume()
Message-ID: <20230403150107.GB11346@thinkpad>
References: <20230403075417.2244203-1-william.xuanziyang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230403075417.2244203-1-william.xuanziyang@huawei.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 03:54:17PM +0800, Ziyang Xuan wrote:
> Syzbot reported a bug as following:
> 
> =====================================================
> BUG: KMSAN: uninit-value in qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
>  qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
>  qrtr_endpoint_post+0xf85/0x11b0 net/qrtr/af_qrtr.c:519
>  qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
>  call_write_iter include/linux/fs.h:2189 [inline]
>  aio_write+0x63a/0x950 fs/aio.c:1600
>  io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
>  __do_sys_io_submit fs/aio.c:2078 [inline]
>  __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
>  __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Uninit was created at:
>  slab_post_alloc_hook mm/slab.h:766 [inline]
>  slab_alloc_node mm/slub.c:3452 [inline]
>  __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
>  __do_kmalloc_node mm/slab_common.c:967 [inline]
>  __kmalloc_node_track_caller+0x114/0x3b0 mm/slab_common.c:988
>  kmalloc_reserve net/core/skbuff.c:492 [inline]
>  __alloc_skb+0x3af/0x8f0 net/core/skbuff.c:565
>  __netdev_alloc_skb+0x120/0x7d0 net/core/skbuff.c:630
>  qrtr_endpoint_post+0xbd/0x11b0 net/qrtr/af_qrtr.c:446
>  qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
>  call_write_iter include/linux/fs.h:2189 [inline]
>  aio_write+0x63a/0x950 fs/aio.c:1600
>  io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
>  __do_sys_io_submit fs/aio.c:2078 [inline]
>  __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
>  __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> It is because that skb->len requires at least sizeof(struct qrtr_ctrl_pkt)
> in qrtr_tx_resume(). And skb->len equals to size in qrtr_endpoint_post().
> But size is less than sizeof(struct qrtr_ctrl_pkt) when qrtr_cb->type
> equals to QRTR_TYPE_RESUME_TX in qrtr_endpoint_post() under the syzbot
> scenario. This triggers the uninit variable access bug.
> 

I'm not familiar with syzkaller. Can you please share the data that was fuzzed
by the bot?

- Mani

> Add size check when qrtr_cb->type equals to QRTR_TYPE_RESUME_TX in
> qrtr_endpoint_post() to fix the bug.
> 
> Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow control")
> Reported-by: syzbot+4436c9630a45820fda76@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=c14607f0963d27d5a3d5f4c8639b500909e43540
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  net/qrtr/af_qrtr.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
> index 3a70255c8d02..631e81a8a368 100644
> --- a/net/qrtr/af_qrtr.c
> +++ b/net/qrtr/af_qrtr.c
> @@ -498,6 +498,10 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
>  	if (!size || len != ALIGN(size, 4) + hdrlen)
>  		goto err;
>  
> +	if (cb->type == QRTR_TYPE_RESUME_TX &&
> +	    size < sizeof(struct qrtr_ctrl_pkt))
> +		goto err;
> +
>  	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
>  	    cb->type != QRTR_TYPE_RESUME_TX)
>  		goto err;
> -- 
> 2.25.1
> 

-- 
மணிவண்ணன் சதாசிவம்
