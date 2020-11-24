Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D1C2C338D
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 22:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387641AbgKXVu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 16:50:26 -0500
Received: from www62.your-server.de ([213.133.104.62]:36268 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731557AbgKXVu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 16:50:26 -0500
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1khgCd-0006kk-6H; Tue, 24 Nov 2020 22:50:23 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1khgCc-000V64-Ub; Tue, 24 Nov 2020 22:50:22 +0100
Subject: Re: [PATCH bpf v2] net, xsk: Avoid taking multiple skbuff references
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        jonathan.lemon@gmail.com, yhs@fb.com, weqaar.janjua@gmail.com,
        magnus.karlsson@intel.com, weqaar.a.janjua@intel.com
References: <20201123175600.146255-1-bjorn.topel@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d210e074-432f-025c-1ede-4f9476f1501c@iogearbox.net>
Date:   Tue, 24 Nov 2020 22:50:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20201123175600.146255-1-bjorn.topel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25998/Tue Nov 24 14:16:50 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/20 6:56 PM, Björn Töpel wrote:
> From: Björn Töpel <bjorn.topel@intel.com>
> 
> Commit 642e450b6b59 ("xsk: Do not discard packet when NETDEV_TX_BUSY")
> addressed the problem that packets were discarded from the Tx AF_XDP
> ring, when the driver returned NETDEV_TX_BUSY. Part of the fix was
> bumping the skbuff reference count, so that the buffer would not be
> freed by dev_direct_xmit(). A reference count larger than one means
> that the skbuff is "shared", which is not the case.
> 
> If the "shared" skbuff is sent to the generic XDP receive path,
> netif_receive_generic_xdp(), and pskb_expand_head() is entered the
> BUG_ON(skb_shared(skb)) will trigger.
> 
> This patch adds a variant to dev_direct_xmit(), __dev_direct_xmit(),
> where a user can select the skbuff free policy. This allows AF_XDP to
> avoid bumping the reference count, but still keep the NETDEV_TX_BUSY
> behavior.
> 
> Reported-by: Yonghong Song <yhs@fb.com>
> Fixes: 642e450b6b59 ("xsk: Do not discard packet when NETDEV_TX_BUSY")
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>

Yeah looks better! Applied, thanks!
