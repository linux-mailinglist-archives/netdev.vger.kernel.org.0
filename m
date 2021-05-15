Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475D23815E6
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 06:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhEOE2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 00:28:33 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:15736 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhEOE2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 00:28:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621052840; x=1652588840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p7KNGkx6kXHjAg2/6FjVNBOs8d74NTHOunw4tm9OCE4=;
  b=SNDyUbM5EScUduv0soI5Wz0X/+yCbLUknWWOiWdLse1hvlDuyDJWbA9I
   EFyBQrvPlTnG6Hvg5UTpD+WGY+U2y9+mbxTgn2cLUxj1GyISlyXS4TsT8
   p3WUBdMQXUleXldNup4DUQyB3bNM4noscxi/Jin4KgZr7/yYXplkdW+UW
   U=;
X-IronPort-AV: E=Sophos;i="5.82,300,1613433600"; 
   d="scan'208";a="112350673"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 15 May 2021 04:27:18 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id 9C2BBA1B7A;
        Sat, 15 May 2021 04:27:17 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:27:17 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.29) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:27:06 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 11/11] bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
Date:   Sat, 15 May 2021 13:27:02 +0900
Message-ID: <20210515042702.82265-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210515020515.mq2b3gqaq5edepk7@kafai-mbp>
References: <20210515020515.mq2b3gqaq5edepk7@kafai-mbp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.29]
X-ClientProxiedBy: EX13D28UWB004.ant.amazon.com (10.43.161.56) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Fri, 14 May 2021 19:05:15 -0700
> On Mon, May 10, 2021 at 12:44:33PM +0900, Kuniyuki Iwashima wrote:
> > diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
> > index 12ee40284da0..2060bc122c53 100644
> [ ... ]
> 
> > +static int setup_fastopen(char *buf, int size, int *saved_len, bool restore)
> > +{
> > +	int err = 0, fd, len;
> > +
> > +	fd = open("/proc/sys/net/ipv4/tcp_fastopen", O_RDWR);
> > +	if (!ASSERT_NEQ(fd, -1, "open"))
> > +		return -1;
> > +
> > +	if (restore) {
> > +		len = write(fd, buf, *saved_len);
> > +		if (!ASSERT_EQ(len, *saved_len, "write - restore"))
> > +			err = -1;
> > +	} else {
> > +		*saved_len = read(fd, buf, size);
> > +		if (!ASSERT_GE(*saved_len, 1, "read")) {
> > +			err = -1;
> > +			goto close;
> > +		}
> > +
> > +		err = lseek(fd, 0, SEEK_SET);
> > +		if (!ASSERT_OK(err, "lseek"))
> > +			goto close;
> > +
> > +		/* (TFO_CLIENT_ENABLE | TFO_SERVER_ENABLE) */
> > +		len = write(fd, "3", 1);
> > +		if (!ASSERT_EQ(len, 1, "write - setup"))
> Is it to trigger the tcp_try_fastopen() case?
> I am not sure it is enough.  At least, I think not for the
> very first connection before the cookie is saved.
> The second run of the test may be able to trigger it.
> 
> setsockopt(TCP_FASTOPEN_NO_COOKIE) or another value in the
> "/proc/sys/net/ipv4/tcp_fastopen" (ip-sysctl.rst) may be
> needed.

Ah, right. I missed that point while testing in the same host.
TFO should be always forced without cookies.


> 
> > +			err = -1;
> > +	}
> > +
> > +close:
> > +	close(fd);
> > +
> > +	return err;
> > +}
> > +
> [ ... ]
> 
> > diff --git a/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
> > new file mode 100644
> > index 000000000000..72978b5d1fcb
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
> > @@ -0,0 +1,67 @@
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
> > +int migrated_at_close SEC(".data");
> > +int migrated_at_send_synack SEC(".data");
> > +int migrated_at_recv_ack SEC(".data");
> int migrated_at_close = 0;
> int migrated_at_send_synack = 0;
> int migrated_at_recv_ack = 0;
> 
> and then use skel->bss->migrated_at_* in migrate_reuseport.c.

I'll fix them.

Thank you.
