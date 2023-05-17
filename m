Return-Path: <netdev+bounces-3450-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 253837072C2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 22:11:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19F521C20FBE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 20:11:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DABB449A4;
	Wed, 17 May 2023 20:11:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA72111AD
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 20:11:25 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8010E7C;
	Wed, 17 May 2023 13:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Ncx1qH8n9sOF9FCZslMLbmv0w/78dVsCubBVxxWQ9gE=; b=nSy+KBG+i376ssgh15Q3xm7H/w
	3XNzbdDbyv1xjXNJE9FqV1X823Zjg4sm5tlDoULoBWhxToyEPKex3bV+xciamtVV9ORTyzikMYpps
	/3yzuoNysIx1dzYZqZ7lBAcWpq7FAj2O1McNtBR59TKUEC6UutvH3haEp5gBXb0AhqPE3crcl8lws
	SCMQe5UbPEKFvYxHgtZWonSPhO4WFmhwCcZxwjaOrMomeKjkfQYH5kuaY/0kuMnw95LGkpwdQY/Cy
	IqJICTQ7OrF+7Lx9+UjSL4Rjz93GF4KrVp/c5nklaEu8l5bPjgBFG1YTWd58IVJDDBplB2oBy3yqN
	vJ0QN9xg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53498)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pzNUP-0000B4-8p; Wed, 17 May 2023 21:11:13 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pzNUM-0002Lp-1y; Wed, 17 May 2023 21:11:10 +0100
Date: Wed, 17 May 2023 21:11:10 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Yeqi Fu <asuk4.q@gmail.com>
Cc: mw@semihalf.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Ivan Orlov <ivan.orlov0322@gmail.com>
Subject: Re: [PATCH] net: mvpp2: Fix error checking
Message-ID: <ZGU03muIumVDu0Gt@shell.armlinux.org.uk>
References: <20230517190811.367461-1-asuk4.q@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517190811.367461-1-asuk4.q@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 03:08:11AM +0800, Yeqi Fu wrote:
> The function debugfs_create_dir returns ERR_PTR if an error occurs,
> and the appropriate way to verify for errors is to use the inline
> function IS_ERR. The patch will substitute the null-comparison with
> IS_ERR.

Exactly as I said to a very similar patch received a few days ago
from SikkiLadho:

"The modern wisdom for debugfs is not to check for any errors, so if
we're going to touch this, that's the route that any patch should be
taking.

Thanks."

Your patch seems to have the same Suggested-by: which suggests to me
that you probably know SikkiLadho and are working together with the
person who suggested the change, so it would be good that when a
patch from one of you is commented upon, those comments are taken
into account rather than someone else sending an identical patch to
the first.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

