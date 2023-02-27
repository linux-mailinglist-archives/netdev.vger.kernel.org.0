Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57E66A3E82
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 10:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjB0JhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 04:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjB0JhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 04:37:04 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0735CC1E;
        Mon, 27 Feb 2023 01:37:00 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so5594942pjp.2;
        Mon, 27 Feb 2023 01:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vIV5ogbFsguZWx+MjZtbNr7+DuxH9TxT45H3zXtXUWo=;
        b=f6rw5IKGM5R/BzPNQAUbRbpgP6D9kDYrvIrMFHH+mHYONIeebAt/rYmVDB4HklhcN8
         NpjQRwC8AEanKylP/foRjOVGGBV5FbMcdq5JR1AOStEd8UFxQ1wL1/4lLlVSsM1PbQwc
         z35wRZfKmH5L3HOcU8vZB8FFjGq5O3OCjo8gYVYVgM9utyYYx+vQjfg66sugRoHR9Riq
         kbu0AcnW0RJiPR10CqmSLgchpkp474NZyLcev4Cj5OTQsk/0XKcoGyYNgaSj+2ZbM8PI
         XAYLxCp91p7Wwqlu4T2t+kT50a80gO+KqXudZDxeXzPqgvN5QbYKoX/z1JEMJWo5P0di
         14mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vIV5ogbFsguZWx+MjZtbNr7+DuxH9TxT45H3zXtXUWo=;
        b=R7cO54wmJf8TOg2FWOqfHLojRPRLjRJjSwQcFlxkegS5J1K/UT3WqoAoggR75+MO7J
         H+Hkqr6qhHLm7CrGkzigHk/wu18TybKEJrdohNf7tEn22Rg/h2gAzRS7zqD+tC4QMbNS
         m6NgpfIgBRQmVT5JBEcSlE6rBBt5pzJyLAgrVd/bG6K/hs1MWu2b+HuBIVlFWUwP2NpA
         z8IpHjnqCT0+VeJIrh5bOYMRZCDIgYIRDI80pdUOD6oaMmb0JUmjBMxeYJyIzYxe55VG
         DsT5SDmrwzMmGwEbsTnD6n631NeDQIxsFfMquhPjpjasp6vykxxjNoFQCmJftZyRshC8
         ybsQ==
X-Gm-Message-State: AO0yUKUUbPq4Vb3xH+a8UcGIf05g+E40sgjnqNAdyCMckbAn/TdIOIgk
        q6BP2CoHQ0eBbBtitsJajuX6amn2GO5uKsZj
X-Google-Smtp-Source: AK7set+8UqJw9QjcHlTLvZ9nato159x3dZfX5U6lHb3LhGUdoLDcSpErHeTgkpywe6DgJYS8Hek9ig==
X-Received: by 2002:a17:90b:4f87:b0:234:91a2:e07c with SMTP id qe7-20020a17090b4f8700b0023491a2e07cmr25692399pjb.31.1677490619632;
        Mon, 27 Feb 2023 01:36:59 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l190-20020a6388c7000000b00502f4c62fd3sm3690873pgd.33.2023.02.27.01.36.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 01:36:59 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Yi Chen <yiche@redhat.com>, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH nf] selftests: nft_nat: ensuring the listening side is up before starting the client
Date:   Mon, 27 Feb 2023 17:36:46 +0800
Message-Id: <20230227093646.1066666-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test_local_dnat_portonly() function initiates the client-side as
soon as it sets the listening side to the background. This could lead to
a race condition where the server may not be ready to listen. To ensure
that the server-side is up and running before initiating the
client-side, a delay is introduced to the test_local_dnat_portonly()
function.

Before the fix:
  # ./nft_nat.sh
  PASS: netns routing/connectivity: ns0-rthlYrBU can reach ns1-rthlYrBU and ns2-rthlYrBU
  PASS: ping to ns1-rthlYrBU was ip NATted to ns2-rthlYrBU
  PASS: ping to ns1-rthlYrBU OK after ip nat output chain flush
  PASS: ipv6 ping to ns1-rthlYrBU was ip6 NATted to ns2-rthlYrBU
  2023/02/27 04:11:03 socat[6055] E connect(5, AF=2 10.0.1.99:2000, 16): Connection refused
  ERROR: inet port rewrite

After the fix:
  # ./nft_nat.sh
  PASS: netns routing/connectivity: ns0-9sPJV6JJ can reach ns1-9sPJV6JJ and ns2-9sPJV6JJ
  PASS: ping to ns1-9sPJV6JJ was ip NATted to ns2-9sPJV6JJ
  PASS: ping to ns1-9sPJV6JJ OK after ip nat output chain flush
  PASS: ipv6 ping to ns1-9sPJV6JJ was ip6 NATted to ns2-9sPJV6JJ
  PASS: inet port rewrite without l3 address

Fixes: 282e5f8fe907 ("netfilter: nat: really support inet nat without l3 address")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 924ecb3f1f73..dd40d9f6f259 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -404,6 +404,8 @@ EOF
 	echo SERVER-$family | ip netns exec "$ns1" timeout 5 socat -u STDIN TCP-LISTEN:2000 &
 	sc_s=$!
 
+	sleep 1
+
 	result=$(ip netns exec "$ns0" timeout 1 socat TCP:$daddr:2000 STDOUT)
 
 	if [ "$result" = "SERVER-inet" ];then
-- 
2.38.1

