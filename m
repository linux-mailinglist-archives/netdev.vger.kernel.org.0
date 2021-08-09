Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF69F3E4A75
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbhHIRE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:04:26 -0400
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:49616 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229877AbhHIREY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 13:04:24 -0400
Received: from omf20.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id DC724180A68C0;
        Mon,  9 Aug 2021 17:04:02 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf20.hostedemail.com (Postfix) with ESMTPA id 11EC518A616;
        Mon,  9 Aug 2021 17:04:01 +0000 (UTC)
Message-ID: <1f99c69f4e640accaf7459065e6625e73ec0f8d4.camel@perches.com>
Subject: [PATCH] netlink: NL_SET_ERR_MSG - remove local static array
From:   Joe Perches <joe@perches.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Mon, 09 Aug 2021 10:04:00 -0700
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 11EC518A616
X-Spam-Status: No, score=-0.97
X-Stat-Signature: 1joi1f56hq7xsayp5qa835uknjh8widb
X-Rspamd-Server: rspamout02
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX191vkcQB2Zva/2bFrMkOeuGf5dbTCrBcK4=
X-HE-Tag: 1628528641-360961
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The want was to have some separate object section for netlink messages
so all netlink messages could be specifically listed by some tool but
the effect is duplicating static const char arrays in the object code.

It seems unused presently so change the macro to avoid the local static
declarations until such time as these actually are wanted and used.

This reduces object size ~8KB in an x86-64 defconfig without modules.

$ size vmlinux.o*
   text	   data	    bss	    dec	    hex	filename
20110471	3460344	 741760	24312575	172faff	vmlinux.o.new
20119444	3460344	 741760	24321548	1731e0c	vmlinux.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/netlink.h | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 61b1c7fcc401e..4bb32ae134aa8 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -89,13 +89,12 @@ struct netlink_ext_ack {
  * to the lack of an output buffer.)
  */
 #define NL_SET_ERR_MSG(extack, msg) do {		\
-	static const char __msg[] = msg;		\
 	struct netlink_ext_ack *__extack = (extack);	\
 							\
-	do_trace_netlink_extack(__msg);			\
+	do_trace_netlink_extack(msg);			\
 							\
 	if (__extack)					\
-		__extack->_msg = __msg;			\
+		__extack->_msg = msg;			\
 } while (0)
 
 #define NL_SET_ERR_MSG_MOD(extack, msg)			\
@@ -111,13 +110,12 @@ struct netlink_ext_ack {
 #define NL_SET_BAD_ATTR(extack, attr) NL_SET_BAD_ATTR_POLICY(extack, attr, NULL)
 
 #define NL_SET_ERR_MSG_ATTR_POL(extack, attr, pol, msg) do {	\
-	static const char __msg[] = msg;			\
 	struct netlink_ext_ack *__extack = (extack);		\
 								\
-	do_trace_netlink_extack(__msg);				\
+	do_trace_netlink_extack(msg);				\
 								\
 	if (__extack) {						\
-		__extack->_msg = __msg;				\
+		__extack->_msg = msg;				\
 		__extack->bad_attr = (attr);			\
 		__extack->policy = (pol);			\
 	}							\


