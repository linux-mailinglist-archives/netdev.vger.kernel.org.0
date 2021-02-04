Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0179530F43B
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 14:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbhBDNw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 08:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236391AbhBDNw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 08:52:28 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651E0C061573
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 05:51:46 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id AE55922FAD;
        Thu,  4 Feb 2021 14:51:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612446702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g5XzHWd0I7aR0v8+Nl3MJ/fayFIVMdbUbm8ZLSk3cMo=;
        b=UyYDPUyM9HkCQTeStr9/kaEXRdL/HUkq8LaL/Bdd9QJHPIQqkHAt85MVTy9kenFer/DD4P
        lFttQJzsK9DwNnDCax2+4SgcnfD4cG7zVsv8oEPTojEtty1jbfzk9gnX9fYQ9x9x6g9OF2
        9sKfcD1zgwJZfqqe2VBTxiqhAeVmPMw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 04 Feb 2021 14:51:41 +0100
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>
Subject: Re: [PATCH net] net: enetc: initialize the RFS and RSS memories
In-Reply-To: <20210204134511.2640309-1-vladimir.oltean@nxp.com>
References: <20210204134511.2640309-1-vladimir.oltean@nxp.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <e13eec965ab1473823faf65b7a0a2d7d@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-04 14:45, schrieb Vladimir Oltean:
> Michael tried to enable Advanced Error Reporting through the ENETC's
> Root Complex Event Collector, and the system started spitting out 
> single
> bit correctable ECC errors coming from the ENETC interfaces:
> 
> pcieport 0000:00:1f.0: AER: Multiple Corrected error received: 
> 0000:00:00.0
> fsl_enetc 0000:00:00.0: PCIe Bus Error: severity=Corrected,
> type=Transaction Layer, (Receiver ID)
> fsl_enetc 0000:00:00.0:   device [1957:e100] error 
> status/mask=00004000/00000000
> fsl_enetc 0000:00:00.0:    [14] CorrIntErr
> fsl_enetc 0000:00:00.1: PCIe Bus Error: severity=Corrected,
> type=Transaction Layer, (Receiver ID)
> fsl_enetc 0000:00:00.1:   device [1957:e100] error 
> status/mask=00004000/00000000
> fsl_enetc 0000:00:00.1:    [14] CorrIntErr
> 
> Further investigating the port correctable memory error detect register
> (PCMEDR) shows that these AER errors have an associated SOURCE_ID of 6
> (RFS/RSS):
> 
> $ devmem 0x1f8010e10 32
> 0xC0000006
> $ devmem 0x1f8050e10 32
> 0xC0000006
> 
> Discussion with the hardware design engineers reveals that on LS1028A,
> the hardware does not do initialization of that RFS/RSS memory, and 
> that
> software should clear/initialize the entire table before starting to
> operate. That comes as a bit of a surprise, since the driver does not 
> do
> initialization of the RFS memory. Also, the initialization of the
> Receive Side Scaling is done only partially.
> 
> Even though the entire ENETC IP has a single shared flow steering
> memory, the flow steering service should returns matches only for TCAM
> entries that are within the range of the Station Interface that is 
> doing
> the search. Therefore, it should be sufficient for a Station Interface
> to initialize all of its own entries in order to avoid any ECC errors,
> and only the Station Interfaces in use should need initialization.
> 
> There are Physical Station Interfaces associated with PCIe PFs and
> Virtual Station Interfaces associated with PCIe VFs. We let the PF
> driver initialize the entire port's memory, which includes the RFS
> entries which are going to be used by the VF.
> 
> Reported-by: Michael Walle <michael@walle.cc>
> Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet 
> drivers")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Michael Walle <michael@walle.cc>

Thanks Vladimir!

-michael
