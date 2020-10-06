Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6E9284805
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 10:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgJFIBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 04:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgJFIBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 04:01:00 -0400
X-Greylist: delayed 508 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Oct 2020 01:01:00 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14F4C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 01:01:00 -0700 (PDT)
Received: from localhost.localdomain (p200300e9d72c3c4353f06c511a49ff67.dip0.t-ipconnect.de [IPv6:2003:e9:d72c:3c43:53f0:6c51:1a49:ff67])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 45B16C2A64;
        Tue,  6 Oct 2020 09:52:28 +0200 (CEST)
Subject: Re: [RESEND net-next 4/8] net: mac802154: convert tasklets to use new
 tasklet_setup() API
To:     Allen Pais <allen.lkml@gmail.com>, davem@davemloft.net
Cc:     gerrit@erg.abdn.ac.uk, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        santosh.shilimkar@oracle.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>
References: <20201006063201.294959-1-allen.lkml@gmail.com>
 <20201006063201.294959-5-allen.lkml@gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <b8600bac-e8b9-4281-dcef-bd7e8d4669f0@datenfreihafen.org>
Date:   Tue, 6 Oct 2020 09:52:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20201006063201.294959-5-allen.lkml@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 06.10.20 08:31, Allen Pais wrote:
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>
> ---
>   net/mac802154/main.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/net/mac802154/main.c b/net/mac802154/main.c
> index 06ea0f8bf..520cedc59 100644
> --- a/net/mac802154/main.c
> +++ b/net/mac802154/main.c
> @@ -20,9 +20,9 @@
>   #include "ieee802154_i.h"
>   #include "cfg.h"
>   
> -static void ieee802154_tasklet_handler(unsigned long data)
> +static void ieee802154_tasklet_handler(struct tasklet_struct *t)
>   {
> -	struct ieee802154_local *local = (struct ieee802154_local *)data;
> +	struct ieee802154_local *local = from_tasklet(local, t, tasklet);
>   	struct sk_buff *skb;
>   
>   	while ((skb = skb_dequeue(&local->skb_queue))) {
> @@ -91,9 +91,7 @@ ieee802154_alloc_hw(size_t priv_data_len, const struct ieee802154_ops *ops)
>   	INIT_LIST_HEAD(&local->interfaces);
>   	mutex_init(&local->iflist_mtx);
>   
> -	tasklet_init(&local->tasklet,
> -		     ieee802154_tasklet_handler,
> -		     (unsigned long)local);
> +	tasklet_setup(&local->tasklet, ieee802154_tasklet_handler);
>   
>   	skb_queue_head_init(&local->skb_queue);
>   
> 


Acked-by: Stefan Schmidt <stefan@datenfreihafen.org>

regards
Stefan Schmidt
