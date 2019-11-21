Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5E1C104894
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKUCgk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 Nov 2019 21:36:40 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:50206 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKUCgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 21:36:40 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xAL2Dc8h019344, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xAL2Dc8h019344
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 10:13:39 +0800
Received: from RTEXMB03.realtek.com.tw (172.21.6.96) by
 RTITCAS12.realtek.com.tw (172.21.6.16) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Thu, 21 Nov 2019 10:13:38 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 21 Nov 2019 10:13:38 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::f0a5:1a8b:cf45:7112]) by
 RTEXMB04.realtek.com.tw ([fe80::f0a5:1a8b:cf45:7112%4]) with mapi id
 15.01.1779.005; Thu, 21 Nov 2019 10:13:38 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Prashant Malani <pmalani@chromium.org>
CC:     "grundler@chromium.org" <grundler@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net] r8152: Re-order napi_disable in rtl8152_close
Thread-Topic: [PATCH net] r8152: Re-order napi_disable in rtl8152_close
Thread-Index: AQHVn9p0kCKKsPhQEkqnVEj6cHKxFKeU4m0g
Date:   Thu, 21 Nov 2019 02:13:38 +0000
Message-ID: <d7c05cd827d3487d8376db0fe30baace@realtek.com>
References: <20191120194020.8796-1-pmalani@chromium.org>
In-Reply-To: <20191120194020.8796-1-pmalani@chromium.org>
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

Prashant Malani [mailto:pmalani@chromium.org]
> Sent: Thursday, November 21, 2019 3:40 AM

> Both rtl_work_func_t() and rtl8152_close() call napi_disable().
> Since the two calls aren't protected by a lock, if the close
> function starts executing before the work function, we can get into a
> situation where the napi_disable() function is called twice in
> succession (first by rtl8152_close(), then by set_carrier()).
> 
> In such a situation, the second call would loop indefinitely, since
> rtl8152_close() doesn't call napi_enable() to clear the NAPI_STATE_SCHED
> bit.
> 
> The rtl8152_close() function in turn issues a
> cancel_delayed_work_sync(), and so it would wait indefinitely for the
> rtl_work_func_t() to complete. Since rtl8152_close() is called by a
> process holding rtnl_lock() which is requested by other processes, this
> eventually leads to a system deadlock and crash.
> 
> Re-order the napi_disable() call to occur after the work function
> disabling and urb cancellation calls are issued.
> 
> Change-Id: I6ef0b703fc214998a037a68f722f784e1d07815e
> Reported-by: http://crbug.com/1017928
> Signed-off-by: Prashant Malani <pmalani@chromium.org>

Acked-by: Hayes Wang <hayeswang@realtek.com>

Thanks

Best Regards,
Hayes


