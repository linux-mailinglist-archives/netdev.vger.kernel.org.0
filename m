Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC95A62F95F
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 16:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242196AbiKRPgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 10:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241937AbiKRPgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 10:36:06 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EA45A6C1;
        Fri, 18 Nov 2022 07:36:06 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id v17so4884022plo.1;
        Fri, 18 Nov 2022 07:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oUY4IlqwKzdFdJR6S2+WJK8AdQXsyhGvuIVGww793do=;
        b=HE9tIk0JSQm+HGHI7Y97rNsTX60CNVPyVRYZ0MgNeBKqvITYbimfWghYkXhF9REvUh
         AuJYm5PuE7W7eOXNdLRO9U6WzltAVP3DNWtHeg/PpC7hFjQKrF2k/Ww1Z1GAkIZzWyZJ
         ZkzCerYTsyffw1dYkIU8zNBZEqdSIKXNK8lOGO3VDDZifBbV7T6hygXGANAX3zne9NyI
         jx3sJbe4qVsJc//xGytU5qN1uNd1U1FEMngSBYsi+XIZM+5zXK5Ub+NlD4bznykjM0db
         cJu9qmOwCMsqIzThyEc2O7YyrMvpYA9izrPhlBMlJmzpvgHBVy2GaadLbxyvBLYyalwh
         pBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oUY4IlqwKzdFdJR6S2+WJK8AdQXsyhGvuIVGww793do=;
        b=HW3IGEwX+Awl5YhJQdivQg/31SZQPMr45Aj6fkdwR2ZHqStIi8tnOoX5psfuWKd+HB
         Zqpjk6NiIWRt6pmF0x7gTIhzCgWUOZzu3DFKGndqNuIQvV/k5BIwOpKOnRzkMvX70q7G
         +QJqN31yAYuvDWo0uEbH5dgDwkWY5dY46K+dI9j/9dVhpsVxiD3rlWejCT4NFEziPXDc
         bXwZLdwkYYhT+9ksehjbjdZ5t6SdgPKzcfxben/ZzbWnfSVg2E8T99QEsQvXybz1GHUq
         XsMsagWWyydBTXnw/0budsOfRNm15F64aQF6uCRZDJkg751DtSE76Yo0wyZDIeiG1azX
         0KDA==
X-Gm-Message-State: ANoB5pl02Tt0+yyvsoUxJ9UnytX8xxAiXDZtP9RhzuhVriGbhEbrj+5c
        ZYSF/0diC6nFBzYpezop4og=
X-Google-Smtp-Source: AA0mqf7/xVN1CI4YbOKJDUBMcG/e6izgMehj7mDwtMYqFgl8q9P317Cia7ptFqfrmnenk6Hc8fMA6g==
X-Received: by 2002:a17:902:bd94:b0:186:b063:339 with SMTP id q20-20020a170902bd9400b00186b0630339mr63981pls.70.1668785765550;
        Fri, 18 Nov 2022 07:36:05 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.231])
        by smtp.googlemail.com with ESMTPSA id q93-20020a17090a1b6600b00213d28a6dedsm5552098pjq.13.2022.11.18.07.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 07:36:05 -0800 (PST)
Message-ID: <ea5c55f30cab0a7c8d17f92e2eca2ff5a60f52c3.camel@gmail.com>
Subject: Re: [PATCH net] fm10k: fix potential memleak in fm10k_xmit_frame()
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 18 Nov 2022 07:36:03 -0800
In-Reply-To: <1668775048-22031-1-git-send-email-zhangchangzhong@huawei.com>
References: <1668775048-22031-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-18 at 20:37 +0800, Zhang Changzhong wrote:
> The fm10k_xmit_frame() returns NETDEV_TX_OK without freeing skb in error
> handling case, add dev_kfree_skb() to fix it. Compile tested only.
>=20
> Fixes: b101c9626477 ("fm10k: Add transmit and receive fastpath and interr=
upt handlers")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/intel/fm10k/fm10k_netdev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/ne=
t/ethernet/intel/fm10k/fm10k_netdev.c
> index 2cca9e8..c7b672a 100644
> --- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
> +++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
> @@ -531,8 +531,10 @@ static netdev_tx_t fm10k_xmit_frame(struct sk_buff *=
skb, struct net_device *dev)
>  			return NETDEV_TX_OK;
> =20
>  		/* make sure there is enough room to move the ethernet header */
> -		if (unlikely(!pskb_may_pull(skb, VLAN_ETH_HLEN)))
> +		if (unlikely(!pskb_may_pull(skb, VLAN_ETH_HLEN))) {
> +			dev_kfree_skb(skb);
>  			return NETDEV_TX_OK;
> +		}
> =20
>  		/* verify the skb head is not shared */
>  		err =3D skb_cow_head(skb, 0);

Fix looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
