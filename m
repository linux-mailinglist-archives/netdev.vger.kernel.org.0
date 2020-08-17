Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578D0246634
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgHQMTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:19:47 -0400
Received: from proxima.lasnet.de ([78.47.171.185]:43126 "EHLO
        proxima.lasnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgHQMTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:19:46 -0400
Received: from localhost.localdomain (p200300e9d747fd86eda1c6650823d2bd.dip0.t-ipconnect.de [IPv6:2003:e9:d747:fd86:eda1:c665:823:d2bd])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 49FCBC25F9;
        Mon, 17 Aug 2020 14:19:40 +0200 (CEST)
Subject: Re: [PATCH 4/8] net: mac802154: convert tasklets to use new
 tasklet_setup() API
To:     Allen Pais <allen.cryptic@gmail.com>, gerrit@erg.abdn.ac.uk,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        santosh.shilimkar@oracle.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
References: <20200817085120.24894-1-allen.cryptic@gmail.com>
 <20200817085120.24894-4-allen.cryptic@gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <5309b90a-1caa-ec22-ddb9-49eca3581957@datenfreihafen.org>
Date:   Mon, 17 Aug 2020 14:19:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200817085120.24894-4-allen.cryptic@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 17.08.20 10:51, Allen Pais wrote:
> From: Allen Pais <allen.lkml@gmail.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>
> ---
>   net/mac802154/main.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/net/mac802154/main.c b/net/mac802154/main.c
> index 06ea0f8bfd5c..520cedc594e1 100644
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
