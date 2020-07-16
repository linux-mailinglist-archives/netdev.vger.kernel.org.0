Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5588222139
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 13:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgGPLRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 07:17:44 -0400
Received: from mxout03.lancloud.ru ([89.108.73.187]:33992 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbgGPLRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 07:17:44 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jul 2020 07:17:43 EDT
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 4E6132092F27
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Subject: [PATCH RFC] bluetooth: add support for some old headsets
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Organization: Open Mobile Platform, LLC
Message-ID: <6f461412-a6c0-aa53-5e74-394e278ee9b1@omprussia.ru>
Date:   Thu, 16 Jul 2020 14:08:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [213.87.162.13]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MediaTek Bluetooth platform (MT6630 etc.) has a peculiar implementation
for the eSCO/SCO connection via BT/EDR: the host controller returns error
code 0x20 (LMP feature not supported) for HCI_Setup_Synchronous_Connection
(0x0028) command without actually trying to setup connection with a remote
device in case such device (like Digma BT-14 headset) didn't advertise its
supported features.  Even though this doesn't break compatibility with the
Bluetooth standard it breaks the compatibility with the Hands-Free Profile
(HFP).

This patch returns the compatibility with the HFP profile and actually
tries to check all available connection parameters despite of the specific
MediaTek implementation. Without it one was unable to establish eSCO/SCO
connection with some headsets.

Based on the patch by Ildar Kamaletdinov <i.kamaletdinov@omprussia.ru>.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>

---
This patch is against the 'bluetooth-next.git' repo.

 net/bluetooth/hci_event.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: bluetooth-next/net/bluetooth/hci_event.c
===================================================================
--- bluetooth-next.orig/net/bluetooth/hci_event.c
+++ bluetooth-next/net/bluetooth/hci_event.c
@@ -2187,6 +2187,13 @@ static void hci_cs_setup_sync_conn(struc
 	if (acl) {
 		sco = acl->link;
 		if (sco) {
+			if (status == 0x20 && /* Unsupported LMP Parameter value */
+			    sco->out) {
+				sco->pkt_type = (hdev->esco_type & SCO_ESCO_MASK) |
+						(hdev->esco_type & EDR_ESCO_MASK);
+				if (hci_setup_sync(sco, sco->link->handle))
+					goto unlock;
+			}
 			sco->state = BT_CLOSED;
 
 			hci_connect_cfm(sco, status);
@@ -2194,6 +2201,7 @@ static void hci_cs_setup_sync_conn(struc
 		}
 	}
 
+unlock:
 	hci_dev_unlock(hdev);
 }
 
