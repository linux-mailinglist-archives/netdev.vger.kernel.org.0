Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04BE51711B4
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgB0Hu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:26 -0500
Received: from mail-wm1-f53.google.com ([209.85.128.53]:52113 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbgB0Hu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:26 -0500
Received: by mail-wm1-f53.google.com with SMTP id t23so2341452wmi.1
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Nm8WSZ0LrdE+Nf+i4dbseDH+2r4z852D0MwCkbjg4PM=;
        b=t3Xj1umIF3DGHw7NvUa5m5eOlehgDOjBnMsJivjvXg7R1O6RaWcT3YR8d0rHjgmqp6
         tVkIrlkwIyT1HLxZFVRbd9QcDMs9CKGX/bSKCm45OqgjjKNbL+YCsznJ87U/h80vXNky
         Mr3xrrEI7bltLBeRSelkMNPCGIBh9CrJed57MhPYm1Ehr7xHNpMUs83LeUWJYQ0bVF1T
         tIXxSuvJXoqLW2kftJPCb+HXWo4dsSfSsVr7BY2yaxwXEbsjZSLAsLfz/6tUc081UjSp
         qIwT/DuVqNmSCaXNlcV9VvLMmYW5EGrbJqWHBHDInJyt37/sQhFnsamN5OASETUZ6dW7
         QIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Nm8WSZ0LrdE+Nf+i4dbseDH+2r4z852D0MwCkbjg4PM=;
        b=oZdvoXFiE6r1EENylKgmNP41xCAp5EFi1F1ikLqmi1nDPJEcFHs45N3jvqOf9eW5bu
         vwhn4Z4U1nFOL2xDiiMwAbqdjjegaMX4jdu1WBBYtvJu7EMQvaWB5CODy38XnKhFMvOg
         pRAs3nZ+GwrKG61PyAhoV/AzRH/Y+wTSY0pOAQxhIHbj9uDo8BblIm1y+6x1OUgDOFbi
         Py4759WrMC7xzzz0xgrHgXYK/j5CAObU1mn7Vx0Mzs32gk+jcw1uJPOroYllPhoShzr8
         vypbfL+BZNOv6AEiW23wVpypXzMvH+pPH2Vx3y6vTw6YJ7pRwhMs3WqdAoM6VnACFH1d
         2iYQ==
X-Gm-Message-State: APjAAAUlLkieeUMTcJG/AgZ7i4VPZ14B6nhJ4Q6tts7szV/yE4hU3nrx
        Ro62otoOqaopM+OQRVw4ZwbMyg23m7s=
X-Google-Smtp-Source: APXvYqyjOLr/8+4A7cyZCqJmrBkcO147y7/szUs+kRUpevFjEWK5ZWjsEVY3UB8cbh/aUHuAk9Q8cw==
X-Received: by 2002:a1c:3803:: with SMTP id f3mr3714008wma.134.1582789823872;
        Wed, 26 Feb 2020 23:50:23 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id i2sm6391874wmb.28.2020.02.26.23.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:23 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 01/16] selftests: forwarding: lib.sh: Add start_tcp_traffic
Date:   Thu, 27 Feb 2020 08:50:06 +0100
Message-Id: <20200227075021.3472-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

Extract a helper __start_traffic() configurable by protocol type. Allow
passing through extra mausezahn arguments. Add a wrapper,
start_tcp_traffic().

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 tools/testing/selftests/net/forwarding/lib.sh | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/lib.sh b/tools/testing/selftests/net/forwarding/lib.sh
index 2f5da414aaa7..f80f384978ce 100644
--- a/tools/testing/selftests/net/forwarding/lib.sh
+++ b/tools/testing/selftests/net/forwarding/lib.sh
@@ -1132,18 +1132,29 @@ flood_test()
 	flood_multicast_test $br_port $host1_if $host2_if
 }
 
-start_traffic()
+__start_traffic()
 {
+	local proto=$1; shift
 	local h_in=$1; shift    # Where the traffic egresses the host
 	local sip=$1; shift
 	local dip=$1; shift
 	local dmac=$1; shift
 
 	$MZ $h_in -p 8000 -A $sip -B $dip -c 0 \
-		-a own -b $dmac -t udp -q &
+		-a own -b $dmac -t "$proto" -q "$@" &
 	sleep 1
 }
 
+start_traffic()
+{
+	__start_traffic udp "$@"
+}
+
+start_tcp_traffic()
+{
+	__start_traffic tcp "$@"
+}
+
 stop_traffic()
 {
 	# Suppress noise from killing mausezahn.
-- 
2.21.1

