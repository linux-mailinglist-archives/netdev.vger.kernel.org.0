Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B531F6CDD
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 19:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFKRgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 13:36:13 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46121 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726277AbgFKRgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 13:36:12 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with SMTP; 11 Jun 2020 20:36:09 +0300
Received: from mtr-vdi-191.wap.labs.mlnx. (mtr-vdi-191.wap.labs.mlnx [10.209.100.28])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 05BHa9Yf013972;
        Thu, 11 Jun 2020 20:36:09 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH iproute2] ip address: Fix loop initial declarations are only allowed in C99
Date:   Thu, 11 Jun 2020 20:35:43 +0300
Message-Id: <20200611173543.42371-1-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some distros, i.e. rhel 7.6, compilation fails with the following:

ipaddress.c: In function ‘lookup_flag_data_by_name’:
ipaddress.c:1260:2: error: ‘for’ loop initial declarations are only allowed in C99 mode
  for (int i = 0; i < ARRAY_SIZE(ifa_flag_data); ++i) {
  ^
ipaddress.c:1260:2: note: use option -std=c99 or -std=gnu99 to compile your code

This commit fixes the single place needed for compilation to pass.

Fixes: 9d59c86e575b ("iproute2: ip addr: Organize flag properties structurally")
Signed-off-by: Roi Dayan <roid@mellanox.com>
---
 ip/ipaddress.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 3b53933f4167..f97eaff3dbbf 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -1257,7 +1257,9 @@ static const struct ifa_flag_data_t {
 
 /* Returns a pointer to the data structure for a particular interface flag, or null if no flag could be found */
 static const struct ifa_flag_data_t* lookup_flag_data_by_name(const char* flag_name) {
-	for (int i = 0; i < ARRAY_SIZE(ifa_flag_data); ++i) {
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(ifa_flag_data); ++i) {
 		if (strcmp(flag_name, ifa_flag_data[i].name) == 0)
 			return &ifa_flag_data[i];
 	}
-- 
2.8.4

