Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE7EC2C0D66
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 15:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbgKWOWi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 23 Nov 2020 09:22:38 -0500
Received: from spam.lhost.no ([5.158.192.84]:56018 "EHLO mx03.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729794AbgKWOWh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 09:22:37 -0500
X-ASG-Debug-ID: 1606141354-0ffc0561bcf8fb10001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx03.lhost.no with ESMTP id q68zBcXCdpAuBpSx (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Mon, 23 Nov 2020 15:22:35 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from s103.paneda.no (10.16.55.12) by s103.paneda.no (10.16.55.12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Mon, 23
 Nov 2020 15:22:32 +0100
Received: from s103.paneda.no ([fe80::5c7b:c468:58da:4a47]) by s103.paneda.no
 ([fe80::5c7b:c468:58da:4a47%12]) with mapi id 15.01.1979.003; Mon, 23 Nov
 2020 15:22:32 +0100
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Hardcoded multicast queue length in macvlan.c driver causes poor
 multicast receive performance
Thread-Topic: Hardcoded multicast queue length in macvlan.c driver causes poor
 multicast receive performance
X-ASG-Orig-Subj: Hardcoded multicast queue length in macvlan.c driver causes poor
 multicast receive performance
Thread-Index: AdbBmBo51BY+qmTERji5QdOdvPJslQAC4h8A
Date:   Mon, 23 Nov 2020 14:22:31 +0000
Message-ID: <147b704ac1d5426fbaa8617289dad648@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
In-Reply-To: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [83.140.179.234]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1606141355
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx03.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 1556
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

There is a special queue handling in macvlan.c for broadcast and multicast packages that was arbitrarily set to 1000 in commit 07d92d5cc977a7fe1e683e1d4a6f723f7f2778cb . While this is probably sufficient for most uses cases it is insufficient to support high packet rates. I currently have a setup with 144 000 multicast packets incoming per second (144 different live audio RTP streams) and suffer very frequent packet loss. With unicast this is not an issue and I can in addition to the 144kpps load the macvlan interface with another 450mbit/s using iperf.

In order to verify that the queue is the problem I edited the define to 100000 and recompiled the kernel module. After replacing it with rmmod/insmod I get 0 packet loss (measured over 2 days where I before had losses every other second or so) and can also load an additional 450 mbit/s multicast traffic using iperf without losses. So basically no change in performance between unicast/multicast when it comes to lost packets on my machine.

I think It would be best if this queue length was configurable somehow. Either an option when creating the macvlan (like how bridge/passthrough/etc are set) or at least when loading the module (for instance by using a config in /etc/modprobe.d). One size does not fit all in this situation.


Link to code in question using the define (on master):
https://github.com/torvalds/linux/blob/27bba9c532a8d21050b94224ffd310ad0058c353/drivers/net/macvlan.c#L357 

(re-sent in text/plain instead of html)

Best regards,
Thomas Karlsson
