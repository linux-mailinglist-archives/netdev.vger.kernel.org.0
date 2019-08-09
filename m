Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B39A88368
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbfHITn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:43:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37036 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfHITn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:43:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B6E96142CA79C;
        Fri,  9 Aug 2019 12:43:28 -0700 (PDT)
Date:   Fri, 09 Aug 2019 12:43:27 -0700 (PDT)
Message-Id: <20190809.124327.1282600811774499704.davem@davemloft.net>
To:     Jose.Abreu@synopsys.com
Cc:     netdev@vger.kernel.org, Joao.Pinto@synopsys.com
Subject: Re: [PATCH net-next 01/12] net: stmmac: Get correct timestamp
 values from XGMAC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <7acdee903b01dd5462f687c31163628cefa0e372.1565375521.git.joabreu@synopsys.com>
References: <cover.1565375521.git.joabreu@synopsys.com>
        <cover.1565375521.git.joabreu@synopsys.com>
        <7acdee903b01dd5462f687c31163628cefa0e372.1565375521.git.joabreu@synopsys.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 12:43:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>
Date: Fri,  9 Aug 2019 20:36:09 +0200

> +	void __iomem *ioaddr = hw->pcsr;
> +	int count = 0;
> +	u32 value;
> +
> +	do {
> +		if (readl_poll_timeout_atomic(ioaddr + XGMAC_TIMESTAMP_STATUS,
> +					      value, value & XGMAC_TXTSC,
> +					      100, 10000))
> +			break;
> +
> +		*ts = readl(ioaddr + XGMAC_TXTIMESTAMP_NSEC) & XGMAC_TXTSSTSLO;
> +		*ts += readl(ioaddr + XGMAC_TXTIMESTAMP_SEC) * 1000000000ULL;
> +	} while (count++);
> +
> +	if (count)
> +		return 0;
> +	return -EBUSY;

This is a very strange construct, the loop never executes more than once.
Simplified it is essentially:

	if (readl_poll_timeout_atomic(ioaddr + XGMAC_TIMESTAMP_STATUS,
				      value, value & XGMAC_TXTSC,
				      100, 10000))
		return -EBUSY;

	*ts = readl(ioaddr + XGMAC_TXTIMESTAMP_NSEC) & XGMAC_TXTSSTSLO;
	*ts += readl(ioaddr + XGMAC_TXTIMESTAMP_SEC) * 1000000000ULL;
	return 0;

Don't make the code more complicated than it needs to be, there is no
reason to use a loop here.  And using a loop makes it look like the
loop is the polling/timeout construct, when it isn't, because
readl_poll_timeout_atomic() is serving that purpose.

