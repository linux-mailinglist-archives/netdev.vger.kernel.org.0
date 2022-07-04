Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2E2565A08
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 17:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiGDPkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 11:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiGDPks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 11:40:48 -0400
Received: from violet.fr.zoreil.com (violet.fr.zoreil.com [IPv6:2001:4b98:dc0:41:216:3eff:fe56:8398])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81292101CE
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 08:40:47 -0700 (PDT)
Received: from violet.fr.zoreil.com ([127.0.0.1])
        by violet.fr.zoreil.com (8.17.1/8.17.1) with ESMTP id 264FeFLS1045022;
        Mon, 4 Jul 2022 17:40:15 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 violet.fr.zoreil.com 264FeFLS1045022
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fr.zoreil.com;
        s=v20220413; t=1656949215;
        bh=q/Kpzj7GaCZGjUIfTBkslpQQ1YF2/dGDZFG+t+1re6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B+8S7Ak4KEt62wMAni5H5cjkk/YUjEl1G7HOr6vSor4HUQGTT5k6OvHs2D9dTKN2C
         H8raCa32Av8mL4wt/3IbDCxuKJkG3X4ju/u4XxYO/cEXFqp4GN3F3r0J7qZhAviRsG
         cSrtIAaL7PWuLZGKNY8EC2PW9OR82SPxVY+bZ1nM=
Received: (from romieu@localhost)
        by violet.fr.zoreil.com (8.17.1/8.17.1/Submit) id 264FeEgq1045021;
        Mon, 4 Jul 2022 17:40:14 +0200
Date:   Mon, 4 Jul 2022 17:40:13 +0200
From:   Francois Romieu <romieu@fr.zoreil.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Erhard F." <erhard_f@mailbox.org>
Subject: Re: [PATCH net] r8169: fix accessing unset transport header
Message-ID: <YsMJ3foj4v57xPF0@electric-eye.fr.zoreil.com>
References: <ee150b21-7415-dd3f-6785-0163fd150493@googlemail.com>
 <YsI6bEFtM+2uK492@electric-eye.fr.zoreil.com>
 <26745304-2c23-ae26-9cb9-2cf1fa5422ac@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26745304-2c23-ae26-9cb9-2cf1fa5422ac@googlemail.com>
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
> On 04.07.2022 02:55, Francois Romieu wrote:
> > Heiner Kallweit <hkallweit1@gmail.com> :
> >> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> > [...]
> >> @@ -4420,7 +4418,7 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
> >>  		if (rtl_quirk_packet_padto(tp, skb))
> >>  			features &= ~NETIF_F_CSUM_MASK;
> >>  
> >> -		if (transport_offset > TCPHO_MAX &&
> >> +		if (skb_transport_offset(skb) > TCPHO_MAX &&
> >>  		    rtl_chip_supports_csum_v2(tp))
> >>  			features &= ~NETIF_F_CSUM_MASK;
> >>  	}
> > 
> > Neither skb_is_gso nor CHECKSUM_PARTIAL implies a transport header so the
> > warning may still trigger, right ?
> 
> I'm not an expert here, and due to missing chip documentation I can't say
> whether the chip could handle hw csumming correctly w/o transport header.
> I'd see whether we get more reports of this warning. If yes, then maybe
> we should use skb_transport_header_was_set() explicitly and disable
> hw csumming if there's no transport header.

(some sleep later)

I had forgotten the NETIF_F_* stuff in the r8169 driver. :o/

So, yes, ignore this point.

> > Btw it's a bit unexpected to see a "Fixes" tag related to a RTL8125 bug as
> > well as a "Tested-by" by the bugzilla submitter when the dmesg included in
> > bz216157 exibits a RTL8168e/8111e.
> > 
> The Fixes tag refers to the latest change to the affected code, therefore
> it comes a little unexpected, right.

?

8d520b4de3ed does not change the affected code.

Eric's unset transport offset detection debug code would have produced the
same output with the parent of the "Fixes" commit id:

$ git cat-file -p 8d520b4de3ed^:drivers/net/ethernet/realtek/r8169_main.c | grep -A4 -B1 -E 'rtl8169_features_check'

static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
						struct net_device *dev,
						netdev_features_t features)
{
	int transport_offset = skb_transport_offset(skb);
--
	.ndo_start_xmit		= rtl8169_start_xmit,
	.ndo_features_check	= rtl8169_features_check,
	.ndo_tx_timeout		= rtl8169_tx_timeout,
	.ndo_validate_addr	= eth_validate_addr,
	.ndo_change_mtu		= rtl8169_change_mtu,
	.ndo_fix_features	= rtl8169_fix_features,


-> 8d520b4de3ed does not modify the first
'int transport_offset = skb_transport_offset(skb);' statement and neither
does it modify the code path to rtl8169_features_check 

8d520b4de3ed actually removes some logical path towards rtl8169_tso_csum_v2
but it does not change (nor does it break) the relevant code:

$ git cat-file -p 8d520b4de3ed^:drivers/net/ethernet/realtek/r8169_main.c | grep -A3 -B1 -E 'bool rtl8169_tso_csum_v2'

static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
				struct sk_buff *skb, u32 *opts)
{
	u32 transport_offset = (u32)skb_transport_offset(skb);


-- 
Ueimor
