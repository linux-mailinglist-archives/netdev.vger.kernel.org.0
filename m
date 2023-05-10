Return-Path: <netdev+bounces-1415-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 588176FDB6E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:14:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DF831C20C50
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 10:14:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79B396FD9;
	Wed, 10 May 2023 10:14:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C96F569C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 10:14:39 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FF52103
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 03:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fNHRl3/wVZncE9/NFvZoAs9tOW3Dxy6LQacML8u7MyM=; b=OT5YspYt/x75r+vas10mYxbpIV
	MxnD1kHr/Vlfar2baorSLHNbICnrGQ18XM5WI3ZlD9dgq7V2NAj1ivaXVueX4mXYoe9pUMSlvWi1n
	2hP8T3kfkkCBjkq2pf/oKuvfOLy06fkb7EyBzW86CCepIE8GNU9dwUxxbEieMQE2MPfpyM+kB4c4U
	WJGrl1TT1jifufKHzTX8jjC0Wxz+zHRaB0YeEEy77Ut2SlXIj3J7ZiXlhxBU6UJisAobx0OtvaYfU
	Kb28TXDOdXAaXGCjrMpfHNPwdi7Qn44pJ5oegGygTnuL0CKzHBSO7D6NUU8Y7mlBBPdgb4ro43hCh
	9ew5lPBg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37554)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pwgq6-0004jH-7H; Wed, 10 May 2023 11:14:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pwgq4-0002uB-CP; Wed, 10 May 2023 11:14:28 +0100
Date: Wed, 10 May 2023 11:14:28 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH net-next 0/6] net: mvneta: reduce size of TSO header
 allocation
Message-ID: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

With reference to
https://forum.turris.cz/t/random-kernel-exceptions-on-hbl-tos-7-0/18865/
https://github.com/openwrt/openwrt/pull/12375#issuecomment-1528842334

It appears that mvneta attempts an order-6 allocation for the TSO
header memory. While this succeeds early on in the system's life time,
trying order-6 allocations later can result in failure due to memory
fragmentation.

Firstly, the reason it's so large is that we take the number of
transmit descriptors, and allocate a TSO header buffer for each, and
each TSO header is 256 bytes. The driver uses a simple mechanism to
determine the address - it uses the transmit descriptor index as an
index into the TSO header memory.

	(The first obvious question is: do there need to be this
	many? Won't each TSO header always have at least one bit
	of data to go with it? In other words, wouldn't the maximum
	number of TSO headers that a ring could accept be the number
	of ring entries divided by 2?)

There is no real need for this memory to be an order-6 allocation,
since nothing in hardware requires this buffer to be contiguous.

Therefore, this series splits this order-6 allocation up into 32
order-1 allocations (8k pages on 4k page platforms), each giving
32 TSO headers per page.

In order to do this, these patches:

1) fix a horrible transmit path error-cleanup bug - the existing
   code unmaps from the first descriptor that was allocated at
   interface bringup, not the first descriptor that the packet
   is using, resulting in the wrong descriptors being unmapped.

2) since xdp support was added, we now have buf->type which indicates
   what this transmit buffer contains. Use this to mark TSO header
   buffers.

3) get rid of IS_TSO_HEADER(), instead using buf->type to determine
   whether this transmit buffer needs to be DMA-unmapped.

4) move tso_build_hdr() into mvneta_tso_put_hdr() to keep all the
   TSO header building code together.

5) split the TSO header allocation into chunks of order-1 pages.

This has now been tested by the Turris folk and has been found to fix
the allocation error.

 drivers/net/ethernet/marvell/mvneta.c | 166 +++++++++++++++++++++++-----------
 1 file changed, 115 insertions(+), 51 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

