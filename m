Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB7E1D0C73
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 11:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgEMJjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 05:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbgEMJjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 05:39:48 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58F6C061A0C;
        Wed, 13 May 2020 02:39:47 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 65534)
        id 9CC9F58725882; Wed, 13 May 2020 11:39:45 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on a3.inai.de
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 532D958725880;
        Wed, 13 May 2020 11:39:44 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, pablo@netfilter.org, fw@strlen.de,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v4] doc: document danger of applying REJECT to INVALID CTs
Date:   Wed, 13 May 2020 11:39:44 +0200
Message-Id: <20200513093944.9752-1-jengelh@inai.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <CANP3RGfNH1m=-rFdkAmGUt3vxFqaGmJnW+RKP-faU6WwOKWoZg@mail.gmail.com>
References: <CANP3RGfNH1m=-rFdkAmGUt3vxFqaGmJnW+RKP-faU6WwOKWoZg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---

4th time is the charm?!

 extensions/libip6t_REJECT.man | 20 ++++++++++++++++++++
 extensions/libipt_REJECT.man  | 20 ++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/extensions/libip6t_REJECT.man b/extensions/libip6t_REJECT.man
index 0030a51f..7387436c 100644
--- a/extensions/libip6t_REJECT.man
+++ b/extensions/libip6t_REJECT.man
@@ -30,3 +30,23 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
 hosts (which won't accept your mail otherwise).
 \fBtcp\-reset\fP
 can only be used with kernel versions 2.6.14 or later.
+.PP
+\fIWarning:\fP You should not indiscriminately apply the REJECT target to
+packets whose connection state is classified as INVALID; instead, you should
+only DROP these.
+.PP
+Consider a source host transmitting a packet P, with P experiencing so much
+delay along its path that the source host issues a retransmission, P_2, with
+P_2 being succesful in reaching its destination and advancing the connection
+state normally. It is conceivable that the late-arriving P may be considered to
+be not associated with any connection tracking entry. Generating a reject
+packet for this packet would then terminate the healthy connection.
+.PP
+So, instead of:
+.PP
+-A INPUT ... -j REJECT
+.PP
+do consider using:
+.PP
+-A INPUT ... -m conntrack --ctstate INVALID -j DROP
+-A INPUT ... -j REJECT
diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
index 8a360ce7..618a766c 100644
--- a/extensions/libipt_REJECT.man
+++ b/extensions/libipt_REJECT.man
@@ -30,3 +30,23 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
 hosts (which won't accept your mail otherwise).
 .IP
 (*) Using icmp\-admin\-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
+.PP
+\fIWarning:\fP You should not indiscriminately apply the REJECT target to
+packets whose connection state is classified as INVALID; instead, you should
+only DROP these.
+.PP
+Consider a source host transmitting a packet P, with P experiencing so much
+delay along its path that the source host issues a retransmission, P_2, with
+P_2 being succesful in reaching its destination and advancing the connection
+state normally. It is conceivable that the late-arriving P may be considered to
+be not associated with any connection tracking entry. Generating a reject
+packet for this packet would then terminate the healthy connection.
+.PP
+So, instead of:
+.PP
+-A INPUT ... -j REJECT
+.PP
+do consider using:
+.PP
+-A INPUT ... -m conntrack --ctstate INVALID -j DROP
+-A INPUT ... -j REJECT
-- 
2.26.2

