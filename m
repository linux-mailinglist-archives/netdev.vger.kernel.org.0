Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C435AE937
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 15:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiIFNQB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 09:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240391AbiIFNPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 09:15:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEFB57238
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 06:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662470153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1uJsWhraelKXluHwB7FaDWCgu+gdxCn6dypgVW00Tgc=;
        b=GiDryCGiXaZvT+uNIVIJwGAcBweDZGcg1Z/2m7/JXiakS/3eiT4rOFbm3a3sj6YDN/1m5K
        ALK0Anyh0pJF7hrCLP0o+mk3AjRv+4OD0fikFx8nS9DFnt9XA/7XeGiFkg5aSceDdbkXHK
        Ko2R2pUITSATB2k9zqOLEeSNiNFnykM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-301-r3zt6mTFM5qPzMC76soLZA-1; Tue, 06 Sep 2022 09:15:36 -0400
X-MC-Unique: r3zt6mTFM5qPzMC76soLZA-1
Received: by mail-wm1-f70.google.com with SMTP id b16-20020a05600c4e1000b003a5a47762c3so6273546wmq.9
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 06:15:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=1uJsWhraelKXluHwB7FaDWCgu+gdxCn6dypgVW00Tgc=;
        b=SdZWmrMduXJWHQFOLZRto9N0cY0y0SswjyVF0koa+9Zdd6sRHJ49GZBqjfrdPe67NS
         IVeOPQqdZgF2dcRMeYjRT6LmgERWuvwTpfN+UqgJ6p47j53nZmf1ND9d3PJAmcKQX8k8
         TPsswZaEp0cMjKa8kE0Eb6R2ZmE4SCB+S6kSI3LzZmko4LDVTF8rw5kNPE8JBG7+X53X
         4hs02iHVIXJeoRrDuFAU6J+G+EADd5qG0rQpFi4zBbeGjs/YbC9tWEFg+EwLamklKDIF
         unLcZpQqwaLDKuehaZSomDoVz7uzYVdZN6NDpUn4IVM2S0yHdT6gEhRiSC474xL7KmY8
         4Y+Q==
X-Gm-Message-State: ACgBeo1jPT8GH1OvBTIraGUf6FtkajfTdPc1oZgmSidqg10RG7sPyHVT
        kWaEg4eclGmuu8gX5FeG6nwdC5Gwbwsn5y83U7wDpsEby5JHZ4JDPjt0/dLIIDJtAT5if+/ZfIl
        PlwYmUwN3qtlQalsp
X-Received: by 2002:a5d:59a4:0:b0:228:5f74:796 with SMTP id p4-20020a5d59a4000000b002285f740796mr9196587wrr.655.1662470133833;
        Tue, 06 Sep 2022 06:15:33 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5P3NAwv8A+ZEKH3JYcwHQ89wUpJPH3H2eNehgZC3vx/2n+iYwWJrNvkLHshgWwyn7m7zUFWA==
X-Received: by 2002:a5d:59a4:0:b0:228:5f74:796 with SMTP id p4-20020a5d59a4000000b002285f740796mr9196562wrr.655.1662470133442;
        Tue, 06 Sep 2022 06:15:33 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-72.dyn.eolo.it. [146.241.112.72])
        by smtp.gmail.com with ESMTPSA id q1-20020a05600c2e4100b003a2cf1ba9e2sm13653800wmf.6.2022.09.06.06.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 06:15:32 -0700 (PDT)
Message-ID: <8b2589bd6303133fd27cab1af27b096a5f848074.camel@redhat.com>
Subject: Re: [PATCH net-next 2/5] net: hns3: support ndo_select_queue()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        lanhao@huawei.com
Date:   Tue, 06 Sep 2022 15:15:31 +0200
In-Reply-To: <20220905081539.62131-3-huangguangbin2@huawei.com>
References: <20220905081539.62131-1-huangguangbin2@huawei.com>
         <20220905081539.62131-3-huangguangbin2@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-09-05 at 16:15 +0800, Guangbin Huang wrote:
> To support tx packets to select queue according to its dscp field after
> setting dscp and tc map relationship, this patch implements
> ndo_select_queue() to set skb->priority according to the user's setting
> dscp and priority map relationship.
> 
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> ---
>  .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 46 +++++++++++++++++++
>  1 file changed, 46 insertions(+)
> 
> diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> index 481a300819ad..82f83e3f8162 100644
> --- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> +++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
> @@ -2963,6 +2963,51 @@ static int hns3_nic_set_vf_mac(struct net_device *netdev, int vf_id, u8 *mac)
>  	return h->ae_algo->ops->set_vf_mac(h, vf_id, mac);
>  }
>  
> +#define HNS3_INVALID_DSCP		0xff
> +#define HNS3_DSCP_SHIFT			2
> +
> +static u8 hns3_get_skb_dscp(struct sk_buff *skb)
> +{
> +	__be16 protocol = skb->protocol;
> +	u8 dscp = HNS3_INVALID_DSCP;
> +
> +	if (protocol == htons(ETH_P_8021Q))
> +		protocol = vlan_get_protocol(skb);
> +
> +	if (protocol == htons(ETH_P_IP))
> +		dscp = ipv4_get_dsfield(ip_hdr(skb)) >> HNS3_DSCP_SHIFT;
> +	else if (protocol == htons(ETH_P_IPV6))
> +		dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> HNS3_DSCP_SHIFT;
> +
> +	return dscp;
> +}
> +
> +static u16 hns3_nic_select_queue(struct net_device *netdev,
> +				 struct sk_buff *skb,
> +				 struct net_device *sb_dev)
> +{
> +	struct hnae3_handle *h = hns3_get_handle(netdev);
> +	u8 dscp, priority;
> +	int ret;
> +
> +	if (h->kinfo.tc_map_mode != HNAE3_TC_MAP_MODE_DSCP ||
> +	    !h->ae_algo->ops->get_dscp_prio)
> +		goto out;
> +
> +	dscp = hns3_get_skb_dscp(skb);
> +	if (unlikely(dscp == HNS3_INVALID_DSCP))
> +		goto out;
> +
> +	ret = h->ae_algo->ops->get_dscp_prio(h, dscp, NULL, &priority);

This introduces an additional, unneeded indirect call in the fast path,
you could consider replacing the above with a direct call to
hclge_get_dscp_prio() - again taking care of the CONFIG_HNS3_DCB
dependency.

Cheers,

Paolo

