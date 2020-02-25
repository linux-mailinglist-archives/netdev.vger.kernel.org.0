Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD8D416EE91
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbgBYTFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:05:04 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.50]:29274 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728787AbgBYTFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 14:05:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1582657502;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=42aBOKu2QpvgqIIKVgSLqUIZaavqYHI63A82ZQRYIvA=;
        b=GFgmIc/zm8LApjbbeVVOSVwpEhCwIW7Ot+b0Y3u6w3/ahEUel1xyYO9im1sqRc10MU
        Uc+0BNhYha/KOMuNKX31E2kUOm5lobquaA3MUpzurkM5d9+nuxiK//40QinUWly3VDbe
        GdAqd0B4O62TbKUzzCgTkli/WAHf0i5dJt4rmRuE18iPLJgfDG/JDTFS+JTc9iwY6hNU
        FDlrIxAnD88ZabbNP6iaIOIyHRkrSd/mz9C/zROOu8eV6YR0noC1BycqUQdE3M0REouS
        2HIMhnomo6qt2C23sb4LD6g7bFFnJQCppW1LynHrpBKJ10F95CoDSP/mFssdYjIXiWTA
        vWIg==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3PMaViOoLMJVsh5lE2J"
X-RZG-CLASS-ID: mo00
Received: from [192.168.1.177]
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id g084e8w1PJ4uDGM
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 25 Feb 2020 20:04:56 +0100 (CET)
Subject: Re: [RFC] slip: not call free_netdev before rtnl_unlock in slip_open
To:     yangerkun <yangerkun@huawei.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, maowenan@huawei.com
References: <20200213093248.129757-1-yangerkun@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <2c08964c-d160-9841-4196-911a2ec7c2ff@hartkopp.net>
Date:   Tue, 25 Feb 2020 20:04:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200213093248.129757-1-yangerkun@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I pick it up to take a look at this :-)

On 13/02/2020 10.32, yangerkun wrote:
> As the description before netdev_run_todo, we cannot call free_netdev
> before rtnl_unlock, fix it by reorder the code.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>

Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>

The same issue applies to slcan_open() in slcan.c too.

I'll send a patch for it, when this fix got merged.

Best regards,
Oliver

> ---
>   drivers/net/slip/slip.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index 6f4d7ba8b109..babb01888b78 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -863,7 +863,10 @@ static int slip_open(struct tty_struct *tty)
>   	tty->disc_data = NULL;
>   	clear_bit(SLF_INUSE, &sl->flags);
>   	sl_free_netdev(sl->dev);
> +	/* do not call free_netdev before rtnl_unlock */
> +	rtnl_unlock();
>   	free_netdev(sl->dev);
> +	return err;
>   
>   err_exit:
>   	rtnl_unlock();
> 
