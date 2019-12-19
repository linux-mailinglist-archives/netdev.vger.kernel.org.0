Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6302B12646E
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 15:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfLSOSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 09:18:49 -0500
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:33591 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726695AbfLSOSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 09:18:49 -0500
Received: from fern.phenome.org ([83.163.117.153])
        by smtp-cloud9.xs4all.net with ESMTPA
        id hwdZiIDvHGyJwhwdaiGaf8; Thu, 19 Dec 2019 15:18:47 +0100
From:   Antony Antony <antony@phenome.org>
To:     netdev@vger.kernel.org
Cc:     Antony Antony <antony@phenome.org>, Matt Ellison <matt@arroyo.io>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH] ip: xfrm if_id -ve value is error
Date:   Thu, 19 Dec 2019 15:18:03 +0100
Message-Id: <20191219141803.3453-1-antony@phenome.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfFTxRcbS5EZxZmIBvpe7aAD/n1oMuazy70MuvPW4DZgS+3qwOYBCeZnbTPlC+t7EqZFadJg8mzWvIT7B+HAGuuhhD+rJMHvl4cJXzbh+eo9uYCIjyq1s
 NO8CKTYNaacY+IHkiIhzykiMnGxDZ9wAAiV5D6w0yZNvt/8MibOZ0uC8gaUp+HNPzNYEE2Qs6gnZ9G/UWTBkMbE1mAtxSwhjow/iVwjNulBH4t3JhJMbUKK5
 PCHPekt7lNqFCtPNxC56Hyvi54c9SR3eKxuaeEnVmKk=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if_id is u32, error on -ve values instead of setting to 0

after :
 ip link add ipsec1 type xfrm dev lo if_id -10
 Error: argument "-10" is wrong: if_id value is invalid

before : note xfrm if_id 0
 ip link add ipsec1 type xfrm dev lo if_id -10
 ip -d  link show dev ipsec1
 9: ipsec1@lo: <NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/none 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 1500
    xfrm if_id 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

Fixes: 286446c1e8c ("ip: support for xfrm interfaces")

Signed-off-by: Antony Antony <antony@phenome.org>
---
 ip/link_xfrm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/ip/link_xfrm.c b/ip/link_xfrm.c
index a28f308d..7dbfb13f 100644
--- a/ip/link_xfrm.c
+++ b/ip/link_xfrm.c
@@ -37,7 +37,9 @@ static int xfrm_parse_opt(struct link_util *lu, int argc, char **argv,
 				exit(nodev(*argv));
 		} else if (!matches(*argv, "if_id")) {
 			NEXT_ARG();
-			if (!get_u32(&if_id, *argv, 0))
+			if (get_u32(&if_id, *argv, 0))
+				invarg("if_id value is invalid", *argv);
+			else
 				addattr32(n, 1024, IFLA_XFRM_IF_ID, if_id);
 		} else {
 			xfrm_print_help(lu, argc, argv, stderr);
-- 
2.21.0

