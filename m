Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3713D433B64
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhJSP7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:59:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhJSP7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:59:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6086560F9D;
        Tue, 19 Oct 2021 15:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634659054;
        bh=JDppQYUjK1xHVoUqWCmeSgMoYA4Hof87wS9p0i8dX58=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N95ZBVIBEinr1DlYUJP+0yqoKpIM4Sd04Z+sjuRqOdRNdCAg0bjddCDAx1O5pnO6O
         bHAY2FE9zL9cno4s2SJZyWWoAcdcTptebWXnEWlffFOJ41TsntiR7Q8HEQSvP9rJzK
         StcoCPt7BfrcOR3yRZvHkDoWts+Ca/cQfHs7y9RvghujNI+tbT4omF0vRqVivtYvkG
         VLrkr77TiDWx3jpeqciOqMd48rM+V05J6cjmXSw5Ozt1nNIYU5sheUsV//Iyk3LP81
         6zl9JiJRHxDgaLpcqfVYw0eNTTGg4HfHRMkGjW9yPCcvHocZAxutZYRtdOTfNt2nKI
         QZIKlXvRxIrfg==
Date:   Tue, 19 Oct 2021 08:57:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: sched: gred: dynamically allocate
 tc_gred_qopt_offload
Message-ID: <20211019085733.11149203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211019153739.446190-1-arnd@kernel.org>
References: <20211019153739.446190-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 17:37:27 +0200 Arnd Bergmann wrote:
> @@ -470,8 +477,7 @@ static int gred_change_table_def(struct Qdisc *sch, struct nlattr *dps,
>  		}
>  	}
>  
> -	gred_offload(sch, TC_GRED_REPLACE);
> -	return 0;
> +	return gred_offload(sch, TC_GRED_REPLACE);
>  }
>  
>  static inline int gred_change_vq(struct Qdisc *sch, int dp,
> @@ -719,8 +725,7 @@ static int gred_change(struct Qdisc *sch, struct nlattr *opt,
>  	sch_tree_unlock(sch);
>  	kfree(prealloc);
>  
> -	gred_offload(sch, TC_GRED_REPLACE);
> -	return 0;
> +	return gred_offload(sch, TC_GRED_REPLACE);

Now we can return an error even tho the SW path has changed.
Qdisc offloads should not affect the SW changes AFAIR.

If we need to alloc dynamically let's allocate the buffer at init and
keep it in struct gred_sched. The offload calls are all under RTNL lock
so in fact we could even use static data, but let's do it right and
have a buffer per qdisc.
