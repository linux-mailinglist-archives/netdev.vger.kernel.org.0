Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548AA3EC16E
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 10:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237614AbhHNIkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 04:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237426AbhHNIkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 04:40:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB31C06175F;
        Sat, 14 Aug 2021 01:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=62Vas8vfgaU4Fg6a79+EgFsfJwf25X3qtqREVjssypo=; b=rpZ/Hf6OytEohJ44VJerrJnY/s
        TEFsUGwQv3vlbUI/UJ63t6E2YTwPjll3r0wySKJteuhDjjHUkTC891M2EaZAtSmzc/6A7VtDUYdeZ
        sj04B0bK0q7cXgHrj4BkRf93eUFG3YOvax+SqxiXEMu68HGkPpVwIx3Bxu1nSZfJ9kMUCSzXM+sto
        M6hSpq59VxPiY/BdGTlq9OS61Y6ZM0kqRjZzvGbgjN7M74UQJlVY3yE+PFufg32Mk50/mGh+9hFnM
        AZlp+9VpV1p/UVgYqoI5Yt2M0GsKqu2cVVjHNlp2YnwDTFsE9y6r5rwyYuCw4Obj52pcnajsvDSDo
        yGLfyGTw==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mEpBa-00GXfB-Cb; Sat, 14 Aug 2021 08:38:41 +0000
Date:   Sat, 14 Aug 2021 09:38:34 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci@vger.kernel.org, Alexander Duyck <alexanderduyck@fb.com>,
        oss-drivers@corigine.com, Paul Mackerras <paulus@samba.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Rafa?? Mi??ecki <zajec5@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Vadym Kochan <vkochan@marvell.com>, Michael Buesch <m@bues.ch>,
        Jiri Pirko <jiri@nvidia.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        netdev@vger.kernel.org, Simon Horman <simon.horman@corigine.com>,
        Oliver O'Halloran <oohall@gmail.com>,
        linuxppc-dev@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 4/8] PCI: replace pci_dev::driver usage that gets the
 driver name
Message-ID: <YReBCtWxvmDx7Uqg@infradead.org>
References: <20210811080637.2596434-1-u.kleine-koenig@pengutronix.de>
 <20210811080637.2596434-5-u.kleine-koenig@pengutronix.de>
 <YRTIqGm5Dr8du7a7@infradead.org>
 <20210812081425.7pjy4a25e2ehkr3x@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210812081425.7pjy4a25e2ehkr3x@pengutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 12, 2021 at 10:14:25AM +0200, Uwe Kleine-K??nig wrote:
> dev_driver_string() might return "" (via dev_bus_name()). If that happens
> *drvstr == '\0' becomes true.
> 
> Would the following be better?:
> 
> 	const char *drvstr;
> 
> 	if (pdev)
> 		return "<null>";
> 
> 	drvstr = dev_driver_string(&pdev->dev);
> 
> 	if (!strcmp(drvstr, ""))
> 		return "<null>";
> 
> 	return drvstr;
> 
> When I thought about this hunk I considered it ugly to have "<null>" in
> it twice.

Well, if you want to avoid that you can do:

	if (pdev) {
		const char *name = dev_driver_string(&pdev->dev);

		if (strcmp(drvstr, ""))
			return name;
	}
	return "<null>";

Which would be a lot more readable.
