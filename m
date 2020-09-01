Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F78259F84
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbgIATya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:54:30 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:56826 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgIATy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:54:27 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 081JsHLQ077017;
        Tue, 1 Sep 2020 14:54:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598990057;
        bh=jAc5yhHSuR2/HSoiqH5ZAgoXM4oGSjl/hbyHU0rZrx0=;
        h=From:To:Subject:Date;
        b=n428VyhSA3WI+RM7MXiJKF8PaLOnDHdlJZ35xOmWQi+9cGzFPuo4EcvX7agQDNDvF
         ET66YfOVm56X0G8uLI94S9M6Gu6tUEgc1phpQwBBTwHekIifKKOaIDnO62c07+Cxjx
         MvMwf7h5GzXZx3QeUbAApco37fHNV6B3BcP9gO/Y=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 081JsHMF010060
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 1 Sep 2020 14:54:17 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 1 Sep
 2020 14:54:16 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 1 Sep 2020 14:54:16 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 081JsFZk093195;
        Tue, 1 Sep 2020 14:54:15 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>,
        <grygorii.strashko@ti.com>
Subject: [PATCH net-next 0/1] Support for VLAN interface over HSR/PRP
Date:   Tue, 1 Sep 2020 15:54:14 -0400
Message-ID: <20200901195415.4840-1-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add support for creating VLAN interface over HSR or
PRP interface. Typically industrial networks uses VLAN in
deployment and this capability is needed to support these
networks.

This is tested using two TI AM572x IDK boards connected back
to back over CPSW  ports (eth0 and eth1).

Following is the setup

                Physical Setup
                ++++++++++++++
                      
 _______________    (CPSW)     _______________
 |              |----eth0-----|               |
 |TI AM572x IDK1|             | TI AM572x IDK2|
 |______________|----eth1-----|_______________|


                Network Topolgy
                +++++++++++++++

                       TI AM571x IDK  TI AM572x IDK            

                                  
192.168.100.10                 CPSW ports                 192.168.100.20
             IDK-1                                        IDK-2
hsr0/prp0.100--| 192.168.2.10  |--eth0--| 192.168.2.20 |--hsr0/prp0.100
               |----hsr0/prp0--|        |---hsr0/prp0--|
hsr0/prp0.101--|               |--eth1--|              |--hsr0/prp0/101

192.168.101.10                                            192.168.101.20

Following tests:-
 - create hsr or prp interface and ping the interface IP address
   and verify ping is successful.
 - Create 2 VLANs over hsr or prp interface on both IDKs (VID 100 and
   101). Ping between the IP address of the VLAN interfaces
 - Do iperf UDP traffic test with server on one IDK and client on the
   other. Do this using 100 and 101 subnet IP addresses
 - Dump /proc/net/vlan/{hsr|prp}0.100 and verify frames are transmitted
   and received at these interfaces.
 - Delete the vlan and hsr/prp interface and verify interfaces are
   removed cleanly.

Logs for IDK-1 at https://pastebin.ubuntu.com/p/NxF83yZFDX/
Logs for IDK-2 at https://pastebin.ubuntu.com/p/YBXBcsPgVK/

Murali Karicheri (1):
  net: hsr/prp: add vlan support

 net/hsr/hsr_device.c  |  4 ----
 net/hsr/hsr_forward.c | 16 +++++++++++++---
 2 files changed, 13 insertions(+), 7 deletions(-)

-- 
2.17.1

