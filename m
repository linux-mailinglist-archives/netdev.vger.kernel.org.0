Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649C2482158
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 02:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240980AbhLaB4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 20:56:42 -0500
Received: from m12-15.163.com ([220.181.12.15]:64419 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhLaB4m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 20:56:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:From:Subject; bh=+oBA6
        4dW1q+d2nuT5RDIJI1X5ppJGmUcaIgwmPZugSs=; b=MRSTgV9mOiWWZfQPZ+oRw
        SN/WeUHdyfk9qxBLmbEM6/2IZsOQraR9o97qxlVOk7B/Sl/KTCOYJl1cu8gkPHlW
        nlLuuLvwTyNbdKIxmUNqyxsUI7G5q6clO2G1pmD930W5ug9IfP3mGbb5IZfPhH04
        oo9MCGmXCcmxnUOv8c/kXI=
Received: from [192.168.16.100] (unknown [110.80.1.43])
        by smtp11 (Coremail) with SMTP id D8CowABXXFFnWM5hRvh2Dw--.78S2;
        Fri, 31 Dec 2021 09:10:02 +0800 (CST)
Message-ID: <a2295ebf-0734-a480-e908-caf5c02cb6a9@163.com>
Date:   Fri, 31 Dec 2021 09:10:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH v2] selftests: net: udpgro_fwd.sh: Use ping6 on systems where
 ping doesn't handle IPv6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: D8CowABXXFFnWM5hRvh2Dw--.78S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Ww17KrW8Aw4kXrWfCF4fuFg_yoW8Wr45pr
        W0kw1j9rWFgF1fCw1rCa1Uta95CaykZanYyF1vkryUZa45GFyxJrW0gry7AF17urWvv3Z0
        vFyIga47Zan5Ja7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jotCwUUUUU=
X-Originating-IP: [110.80.1.43]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/xtbBLQp6kFziZ5j7eQAAsO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

In CentOS7(iputils-20160308-10.el7.x86_64), udpgro_fwd.sh output
following message:
  ping: 2001:db8:1::100: Address family for hostname not supported

Use ping6 on systems where ping doesn't handle IPv6.

v1 -> v2:
 - explicitly checking the available ping feature, as e.g. do the
   bareudp.sh self-tests.(Paolo)

Fixes: a062260a9d5f ("selftests: net: add UDP GRO forwarding self-tests")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 tools/testing/selftests/net/udpgro_fwd.sh | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 6a3985b..6f05e06 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -185,6 +185,7 @@ for family in 4 6; do
 	IPT=iptables
 	SUFFIX=24
 	VXDEV=vxlan
+	PING=ping

 	if [ $family = 6 ]; then
 		BM_NET=$BM_NET_V6
@@ -192,6 +193,8 @@ for family in 4 6; do
 		SUFFIX="64 nodad"
 		VXDEV=vxlan6
 		IPT=ip6tables
+		# Use ping6 on systems where ping doesn't handle IPv6
+		ping -w 1 -c 1 ::1 > /dev/null 2>&1 || PING="ping6"
 	fi

 	echo "IPv$family"
@@ -237,7 +240,7 @@ for family in 4 6; do

 	# load arp cache before running the test to reduce the amount of
 	# stray traffic on top of the UDP tunnel
-	ip netns exec $NS_SRC ping -q -c 1 $OL_NET$DST_NAT >/dev/null
+	ip netns exec $NS_SRC $PING -q -c 1 $OL_NET$DST_NAT >/dev/null
 	run_test "GRO fwd over UDP tunnel" $OL_NET$DST_NAT 1 1 $OL_NET$DST
 	cleanup

-- 
1.8.3.1

