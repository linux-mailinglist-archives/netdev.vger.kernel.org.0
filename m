Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB55C4B97D8
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 05:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbiBQEoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 23:44:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiBQEo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 23:44:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDCB18E13E;
        Wed, 16 Feb 2022 20:44:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 019B661D5A;
        Thu, 17 Feb 2022 04:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A95C340E9;
        Thu, 17 Feb 2022 04:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645073051;
        bh=BGju6hGLRyEf2m6nqCHDCLlyVhV4bPLTg/Mt5EZCJk0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fnr5DTR1stC0tveq/1mbFOkNj5sGzaRnrjkYH/pbWahB2ee6xp4BUQOs7YH8Tli9/
         n9A/ttfmc08ZuY7onnlVC440omb/w0TOlwvR71v2f8uAHMuEwxBgXwY2vGVnvZDNH5
         3/Wb1txHpwytTtU+JnYa0lpGOGRjfN3DR4LwFKmhfL6VBs76ABJufWvQGuEwDUt67q
         qskYMzy9I3aXTmcyIK+Zvuh13H4n1aLe9e4pXrCiKQ6+4ul+jnzdNnw5bQQjoA+RSz
         1cTGG92nMhPQHt6PYjL9jTh9YFOEZFunmrOfA6DQQu4OBmHUpoBnz1VC5G2dSwEAYD
         Pn+G4yWt69P1w==
Date:   Wed, 16 Feb 2022 20:44:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jeffrey Ji <jeffreyjilinux@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Mahesh Bandewar <maheshb@google.com>,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v1 net-next] teaming: deliver link-local packets with
 the link they arrive on
Message-ID: <20220216204409.1d2928b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220215220517.2498751-1-jeffreyji@google.com>
References: <20220215220517.2498751-1-jeffreyji@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Feb 2022 22:05:17 +0000 Jeffrey Ji wrote:
> From: jeffreyji <jeffreyji@google.com>
> 
> skb is ignored if team port is disabled. We want the skb to be delivered
> if it's an LLDP packet.
> 
> Issue is already fixed for bonding in commit
> b89f04c61efe3b7756434d693b9203cc0cce002e

This is not the correct way to quote a commit.  It should be
commit <12+ chars of sha1> ("title line").

> Signed-off-by: jeffreyji <jeffreyji@google.com>

You must CC maintainers. scripts/get_maintainer.pl is your friend.
You don't have to CC linux-kernel, tho, nobody reads that. Please
resend.

> diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
> index 8b2adc56b92a..24d66dfbb2e1 100644
> --- a/drivers/net/team/team.c
> +++ b/drivers/net/team/team.c
> @@ -734,6 +734,12 @@ static rx_handler_result_t team_handle_frame(struct sk_buff **pskb)
>  	port = team_port_get_rcu(skb->dev);
>  	team = port->team;
>  	if (!team_port_enabled(port)) {
> +		if (is_link_local_ether_addr(eth_hdr(skb)->h_dest))
> +			/*

Please run checkpatch --strict on your submissions

> +			 * link-local packets are mostly useful when stack
> +			 * receives them with the link they arrive on.
> +			 */
> +			return RX_HANDLER_PASS;
>  		/* allow exact match delivery for disabled ports */
>  		res = RX_HANDLER_EXACT;
>  	} else {

