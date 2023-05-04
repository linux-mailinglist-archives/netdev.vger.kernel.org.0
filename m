Return-Path: <netdev+bounces-338-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BAB06F7324
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:22:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1101F280E07
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E7AEEA4;
	Thu,  4 May 2023 19:22:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64817E7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:22:07 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB5DDB
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 12:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=a3krCOPh5pV8WwY920n9ZyF6RN0TaACbUbUDVznPnC4=; b=CmITCjwxEzafaTrgPXlTOgEFEH
	aCOQMxfHNam10VOP9roA9fZ5RWf4D9DLVzvl6G9RTpaibCX0MGepRz4LGu/bQ0lDF5XPSYXwHcFGp
	LSje61kyRXn5p165CXCeTFSGopUaItHobHJKR3V6l4HUzswH13+1Rfcprb0mQVZHWB8M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pueWc-00BwEj-NJ; Thu, 04 May 2023 21:21:58 +0200
Date: Thu, 4 May 2023 21:21:58 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Fabio Estevam <festevam@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Steffen =?iso-8859-1?Q?B=E4tz?= <steffen@innosonix.de>,
	netdev <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
Message-ID: <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 03:39:17PM -0300, Fabio Estevam wrote:
> Hi,
> 
> We are running kernel 6.1.26 on an imx8mn-based board with a Marvell
> mv88e6320 switch.



> 
> eth1 and eth2 are the mv88e6320 ports. We connect a PTP sync source to eth1
> and we notice that after setting up vlan_filtering on a bridge, the PTP
> packets are no longer forwarded by the switch.
> 
> Below is the networking setup.
> 
> It does not matter if we assign an IP and sniff on the br0 or on the veth2,
> PTP multicast is not appearing. Some multicast like ARP does come through.
> Flags on br0: multicast_snooping = 1, mcast_flood  =1, mcast_router = 1

Do you see the PTP traffic on eth1?

What MAC address is the PTP traffic using? Is it a link local MAC
address? There are some range of MAC addresses which you are not
supposed to forward across a bridge. e.g. you don't forward BPDUs.
Take a look at br_handle_frame(). Maybe you can play with
group_fwd_mask.

	 Andrew


