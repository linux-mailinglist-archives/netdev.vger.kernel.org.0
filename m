Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3C761A1824
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 00:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgDGW3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 18:29:47 -0400
Received: from correo.us.es ([193.147.175.20]:53152 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgDGW3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Apr 2020 18:29:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 43DDAF2DF1
        for <netdev@vger.kernel.org>; Wed,  8 Apr 2020 00:29:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FFA9DA736
        for <netdev@vger.kernel.org>; Wed,  8 Apr 2020 00:29:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 25982FF6F4; Wed,  8 Apr 2020 00:29:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2886DA736;
        Wed,  8 Apr 2020 00:29:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Apr 2020 00:29:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BC6014251480;
        Wed,  8 Apr 2020 00:29:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/7] netfilter: xt_IDLETIMER: target v1 - match Android layout
Date:   Wed,  8 Apr 2020 00:29:32 +0200
Message-Id: <20200407222936.206295-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200407222936.206295-1-pablo@netfilter.org>
References: <20200407222936.206295-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

Android has long had an extension to IDLETIMER to send netlink
messages to userspace, see:
  https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/include/uapi/linux/netfilter/xt_IDLETIMER.h#42
Note: this is idletimer target rev 1, there is no rev 0 in
the Android common kernel sources, see registration at:
  https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/net/netfilter/xt_IDLETIMER.c#483

When we compare that to upstream's new idletimer target rev 1:
  https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/tree/include/uapi/linux/netfilter/xt_IDLETIMER.h#n46

We immediately notice that these two rev 1 structs are the
same size and layout, and that while timer_type and send_nl_msg
are differently named and serve a different purpose, they're
at the same offset.

This makes them impossible to tell apart - and thus one cannot
know in a mixed Android/vanilla environment whether one means
timer_type or send_nl_msg.

Since this is iptables/netfilter uapi it introduces a problem
between iptables (vanilla vs Android) userspace and kernel
(vanilla vs Android) if the two don't match each other.

Additionally when at some point in the future Android picks up
5.7+ it's not at all clear how to resolve the resulting merge
conflict.

Furthermore, since upgrading the kernel on old Android phones
is pretty much impossible there does not seem to be an easy way
out of this predicament.

The only thing I've been able to come up with is some super
disgusting kernel version >= 5.7 check in the iptables binary
to flip between different struct layouts.

By adding a dummy field to the vanilla Linux kernel header file
we can force the two structs to be compatible with each other.

Long term I think I would like to deprecate send_nl_msg out of
Android entirely, but I haven't quite been able to figure out
exactly how we depend on it.  It seems to be very similar to
sysfs notifications but with some extra info.

Currently it's actually always enabled whenever Android uses
the IDLETIMER target, so we could also probably entirely
remove it from the uapi in favour of just always enabling it,
but again we can't upgrade old kernels already in the field.

(Also note that this doesn't change the structure's size,
as it is simply fitting into the pre-existing padding, and
that since 5.7 hasn't been released yet, there's still time
to make this uapi visible change)

Cc: Manoj Basapathi <manojbm@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_IDLETIMER.h | 1 +
 net/netfilter/xt_IDLETIMER.c                | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
index 434e6506abaa..49ddcdc61c09 100644
--- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
+++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
@@ -48,6 +48,7 @@ struct idletimer_tg_info_v1 {
 
 	char label[MAX_IDLETIMER_LABEL_SIZE];
 
+	__u8 send_nl_msg;   /* unused: for compatibility with Android */
 	__u8 timer_type;
 
 	/* for kernel module internal use only */
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 75bd0e5dd312..7b2f359bfce4 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -346,6 +346,9 @@ static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
 
 	pr_debug("checkentry targinfo%s\n", info->label);
 
+	if (info->send_nl_msg)
+		return -EOPNOTSUPP;
+
 	ret = idletimer_tg_helper((struct idletimer_tg_info *)info);
 	if(ret < 0)
 	{
-- 
2.11.0

