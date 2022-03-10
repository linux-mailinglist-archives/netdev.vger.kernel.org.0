Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 526D84D4063
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239506AbiCJEpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239509AbiCJEpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:45:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE84E3381
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:44:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D4BEB8216C
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6603C340E8;
        Thu, 10 Mar 2022 04:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646887447;
        bh=HNhJWOk7ptjvvG6xxXt8ZnNcSPT6K7U+7vIKWj45dUg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TQIfvzNHPIw35dOZYdcObAzIuazGrfWvW8UT/kTulV409BVeujRaF+WEa8UJwNQAz
         f3y0I8/wpt+f2eWEzodXqajV0nqZObxajNaHxsVAyaAsl3fxL38oAY97Yq5pTayxfi
         vQDQlgHbdKsFAVGovCiWQglN0mRtsldvcG1a3LXPsXwFQal+Lr5PC7aJR07mvugqme
         DcdDX6uLeDRrsqrmeYtlE6C7wVXiLo8k4eZD5OIEv37g4RzVTqRLbO2Kpyaxe+hLH4
         22Lp4jI3kLnmmIhDcd0BYOYo4X0FonScAWvxFUAWprbbr98Tudq/sccLim49eIV1E7
         the9i0ui91vAw==
Date:   Wed, 9 Mar 2022 20:44:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v3 net-next 14/14] mlx5: support BIG TCP packets
Message-ID: <20220309204405.58079350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310002846.460907-15-eric.dumazet@gmail.com>
References: <20220310002846.460907-1-eric.dumazet@gmail.com>
        <20220310002846.460907-15-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Mar 2022 16:28:46 -0800 Eric Dumazet wrote:
> @@ -918,12 +953,27 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
>  	eseg->mss = attr.mss;
>  
>  	if (attr.ihs) {
> -		memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
> +		if (unlikely(attr.hopbyhop)) {
> +			/* remove the HBH header.
> +			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
> +			 */
> +			memcpy(eseg->inline_hdr.start, skb->data, ETH_HLEN + sizeof(*h6));
> +			h6 = (struct ipv6hdr *)((char *)eseg->inline_hdr.start + ETH_HLEN);
> +			h6->nexthdr = IPPROTO_TCP;
> +			/* Copy the TCP header after the IPv6 one */
> +			memcpy(h6 + 1,
> +			       skb->data + ETH_HLEN + sizeof(*h6) +
> +					sizeof(struct hop_jumbo_hdr),
> +			       tcp_hdrlen(skb));
> +			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
> +		} else {
> +			memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
> +		}

Compiler says there's no h6 in mlx5i_sq_xmit().
