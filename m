Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B341C6A9718
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 13:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjCCMQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 07:16:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjCCMQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 07:16:48 -0500
X-Greylist: delayed 562 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 03 Mar 2023 04:16:45 PST
Received: from esmtp-1.proxad.net (esmtp-1.proxad.net [213.36.6.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCD62A98D;
        Fri,  3 Mar 2023 04:16:45 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by esmtp-1.proxad.net (Postfix) with ESMTP id 7051881BB1;
        Fri,  3 Mar 2023 13:07:22 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at proxad.net
Received: from esmtp-1.proxad.net ([127.0.0.1])
        by localhost (esmtp-b23-1.proxad.net [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kvvE6ffmOTT2; Fri,  3 Mar 2023 13:07:21 +0100 (CET)
Received: from zstore-5.mgt.proxad.net (unknown [172.18.94.8])
        by esmtp-1.proxad.net (Postfix) with ESMTP id 9A57181A18;
        Fri,  3 Mar 2023 13:07:15 +0100 (CET)
Date:   Fri, 3 Mar 2023 13:07:15 +0100 (CET)
From:   Adrien Moulin <amoulin@corp.free.fr>
To:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Message-ID: <61481278.42813558.1677845235112.JavaMail.zimbra@corp.free.fr>
Subject: TLS zerocopy sendfile offset causes data corruption
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.8.12_GA_3803 (ZimbraWebClient - SAF16.2 (Mac)/8.8.12_GA_3794)
Thread-Index: lTDPthBuN+Zxmy4UPuAb4ZDFQmGN9Q==
Thread-Topic: TLS zerocopy sendfile offset causes data corruption
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_05,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When doing a sendfile call on a TLS_TX_ZEROCOPY_RO-enabled socket with an offset that is neither zero nor 4k-aligned, and with a "count" bigger than a single TLS record, part of the data received will be corrupted.

I am seeing this on 5.19 and 6.2.1 (x86_64) with a ConnectX-6 Dx NIC, with TLS NIC offload including sendfile otherwise working perfectly when not using TLS_TX_ZEROCOPY_RO.
I have a simple reproducer program available here https://gist.github.com/elyosh/922e6c15f8d4d7102c8ac9508b0cdc3b

Doing sendfile of a 32K file with a 8 bytes offset, first without zerocopy :

# ./ktls_test -i testfile -p 443 -c cert.pem -k key.pem -o 8
Serving file testfile, will send 32760 bytes (8 - 32768) with SHA1 sum 83fc1e3900cf900025311f2c27378a357f9f4d2c
sendfile(5, 3, 8, 32760) = 32760

% wget -S -q -O test_copy https://xxxxxx/; shasum test_copy
  HTTP/1.1 200 OK
  Content-Type: application/octet-stream
  Content-Length: 32760
  X-Source-SHA1: 83fc1e3900cf900025311f2c27378a357f9f4d2c
83fc1e3900cf900025311f2c27378a357f9f4d2c  test_copy

Same with TLS_TX_ZEROCOPY_RO enabled, received data will be corrupted :

# ./ktls_test -i testfile -p 443 -c cert.pem -k key.pem -o 8 -z
Serving file testfile, will send 32760 bytes (8 - 32768) with SHA1 sum 83fc1e3900cf900025311f2c27378a357f9f4d2c
TLS_TX_ZEROCOPY_RO enabled
sendfile(5, 3, 8, 32760) = 32760

% wget -S -q -O test_zerocopy https://xxxxxx/; shasum test_zerocopy
  HTTP/1.1 200 OK
  Content-Type: application/octet-stream
  Content-Length: 32760
  X-Source-SHA1: 83fc1e3900cf900025311f2c27378a357f9f4d2c
03374f669f98d5f56837660a3817ce1d2a2819f8  test_zerocopy

% diff -U 1 -d <(xxd test_copy) <(xxd test_zerocopy)                             
--- /dev/fd/11	2023-03-03 10:13:26
+++ /dev/fd/12	2023-03-03 10:13:26
@@ -1087,3 +1087,3 @@
 000043e0: 1010 1010 1010 1010 1010 1010 1010 1010  ................
-000043f0: 1010 1010 1010 1010 1111 1111 1111 1111  ................
+000043f0: 1010 1010 1010 1010 1010 1010 1010 1010  ................
 00004400: 1111 1111 1111 1111 1111 1111 1111 1111  ................
@@ -1151,3 +1151,3 @@
 000047e0: 1111 1111 1111 1111 1111 1111 1111 1111  ................
-000047f0: 1111 1111 1111 1111 1212 1212 1212 1212  ................
+000047f0: 1111 1111 1111 1111 1111 1111 1111 1111  ................
 00004800: 1212 1212 1212 1212 1212 1212 1212 1212  ................
@@ -1215,3 +1215,3 @@
 00004be0: 1212 1212 1212 1212 1212 1212 1212 1212  ................
-00004bf0: 1212 1212 1212 1212 1313 1313 1313 1313  ................
+00004bf0: 1212 1212 1212 1212 1212 1212 1212 1212  ................
 00004c00: 1313 1313 1313 1313 1313 1313 1313 1313  ................

For context, I noticed this issue trying to serve cached files with nginx. For static files this works fine (sendfile offset is zero at first, then 16k-aligned), but cached files are stored with a ~500 bytes header that is skipped in the sendfile call, triggering this issue.

Best regards

-- 
Adrien Moulin
