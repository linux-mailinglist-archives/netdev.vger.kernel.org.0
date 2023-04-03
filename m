Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC5E6D4379
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjDCL2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231966AbjDCL2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:28:07 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A27812053;
        Mon,  3 Apr 2023 04:27:51 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id C5A775FD22;
        Mon,  3 Apr 2023 14:27:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680521269;
        bh=IT8v0HROiXE98eFOBlkbvJKsX4eGIdzHHzOWFB5UhsM=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=XpyVQ5f0Mu7e/D8l9CfMGthvfxgoiPgxcMVZRjwL1QDaQU60hZm0Mllrk61kkNGJa
         o6Fm2ysFL1+9GpzLKYw5Jy3/Usl/tlzMYXM8dRWwN1lmSCkzuTswQmMjfaHb/cXCQr
         j95fXPFV+YuF6g9ASaR88yvjVvG0+Hw8UB2JgUk+U/K+3TF6kAxqqrRGJlq0zwmeo6
         sSvQZoWD+WsRP+cROH7TYCR4uD1HgAvjH1u/hXHiEG/tbunEami+wC2lvh1B0jM0aP
         lZqr/mwuyZ1T+JJ5+e/3/KGmk/FDxcBimuOe88oBgOk1GbP3Hza4tHO2Y+E2XuQOlS
         4TL5GOAvEuwMw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  3 Apr 2023 14:27:49 +0300 (MSK)
Message-ID: <2cfe98c9-0b47-d50a-0570-70e6d4af281e@sberdevices.ru>
Date:   Mon, 3 Apr 2023 14:24:17 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <0d20e25a-640c-72c1-2dcb-7a53a05e3132@sberdevices.ru>
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
Subject: [PATCH net-next v4 1/3] vsock/vmci: convert VMCI error code to
 -ENOMEM on receive
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/03 05:35:00 #21028078
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
is preparation for the next patch, which changes af_vsock.c behaviour
on receive to pass value returned from transport to the user.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/vmci_transport.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 36eb16a40745..a5375c97f5b0 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1831,10 +1831,17 @@ static ssize_t vmci_transport_stream_dequeue(
 	size_t len,
 	int flags)
 {
+	ssize_t err;
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
-- 
2.25.1
