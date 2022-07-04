Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5D8564AFE
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 02:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiGDA4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 20:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiGDA4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 20:56:45 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB315F91
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 17:56:42 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 2640tBqD1000301;
        Mon, 4 Jul 2022 02:55:11 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 2640tBqD1000301
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1656896111;
        bh=he/yC7NPe9lpEcWw0OsoUIWcPyaZt1fCNFhW8X/QIMc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fiYulR9F7RX0GVmn9DckQjkMYmjLgGz/Oyobrw+qeXBawGNH2hsq3KaBET4EU7JuK
         jqIfF41SJyqwL7sr8ONWhK3fAE6xrE8v5RPfeLASn/JKTbYjDO8emLtcphtrmVT/r2
         6Pq7OdOlxEm+VA/EB+znTUq3Dn+aXYC8iDENr75s=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 2640t9vi1000300;
        Mon, 4 Jul 2022 02:55:09 +0200
Date:   Mon, 4 Jul 2022 02:55:08 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Erhard F." <erhard_f@mailbox.org>
Subject: Re: [PATCH net] r8169: fix accessing unset transport header
Message-ID: <YsI6bEFtM+2uK492@electric-eye.fr.zoreil.com>
References: <ee150b21-7415-dd3f-6785-0163fd150493@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee150b21-7415-dd3f-6785-0163fd150493@googlemail.com>
X-Organisation: Land of Sunshine Inc.
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> :
> 66e4c8d95008 ("net: warn if transport header was not set") added
> a check that triggers a warning in r8169, see [0].
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=216157
> 
> Fixes: 8d520b4de3ed ("r8169: work around RTL8125 UDP hw bug")
> Reported-by: Erhard F. <erhard_f@mailbox.org>
> Tested-by: Erhard F. <erhard_f@mailbox.org>
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

/me wonders...

- bz216157 experiences a (2nd) warning because the rtl8169_tso_csum_v2
  ARP path shares the factored read of the (unset) transport offset
  but said ARP path does not use the transport offset.
  -> ok, the warning is mostly harmless. 

- rtl8169_tso_csum_v2 non-ARP paths own WARN_ON_ONCE will always
  complain before Eric's transport specific warning triggers.
  -> ok, the warning is redundant.

- rtl8169_features_check

> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 3098d6672..1b7fdb4f0 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
[...]
> @@ -4402,14 +4401,13 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>  						struct net_device *dev,
>  						netdev_features_t features)
>  {
> -	int transport_offset = skb_transport_offset(skb);
>  	struct rtl8169_private *tp = netdev_priv(dev);
>  
>  	if (skb_is_gso(skb)) {
>  		if (tp->mac_version == RTL_GIGA_MAC_VER_34)
>  			features = rtl8168evl_fix_tso(skb, features);
>  
> -		if (transport_offset > GTTCPHO_MAX &&
> +		if (skb_transport_offset(skb) > GTTCPHO_MAX &&
>  		    rtl_chip_supports_csum_v2(tp))
>  			features &= ~NETIF_F_ALL_TSO;
>  	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
> @@ -4420,7 +4418,7 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>  		if (rtl_quirk_packet_padto(tp, skb))
>  			features &= ~NETIF_F_CSUM_MASK;
>  
> -		if (transport_offset > TCPHO_MAX &&
> +		if (skb_transport_offset(skb) > TCPHO_MAX &&
>  		    rtl_chip_supports_csum_v2(tp))
>  			features &= ~NETIF_F_CSUM_MASK;
>  	}

Neither skb_is_gso nor CHECKSUM_PARTIAL implies a transport header so the
warning may still trigger, right ?

Btw it's a bit unexpected to see a "Fixes" tag related to a RTL8125 bug as
well as a "Tested-by" by the bugzilla submitter when the dmesg included in
bz216157 exibits a RTL8168e/8111e.

-- 
Ueimor
