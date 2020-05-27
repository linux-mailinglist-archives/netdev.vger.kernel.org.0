Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 310011E444D
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 15:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388738AbgE0NsJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 09:48:09 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:51201 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388082AbgE0NsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 09:48:09 -0400
Received: from threadripper.lan ([149.172.98.151]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MP2zs-1jNNUv2gma-00POkx; Wed, 27 May 2020 15:47:57 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@canonical.com>,
        Stephen Worley <sworley@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] [net-next] nexthop: fix enum type confusion
Date:   Wed, 27 May 2020 15:47:41 +0200
Message-Id: <20200527134755.978758-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:n5qEtqFUXXj4zCm5zjHLPSjM3G1b9LQHX2qPlw6UHDY5j+eeoTt
 RZVjMN1E+TihYiBM1VrGlWrZfadBUWmEQXT17oY8cDNC8Z3OsN5DEOo6oYhFHCk5aUlvHCA
 lTkYegq9MeUrQfdhrM59VDRUWQt4AU312DjVElEYJQRTO92fjl88TlwXlru+3qg4u8HRQHY
 4rn1m9//P8Y12puOmtDbg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:0vssRlZ1k7Y=:FW5nQtiKCgGw7l3TtxlrIB
 z5X3TPsAWxaRibqoS8sYLvmBKczlqGl87mf5Nkq17HYkf/Mhx4ZAqdURXaGGTXTN/sJIUmSR0
 YCgCHyvhsUt61uoYNNdFbCIaIePjRjLRdCIZHRK39MygPRYpfss1WqA7MEAQU2oB7ezqDSUIM
 KSX3x5Tu5lIAlFc2LmtETZIj7Evy3HiCopCV8OqC4/H4pAmanHvq4E5QvZUnHnk0GSWocFNkg
 +DdgKLyb+T15WJWzv2Nu5R0UJGxeoHJOh0ZWs6wtkdlclRv6XuFMNLon+ftDfNOMY1mceYD6e
 uDJ7OviiXknDsw/IUMgKslfAM4fsZzCDj37w6/cscxSZeYCgN0+oj1tBRk/UScOV6f6Rfu6F1
 3Disro/0yQVHaJCB3Jf8fnh+ysExvNIheTwDs4QGQ954iNudvOZhMBGea4ohGSzZlpZCyvmOx
 qGaZmPcjxgV8xyxLUtDzZLMxrGOtElQuAOyc2KaS+ERdBoO015hgwxq6b4jnjd9o6B9En4CIk
 JAi35XTkp/Er0PymziPIBnnjymVjsVIoNCcusuf9QvkiSfT5LBKyv7o0wwtMXeL10wvGDJOca
 EmV3X8wL7zrfWnwRweZH79lYMoSY14YNqtGK5vyQSTwV8A4LJm45yHOHaNdi3LpObAOrllgyP
 MfoCP71BGbfwTJDkQdBYs6seNxm8SfSRTrnPtbW0a2ToeCf3jluGn454W2wBHf8b9OWDyQ2y5
 /O4xqMKkwCZTxSpKqTDNVrhaaoXOEzA7B3CQsmoAUSYnZjiKN6LEOw3CACu19ODaNmri8qtf/
 MgyKMgMwFo4ffznhqfLBTJhEEfGBF1EIOfIasw7KYYUz1ed01A=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang points out a mismatch between function arguments
using a different enum type:

net/ipv4/nexthop.c:841:30: error: implicit conversion from enumeration type 'enum nexthop_event_type' to different enumeration type 'enum fib_event_type' [-Werror,-Wenum-conversion]
        call_nexthop_notifiers(net, NEXTHOP_EVENT_DEL, nh);
        ~~~~~~~~~~~~~~~~~~~~~~      ^~~~~~~~~~~~~~~~~

This looks like a copy-paste error, so just use the intended
type instead.

Fixes: 8590ceedb701 ("nexthop: add support for notifiers")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 143011f9b580..ec1282858cb7 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -37,7 +37,7 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
 };
 
 static int call_nexthop_notifiers(struct net *net,
-				  enum fib_event_type event_type,
+				  enum nexthop_event_type event_type,
 				  struct nexthop *nh)
 {
 	int err;
-- 
2.26.2

