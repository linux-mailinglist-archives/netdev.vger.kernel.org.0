Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB645482161
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 03:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237525AbhLaCB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 21:01:27 -0500
Received: from m12-15.163.com ([220.181.12.15]:4472 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhLaCB0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 21:01:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:From:Subject; bh=KCebF
        ao3q610ZuO1duvuoDynHTEv5kKdcS7T/o08FQg=; b=YHr1Bkuu+3D8c7t8+xbJh
        pMUS1FKPH+n+rYVQ+p0AKiIKKeowvofQ6B3Yln7M4KDWn+B2aRG27ExgdL9c5Zdh
        fIc862rWOBSeEZ/NYlROLGw3zvp6Sg7VZtOVs1UcY/pwuQ5HZQo1j5j2q1R+MNlG
        ikBdohr/AWJBX18+GgSkxk=
Received: from [192.168.16.100] (unknown [110.86.5.91])
        by smtp11 (Coremail) with SMTP id D8CowACnHmNjZM5hUO57Dw--.8S2;
        Fri, 31 Dec 2021 10:01:11 +0800 (CST)
Message-ID: <825ee22b-4245-dbf7-d2f7-a230770d6e21@163.com>
Date:   Fri, 31 Dec 2021 10:01:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH] selftests: net: udpgro_fwd.sh: explicitly checking the
 available ping feature
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: D8CowACnHmNjZM5hUO57Dw--.8S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruw4rCryruF1rXFyUtFW8Zwb_yoWDJwbEqr
        sFgwn3Wr45ArW2yw4xKr1Y9r9aka15C397Jw4xXw1avryUAa17WFWktF17AF43W398K34a
        vFsYvF13C3yjvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8HGQ3UUUUU==
X-Originating-IP: [110.86.5.91]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/xtbB9w96kF2Mbnf80AACs0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

As Paolo pointed out, the result of ping IPv6 address depends on
the running distro. So explicitly checking the available ping feature,
as e.g. do the bareudp.sh self-tests.

Fixes: 8b3170e07539 ("selftests: net: using ping6 for IPv6 in udpgro_fwd.sh")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 tools/testing/selftests/net/udpgro_fwd.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 3ea7301..6f05e06 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -193,7 +193,8 @@ for family in 4 6; do
 		SUFFIX="64 nodad"
 		VXDEV=vxlan6
 		IPT=ip6tables
-		PING="ping6"
+		# Use ping6 on systems where ping doesn't handle IPv6
+		ping -w 1 -c 1 ::1 > /dev/null 2>&1 || PING="ping6"
 	fi

 	echo "IPv$family"
-- 
1.8.3.1

