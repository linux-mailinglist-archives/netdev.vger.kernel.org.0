Return-Path: <netdev+bounces-2324-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A6B6701375
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 02:39:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BA151C2131C
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 00:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111287E6;
	Sat, 13 May 2023 00:39:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ACBA23
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 00:39:12 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A536611639
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 17:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=XRDobmDOvpGUxLayOkTBUJyxyM2Yk0eSNgM8bpCrq2A=; b=4NeL9LAeAWjHclNh9dki748zee
	7ufi/aNGnk649JLWVQp6hKXU6HhcAE4swu5gTONuu0Z0nIuDIHPr+JsHgpWGbPCxUhYpj+Dlg3d7Q
	hz8faLqyPZB1dZfjnx+Y8Q9QkcAfXMMhf2/7pqS03Gutd0S9Inb7Z3Wn2V++SdEC3Hlg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pxcdu-00CiGN-Oo; Sat, 13 May 2023 01:57:46 +0200
Date: Sat, 13 May 2023 01:57:46 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC net-next 3/9] net: phylink: add function to resolve
 clause 73 negotiation
Message-ID: <7cec3e9f-e614-43b4-abe9-c423d5f63563@lunn.ch>
References: <ZF52z7PqH2HLrWEU@shell.armlinux.org.uk>
 <E1pxWXz-002Qs5-0N@rmk-PC.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pxWXz-002Qs5-0N@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> +void phylink_resolve_c73(struct phylink_link_state *state)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(phylink_c73_priority_resolution); i++) {
> +		int bit = phylink_c73_priority_resolution[i].bit;
> +		if (linkmode_test_bit(bit, state->advertising) &&
> +		    linkmode_test_bit(bit, state->lp_advertising))
> +			break;
> +	}
> +
> +	if (i < ARRAY_SIZE(phylink_c73_priority_resolution)) {
> +		state->speed = phylink_c73_priority_resolution[i].speed;
> +		state->duplex = DUPLEX_FULL;
> +	} else {
> +		/* negotiation failure */
> +		state->link = false;
> +	}

Hi Russell

This looks asymmetric in that state->link is not set true if a
resolution is found.

Can that set be moved here? Or are there other conditions which also
need to be fulfilled before it is set?

     Andrew

