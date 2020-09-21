Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2304271F97
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgIUKDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:03:09 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:4940 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726406AbgIUKDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:03:08 -0400
X-Greylist: delayed 1662 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 06:03:06 EDT
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08L9NI8K030954
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 11:35:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=subject : references : to
 : from : message-id : date : mime-version : in-reply-to : content-type :
 content-transfer-encoding; s=STMicroelectronics;
 bh=zoc0+qhn3ax/+nOQu7w6iNDNNCT7E46OqCWQZc3ceoI=;
 b=c3w9mKXbQb4xiazncHeuGfVV3FObz8x2iFGPuiaN2Yx1jVxMnL66EB8WnfkXfFIEM5mk
 o0y5dDLJrfKG/MkQdDRt18OSZVOZKoeHxdnwsV1pYY0+di6fDIzXu2RIJ/poG3BIcI+X
 NSoQmLZOBjcvOWERamefCSm2HAQPkUElHPpUCn7wmAuY9s5wg0tNDVDmfjHRA2kdioDf
 92PuKHoYoWPNEgr7OgHAixkY7sNJOeiRy3OrOxSK3RcQzMkhtENYEt90udsWCmSFZASs
 S17+luxAVjq2zGwXldXOcoGM6EMLfFBwnWJiXtU8pt2zGJ7b1seBOPFJ0qru8lAkriZ2 dA== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 33n747sfm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 11:35:23 +0200
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 20A98100034
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 11:35:23 +0200 (CEST)
Received: from Webmail-eu.st.com (sfhdag5node3.st.com [10.75.127.15])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 185EE22099A
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 11:35:23 +0200 (CEST)
Received: from lmecxl0555.lme.st.com (10.75.127.50) by SFHDAG5NODE3.st.com
 (10.75.127.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 21 Sep
 2020 11:35:22 +0200
Subject: Question on commit: [PATCH] net: stmmac: Delete txtimer in suspend()
References: <c7447637466945d4bffcb67e63ade205@SFHDAG5NODE3.st.com>
To:     <netdev@vger.kernel.org>
From:   Christophe ROULLIER <christophe.roullier@st.com>
X-Forwarded-Message-Id: <c7447637466945d4bffcb67e63ade205@SFHDAG5NODE3.st.com>
Message-ID: <c1275e42-7df9-ddce-33ac-589f813e73f9@st.com>
Date:   Mon, 21 Sep 2020 11:35:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c7447637466945d4bffcb67e63ade205@SFHDAG5NODE3.st.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG8NODE1.st.com (10.75.127.22) To SFHDAG5NODE3.st.com
 (10.75.127.15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_01:2020-09-21,2020-09-20 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi all,

I would like to know if you have already seen this behavior :

Without this patch 
https://patchwork.ozlabs.org/project/netdev/patch/20200201020124.5989-1-nicoleotsuka@gmail.com/, 
during suspend/resume sequence on STM32MP15 (stmmac driver):

[   69.184175] dwc2 49000000.usb-otg: suspending usb gadget configfs-gadget

[   69.358831] stm32-dwmac 5800a000.ethernet eth0: Link is Down

[   69.370345] Disabling non-boot CPUs ...

[   69.371309] CPU1 killed.

[   69.379201] Enabling non-boot CPUs ...

[   69.382421] CPU1 is up

[   69.402201] dwmac4: Master AXI performs any burst length

[   69.402235] stm32-dwmac 5800a000.ethernet eth0: No Safety Features 
support found

[   69.402306] stm32-dwmac 5800a000.ethernet eth0: configuring for 
phy/rgmii-id link mode

[   69.405656] usb usb2: root hub lost power or was reset

[   69.805154] usb 2-1: reset high-speed USB device number 2 using 
ehci-platform

[   69.883813] dwc2 49000000.usb-otg: resuming usb gadget configfs-gadget

[   70.189888] OOM killer enabled.

[   70.192983] Restarting tasks ... done.

[   70.215832] PM: suspend exit

root@stm32mp1-disco:~# [   75.608337] stm32-dwmac 5800a000.ethernet 
eth0: Link is Up - 1Gbps/Full - flow control rx/tx

And the same soft + patch “net: stmmac: Delete txtimer in suspend()" :

[  181.931229] dwc2 49000000.usb-otg: suspending usb gadget configfs-gadget

[  182.110153] stm32-dwmac 5800a000.ethernet eth0: Link is Down

[  182.112333] stm32-dwmac 5800a000.ethernet eth0: Link is Up - 
1Gbps/Full - flow control rx/tx

[  182.112420] stm32-dwmac 5800a000.ethernet eth0: Link is Down

[  182.120247] Disabling non-boot CPUs ...

[  182.121186] CPU1 killed.

[  182.129095] Enabling non-boot CPUs ...

[  182.132309] CPU1 is up

[  182.151590] dwmac4: Master AXI performs any burst length

[  182.151626] stm32-dwmac 5800a000.ethernet eth0: No Safety Features 
support found

[  182.151695] stm32-dwmac 5800a000.ethernet eth0: configuring for 
phy/rgmii-id link mode

[  182.154930] usb usb2: root hub lost power or was reset

[  182.555119] usb 2-1: reset high-speed USB device number 2 using 
ehci-platform

[  182.633763] dwc2 49000000.usb-otg: resuming usb gadget configfs-gadget

[  182.953899] OOM killer enabled.

[  182.957008] Restarting tasks ... done.

[  182.996662] PM: suspend exit

root@stm32mp1-disco:~# [  188.408297] stm32-dwmac 5800a000.ethernet 
eth0: Link is Up - 1Gbps/Full - flow control rx/tx

I would like to understand why there is more :

[  182.110153] stm32-dwmac 5800a000.ethernet eth0: Link is Down

[  182.112333] stm32-dwmac 5800a000.ethernet eth0: Link is Up - 
1Gbps/Full - flow control rx/tx

[  182.112420] stm32-dwmac 5800a000.ethernet eth0: Link is Down

Any idea ?

Regards.

Christophe.

