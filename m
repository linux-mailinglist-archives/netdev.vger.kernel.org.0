Return-Path: <netdev+bounces-3352-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E5A70689D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 976C1281363
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756B718B16;
	Wed, 17 May 2023 12:50:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A30218B13
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:50:01 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568B0421D;
	Wed, 17 May 2023 05:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=71V5ReKQHSIVV/dbqK9wwRwpMSrqgG8X/SEPqdAnmzI=; b=Al
	g1ZzudGHCtG42DL8odktF7HpqU3IfPG7EJazjl9lC5Q4NlplP/ME3lZRgVSz1+lX/Sm7lIm57k0CE
	6BAW9PN2V2AVtL4TOgDP4VGruJZ9ql9vfdHeWBrvlmG8BKZhQnRlQwogZ/UcxIalFaor3I437vLjl
	9mmuCUuqUFCULhg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pzGbF-00D8VZ-Kc; Wed, 17 May 2023 14:49:49 +0200
Date: Wed, 17 May 2023 14:49:49 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: netdev@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: phy: broadcom: Add support for
 WAKE_FILTER
Message-ID: <a47d27e0-a8ef-4df0-aa45-623dda9e6412@lunn.ch>
References: <20230516231713.2882879-1-florian.fainelli@broadcom.com>
 <20230516231713.2882879-3-florian.fainelli@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230516231713.2882879-3-florian.fainelli@broadcom.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 04:17:12PM -0700, Florian Fainelli wrote:
> Since the PHY is capable of matching any arbitrary Ethernet MAC
> destination as a programmable wake-up pattern, add support for doing
> that using the WAKE_FILTER and ethtool::rxnfc API.

Are there other actions the PHY can perform?

For a MAC based filter, i expect there are other actions, like drop,
queue selection, etc. So using the generic RXNFC API makes some sense.

> ethtool -N eth0 flow-type ether dst 01:00:5e:00:00:fb loc 0 action -2
> ethtool -n eth0
> Total 1 rules
> 
> Filter: 0
>         Flow Type: Raw Ethernet
>         Src MAC addr: 00:00:00:00:00:00 mask: FF:FF:FF:FF:FF:FF
>         Dest MAC addr: 01:00:5E:00:00:FB mask: 00:00:00:00:00:00
>         Ethertype: 0x0 mask: 0xFFFF
>         Action: Wake-on-LAN
> ethtool -s eth0 wol f

What i don't particularly like about this is its not vary
discoverable, since it is not part of:

          wol p|u|m|b|a|g|s|f|d...
                  Sets Wake-on-LAN options.  Not all devices support
                  this.  The argument to this option is a string of
                  characters specifying which options to enable.

                  p   Wake on PHY activity
                  u   Wake on unicast messages
                  m   Wake on multicast messages
                  b   Wake on broadcast messages
                  a   Wake on ARP
                  g   Wake on MagicPacket™
                  s   Enable SecureOn™ password for MagicPacket™
                  f   Wake on filter(s)
                  d   Disable (wake on  nothing).   This  option
                      clears all previous options.

If the PHY hardware is not generic, it only has one action, WoL, it
might be better to have this use the standard wol commands. Can it be
made to work under the 'f' option?

The API to the PHY driver could then be made much more narrow, and you
would not need the comment this is supposed to only be used for WoL.

      Andrew

