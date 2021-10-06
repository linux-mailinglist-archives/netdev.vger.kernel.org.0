Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155EB423D38
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbhJFLt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238117AbhJFLtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:49:52 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6562C061749;
        Wed,  6 Oct 2021 04:47:59 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x7so8735714edd.6;
        Wed, 06 Oct 2021 04:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nhBac9ySmVQ5ir83z9Tad+wE2IbxDFGBb95nCedyfbc=;
        b=ai3V7nk4kDPh3m42WXc2Bnc0Ujz1eqivV3xMn88FKHju/se7c8psloCp9JI6CCnuwd
         IeKJ5NYdWcniRjfiiDEl9plJ07z95XJ5bB2MUyYZQS1S6MEwBYv8NGb1yGVYTCoOkkUs
         uzdX8wh+bzoiMxyG+ZQW28AtacxFWNqVUgZbtO9djd6HWbAkBLEazhIVSjmLzBVj+gTd
         Dwi6WbHwHH71IaebTPFet+eoT1RHCrxPQDNMSYvRgVn4PN0rRFwy8HkAtqmMAheoeDSy
         IqpeSumzDobbpqf9gegyvOu3RULolTNCSsESODMMd93eBIx+m3zeKdh7bZPuy2w/L2Ty
         zhEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nhBac9ySmVQ5ir83z9Tad+wE2IbxDFGBb95nCedyfbc=;
        b=iU+3j4IMzmgX7swokpHryiwTHUe/pwFhcWFaQKyccGNXsuCzWOw0Jj04yjeiyJtcc7
         HLoJeKg5khB6Wem75foNdUI0TnrYkSMLqKJJsHODn+v1//q2QgmqaGdyIeJWQKfFnchS
         yvAbCIXzo/qat5zRCkUpoXSIwwlGPm67GWcqo3TAfYhQul5CT/jHpzxWPAdN3+eYkZnB
         NEUkGIS5oIJfqCAUKD7LiR6nBW0v4wzlctIpX3ajVTMJrvst1AsPLHLBFUYzDoDXxvro
         alpiwAOS3cVhcsGuN067ycEILAi15gki73EDZ6LO+BGmRxjkENNGhTIGi42KoVI+MQ5D
         TqLw==
X-Gm-Message-State: AOAM532X8XxC/d19xgL9hysOVBHzwDhOq5JMGPYTDWT/8KcOQUObhfY5
        gIRiil9z85werrLaJ/yY7bs=
X-Google-Smtp-Source: ABdhPJwT7h8oyRpS0oK1rMDQvUm3a0FHWs1by1mkvq4CPDppdbl2/s5mPc9MGtGXBnQ7RdIEUL3fLQ==
X-Received: by 2002:a50:da48:: with SMTP id a8mr33312528edk.146.1633520877446;
        Wed, 06 Oct 2021 04:47:57 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:47:57 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/11] selftests: net/fcnal: kill_procs via spin instead of sleep
Date:   Wed,  6 Oct 2021 14:47:21 +0300
Message-Id: <ff71285715d47b8c9b6bedb3b50700a26bc81f41.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633520807.git.cdleonard@gmail.com>
References: <cover.1633520807.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sleeping for one second after a kill is not necessary and adds up quite
quickly. Replace with a fast loop spinning until pidof returns nothing.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 0bd60cd3bc06..b7fda51deb3f 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -176,12 +176,19 @@ show_hint()
 	fi
 }
 
 kill_procs()
 {
-	killall nettest ping ping6 >/dev/null 2>&1
-	sleep 1
+	local pids
+	while true; do
+		pids=$(pidof nettest ping ping6)
+		if [[ -z $pids ]]; then
+			break
+		fi
+		kill $pids
+		sleep 0.01
+	done
 }
 
 do_run_cmd()
 {
 	local cmd="$*"
-- 
2.25.1

