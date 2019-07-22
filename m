Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 871D3702E8
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 17:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbfGVPAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 11:00:41 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:39053 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfGVPAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 11:00:41 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mn2Jj-1iF2Sg2Z0h-00k8ux; Mon, 22 Jul 2019 17:00:21 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kangjie Lu <kjlu@umn.edu>, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] ovs: datapath: hide clang frame-overflow warnings
Date:   Mon, 22 Jul 2019 17:00:01 +0200
Message-Id: <20190722150018.1156794-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:n38BZKXQeU4NCOj2u3jNETtHaDR3crTUgKISheti+Q/vGZ4iOf9
 CEdgitQaFx19lylhbtU4GNob2+pIJoGxqHzfM/c0Y510k2PvKqagKwo4wxgp/wFzvEnZRAr
 2qeqnFJWkAh9FMW6vYDyHXBJNcfl7PNO94jSWeEaAbMwbH+nN2KT/eYVXpX++zZrxMCIB6M
 51tSASVvAUVMs9JjoCWzg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:BIxhja8daZY=:a3r2BQT8oflr6GgXt6Jes2
 W45PjZlPErn72wTTrP4kq3o2NkWZx3eYlFz/FqMAlX1sEvyBzuIWG6sZ7I79ivukuKeDqt1Av
 A86XaIJYB7L31S6LtCZVKbtFdi+PWSoyH+ZESd5Kmr5XYPBynuYAZM6xraW/LYqJvNtLWtwmg
 Rc6jbSFKK0dGq0cFDK+ep7eUzrdRSTiHNhhDXzYH+CEnRxxgAlEgV9rCUFXjNVuyjTkkVSheg
 c4/INjS1MBkLRutGKrPt0lAIqjUpMAQCk4Dpr0IGcCkEEQ7+JXlJanSpGiADdniVWM1NgEMrG
 xLvDGBpVJO8TSRVS0O5bZTeB+WmDYauLUKaLYh6S7IYg/xrdb/bLOdkdohsQA/yFc7iiQv2HO
 abpRQTVBawt6wp0uxxFjSmmUGwrQxeQ2QMg8SDDnZ1QbVLTavQTztwWawywRiwf20XEHNMIdv
 2qLG6QrhmQ+XgbY1UZqgxWznoLOe4dIeRglEJcXBTWj0nU310DWAcsSGhIJZlUlmYBohJGer0
 HGRB8KD5gKnJEp0DAwUs0LmcD8SbfoKlWCswinBVQEUE3Fa81aVAaRY/r4BY62EG6zARO5OCO
 U90PkOFax25c9cZ6DjGbqVbx86vJRLD2r8Rpr0XyDwUHkD8UJzW1m5iBu5Xjb4VwrMsfH8Z7i
 M23qg4QUtWCPXitysMNbfZJV1LcBQ1s/KvA7UYDFJLxRZTEawnf+640BFZ59wprwt8OcDiKre
 Qj6/B5iDFVB8GZdhrAtwY8eWJWrJG2Qxng66jw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some functions in the datapath code are factored out so that each
one has a stack frame smaller than 1024 bytes with gcc. However,
when compiling with clang, the functions are inlined more aggressively
and combined again so we get

net/openvswitch/datapath.c:1124:12: error: stack frame size of 1528 bytes in function 'ovs_flow_cmd_set' [-Werror,-Wframe-larger-than=]

Marking both get_flow_actions() and ovs_nla_init_match_and_action()
as 'noinline_for_stack' gives us the same behavior that we see with
gcc, and no warning. Note that this does not mean we actually use
less stack, as the functions call each other, and we still get
three copies of the large 'struct sw_flow_key' type on the stack.

The comment tells us that this was previously considered safe,
presumably since the netlink parsing functions are called with
a known backchain that does not also use a lot of stack space.

Fixes: 9cc9a5cb176c ("datapath: Avoid using stack larger than 1024.")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/openvswitch/datapath.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 892287d06c17..d01410e52097 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1047,7 +1047,7 @@ static int ovs_flow_cmd_new(struct sk_buff *skb, struct genl_info *info)
 }
 
 /* Factor out action copy to avoid "Wframe-larger-than=1024" warning. */
-static struct sw_flow_actions *get_flow_actions(struct net *net,
+static noinline_for_stack struct sw_flow_actions *get_flow_actions(struct net *net,
 						const struct nlattr *a,
 						const struct sw_flow_key *key,
 						const struct sw_flow_mask *mask,
@@ -1081,12 +1081,13 @@ static struct sw_flow_actions *get_flow_actions(struct net *net,
  * we should not to return match object with dangling reference
  * to mask.
  * */
-static int ovs_nla_init_match_and_action(struct net *net,
-					 struct sw_flow_match *match,
-					 struct sw_flow_key *key,
-					 struct nlattr **a,
-					 struct sw_flow_actions **acts,
-					 bool log)
+static noinline_for_stack int
+ovs_nla_init_match_and_action(struct net *net,
+			      struct sw_flow_match *match,
+			      struct sw_flow_key *key,
+			      struct nlattr **a,
+			      struct sw_flow_actions **acts,
+			      bool log)
 {
 	struct sw_flow_mask mask;
 	int error = 0;
-- 
2.20.0

