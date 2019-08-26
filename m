Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 524F09CCB9
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 11:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbfHZJnj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Aug 2019 05:43:39 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:39928 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfHZJnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 05:43:39 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7Q9hXn1020391, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7Q9hXn1020391
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Aug 2019 17:43:33 +0800
Received: from RTITMBSVM03.realtek.com.tw ([fe80::e1fe:b2c1:57ec:f8e1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0468.000; Mon, 26 Aug
 2019 17:43:32 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jiri Slaby <jslaby@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net v2 1/2] Revert "r8152: napi hangup fix after disconnect"
Thread-Topic: [PATCH net v2 1/2] Revert "r8152: napi hangup fix after
 disconnect"
Thread-Index: AQHVW+oYPqwM5rED6EyH48TSLgwyCacMmhSAgACMaRA=
Date:   Mon, 26 Aug 2019 09:43:32 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2F18D6733@RTITMBSVM03.realtek.com.tw>
References: <1394712342-15778-317-Taiwan-albertk@realtek.com>
 <1394712342-15778-318-Taiwan-albertk@realtek.com>
 <1f707377-7b61-4ba1-62bf-f275d0360749@suse.cz>
In-Reply-To: <1f707377-7b61-4ba1-62bf-f275d0360749@suse.cz>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Slaby [mailto:jslaby@suse.cz]
> Sent: Monday, August 26, 2019 4:55 PM
[...]
> Could you clarify *why* it conflicts? And how is the problem fixed by
> 0ee1f473496 avoided now?

In rtl8152_disconnect(), the flow would be as following.

static void rtl8152_disconnect(struct usb_interface *intf)
{
	...
	- netif_napi_del(&tp->napi);
	- unregister_netdev(tp->netdev);
	   - rtl8152_close
	      - napi_disable

Therefore you add a checking of RTL8152_UNPLUG to avoid
calling napi_disable() after netif_napi_del(). However,
after commit ffa9fec30ca0 ("r8152: set RTL8152_UNPLUG
only for real disconnection"), RTL8152_UNPLUG is not
always set when calling rtl8152_disconnect(). That is,
napi_disable() would be called after netif_napi_del(),
if RTL8152_UNPLUG is not set.

The best way is to avoid calling netif_napi_del() before
calling unregister_netdev(). And I has submitted such
patch following this one.

Best Regards,
Hayes


