Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE17217F23
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 07:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgGHFeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 01:34:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726206AbgGHFeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 01:34:23 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9888120774;
        Wed,  8 Jul 2020 05:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594186463;
        bh=SW6LMFRk9VIGcXiCDtCnGrDRmznPD9lQVczLeids3Bo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=H+a540DUwEUaR//CGkO2iMZGe5VIBKEdWrswDaaTal/dMh6YCExYECfR/TJGHWcDc
         8HpRuYg6nrtCgvD/7SGu8dYh2AL6bwoYVZoBgSJyJpy71lvQnJqU8YI/cU3Ufq/Vpa
         QjqWaB89RIrqrPKVPF+WL8dbyZ2npdl+VEZM2xvk=
Date:   Wed, 8 Jul 2020 08:34:18 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rds: send: Replace sg++ with sg = sg_next(sg)
Message-ID: <20200708053418.GP207186@unreal>
References: <20200708034252.17408-1-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200708034252.17408-1-vulab@iscas.ac.cn>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 08, 2020 at 03:42:52AM +0000, Xu Wang wrote:
> Replace sg++ with sg = sg_next(sg).
>
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  net/rds/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/rds/send.c b/net/rds/send.c
> index 68e2bdb08fd0..57d03a6753de 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -387,7 +387,7 @@ int rds_send_xmit(struct rds_conn_path *cp)
>  				ret -= tmp;
>  				if (cp->cp_xmit_data_off == sg->length) {
>  					cp->cp_xmit_data_off = 0;
> -					sg++;
> +					sg = sg_next(sg);

What about rest cases?

➜  kernel git:(rdma-next) git grep "sg++" net/rds/
net/rds/message.c:              sg++;
net/rds/message.c:                      sg++;
net/rds/message.c:                      sg++;
net/rds/send.c:                                 sg++;
net/rds/tcp_send.c:                     sg++;

Thanks

>  					cp->cp_xmit_sg++;
>  					BUG_ON(ret != 0 && cp->cp_xmit_sg ==
>  					       rm->data.op_nents);
> --
> 2.17.1
>
