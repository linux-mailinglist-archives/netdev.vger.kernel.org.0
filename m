Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF0E3230D
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 13:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfFBLKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 07:10:04 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39871 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbfFBLKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 07:10:04 -0400
Received: by mail-pf1-f193.google.com with SMTP id j2so8900609pfe.6
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 04:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2pFEUYDHFg7rnZ7Z2U7G7gMrGbA4wlTfL08BWYuLPxk=;
        b=bNP4uPhFJdOWRieR9Zg8kqS70nNNkqQOmszWIcY05QrqqQ/xUAf1BCtvN9Q6+SWI3S
         4nfrGupXXQf/8hd9cbpPch9XdoLg1vOB1KrmgTYMa4+/wLSuN8PNjpMaaUvmZp1Kkfsa
         NuS+A9Ax2PmqxmSSpH6r4KY8JtR/20VYBTseoIY/KS5yKTjw6U1Z1fkFpH0Jt7zyTaxi
         D69GWpVr+IeRXUq/2jD9SVZ3zgiTI1Npi70CAGysv7y+z6//kLnZJM03UPPAUn+iei02
         GHN6Kvu3MpvQGJKgBAkIGWC14iea4o6/B+givZcTSBjsTfyWuy/YXFVPDBScuVt/WM0Z
         Z5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2pFEUYDHFg7rnZ7Z2U7G7gMrGbA4wlTfL08BWYuLPxk=;
        b=phpWnlpqsd3XprFXHrgKeTIQauw7IMFbpiGn+JD7Cgee/B2+LIBoqO0F/ddjm44dPX
         sda0dvhNX2setGeMBrfJK+Qqdq+R5ro/L3IvUd8wN6JVN/dkvMGeE2N6rYb2ypuVWM7A
         8RkCYnI0LtiYlsG+8BiIR6r5S1HJKPRMIOd4AfcWizeliKt1cnWUPWbHDfgyo/8SGhTv
         WwbVxkFBuip7Ya4Jbo6s6Vm1BIM0ZjjCl7oC/ah/fQZXm0A+yieVgRJpE8ejPVfNnkea
         0YrEkiQ2DkzVXQ3wVLY9LGWGI9QYh7/h2XlBO+T3FwjpiN97kIUiZMGgKe5mrJSy6lb/
         pnjA==
X-Gm-Message-State: APjAAAVEk1hAwQSxodqsGcVXCKsg2CNxlsJ2QSHSZ3Zb+NGr3n0P85Os
        BoGOq4K3by9aEtv2njBzkhci+zdi
X-Google-Smtp-Source: APXvYqynR8YziXxYeKryw1ezASbMVoOUtI/uiS3HvHnpqE26KEoQOFMXzfTXQzysX63K4FRXbJiZgg==
X-Received: by 2002:a17:90a:25af:: with SMTP id k44mr8546921pje.122.1559473803399;
        Sun, 02 Jun 2019 04:10:03 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d6sm12655826pgv.4.2019.06.02.04.10.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 04:10:02 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, David Ahern <dsahern@gmail.com>
Subject: [PATCH net] selftests: set sysctl bc_forwarding properly in router_broadcast.sh
Date:   Sun,  2 Jun 2019 19:09:55 +0800
Message-Id: <e22d53ba6d4dde4de8364f9c903a98061344cbe2.1559473795.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sysctl setting bc_forwarding for $rp2 is needed when ping_test_from h2,
otherwise the bc packets from $rp2 won't be forwarded. This patch is to
add this setting for $rp2.

Also, as ping_test_from does grep "$from" only, which could match some
unexpected output, some test case doesn't really work, like:

  # ping_test_from $h2 198.51.200.255 198.51.200.2
    PING 198.51.200.255 from 198.51.100.2 veth3: 56(84) bytes of data.
    64 bytes from 198.51.100.1: icmp_seq=1 ttl=64 time=0.336 ms

When doing grep $form (198.51.200.2), the output could still match.
So change to grep "bytes from $from" instead.

Fixes: 40f98b9af943 ("selftests: add a selftest for directed broadcast forwarding")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 tools/testing/selftests/net/forwarding/router_broadcast.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/router_broadcast.sh b/tools/testing/selftests/net/forwarding/router_broadcast.sh
index 9a678ec..4eac0a0 100755
--- a/tools/testing/selftests/net/forwarding/router_broadcast.sh
+++ b/tools/testing/selftests/net/forwarding/router_broadcast.sh
@@ -145,16 +145,19 @@ bc_forwarding_disable()
 {
 	sysctl_set net.ipv4.conf.all.bc_forwarding 0
 	sysctl_set net.ipv4.conf.$rp1.bc_forwarding 0
+	sysctl_set net.ipv4.conf.$rp2.bc_forwarding 0
 }
 
 bc_forwarding_enable()
 {
 	sysctl_set net.ipv4.conf.all.bc_forwarding 1
 	sysctl_set net.ipv4.conf.$rp1.bc_forwarding 1
+	sysctl_set net.ipv4.conf.$rp2.bc_forwarding 1
 }
 
 bc_forwarding_restore()
 {
+	sysctl_restore net.ipv4.conf.$rp2.bc_forwarding
 	sysctl_restore net.ipv4.conf.$rp1.bc_forwarding
 	sysctl_restore net.ipv4.conf.all.bc_forwarding
 }
@@ -171,7 +174,7 @@ ping_test_from()
 	log_info "ping $dip, expected reply from $from"
 	ip vrf exec $(master_name_get $oif) \
 		$PING -I $oif $dip -c 10 -i 0.1 -w $PING_TIMEOUT -b 2>&1 \
-		| grep $from &> /dev/null
+		| grep "bytes from $from" > /dev/null
 	check_err_fail $fail $?
 }
 
-- 
2.1.0

