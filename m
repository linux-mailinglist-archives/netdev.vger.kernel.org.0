Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2AD1BAC2A
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 20:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgD0SR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 14:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725963AbgD0SR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 14:17:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989C0C0610D5;
        Mon, 27 Apr 2020 11:17:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5DA9C15D533BB;
        Mon, 27 Apr 2020 11:17:58 -0700 (PDT)
Date:   Mon, 27 Apr 2020 11:17:57 -0700 (PDT)
Message-Id: <20200427.111757.1063040756096170355.davem@davemloft.net>
To:     xiyuyang19@fudan.edu.cn
Cc:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, kpsingh@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        yuanxzhang@fudan.edu.cn, kjlu@umn.edu, tanxin.ctf@gmail.com
Subject: Re: [PATCH] net/tls: Fix sk_psock refcnt leak in
 bpf_exec_tx_verdict()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587819277-38974-1-git-send-email-xiyuyang19@fudan.edu.cn>
References: <1587819277-38974-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Apr 2020 11:17:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Date: Sat, 25 Apr 2020 20:54:37 +0800

> bpf_exec_tx_verdict() invokes sk_psock_get(), which returns a reference
> of the specified sk_psock object to "psock" with increased refcnt.
> 
> When bpf_exec_tx_verdict() returns, local variable "psock" becomes
> invalid, so the refcount should be decreased to keep refcount balanced.
> 
> The reference counting issue happens in one exception handling path of
> bpf_exec_tx_verdict(). When "policy" equals to NULL but "psock" is not
> NULL, the function forgets to decrease the refcnt increased by
> sk_psock_get(), causing a refcnt leak.
> 
> Fix this issue by calling sk_psock_put() on this error path before
> bpf_exec_tx_verdict() returns.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Applied and queued up for -stable.
