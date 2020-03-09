Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A876D17DC36
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 10:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgCIJPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 05:15:51 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:34440 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgCIJPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 05:15:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 24F5F20504;
        Mon,  9 Mar 2020 10:15:50 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id W09Y1Aqq1nGA; Mon,  9 Mar 2020 10:15:49 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B0B67201D5;
        Mon,  9 Mar 2020 10:15:49 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 9 Mar 2020
 10:15:49 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 50BDD31801BA;
 Mon,  9 Mar 2020 10:15:49 +0100 (CET)
Date:   Mon, 9 Mar 2020 10:15:49 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec] esp: remove the skb from the chain when it's
 enqueued in cryptd_wq
Message-ID: <20200309091549.GO19286@gauss3.secunet.de>
References: <2f86c9d7c39cfad21fdb353a183b12651fc5efe9.1583311902.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2f86c9d7c39cfad21fdb353a183b12651fc5efe9.1583311902.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 04:51:42PM +0800, Xin Long wrote:
> Xiumei found a panic in esp offload:
> 
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
>   RIP: 0010:esp_output_done+0x101/0x160 [esp4]
>   Call Trace:
>    ? esp_output+0x180/0x180 [esp4]
>    cryptd_aead_crypt+0x4c/0x90
>    cryptd_queue_worker+0x6e/0xa0
>    process_one_work+0x1a7/0x3b0
>    worker_thread+0x30/0x390
>    ? create_worker+0x1a0/0x1a0
>    kthread+0x112/0x130
>    ? kthread_flush_work_fn+0x10/0x10
>    ret_from_fork+0x35/0x40
> 
> It was caused by that skb secpath is used in esp_output_done() after it's
> been released elsewhere.
> 
> The tx path for esp offload is:
> 
>   __dev_queue_xmit()->
>     validate_xmit_skb_list()->
>       validate_xmit_xfrm()->
>         esp_xmit()->
>           esp_output_tail()->
>             aead_request_set_callback(esp_output_done) <--[1]
>             crypto_aead_encrypt()  <--[2]
> 
> In [1], .callback is set, and in [2] it will trigger the worker schedule,
> later on a kernel thread will call .callback(esp_output_done), as the call
> trace shows.
> 
> But in validate_xmit_xfrm():
> 
>   skb_list_walk_safe(skb, skb2, nskb) {
>     ...
>     err = x->type_offload->xmit(x, skb2, esp_features);  [esp_xmit]
>     ...
>   }
> 
> When the err is -EINPROGRESS, which means this skb2 will be enqueued and
> later gets encrypted and sent out by .callback later in a kernel thread,
> skb2 should be removed fromt skb chain. Otherwise, it will get processed
> again outside validate_xmit_xfrm(), which could release skb secpath, and
> cause the panic above.
> 
> This patch is to remove the skb from the chain when it's enqueued in
> cryptd_wq. While at it, remove the unnecessary 'if (!skb)' check.
> 
> Fixes: 3dca3f38cfb8 ("xfrm: Separate ESP handling from segmentation for GRO packets.")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks a lot Xin!
