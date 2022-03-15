Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715A24D937A
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241747AbiCOFEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235582AbiCOFD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:03:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8F520A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 22:02:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31652B810F6
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 05:02:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E329C340E8;
        Tue, 15 Mar 2022 05:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647320565;
        bh=BznCpZa5qE8tlmDB2xniE3k+vhMfMG3hHwnuUBA+mTc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D0Tgf33EJj3O4mlmkh2LIeZnxe8Pn58qa9qCad5hgKdpcaFODES10nSqh6ldIHfFA
         DGKakOk3+Xj+OK1ru2Dw7XgzOPA87WgyxZzGxWUFRU88zV7n1bVyySrRJ8Mw7UYrSq
         7KRdZ6/SMnuHYh3G9jVSGGky/B06eQRAABa1A1d8F+U8N8L0cj/9EXPOnMG0aD3GS9
         XhLVKRJSCP8XEYvOwd55T1HetUREG2ezJW1BgNz+oARzayMrYFF7/lE/8BKVnV/KOp
         hmOi4mN8fBdmrD4R0Wpedw16aIr1AY1E3L/l/EoFXGB1fXWF3351cV25/B0zAtTRk7
         dNidqdWVwnDRA==
Date:   Mon, 14 Mar 2022 22:02:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Maor Dickman <maord@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] net/mlx5e: MPLSoUDP decap, use vlan
 push_eth instead of pedit
Message-ID: <20220314220244.5e8e3cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220309130256.1402040-3-roid@nvidia.com>
References: <20220309130256.1402040-1-roid@nvidia.com>
        <20220309130256.1402040-3-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Mar 2022 15:02:55 +0200 Roi Dayan wrote:
> +	case FLOW_ACTION_VLAN_PUSH_ETH:
> +		if (!flow_flag_test(parse_state->flow, L3_TO_L2_DECAP))
> +			return -EOPNOTSUPP;
> +		parse_state->eth_push = true;
> +		memcpy(attr->eth.h_dest, act->vlan_push_eth_dst, ETH_ALEN);
> +		memcpy(attr->eth.h_source, act->vlan_push_eth_src, ETH_ALEN);
> +		break;

How does the device know the proto? I kind of expected this code will
require some form of a match on proto.
