Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D351A29E06E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgJ1WEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:04:55 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56960 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728268AbgJ1WBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:01:08 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 156EC65E57
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 20:41:31 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.144])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 9981A2010B;
        Wed, 28 Oct 2020 20:41:30 +0000 (UTC)
Received: from us4-mdac16-35.at1.mdlocal (unknown [10.110.49.219])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 96E0D800A4;
        Wed, 28 Oct 2020 20:41:30 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.103])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0158B40084;
        Wed, 28 Oct 2020 20:41:30 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A949F980078;
        Wed, 28 Oct 2020 20:41:29 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 28 Oct
 2020 20:41:24 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 0/4] sfc: EF100 TSO enhancements
To:     <linux-net-drivers@solarflare.com>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
Message-ID: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
Date:   Wed, 28 Oct 2020 20:41:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25752.003
X-TM-AS-Result: No-1.309700-8.000000-10
X-TMASE-MatchedRID: ShzUERdoFATKGuE12Tco0FJbv6sGZHYqxXRDKEyu2zFOsq/n2Kz29FW5
        UN79kMsqpzvlVPpnzu5Tijz/Q8m+/ZJL/r/YvPShqjZ865FPtpqm7EUWk2jS0cNAewdCCM5EKQb
        +OoiREpqEgl0njLljkhKUgCVJnOKAm0BF8EU4/qFPecEIo68AS58CClrNVSL7Yy6fApvL8BcKHk
        UYQmViAZ7wVhuRk/CXKqt2FG1/DdBNfs8n85Te8oMbH85DUZXy3QfwsVk0UbvqwGfCk7KUszEbq
        Yfrz81A3i0LILPWzuNS/uQb1oWUabM4csmuG36ZlZ9UpGUG80FH68Owitja+K7oRSi1uBkmSVmT
        46lodUAiU+hr3l6L3VrMCKBXF1d6I2VNggMWJCP4LggrmsRgvTwNB+BE7PnlftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.309700-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25752.003
X-MDID: 1603917690-xpq4jr6WgYz9
X-PPE-DISP: 1603917690;xpq4jr6WgYz9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support TSO over encapsulation (with GSO_PARTIAL), and over VLANs
 (which the code already handled but we didn't advertise).  Also
 correct our handling of IPID mangling.

I couldn't find documentation of exactly what shaped SKBs we can
 get given, so patch #2 is slightly guesswork, but when I tested
 TSO over both underlay and (VxLAN) overlay, the checksums came
 out correctly, so at least in those cases the edits we're making
 must be the right ones.
Similarly, I'm not 100% sure I've correctly understood how FIXEDID
 and MANGLEID are supposed to work in patch #3.

Edward Cree (4):
  sfc: extend bitfield macros to 17 fields
  sfc: implement encap TSO on EF100
  sfc: only use fixed-id if the skb asks for it
  sfc: advertise our vlan features

 drivers/net/ethernet/sfc/bitfield.h  | 42 +++++++++++++++++---
 drivers/net/ethernet/sfc/ef100_nic.c | 17 ++++++--
 drivers/net/ethernet/sfc/ef100_tx.c  | 58 ++++++++++++++++------------
 3 files changed, 84 insertions(+), 33 deletions(-)

