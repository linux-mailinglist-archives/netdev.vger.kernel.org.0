Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 743913A9CE1
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 16:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233581AbhFPOFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 10:05:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41761 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbhFPOFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 10:05:30 -0400
Received: from mail-ed1-f69.google.com ([209.85.208.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <andrea.righi@canonical.com>)
        id 1ltW8a-0007ly-4E
        for netdev@vger.kernel.org; Wed, 16 Jun 2021 14:03:24 +0000
Received: by mail-ed1-f69.google.com with SMTP id j3-20020aa7c3430000b0290393f7aad447so1083968edr.18
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 07:03:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=ulcePntEXh1DjVcMEcGKERN3uSnkzIPzKbXFTzr4xjw=;
        b=FcY/oYf9mVKeHtWPppKqEh3DgBUvShP3UCHEuzJ+bB69ls9ILqUKeU6OZZ1Hw40zZ0
         weNRUtt/x1zcslYFnrGjUOk7F42wXHIoSBi1qw5pUgu/xdz6rHd/dfc0ulGYtirioW3E
         JA3GicETxAJu1LVrP0RKhEWGF9xNdCyeYTSSpv7nJ8jw01ryfEw4dxfqQNxCaBxn0Nn/
         ualYjXJiyH4HioVgsNvxb0TlfAln4fipL1BIZnGgy/jnCDEyNACJlc7AWGBXtSnW3M7p
         4t5NBuJyYOI0R8Cll5LPB0eQYX6/VcBH/mkP+P2FpNt/0zG5zZHe2mgf92EhBS9EdpvN
         feDA==
X-Gm-Message-State: AOAM532GVbLa65XW/zNBoKH3jzJj1eDzef5Z3ppQSZ8OisGxgvbvxA6I
        Mj8YaVAMedbd6T23IOL06TMVB7l5j/DK2zJzGVKHAPPZI+Za/2sjInZ8kUzA2b5A56Kv84ZvbXw
        ITcN/l0UyiR+ibShbstFTGr5QJMVcF8n78A==
X-Received: by 2002:a17:906:d0c9:: with SMTP id bq9mr5443087ejb.313.1623852202722;
        Wed, 16 Jun 2021 07:03:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhX/RfqULeqHuPnnvjuwgwmZQdILELg9ddA5TshSiRZRkWbfA+NJUX+hu9SaXOMBkG/zJ19Q==
X-Received: by 2002:a17:906:d0c9:: with SMTP id bq9mr5443065ejb.313.1623852202511;
        Wed, 16 Jun 2021 07:03:22 -0700 (PDT)
Received: from localhost (host-79-46-128-215.retail.telecomitalia.it. [79.46.128.215])
        by smtp.gmail.com with ESMTPSA id u21sm1604314ejm.89.2021.06.16.07.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 07:03:22 -0700 (PDT)
Date:   Wed, 16 Jun 2021 16:03:21 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: net: veth: make test compatible with dash
Message-ID: <YMoEqdpCIQN209ty@xps-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

veth.sh is a shell script that uses /bin/sh; some distro (Ubuntu for
example) use dash as /bin/sh and in this case the test reports the
following error:

 # ./veth.sh: 21: local: -r: bad variable name
 # ./veth.sh: 21: local: -r: bad variable name

This happens because dash doesn't support the option "-r" with local.

Moreover, in case of missing bpf object, the script is exiting -1, that
is an illegal number for dash:

 exit: Illegal number: -1

Change the script to be compatible both with bash and dash and prevent
the errors above.

Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
---
 tools/testing/selftests/net/veth.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
index 2fedc0781ce8..11d7cdb898c0 100755
--- a/tools/testing/selftests/net/veth.sh
+++ b/tools/testing/selftests/net/veth.sh
@@ -18,7 +18,8 @@ ret=0
 
 cleanup() {
 	local ns
-	local -r jobs="$(jobs -p)"
+	local jobs
+	readonly jobs="$(jobs -p)"
 	[ -n "${jobs}" ] && kill -1 ${jobs} 2>/dev/null
 	rm -f $STATS
 
@@ -108,7 +109,7 @@ chk_gro() {
 
 if [ ! -f ../bpf/xdp_dummy.o ]; then
 	echo "Missing xdp_dummy helper. Build bpf selftest first"
-	exit -1
+	exit 1
 fi
 
 create_ns
-- 
2.31.1

