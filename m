Return-Path: <netdev+bounces-1459-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7780E6FDD16
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:49:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CDB4281038
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:49:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D7BE1097A;
	Wed, 10 May 2023 11:49:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FD320B4C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:49:03 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB8061B2
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
	Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TLCqPWBv1H++JJR3ALZxd5CoLH0aDeulOSqhewhv5Dc=; b=TX7Gs8VZDvZ2pn57oqta85r5Re
	FH9GX/3412Jutffz0a8lE8oTd5KY6Vl/kzVmHYkzPWujPb+7WAMqhPvyGQ7W0C0yw1S8jIgteNeIw
	s/nJwKa9LunyO35IdngzYDUl5Fkj5ewt1r4SuaeD5UOyY9nAx/gY3QLlp3/MQxBvtDDbQxrFvLqpy
	pE+ZTkAN3fcYKzPrPVEF1floEv/XZyEiJmms4Upi5N66K05PZPEQL2DN5u95nxzuSH9/oKY/iLAnb
	easWsYED8YCu+MKtMHuvPmzIMIPp7f7qPDNtTYykin5UHNPYzQJTpQvq03KYt6/6J1ciBKx+O7Va1
	AVvunFkQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34442)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1pwiJU-0004tw-6n; Wed, 10 May 2023 12:48:56 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1pwiJS-0002ya-PO; Wed, 10 May 2023 12:48:54 +0100
Date: Wed, 10 May 2023 12:48:54 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: Eric Dumazet <edumazet@google.com>
Cc: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH net-next 5/5] net: mvneta: allocate TSO header DMA memory
 in chunks
Message-ID: <ZFuEphwApIDwJSxb@shell.armlinux.org.uk>
References: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk>
 <E1pwgrb-001XEA-HB@rmk-PC.armlinux.org.uk>
 <CANn89iKrhFWgbqxDU2RY62PmCrhfV+OpvGUAy9uDCJ8KGw9qZw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iKrhFWgbqxDU2RY62PmCrhfV+OpvGUAy9uDCJ8KGw9qZw@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 01:38:17PM +0200, Eric Dumazet wrote:
> On Wed, May 10, 2023 at 12:16 PM Russell King (Oracle)
> <rmk+kernel@armlinux.org.uk> wrote:
> >
> > Now that we no longer need to check whether the DMA address is within
> > the TSO header DMA memory range for the queue, we can allocate the TSO
> > header DMA memory in chunks rather than one contiguous order-6 chunk,
> > which can stress the kernel's memory subsystems to allocate.
> >
> > Instead, use order-1 (8k) allocations, which will result in 32 order-1
> > pages containing 32 TSO headers.
> 
> I guess there is no IOMMU/SMMU/IOTLB involved on platforms using this driver.
> 
> (Otherwise, attempting high-order allocations, then fallback to
> low-order allocations
> would provide better performance if the high-order allocation at init
> time succeeded)

On the hardware I have, that is correct. Maybe others with mvneta on
different SoCs can comment? Thomas probably has an idea, but as he
hasn't worked on Marvell hardware for some time, may have forgotten
everything about Marvell hardware.

On that point, I'm wondering whether there's much value keeping
Thomas' maintainer's entries for Marvell stuff - any comment Thomas?

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

