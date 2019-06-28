Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 509985A313
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 20:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfF1SEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 14:04:07 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39912 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfF1SEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 14:04:06 -0400
Received: by mail-pg1-f196.google.com with SMTP id 196so2926249pgc.6
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 11:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=635JCJQVk7nM+Kaq8WQmv+SGXkEKSmrDgI5LuPFt9Ws=;
        b=mdcVqNrd08J3pWnTWoICNnVbEc2jmyCrpcguFT6Eg5ibd3wMLJI+FyBIcalGVh6nFP
         /9Ba6RDyMfPxswtuCGbQPBRDc16yMmZpe3UnAjSFLVDOtHnaKHDo5SbmSnEEElBr3isA
         DUT4oJ5ZYtbfJDhJVGw9pwWVqmvOp/snX+eAWWmt+KBbX13u6TIIJTrLhX7yi1maWVlB
         OTqTMiF2OrUhXiw8F2YJ4kgwtHK2Ru7DA6clqMExEY4I3rtbUHRcdUZ3rx0XnAoqhAzU
         clFr4y723WH6/FVKxCsVNdf5Li61gdcpn6Cy/U4dD26+or/aJsvfBX+Jlbo56XG9KGiD
         sIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=635JCJQVk7nM+Kaq8WQmv+SGXkEKSmrDgI5LuPFt9Ws=;
        b=SIggz9sdyDpM8kM9sSPZ4Z8/j4qHG3OI9DMWz/JmiKFVup8fXKrowp12qonCM/H5yP
         5ywgny3k2RJ6Dzw2cQD1Q8V7WaMGj/3VI4CsWF4NWeq+FjtC7WW7+AouzeSB4aYcClaB
         jDSx/+VjPBePspbcegC3mZYH/v8Eg4WPlCLtWfjFG45HgzGDtxU6Q28/rNAHHbl/2dbp
         oQZDJbJFk62hcdNpz0Bd9uezb3GjpeV9iK6lDJQOn3rQ0maYqspjPXANX8IbdmAn/tU6
         KIUQ1AzKm6IE5mK+xMSw68y1K8AIP/aQpPupWsbf4pYt/1dhyPAt51RrtWvC9P0giOsY
         sOig==
X-Gm-Message-State: APjAAAXiLdIZ0MaEdQCJGByB5RTydDufRD/vOw55peFQbyqSob6VAsoE
        PpidxXnTvKEuIIkSDBG722VBEfmZ1ns=
X-Google-Smtp-Source: APXvYqyUlFE3qw61HAPjF7WcQkPcVQ92Ya4ZJgu8jkMUQZDl+lsXTEMmneK7gsxXkvbOreWahlLFSQ==
X-Received: by 2002:a63:6286:: with SMTP id w128mr1276673pgb.12.1561745044952;
        Fri, 28 Jun 2019 11:04:04 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id d6sm2175919pgv.4.2019.06.28.11.04.03
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 11:04:04 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     dcaratti@redhat.com, chrism@mellanox.com, willy@infradead.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Li Shuang <shuali@redhat.com>
Subject: [Patch net 1/3] idr: fix overflow case for idr_for_each_entry_ul()
Date:   Fri, 28 Jun 2019 11:03:41 -0700
Message-Id: <20190628180343.8230-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190628180343.8230-1-xiyou.wangcong@gmail.com>
References: <20190628180343.8230-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

idr_for_each_entry_ul() is buggy as it can't handle overflow
case correctly. When we have an ID == UINT_MAX, it becomes an
infinite loop. This happens when running on 32-bit CPU where
unsigned long has the same size with unsigned int.

There is no better way to fix this than casting it to a larger
integer, but we can't just 64 bit integer on 32 bit CPU. Instead
we could just use an additional integer to help us to detect this
overflow case, that is, adding a new parameter to this macro.
Fortunately tc action is its only user right now.

Fixes: 65a206c01e8e ("net/sched: Change act_api and act_xxx modules to use IDR")
Reported-by: Li Shuang <shuali@redhat.com>
Tested-by: Davide Caratti <dcaratti@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Chris Mi <chrism@mellanox.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/linux/idr.h | 7 +++++--
 net/sched/act_api.c | 9 ++++++---
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index ee7abae143d3..68528a72d10d 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -191,14 +191,17 @@ static inline void idr_preload_end(void)
  * idr_for_each_entry_ul() - Iterate over an IDR's elements of a given type.
  * @idr: IDR handle.
  * @entry: The type * to use as cursor.
+ * @tmp: A temporary placeholder for ID.
  * @id: Entry ID.
  *
  * @entry and @id do not need to be initialized before the loop, and
  * after normal termination @entry is left with the value NULL.  This
  * is convenient for a "not found" value.
  */
-#define idr_for_each_entry_ul(idr, entry, id)			\
-	for (id = 0; ((entry) = idr_get_next_ul(idr, &(id))) != NULL; ++id)
+#define idr_for_each_entry_ul(idr, entry, tmp, id)			\
+	for (tmp = 0, id = 0;						\
+	     tmp <= id && ((entry) = idr_get_next_ul(idr, &(id))) != NULL; \
+	     tmp = id, ++id)
 
 /**
  * idr_for_each_entry_continue() - Continue iteration over an IDR's elements of a given type
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 5567af5d7cb5..835adde28a7e 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -221,12 +221,13 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	struct idr *idr = &idrinfo->action_idr;
 	struct tc_action *p;
 	unsigned long id = 1;
+	unsigned long tmp;
 
 	mutex_lock(&idrinfo->lock);
 
 	s_i = cb->args[0];
 
-	idr_for_each_entry_ul(idr, p, id) {
+	idr_for_each_entry_ul(idr, p, tmp, id) {
 		index++;
 		if (index < s_i)
 			continue;
@@ -292,6 +293,7 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 	struct idr *idr = &idrinfo->action_idr;
 	struct tc_action *p;
 	unsigned long id = 1;
+	unsigned long tmp;
 
 	nest = nla_nest_start_noflag(skb, 0);
 	if (nest == NULL)
@@ -300,7 +302,7 @@ static int tcf_del_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 		goto nla_put_failure;
 
 	mutex_lock(&idrinfo->lock);
-	idr_for_each_entry_ul(idr, p, id) {
+	idr_for_each_entry_ul(idr, p, tmp, id) {
 		ret = tcf_idr_release_unsafe(p);
 		if (ret == ACT_P_DELETED) {
 			module_put(ops->owner);
@@ -533,8 +535,9 @@ void tcf_idrinfo_destroy(const struct tc_action_ops *ops,
 	struct tc_action *p;
 	int ret;
 	unsigned long id = 1;
+	unsigned long tmp;
 
-	idr_for_each_entry_ul(idr, p, id) {
+	idr_for_each_entry_ul(idr, p, tmp, id) {
 		ret = __tcf_idr_release(p, false, true);
 		if (ret == ACT_P_DELETED)
 			module_put(ops->owner);
-- 
2.21.0

