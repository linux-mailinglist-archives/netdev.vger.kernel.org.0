Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91616A9597
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 11:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjCCKwW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 3 Mar 2023 05:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjCCKwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 05:52:20 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C555CC2E;
        Fri,  3 Mar 2023 02:52:18 -0800 (PST)
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4PSl8t3Bwfz16Nn6;
        Fri,  3 Mar 2023 18:49:34 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 3 Mar 2023 18:52:15 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2507.021;
 Fri, 3 Mar 2023 18:52:15 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: [Qestion] abort backport commit ("net/ulp: prevent ULP without clone
 op from entering the LISTEN status") in stable-4.19.x
Thread-Topic: [Qestion] abort backport commit ("net/ulp: prevent ULP without
 clone op from entering the LISTEN status") in stable-4.19.x
Thread-Index: AdlNvdvVjnKkJ9z9STWxQrC2kjT+nw==
Date:   Fri, 3 Mar 2023 10:52:15 +0000
Message-ID: <ea1af62dfc3e43859c1cb278f39d1a6f@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, 

When I was working on CVE-2023-0461, I found the below backport commit in stable-4.19.x maybe something wrong?

755193f2523c ("net/ulp: prevent ULP without clone op from entering the LISTEN status") 

1.  err = -EADDRINUSE in inet_csk_listen_start() was removed. But it is the error code when get_port() fails. 
 2. The change in __tcp_set_ulp() should not be discarded?

Can I modify the patch like below?

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 0a69f92da71b..3ed2f753628e 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -903,11 +903,25 @@ void inet_csk_prepare_forced_close(struct sock *sk)
 }
 EXPORT_SYMBOL(inet_csk_prepare_forced_close);
 
+static int inet_ulp_can_listen(const struct sock *sk)
+{
+       const struct inet_connection_sock *icsk = inet_csk(sk);
+
+       if (icsk->icsk_ulp_ops)
+               return -EINVAL;
+
+       return 0;
+}
+
 int inet_csk_listen_start(struct sock *sk, int backlog)
 {
        struct inet_connection_sock *icsk = inet_csk(sk);
        struct inet_sock *inet = inet_sk(sk);
-       int err = -EADDRINUSE;
+       int err;
+
+       err = inet_ulp_can_listen(sk);
+       if (unlikely(err))
+               return err;
 
        reqsk_queue_alloc(&icsk->icsk_accept_queue);
 
@@ -921,6 +935,7 @@ int inet_csk_listen_start(struct sock *sk, int backlog)
         * after validation is complete.
         */
        inet_sk_state_store(sk, TCP_LISTEN);
+       err = -EADDRINUSE;
        if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
                inet->inet_sport = htons(inet->inet_num);
 
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index a5995bb2eaca..437987be68be 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -152,6 +152,11 @@ int tcp_set_ulp(struct sock *sk, const char *name)
                return -ENOENT;
        }
 
+       if (sk->sk_state == TCP_LISTEN) {
+               module_put(ulp_ops->owner);
+               return -EINVAL
+       }
+
        err = ulp_ops->init(sk);
        if (err) {
                module_put(ulp_ops->owner);
