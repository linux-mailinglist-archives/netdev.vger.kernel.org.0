Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE2B6CFC54
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 09:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbjC3HLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 03:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjC3HLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 03:11:14 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1B972683;
        Thu, 30 Mar 2023 00:11:01 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 2F7EE5FD25;
        Thu, 30 Mar 2023 10:11:00 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680160260;
        bh=ggY0SHBEDfjLnsfC/RTR6iP6BEUZWncCZMwnfImDKoE=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=oCPL5TtBEAP6W+v408n4Oq4bR+oEtlA6TQwuISu8BhUWeJ6vYR7TImdW1kVlgZs90
         duxxYE/X8+6SNYv6N9KpE6FI8GC9n2O/SWi6Ut7VrTOXaGQJYz1+dGZe457in0uZGl
         y5YIbaOVdN2mC6LDK7Go27pygHxYUh9GFtoyDdTEnv1j7GfrSTYZthmfcIHj4+oYDp
         8+Nc/cfKRp3GDDT6aeZzC8HZweFypZwI1O5vV3TZkCceuSj1YQjlDwNlPTV8dCGr+v
         Ume3wrtNEBiwc2vSiSJl8z2c0aCB7W7pvCVf5pTSGNCD7iitvuwUqLBsC5yjDvQssJ
         J4AQmuDNWsjnQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu, 30 Mar 2023 10:11:00 +0300 (MSK)
Message-ID: <94d33849-d3c1-7468-72df-f87f897bafd2@sberdevices.ru>
Date:   Thu, 30 Mar 2023 10:07:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <60abc0da-0412-6e25-eeb0-8e32e3ec21e7@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>, <pv-drivers@vmware.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 2/3] vsock/vmci: convert VMCI error code to -ENOMEM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/30 01:24:00 #21043458
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds conversion of VMCI specific error code to general -ENOMEM. It
is needed, because af_vsock.c passes error value returned from transport
to the user.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/vmci_transport.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 36eb16a40745..45de3e75597f 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1831,10 +1831,17 @@ static ssize_t vmci_transport_stream_dequeue(
 	size_t len,
 	int flags)
 {
+	int err;
+
 	if (flags & MSG_PEEK)
-		return vmci_qpair_peekv(vmci_trans(vsk)->qpair, msg, len, 0);
+		err = vmci_qpair_peekv(vmci_trans(vsk)->qpair, msg, len, 0);
 	else
-		return vmci_qpair_dequev(vmci_trans(vsk)->qpair, msg, len, 0);
+		err = vmci_qpair_dequev(vmci_trans(vsk)->qpair, msg, len, 0);
+
+	if (err < 0)
+		err = -ENOMEM;
+
+	return err;
 }
 
 static ssize_t vmci_transport_stream_enqueue(
@@ -1842,7 +1849,13 @@ static ssize_t vmci_transport_stream_enqueue(
 	struct msghdr *msg,
 	size_t len)
 {
-	return vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
+	int err;
+
+	err = vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
+	if (err < 0)
+		err = -ENOMEM;
+
+	return err;
 }
 
 static s64 vmci_transport_stream_has_data(struct vsock_sock *vsk)
-- 
2.25.1
