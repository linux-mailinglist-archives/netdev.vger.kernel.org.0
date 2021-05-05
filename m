Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B752D374BCC
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 01:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhEEXUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 19:20:22 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:11021 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhEEXUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 19:20:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1620256764; x=1651792764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V1yDyAS9obTZv6O5+ocWOKw+3evADzevDjou0AX+rN4=;
  b=LqnUcR6wklABdH4rhSted2CNWCBB3QaGQZRrblHhycWOKXTJLMqXnLYx
   jV4VCk9vF5eGUSpQSuQyudly7KaiWg4ndUTQ1VGhWk7pJd7Gmzgydo6+S
   KCOr0cYgKIp4HiYfbcP6xPsNkCE1MynhckU2MazrxTAp7UfhtlZSKsjpc
   s=;
X-IronPort-AV: E=Sophos;i="5.82,276,1613433600"; 
   d="scan'208";a="133496101"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-1e-c7c08562.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 05 May 2021 23:19:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-c7c08562.us-east-1.amazon.com (Postfix) with ESMTPS id 94827240BEB;
        Wed,  5 May 2021 23:19:20 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 May 2021 23:19:19 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.200) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 5 May 2021 23:19:15 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 11/11] bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
Date:   Thu, 6 May 2021 08:19:12 +0900
Message-ID: <20210505231912.47522-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505051408.5q6xmafbogghkrfz@kafai-mbp.dhcp.thefacebook.com>
References: <20210505051408.5q6xmafbogghkrfz@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.200]
X-ClientProxiedBy: EX13D06UWC002.ant.amazon.com (10.43.162.205) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Tue, 4 May 2021 22:14:08 -0700
> On Tue, Apr 27, 2021 at 12:46:23PM +0900, Kuniyuki Iwashima wrote:
> [ ... ]
> 
> > diff --git a/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
> > new file mode 100644
> > index 000000000000..d7136dc29fa2
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
> > @@ -0,0 +1,51 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Check if we can migrate child sockets.
> > + *
> > + *   1. If reuse_md->migrating_sk is NULL (SYN packet),
> > + *        return SK_PASS without selecting a listener.
> > + *   2. If reuse_md->migrating_sk is not NULL (socket migration),
> > + *        select a listener (reuseport_map[migrate_map[cookie]])
> > + *
> > + * Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > + */
> > +
> > +#include <stddef.h>
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +struct {
> > +	__uint(type, BPF_MAP_TYPE_REUSEPORT_SOCKARRAY);
> > +	__uint(max_entries, 256);
> > +	__type(key, int);
> > +	__type(value, __u64);
> > +} reuseport_map SEC(".maps");
> > +
> > +struct {
> > +	__uint(type, BPF_MAP_TYPE_HASH);
> > +	__uint(max_entries, 256);
> > +	__type(key, __u64);
> > +	__type(value, int);
> > +} migrate_map SEC(".maps");
> > +
> > +SEC("sk_reuseport/migrate")
> > +int prog_migrate_reuseport(struct sk_reuseport_md *reuse_md)
> > +{
> > +	int *key, flags = 0;
> > +	__u64 cookie;
> > +
> > +	if (!reuse_md->migrating_sk)
> > +		return SK_PASS;
> > +
> 
> It will be useful to check if it is migrating a child sk or
> a reqsk by testing the migrating_sk->state for TCP_ESTABLISHED
> and TCP_NEW_SYN_RECV.  skb can be further tested to check if it is
> selecting for the final ACK.  Global variables can then be
> incremented and the user prog can check that, for example,
> it is indeed testing the TCP_NEW_SYN_RECV code path...etc.
> 
> It will also become a good example for others on how migrating_sk
> can be used.

Exactly, I'll count in which state/path the migration happens and validate
them in userspace.

Thank you.


> 
> 
> > +	cookie = bpf_get_socket_cookie(reuse_md->sk);
> > +
> > +	key = bpf_map_lookup_elem(&migrate_map, &cookie);
> > +	if (!key)
> > +		return SK_DROP;
> > +
> > +	bpf_sk_select_reuseport(reuse_md, &reuseport_map, key, flags);
> > +
> > +	return SK_PASS;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> > -- 
> > 2.30.2
> > 
