Return-Path: <netdev+bounces-9632-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1228672A110
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:16:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B619A2819CB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9EC1C77A;
	Fri,  9 Jun 2023 17:16:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237141B915
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:16:16 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81097E4A;
	Fri,  9 Jun 2023 10:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=fJHuQ8zacvpe7ZvXvHuaj0SxXvb3ZjOuhHjQXHcZ+tc=; b=mBz5wKWg4QpH7XJ7Um49Ge35eK
	21DL30tvw1vdJEcJM4x7mEM3JRl7ClTuABp7L1eX3yXFf7YfJEZgfRS7KujAduEaLEAQb0DXL6X67
	EUHo0181Ghca2uYi9fsz+QAV9TD8dPenVCHeaOxSPTVnGDFHgF+zUq+Psc0aMlyjd478=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q7fiW-00FMuM-A0; Fri, 09 Jun 2023 19:16:04 +0200
Date: Fri, 9 Jun 2023 19:16:04 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Alexis =?iso-8859-1?Q?Lothor=E9?= <alexis.lothore@bootlin.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	paul.arola@telus.com, scott.roberts@telus.com
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: implement egress tbf
 qdisc for 6393x family
Message-ID: <176f073a-b5ab-4d8a-8850-fcd8eff65aa7@lunn.ch>
References: <20230609141812.297521-1-alexis.lothore@bootlin.com>
 <20230609141812.297521-3-alexis.lothore@bootlin.com>
 <d196f8c7-19f7-4a7c-9024-e97001c21b90@lunn.ch>
 <dbec77de-ee34-e281-3dd4-2332116a0910@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbec77de-ee34-e281-3dd4-2332116a0910@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Yes, I can do that (or maybe -EINVAL to match Vladimir's comment ?). I think
> it's worth mentioning that I encountered an issue regarding those values during
> tests: I use tc program to set the tbf, and I observed that tc does not even
> reach kernel to set the qdisc if we pass no burst/latency value OR if we set it
> to 0. So tc enforces right on userspace side non-zero value for those
> parameters, and I have passed random values and ignored them on kernel side.

That is not good. Please take a look around and see if any other
driver offloads TBF, and what they do with burst.

> Checking available doc about tc-tbf makes me feel like that indeed a TBF qdisc
> command without burst or latency value makes no sense, except my use case can
> not have such values. That's what I struggled a bit to find a proper qdisc to
> match hardware cap. I may fallback to a custom netlink program to improve testing.

We don't really want a custom application, since we want users to use
TC to set this up.

Looking at the 6390 datasheet, Queue Counter Registers, mode 8 gives
the number of egress buffers for a port. You could validate that the
switch has at least the requested number of buffers assigned to the
port? There is quite a bit you can configure, so maybe there is a way
to influence the number of buffers, so you can actually implement the
burst parameter?

      Andrew

