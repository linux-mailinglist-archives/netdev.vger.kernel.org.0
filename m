Return-Path: <netdev+bounces-466-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BD6B76F77C7
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 23:07:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2E981C21447
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 21:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EFF4156D3;
	Thu,  4 May 2023 21:07:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204B07C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 21:07:24 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB761180
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 14:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
	In-Reply-To:References; bh=n66NeFRKQ3BlMvYkEUNiU3uPu+QBWiVgoOISQI65bQY=; b=pu
	7y6MlnQiiaQW2hwUP08WRlRiI+x8uudDR62CtHTFSsGSGChIED4Q2dI3im/EqX9mPLJj6CbBUIuHs
	v6Yxton/RvSZNPCvLv/NtviYuqIJgb+yOn/b7JiIxDa1DR2gyHchjeg6Rl1SZeEzDluNhJc+YcoBm
	LmuS+tUdLiB9eCI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1puf2b-00BwUh-Cf; Thu, 04 May 2023 21:55:01 +0200
Date: Thu, 4 May 2023 21:55:01 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Fabio Estevam <festevam@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Steffen =?iso-8859-1?Q?B=E4tz?= <steffen@innosonix.de>,
	netdev <netdev@vger.kernel.org>
Subject: Re: mv88e6320: Failed to forward PTP multicast
Message-ID: <5cd6a70c-ea13-4547-958f-5806f86bfa10@lunn.ch>
References: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
 <7b8243a3-9976-484c-a0d0-d4f3debbe979@lunn.ch>
 <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5DXH1wS9YYPWXYr-TvM+9Tj8F0bY0_kd_EAjrcCpEJJ7A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 04:40:53PM -0300, Fabio Estevam wrote:
> Hi Andrew,
> 
> On Thu, May 4, 2023 at 4:21 PM Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > Do you see the PTP traffic on eth1?
> 
> Yes, PTP traffic is seen on eth1.

So it is not a Marvell DSA issue. The frame is making it into the
Linux bridge.

> > What MAC address is the PTP traffic using? Is it a link local MAC
> > address? There are some range of MAC addresses which you are not
> > supposed to forward across a bridge. e.g. you don't forward BPDUs.
> > Take a look at br_handle_frame(). Maybe you can play with
> > group_fwd_mask.
> 
> In our case, it is a multicast MAC.

So not 01-80-C2-00-00-0E ?

I don't know how reliable it is, but see:

https://www.ieee802.org/1/files/public/docs2012/new-tc-messenger-tc-ptp-forwarding-1112-v02.pdf

Slide 5 says:

• 01-1B-19-00-00-00 – a general group address
  • An 802.1Q VLAN Bridge would forward the frame unchanged.
• 01-80-C2-00-00-0E – Individual LAN Scope group ad
  • An 802.1Q VLAN Bridge would drop the frame.

Maybe you are falling into this second case?

You really need to find out where in the Linux bridge it is getting
dropped. It should then be obvious why.

	 Andrew

