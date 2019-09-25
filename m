Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59809BDE08
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 14:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388199AbfIYMZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 08:25:07 -0400
Received: from www62.your-server.de ([213.133.104.62]:50252 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730253AbfIYMZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 08:25:06 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iD6Lt-0004Bo-Q1; Wed, 25 Sep 2019 14:25:01 +0200
Date:   Wed, 25 Sep 2019 14:25:01 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     xiaolinkui <xiaolinkui@kylinos.cn>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: use unlikely for dql_avail case
Message-ID: <20190925122501.GA27720@pc-66.home>
References: <20190925024043.31030-1-xiaolinkui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925024043.31030-1-xiaolinkui@kylinos.cn>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25583/Wed Sep 25 10:27:51 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 10:40:43AM +0800, xiaolinkui wrote:
> This is an unlikely case, use unlikely() on it seems logical.
> 
> Signed-off-by: xiaolinkui <xiaolinkui@kylinos.cn>

It's already here [0], but should probably rather get reverted instead
due to lack of a more elaborate reasoning on why it needs to be done
this way instead of letting compiler do it's job in this case. "Seems
logical" is never a good technical explanation. Do you have any better
analysis you performed prior to submitting the patch (twice by now)?

Thanks,
Daniel

  [0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f3acd33d840d3ea3e1233d234605c85cbbf26054

> ---
>  include/linux/netdevice.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 88292953aa6f..005f3da1b13d 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3270,7 +3270,7 @@ static inline void netdev_tx_completed_queue(struct netdev_queue *dev_queue,
>  	 */
>  	smp_mb();
>  
> -	if (dql_avail(&dev_queue->dql) < 0)
> +	if (unlikely(dql_avail(&dev_queue->dql) < 0))
>  		return;
>  
>  	if (test_and_clear_bit(__QUEUE_STATE_STACK_XOFF, &dev_queue->state))
> -- 
> 2.17.1
> 
> 
> 
