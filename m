Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69057178EB0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388031AbgCDKmE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Mar 2020 05:42:04 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:35850 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387776AbgCDKmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:42:04 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 024AfhIo005745, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTEXMB06.realtek.com.tw[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 024AfhIo005745
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 4 Mar 2020 18:41:43 +0800
Received: from RTEXMB02.realtek.com.tw (172.21.6.95) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 18:41:43 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 18:41:42 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999]) by
 RTEXMB04.realtek.com.tw ([fe80::d9c5:a079:495e:b999%6]) with mapi id
 15.01.1779.005; Wed, 4 Mar 2020 18:41:42 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     "Mancini, Jason" <Jason.Mancini@amd.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: v5.5-rc1 and beyond insta-kills some Comcast wifi routers
Thread-Topic: v5.5-rc1 and beyond insta-kills some Comcast wifi routers
Thread-Index: AQHV8eKYmDBcKgCqq0WSUKvXILk0y6g34qhg//+63wCAAIeWUA==
Date:   Wed, 4 Mar 2020 10:41:42 +0000
Message-ID: <c185b1f27e4a4b66941b50697dba006c@realtek.com>
References: <DM6PR12MB4331FD3C4EF86E6AF2B3EBC7E5E50@DM6PR12MB4331.namprd12.prod.outlook.com>
        <4e2a1fc1-4c14-733d-74e2-750ef1f81bf6@infradead.org>
 <87h7z4r9p5.fsf@kamboji.qca.qualcomm.com>,<4bd036de86c94545af3e5d92f0920ac2@realtek.com>
 <DM6PR12MB433132A38F2AA6A5946B75CBE5E50@DM6PR12MB4331.namprd12.prod.outlook.com>
In-Reply-To: <DM6PR12MB433132A38F2AA6A5946B75CBE5E50@DM6PR12MB4331.namprd12.prod.outlook.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.175]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [AMD Official Use Only - Internal Distribution Only]
> 
> I tested Kalle's patch.  Laptop connects via 5GHz band by default.  Comcast
> router still
> crashed in a hurry.  I blocked (via NM.conf) the 5GHz mac of the router, and
> rebooted
> the laptop. Checked that the router was using 2.4 for the laptop.  Still hung
> the router!
> 
> What I've done temporarily is change the unlimited return value from 0 to
> 4000.
> Somewhere around 5325 the Comcast router gets cranky/weird, and at 5350
> it is
> resetting the wifi stack (without resetting the entire router).
> 
> So there's no boot time flag to turn the feature off currently?
> 

Unfortunately, no, there's no flag to turn off this.

But, from your experiments, if you applied that patch,
("rtw88: disable TX-AMSDU on 2.4G band") connect to AP on 2.4G, and still crash
the Comcast AP, then it looks like it's not TX-AMSDU to be blamed.

Assume the return value you mentioned is max_rc_amsdu_len, if you always
return 1, it will just disable all of the AMSDU process.
You can try it, and to see if sending AMSDU will crash the router or not.

Yen-Hsuan
