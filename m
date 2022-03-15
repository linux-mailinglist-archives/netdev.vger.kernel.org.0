Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF9E4D9F64
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 16:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349700AbiCOPyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 11:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344431AbiCOPyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 11:54:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A726552
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 08:53:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECBD1B8117E
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 15:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC8FC340EE;
        Tue, 15 Mar 2022 15:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647359580;
        bh=ys44ks9Kj5FnxmXpz4Chbro2Z3RBwxf0hPfeKIO3zpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=p9QYjvPwyuVX1U6kfKohDDIcMg7H5LUqzmyJR6ShxEWLbQ79C8s9f2s8WbWDqvzeo
         Ry9x12OOCyleQdd8FrTo8W/m1LL1J+xdCPWabsfAMveFT3MWe9vnvIELF4aXDmrPum
         iEzHwBoNJHatB+Y2s9oeke0vX3WiDO+UDFdcEiQvr5GZOzO3roaw5cSCe/nyWRhpJU
         lLY/+69WQZJar9NDe5ns/0ibc01/9BKsbBhzINzvPYtbgJr0WDTMxY8Az0wgmJej4r
         4QOkinAwB9jqBs5e4mV2RNZ0T9bZUJR68utgsMdQ1BrBz+8mtFZz+kQVsi5r+eEB5X
         1W3QxvJTdaSww==
Date:   Tue, 15 Mar 2022 08:52:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] net/mlx5e: MPLSoUDP decap, use vlan
 push_eth instead of pedit
Message-ID: <20220315085258.40578edd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <517bdd01-243e-3c32-1ec1-ebc7c5a12df4@nvidia.com>
References: <20220309130256.1402040-1-roid@nvidia.com>
        <20220309130256.1402040-3-roid@nvidia.com>
        <20220314220244.5e8e3cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <517bdd01-243e-3c32-1ec1-ebc7c5a12df4@nvidia.com>
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

On Tue, 15 Mar 2022 11:50:46 +0200 Roi Dayan wrote:
> On 2022-03-15 7:02 AM, Jakub Kicinski wrote:
> > On Wed, 9 Mar 2022 15:02:55 +0200 Roi Dayan wrote:  
> >> +	case FLOW_ACTION_VLAN_PUSH_ETH:
> >> +		if (!flow_flag_test(parse_state->flow, L3_TO_L2_DECAP))
> >> +			return -EOPNOTSUPP;
> >> +		parse_state->eth_push = true;
> >> +		memcpy(attr->eth.h_dest, act->vlan_push_eth_dst, ETH_ALEN);
> >> +		memcpy(attr->eth.h_source, act->vlan_push_eth_src, ETH_ALEN);
> >> +		break;  
> > 
> > How does the device know the proto? I kind of expected this code will
> > require some form of a match on proto.  
> 
> Vlan push_eth doesn't handle the protocol, it only push src/dst mac.
> 
>  From tc-vlan man page:
>         PUSH_ETH := push_eth dst_mac LLADDR src_mac LLADDR

It uses the protocol from skb.

> In the case of MPLSoUDP the protocol is set by mpls pop action,
> prior to the vlan push_eth action.
> 
> Example:
>          action order 2: mpls  pop protocol ip pipe
>           index 2 ref 1 bind 1
>          used_hw_stats delayed
> 
>          action order 3: vlan  push_eth dst_mac de:a2:ec:d6:69:c8 
> src_mac de:a2:ec:d6:69:c8 pipe
>           index 2 ref 1 bind 1
>          used_hw_stats delayed

Ack, I was basically asking how the existence of an earlier mpls pop
gets enforced by the driver.
