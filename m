Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF14521FE63
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbgGNUQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:16:16 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:20793 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbgGNUQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:16:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594757770;
        s=strato-dkim-0002; d=hartkopp.net;
        h=In-Reply-To:Date:Message-ID:From:References:Cc:To:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=GNcdh9hbyCSYCE1dhM3aHIwRYOjxxn/mU4RGqzYVsko=;
        b=E7TxQwHHGoOz4M/wN/7wYt+c9eSQNjFHntOgBQhstLYB8vdFDCV2wiy4hraXYWEPdw
        6WdxS/VVPGRuKL8sSAhDEGmucVfgwKxURnaTEcS8ExrVoSF09ZktlQhsGu02w9uqOe35
        gfARf6R9tOXPHx25fZhpESkMtVg3xx78CbCENdnngQVg7SwIqpvEX/zYbjvNxKyrhPRN
        WBGA9GJqBu7KSovNTOm4y8Lg358+TNuKOnAeX1k68/yGqnEN7KewnxtkkrSTUhsWZMCv
        i5/QRfdr3wkLXOIbhhlaHPKUeMtvM8SggKjZhOqu+79aZEl28Uw+NWpNeRcgcY/tDQAs
        zqYA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1o3HMbEWKOdeVTdI="
X-RZG-CLASS-ID: mo00
Received: from [192.168.50.177]
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id R09ac6w6EKA9tgs
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 14 Jul 2020 22:10:09 +0200 (CEST)
Subject: Re: [PATCH net-next] can: silence remove_proc_entry warning
To:     Zhang Changzhong <zhangchangzhong@huawei.com>, mkl@pengutronix.de,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1594709090-3203-1-git-send-email-zhangchangzhong@huawei.com>
From:   Oliver Hartkopp <socketcan@hartkopp.net>
Message-ID: <e2344833-b2f4-cc6f-4b6c-868afc3ced6e@hartkopp.net>
Date:   Tue, 14 Jul 2020 22:10:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594709090-3203-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.07.20 08:44, Zhang Changzhong wrote:
> If can_init_proc() fail to create /proc/net/can directory,
> can_remove_proc() will trigger a warning:
> 
> WARNING: CPU: 6 PID: 7133 at fs/proc/generic.c:672 remove_proc_entry+0x17b0
> Kernel panic - not syncing: panic_on_warn set ...
> 
> Fix to return early from can_remove_proc() if can proc_dir
> does not exists.
> 
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Thanks!

> ---
>   net/can/proc.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/can/proc.c b/net/can/proc.c
> index e6881bf..077af42 100644
> --- a/net/can/proc.c
> +++ b/net/can/proc.c
> @@ -471,6 +471,9 @@ void can_init_proc(struct net *net)
>    */
>   void can_remove_proc(struct net *net)
>   {
> +	if (!net->can.proc_dir)
> +		return;
> +
>   	if (net->can.pde_version)
>   		remove_proc_entry(CAN_PROC_VERSION, net->can.proc_dir);
>   
> @@ -498,6 +501,5 @@ void can_remove_proc(struct net *net)
>   	if (net->can.pde_rcvlist_sff)
>   		remove_proc_entry(CAN_PROC_RCVLIST_SFF, net->can.proc_dir);
>   
> -	if (net->can.proc_dir)
> -		remove_proc_entry("can", net->proc_net);
> +	remove_proc_entry("can", net->proc_net);
>   }
> 
