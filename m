Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE256D918E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbjDFI3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbjDFI3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:29:53 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2933261A5
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:29:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so39981795pjb.0
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 01:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680769792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GQalQSWa0eXFPsQXpx3UaGMs4Nz6XsKzV1uauOd1u0=;
        b=o15vK9kSCE4mZvhiysH38WGnYRpK4aG9oif8BcQlq+RDjjY0juSFyQ4xgDROi8HCVo
         FqVlolJhMV9y7mxBIpE7Kginv3BcJObN+2CASrC7FQHT4LcjGnMp9WcDL5dMxt1Tg3fh
         fMRo3AQbMKipswdpj5eKlrTfKu+BghxvnZHAnSqMv7U1Xy9vwqG0Xi2NMB5uYn1BARIy
         0nVmJOGnhMe4KEJ0T4NTBbml8vcZ/q/gyGjfyQ0cSeO3OuNfzag6tWUnXwmDq/CxMRCl
         L/Ce0dC/r5DrLaT/b5grhr5VN+uLdxmH9jwX9OekJgczBL6+psGNNcBbwON5u3OKx3Yr
         518g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680769792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6GQalQSWa0eXFPsQXpx3UaGMs4Nz6XsKzV1uauOd1u0=;
        b=AP6aTl9gCeGc8LiH+mdEWQ3z09u2lbC6JM+o0hSw9UMD4NtwYCv+f46lE//e8kdqNy
         ryQQUI88P+jersa397I4rKnrazwqEd0TgFHqn+pW0TvvSFJ60ym5y/FGlRgYNEAowZ7G
         wsXinUakoPJH4bioxcnNawDnplsv0vEPdjTIQPf4LQuPTmQ+cNri49/JWvSgbup+5l+c
         Wfr4eNFahg+1LukiurB1C8Y6XHhxgd1Udew5vCbyHyd2MBcLAWSlcHZbtXtPOKrUcARx
         htnjcYu/pTmtxOKYP7L6qOBC3Y74ZNH+UWDDXnl3ClMhFLiG19D89HVvw9w2aUqYZzXp
         5NKw==
X-Gm-Message-State: AAQBX9fSP+Fa2p8JzwJIhDOKhS301tcfkrzgJWBrHKBo3JR0YvLvO54S
        PtWLlBp592KJHOc5df6Jm4s+s4thRk9bVg==
X-Google-Smtp-Source: AKy350byFecMUSYvBKH3N00IuWtfoVCpL5o++EiLaPHIqN5wIAaN6O9y+FD/PUmtd+A/0A9BiaW5fw==
X-Received: by 2002:a17:90b:1d10:b0:23c:feb9:2cea with SMTP id on16-20020a17090b1d1000b0023cfeb92ceamr10022281pjb.42.1680769791953;
        Thu, 06 Apr 2023 01:29:51 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([2409:8a02:782e:a1c0:2082:5d32:9dce:4c17])
        by smtp.gmail.com with ESMTPSA id on13-20020a17090b1d0d00b0023493354f37sm2644433pjb.26.2023.04.06.01.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:29:51 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCHv2 net 3/3] selftests: bonding: add arp validate test
Date:   Thu,  6 Apr 2023 16:23:52 +0800
Message-Id: <20230406082352.986477-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230406082352.986477-1-liuhangbin@gmail.com>
References: <20230406082352.986477-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add bonding arp validate tests with mode active backup,
monitor arp_ip_target and ns_ip6_target. It also checks mii_status
to make sure all slaves are UP.

Acked-by: Jonathan Toppins <jtoppins@redhat.com>
Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
v2: no update
---
 .../drivers/net/bonding/bond_options.sh       | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond_options.sh b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
index 7213211d0bde..db29a3146a86 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond_options.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
@@ -5,6 +5,7 @@
 
 ALL_TESTS="
 	prio
+	arp_validate
 "
 
 REQUIRE_MZ=no
@@ -200,6 +201,60 @@ prio()
 	done
 }
 
+arp_validate_test()
+{
+	local param="$1"
+	RET=0
+
+	# create bond
+	bond_reset "${param}"
+
+	bond_check_connection
+	[ $RET -ne 0 ] && log_test "arp_validate" "$retmsg"
+
+	# wait for a while to make sure the mii status stable
+	sleep 5
+	for i in $(seq 0 2); do
+		mii_status=$(cmd_jq "ip -n ${s_ns} -j -d link show eth$i" ".[].linkinfo.info_slave_data.mii_status")
+		if [ ${mii_status} != "UP" ]; then
+			RET=1
+			log_test "arp_validate" "interface eth$i mii_status $mii_status"
+		fi
+	done
+}
+
+arp_validate_arp()
+{
+	local mode=$1
+	local val
+	for val in $(seq 0 6); do
+		arp_validate_test "mode $mode arp_interval 100 arp_ip_target ${g_ip4} arp_validate $val"
+		log_test "arp_validate" "$mode arp_ip_target arp_validate $val"
+	done
+}
+
+arp_validate_ns()
+{
+	local mode=$1
+	local val
+
+	if skip_ns; then
+		log_test_skip "arp_validate ns" "Current iproute or kernel doesn't support bond option 'ns_ip6_target'."
+		return 0
+	fi
+
+	for val in $(seq 0 6); do
+		arp_validate_test "mode $mode arp_interval 100 ns_ip6_target ${g_ip6} arp_validate $val"
+		log_test "arp_validate" "$mode ns_ip6_target arp_validate $val"
+	done
+}
+
+arp_validate()
+{
+	arp_validate_arp "active-backup"
+	arp_validate_ns "active-backup"
+}
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.38.1

