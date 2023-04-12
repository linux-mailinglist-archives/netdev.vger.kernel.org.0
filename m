Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A76AC6DFF3C
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 21:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjDLTzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 15:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDLTzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 15:55:39 -0400
X-Greylist: delayed 429 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 12 Apr 2023 12:55:37 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3A7172C;
        Wed, 12 Apr 2023 12:55:37 -0700 (PDT)
Received: from [192.168.2.51] (p4fc2f435.dip0.t-ipconnect.de [79.194.244.53])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id E78C8C04F0;
        Wed, 12 Apr 2023 21:48:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1681328906;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRU/LLFBCavEJWvGXUSEUrQNNub1grtUnRPGzPXhilk=;
        b=LhroQB25mwPNJhteylhTIYKBIIuj20UR/QgzRXDV4skZOKTpOZU9PYzaIr6zyhD78B98TL
        QD0H+ZGed0RoSC+Rhm1xvjEKUvWikdQNc8mHMg6rd8OR5mRQN+g/5+GFp0zwqDOENHt/GV
        /L7+M9nn+Y2DrtE+MBmmC25z2K3qWKH723PvUJGuoCCrNUjQ88R+AkTUH61VyEDQnhYJCu
        5LTji3IbDyGxrxf5bBAxGNhZ6b8Vf27gaPV4S7FRnyoVSukakknykAxPYIo4hXCZJz/jmO
        i+PhZowROo0OZW3tzw9d2+4B/kx+FElMrRj8KZnlNdzdpF08L6j/LNjcxf42tQ==
Message-ID: <267e4b90-b82a-253a-9a52-46bc5026f34d@datenfreihafen.org>
Date:   Wed, 12 Apr 2023 21:48:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATH wpan v3] ieee802154: hwsim: Fix possible memory leaks
Content-Language: en-US
To:     Chen Aotian <chenaotian2@163.com>, alex.aring@gmail.com
Cc:     miquel.raynal@bootlin.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Aring <aahringo@redhat.com>
References: <20230409022048.61223-1-chenaotian2@163.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230409022048.61223-1-chenaotian2@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 09.04.23 04:20, Chen Aotian wrote:
> After replacing e->info, it is necessary to free the old einfo.
> 
> Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
> Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Reviewed-by: Alexander Aring <aahringo@redhat.com>
> Signed-off-by: Chen Aotian <chenaotian2@163.com>
> ---
> 
> V2 -> V3:
> * lock_is_held() => lockdep_is_held().(thanks for Alexander)
> 
> V1 -> V2:
> * Using rcu_replace_pointer() is better then rcu_dereference()
>    and rcu_assign_pointer().
> 
>   drivers/net/ieee802154/mac802154_hwsim.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
> index 8445c2189..31cba9aa7 100644
> --- a/drivers/net/ieee802154/mac802154_hwsim.c
> +++ b/drivers/net/ieee802154/mac802154_hwsim.c
> @@ -685,7 +685,7 @@ static int hwsim_del_edge_nl(struct sk_buff *msg, struct genl_info *info)
>   static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
>   {
>   	struct nlattr *edge_attrs[MAC802154_HWSIM_EDGE_ATTR_MAX + 1];
> -	struct hwsim_edge_info *einfo;
> +	struct hwsim_edge_info *einfo, *einfo_old;
>   	struct hwsim_phy *phy_v0;
>   	struct hwsim_edge *e;
>   	u32 v0, v1;
> @@ -723,8 +723,10 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
>   	list_for_each_entry_rcu(e, &phy_v0->edges, list) {
>   		if (e->endpoint->idx == v1) {
>   			einfo->lqi = lqi;
> -			rcu_assign_pointer(e->info, einfo);
> +			einfo_old = rcu_replace_pointer(e->info, einfo,
> +							lockdep_is_held(&hwsim_phys_lock));
>   			rcu_read_unlock();
> +			kfree_rcu(einfo_old, rcu);
>   			mutex_unlock(&hwsim_phys_lock);
>   			return 0;
>   		}

This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
