Return-Path: <netdev+bounces-10259-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2812672D460
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 00:29:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A4D01C20BF3
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 22:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5059B23C62;
	Mon, 12 Jun 2023 22:29:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4410823423
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 22:29:19 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6BB170C;
	Mon, 12 Jun 2023 15:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=y+r3yDX0gpvop5JCvib9GEMK945+knWKoOtG6I/6PDo=; b=EjoOvBxawoJYWkc/fcKgriyiNV
	cIYEPdPC6Oxeq07YiRJx540EwIRgNHsCkUx76lklmGjvNHIO/4p06ZSiM4X8EXAgCJzmoEYj2DozZ
	mNGu7ih/QFL7HzaeMiZeX6P/DCi7+tCm2NPZ/0myxI8jJrhOJwB2uhh7Q2nPGystn5kM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q8q1r-00FePO-QT; Tue, 13 Jun 2023 00:28:51 +0200
Date: Tue, 13 Jun 2023 00:28:51 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Marco Bonelli <marco@mebeim.net>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Maxim Korotkov <korotkov.maxim.s@gmail.com>,
	Gal Pressman <gal@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Simon Horman <simon.horman@corigine.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] ethtool: ioctl: account for sopass diff in
 set_wol
Message-ID: <9ec8eac3-6b2f-4455-89ef-2d5768b4cee9@lunn.ch>
References: <1686605822-34544-1-git-send-email-justin.chen@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1686605822-34544-1-git-send-email-justin.chen@broadcom.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 02:37:00PM -0700, Justin Chen wrote:
> sopass won't be set if wolopt doesn't change. This means the following
> will fail to set the correct sopass.
> ethtool -s eth0 wol s sopass 11:22:33:44:55:66
> ethtool -s eth0 wol s sopass 22:44:55:66:77:88
> 
> Make sure we call into the driver layer set_wol if sopass is different.
> 
> Fixes: 55b24334c0f2 ("ethtool: ioctl: improve error checking for set_wol")
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>
> ---
> 
> Note: Tagged "Fixes" patch has not hit rc yet.
> 
>  net/ethtool/ioctl.c | 3 ++-

Hi Justin

Does the netlink version get this correct?

And just for my own curiosity, why are you so interested in the ioctl
version, which is deprecated and not used by modern versions of
ethtool?

	Andrew

