Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C81A2C4A48
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 22:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbgKYVzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 16:55:53 -0500
Received: from mx04.lhost.no ([5.158.192.85]:48653 "EHLO mx04.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730523AbgKYVzx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 16:55:53 -0500
X-ASG-Debug-ID: 1606341348-0ffc06424c52dc0001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx04.lhost.no with ESMTP id GCro6RUr83z83cvS (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Wed, 25 Nov 2020 22:55:49 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from [192.168.10.188] (83.140.179.234) by s103.paneda.no
 (10.16.55.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Wed, 25
 Nov 2020 22:55:47 +0100
Subject: [PATCH net-next v2] macvlan: Support for high multicast packet rate
To:     Jakub Kicinski <kuba@kernel.org>
X-ASG-Orig-Subj: [PATCH net-next v2] macvlan: Support for high multicast packet rate
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <thomas.karlsson@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b93a6031-f1b4-729d-784b-b1f465d27071@paneda.se>
 <385b9b4c-25f5-b507-4e69-419883fa8043@paneda.se>
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
Message-ID: <28768621-5c08-fd5a-ffa2-7fc51c80e479@paneda.se>
Date:   Wed, 25 Nov 2020 22:55:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <385b9b4c-25f5-b507-4e69-419883fa8043@paneda.se>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.140.179.234]
X-ClientProxiedBy: s103.paneda.no (10.16.55.12) To s103.paneda.no
 (10.16.55.12)
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1606341349
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx04.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 2095
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Background:
Broadcast and multicast packages are enqueued for later processing.
This queue was previously hardcoded to 1000.

This proved insufficient for handling very high packet rates.
This resulted in packet drops for multicast.
While at the same time unicast worked fine.

The change:
This patch make the queue len adjustable to accommodate
for environments with very high multicast packet rate.
But still keeps the default value of 1000 unless specified.

The queue len is specified using the bc_queue_len module parameter.

Signed-off-by: Thomas Karlsson <thomas.karlsson@paneda.se>
---
v2: Patch created on top of 'net-next' instead of 'torvalds/linux'

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d9b6c44a5911..ed67fbfff450 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
@@ -35,11 +36,15 @@

 #define MACVLAN_HASH_BITS      8
 #define MACVLAN_HASH_SIZE      (1<<MACVLAN_HASH_BITS)
-#define MACVLAN_BC_QUEUE_LEN   1000
+#define MACVLAN_DEFAULT_BC_QUEUE_LEN   1000

 #define MACVLAN_F_PASSTHRU     1
 #define MACVLAN_F_ADDRCHANGE   2

+static uint bc_queue_len = MACVLAN_DEFAULT_BC_QUEUE_LEN;
+module_param(bc_queue_len, uint, 0444);
+MODULE_PARM_DESC(bc_queue_len, "The maximum length of the broadcast/multicast work queue");
+
 struct macvlan_port {
        struct net_device       *dev;
        struct hlist_head       vlan_hash[MACVLAN_HASH_SIZE];
@@ -354,7 +359,7 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
        MACVLAN_SKB_CB(nskb)->src = src;

        spin_lock(&port->bc_queue.lock);
-       if (skb_queue_len(&port->bc_queue) < MACVLAN_BC_QUEUE_LEN) {
+       if (skb_queue_len(&port->bc_queue) < bc_queue_len) {
                if (src)
                        dev_hold(src->dev);
                __skb_queue_tail(&port->bc_queue, nskb);
--
2.28.0
