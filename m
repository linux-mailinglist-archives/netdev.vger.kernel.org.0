Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96EDB242F6F
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 21:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHLThF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 15:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgHLThF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 15:37:05 -0400
Received: from the.earth.li (the.earth.li [IPv6:2a00:1098:86:4d:c0ff:ee:15:900d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51A5C061383;
        Wed, 12 Aug 2020 12:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=earth.li;
         s=the; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:Sender:
        Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XqxBkx0fhTjErNZmjOmJ0k+Zy+sZA4pBOuNGrWDz6iI=; b=FMeEhwrV6De794yhR10herc21E
        qdQvLTi+Nv2G9VZkkbfSUyNa3hH/0pMw7ZcvxmIanCTJR/cygmyBgGNaGMG7O9ymJm4SBlC9RnefP
        8tXAq4QSkoI21sA2RFEMRQsyXdSRnpOUr4akPKkWNfzmCgNLP/zXN7M3DsWyRl6nErD+1O/IVKjap
        EJAMRIxdFe+I40ckS63WCjDzAwaSBqS7ImhQ4FAsKqK763DYrN1c2ZzKWxcHhKU8lM0a7t4g6gS00
        8t+GqPAoXn7pTPSQ7mFFT5QzAnUlBYUVlutQLETWTK4+2m//BBwBi9yQ+16e3ZfOIrRjeLTopfBk9
        drVXFmRw==;
Received: from noodles by the.earth.li with local (Exim 4.92)
        (envelope-from <noodles@earth.li>)
        id 1k5wYQ-0002nP-Bl; Wed, 12 Aug 2020 20:36:54 +0100
Date:   Wed, 12 Aug 2020 20:36:54 +0100
From:   Jonathan McDowell <noodles@earth.li>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] net: stmmac: Fix multicast filter on IPQ806x
Message-ID: <cover.1597260787.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This pair of patches are the result of discovering a failure to
correctly receive IPv6 multicast packets on such a device (in particular
DHCPv6 requests and RA solicitations). Putting the device into
promiscuous mode, or allmulti, both resulted in such packets correctly
being received. Examination of the vendor driver (nss-gmac from the
qsdk) shows that it does not enable the multicast filter and instead
falls back to allmulti.

Extend the base dwmac1000 driver to fall back when there's no suitable
hardware filter, and update the ipq806x platform to request this.

Jonathan McDowell (2):
  net: stmmac: dwmac1000: provide multicast filter fallback
  net: ethernet: stmmac: Disable hardware multicast filter

 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c  | 1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c | 3 +++
 2 files changed, 4 insertions(+)

-- 
2.20.1

