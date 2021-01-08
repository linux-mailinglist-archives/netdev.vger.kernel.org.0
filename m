Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B842EF193
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 12:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbhAHLqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 06:46:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36467 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725791AbhAHLqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 06:46:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610106283;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WRY9Ky6OR198qQVcoHDcIciJXlYwY+IiDLRi+naX4Kc=;
        b=ZAvR/BmsBcqqluUk4c+gC14Vng91uGiBiLkDEO3AEG3PkBJqjOwk9YpGMRjUWs5TN9Mmea
        kw1A50gE6/fizE9ejt7KepfHqCOfwmZZvnUPlOjnApdidSn0jQpdDeBw//UzysoVNy3+RU
        msFeyACn3xJHMtvYYU4sgNp3hktAmwQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-AuQJD0wXO7iR8zYFKYYtdQ-1; Fri, 08 Jan 2021 06:44:39 -0500
X-MC-Unique: AuQJD0wXO7iR8zYFKYYtdQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39FF4800D53;
        Fri,  8 Jan 2021 11:44:38 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1763D5C8AA;
        Fri,  8 Jan 2021 11:44:34 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id AC99E32138456;
        Fri,  8 Jan 2021 12:44:33 +0100 (CET)
Subject: [PATCH net] netfilter: conntrack: fix reading nf_conntrack_buckets
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Date:   Fri, 08 Jan 2021 12:44:33 +0100
Message-ID: <161010627346.3858336.14321264288771872662.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old way of changing the conntrack hashsize runtime was through changing
the module param via file /sys/module/nf_conntrack/parameters/hashsize. This
was extended to sysctl change in commit 3183ab8997a4 ("netfilter: conntrack:
allow increasing bucket size via sysctl too").

The commit introduced second "user" variable nf_conntrack_htable_size_user
which shadow actual variable nf_conntrack_htable_size. When hashsize is
changed via module param this "user" variable isn't updated. This results in
sysctl net/netfilter/nf_conntrack_buckets shows the wrong value when users
update via the old way.

This patch fix the issue by always updating "user" variable when reading the
proc file. This will take care of changes to the actual variable without
sysctl need to be aware.

Fixes: 3183ab8997a4 ("netfilter: conntrack: allow increasing bucket size via sysctl too")
Reported-by: Yoel Caspersen <yoel@kviknet.dk>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/netfilter/nf_conntrack_standalone.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 46c5557c1fec..0ee702d374b0 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -523,6 +523,9 @@ nf_conntrack_hash_sysctl(struct ctl_table *table, int write,
 {
 	int ret;
 
+	/* module_param hashsize could have changed value */
+	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
+
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
 	if (ret < 0 || !write)
 		return ret;


