Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE89481B88
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 11:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbhL3Kz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 05:55:56 -0500
Received: from m12-17.163.com ([220.181.12.17]:34760 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235617AbhL3Kz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 05:55:56 -0500
X-Greylist: delayed 912 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 05:55:55 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:From:Subject; bh=1Tko/
        f1eUzxJY4rYpd6U0/jOTngytUzstrkVlw497eQ=; b=IUuthj/WLymVS7YHQ+VYZ
        N9oa6F58QvgP2rlnWy1TJrIeJoHR1ClP9tOqylb459KWnvyq1t5mBb+qjRO1nkrd
        QcbDwXNO12QN3i2c22gZTrSaryh7fIjJ3UYlYUlwOnlMhDiPuByjbkdlGlrQPhQy
        VpbG10Mu1T4iFZnHX8Wpbw=
Received: from [192.168.16.100] (unknown [110.80.1.43])
        by smtp13 (Coremail) with SMTP id EcCowABnYT+bjM1hPNIeFQ--.2705S2;
        Thu, 30 Dec 2021 18:40:28 +0800 (CST)
Message-ID: <61d2d31c-ac20-287d-a931-44356f7cc370@163.com>
Date:   Thu, 30 Dec 2021 18:40:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH] selftests: net: using ping6 for IPv6 in udpgro_fwd.sh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: EcCowABnYT+bjM1hPNIeFQ--.2705S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KFWfAr4kXw47Cr4UGw4fuFg_yoW8Jw4Dpr
        W8C3yYvrW0qF1fJr1rW3WjgFZYgaykXa1FkF1vgF1UZa45XFyxArW0gr17AFy7urWvyws8
        AFyIg3WUuF48GaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UN_-QUUUUU=
X-Originating-IP: [110.80.1.43]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/1tbiRA15kFSIjpVydAAAsh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

udpgro_fwd.sh output following message:
  ping: 2001:db8:1::100: Address family for hostname not supported

Using ping6 when pinging IPv6 addresses.

Fixes: a062260a9d5f ("selftests: net: add UDP GRO forwarding self-tests")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 tools/testing/selftests/net/udpgro_fwd.sh | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 6a3985b..5fdb505f 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -185,6 +185,7 @@ for family in 4 6; do
 	IPT=iptables
 	SUFFIX=24
 	VXDEV=vxlan
+	PING=ping

 	if [ $family = 6 ]; then
 		BM_NET=$BM_NET_V6
@@ -192,6 +193,7 @@ for family in 4 6; do
 		SUFFIX="64 nodad"
 		VXDEV=vxlan6
 		IPT=ip6tables
+		PING="ping6"
 	fi

 	echo "IPv$family"
@@ -237,7 +239,7 @@ for family in 4 6; do

 	# load arp cache before running the test to reduce the amount of
 	# stray traffic on top of the UDP tunnel
-	ip netns exec $NS_SRC ping -q -c 1 $OL_NET$DST_NAT >/dev/null
+	ip netns exec $NS_SRC $PING -q -c 1 $OL_NET$DST_NAT >/dev/null
 	run_test "GRO fwd over UDP tunnel" $OL_NET$DST_NAT 1 1 $OL_NET$DST
 	cleanup

-- 
1.8.3.1

