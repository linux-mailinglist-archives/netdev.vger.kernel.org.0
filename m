Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5036C4B70E2
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:39:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbiBOQFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 11:05:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241216AbiBOQFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 11:05:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B9D624A;
        Tue, 15 Feb 2022 08:04:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94D706178E;
        Tue, 15 Feb 2022 16:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD42EC340EB;
        Tue, 15 Feb 2022 16:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644941095;
        bh=VF83nphVbta3s2UkOE4pwD7kf6THCxG98ABjVxxvqhI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CeMZ3PxEzTmhqApjIO//PJFjrUlOdF1vUc7Cs7PFmnlYIrdiSBdHbT5dtqvEEKFi5
         ArYlnENLlIrkba2Eq/jUSYv+0PL7vxZ3qlR6dC2DSJi6kK2e0UKx6rQcRdrZ+tgV7L
         b9YkJo7dZ7tuj/TGSgJW8GVR4dbMwv9RoLGqukFT2G092aHmVVt/4MTS5bi/h2AUPw
         Bj5HdDs7DUVH9xagu+lU0eJcy+2GSzHGfiaiTr1esMsrBhWNRTJcHwrMPXf7J0mAr/
         ozExV9WWHehfD90y4rG+B4AxyjtWHCgexI7Lxcv50YzBnNqn0hjMC5Irctw+0oKf18
         qzFIPbqdvNDnQ==
Date:   Tue, 15 Feb 2022 08:04:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     dsahern@kernel.org, edumazet@google.com, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, yoshfuji@linux-ipv6.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me, memxor@gmail.com,
        atenart@kernel.org, bigeasy@linutronix.de, pabeni@redhat.com,
        linyunsheng@huawei.com, arnd@arndb.de, yajun.deng@linux.dev,
        roopa@nvidia.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, luiz.von.dentz@intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: Re: [PATCH net-next 00/19] net: add skb drop reasons for TCP, IP,
 dev and neigh
Message-ID: <20220215080452.2898495a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220215112812.2093852-1-imagedong@tencent.com>
References: <20220215112812.2093852-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Feb 2022 19:27:53 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In this series patches, reasons for skb drops are added to TCP, IP, dev
> and neigh.
> 
> For TCP layer, the path of TCP data receive and enqueue are considered.
> However, it's more complex for TCP state processing, as I find that it's
> hard to report skb drop reasons to where it is freed. For example,
> when skb is dropped in tcp_rcv_state_process(), the reason can be caused
> by the call of tcp_v4_conn_request(), and it's hard to return a drop
> reason from tcp_v4_conn_request(). So I just skip such case for this
> moment.
> 
> For IP layer, skb drop reasons are added to the packet outputting path.
> Seems the reasons are not complex, so I didn't split the commits by
> functions.
> 
> For neighbour part, SKB_DROP_REASON_NEIGH_FAILED and
> SKB_DROP_REASON_NEIGH_QUEUEFULL are added.
> 
> For link layer, reasons are added for both packet inputting and
> outputting path.
> 
> The amount of patches in this series seems a bit too many, maybe I should
> join some of them? For example, combine the patches of dev to one.

This series does not apply cleanly.

There's no reason to send 19 patches at a time. Please try to send
smaller series, that's are easier to review, under 10 patches
preferably, certainly under 15.
