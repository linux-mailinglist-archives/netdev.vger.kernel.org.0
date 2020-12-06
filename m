Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571EF2D0094
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 05:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgLFEo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 23:44:28 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:29893 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgLFEo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 23:44:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607229867; x=1638765867;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=nnldJNDnnFoMsDf9hwQPV09C5nytogN2SjHJ6VJV8i0=;
  b=rcjAJR/ZApmDd+dbPU46H0je+gU8tzsVC4f7u8c9e41fTHDIl3KRusCh
   ds5vmi/ddcgE2Wg6KtVJyHwhzFLE505si18bjMmRP9N+9jl/mStnyMdvF
   DHOyPo9E4NBoHsfFmO48SCPkNk783ofBIKuW+6bb7rWkEk5Cs93xeUZr0
   c=;
X-IronPort-AV: E=Sophos;i="5.78,396,1599523200"; 
   d="scan'208";a="67793715"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 06 Dec 2020 04:43:45 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id BF840A25E8;
        Sun,  6 Dec 2020 04:43:44 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Dec 2020 04:43:43 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.66) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Dec 2020 04:43:35 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <kuni1840@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 11/11] bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
Date:   Sun, 6 Dec 2020 13:43:31 +0900
Message-ID: <20201206044331.31320-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201205015000.duec3x4lydhrsq5f@kafai-mbp.dhcp.thefacebook.com>
References: <20201205015000.duec3x4lydhrsq5f@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D31UWC004.ant.amazon.com (10.43.162.27) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sending this mail just for logging because I failed to send mails only 
to LKML, netdev, and bpf yesterday.


From:   Martin KaFai Lau <kafai@fb.com>
Date:   Fri, 4 Dec 2020 17:50:00 -0800
> On Tue, Dec 01, 2020 at 11:44:18PM +0900, Kuniyuki Iwashima wrote:
> > This patch adds a test for BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
> > 
> > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  .../bpf/prog_tests/migrate_reuseport.c        | 164 ++++++++++++++++++
> >  .../bpf/progs/test_migrate_reuseport_kern.c   |  54 ++++++
> >  2 files changed, 218 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c
> > 
> > diff --git a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
> > new file mode 100644
> > index 000000000000..87c72d9ccadd
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
> > @@ -0,0 +1,164 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Check if we can migrate child sockets.
> > + *
> > + *   1. call listen() for 5 server sockets.
> > + *   2. update a map to migrate all child socket
> > + *        to the last server socket (migrate_map[cookie] = 4)
> > + *   3. call connect() for 25 client sockets.
> > + *   4. call close() for first 4 server sockets.
> > + *   5. call accept() for the last server socket.
> > + *
> > + * Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > + */
> > +
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +#include <fcntl.h>
> > +#include <netinet/in.h>
> > +#include <arpa/inet.h>
> > +#include <linux/bpf.h>
> > +#include <sys/socket.h>
> > +#include <sys/types.h>
> > +#include <bpf/bpf.h>
> > +#include <bpf/libbpf.h>
> > +
> > +#define NUM_SOCKS 5
> > +#define LOCALHOST "127.0.0.1"
> > +#define err_exit(condition, message)			      \
> > +	do {						      \
> > +		if (condition) {			      \
> > +			perror("ERROR: " message " ");	      \
> > +			exit(1);			      \
> > +		}					      \
> > +	} while (0)
> > +
> > +__u64 server_fds[NUM_SOCKS];
> > +int prog_fd, reuseport_map_fd, migrate_map_fd;
> > +
> > +
> > +void setup_bpf(void)
> > +{
> > +	struct bpf_object *obj;
> > +	struct bpf_program *prog;
> > +	struct bpf_map *reuseport_map, *migrate_map;
> > +	int err;
> > +
> > +	obj = bpf_object__open("test_migrate_reuseport_kern.o");
> > +	err_exit(libbpf_get_error(obj), "opening BPF object file failed");
> > +
> > +	err = bpf_object__load(obj);
> > +	err_exit(err, "loading BPF object failed");
> > +
> > +	prog = bpf_program__next(NULL, obj);
> > +	err_exit(!prog, "loading BPF program failed");
> > +
> > +	reuseport_map = bpf_object__find_map_by_name(obj, "reuseport_map");
> > +	err_exit(!reuseport_map, "loading BPF reuseport_map failed");
> > +
> > +	migrate_map = bpf_object__find_map_by_name(obj, "migrate_map");
> > +	err_exit(!migrate_map, "loading BPF migrate_map failed");
> > +
> > +	prog_fd = bpf_program__fd(prog);
> > +	reuseport_map_fd = bpf_map__fd(reuseport_map);
> > +	migrate_map_fd = bpf_map__fd(migrate_map);
> > +}
> > +
> > +void test_listen(void)
> > +{
> > +	struct sockaddr_in addr;
> > +	socklen_t addr_len = sizeof(addr);
> > +	int i, err, optval = 1, migrated_to = NUM_SOCKS - 1;
> > +	__u64 value;
> > +
> > +	addr.sin_family = AF_INET;
> > +	addr.sin_port = htons(80);
> > +	inet_pton(AF_INET, LOCALHOST, &addr.sin_addr.s_addr);
> > +
> > +	for (i = 0; i < NUM_SOCKS; i++) {
> > +		server_fds[i] = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
> > +		err_exit(server_fds[i] == -1, "socket() for listener sockets failed");
> > +
> > +		err = setsockopt(server_fds[i], SOL_SOCKET, SO_REUSEPORT,
> > +				 &optval, sizeof(optval));
> > +		err_exit(err == -1, "setsockopt() for SO_REUSEPORT failed");
> > +
> > +		if (i == 0) {
> > +			err = setsockopt(server_fds[i], SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF,
> > +					 &prog_fd, sizeof(prog_fd));
> > +			err_exit(err == -1, "setsockopt() for SO_ATTACH_REUSEPORT_EBPF failed");
> > +		}
> > +
> > +		err = bind(server_fds[i], (struct sockaddr *)&addr, addr_len);
> > +		err_exit(err == -1, "bind() failed");
> > +
> > +		err = listen(server_fds[i], 32);
> > +		err_exit(err == -1, "listen() failed");
> > +
> > +		err = bpf_map_update_elem(reuseport_map_fd, &i, &server_fds[i], BPF_NOEXIST);
> > +		err_exit(err == -1, "updating BPF reuseport_map failed");
> > +
> > +		err = bpf_map_lookup_elem(reuseport_map_fd, &i, &value);
> > +		err_exit(err == -1, "looking up BPF reuseport_map failed");
> > +
> > +		printf("fd[%d] (cookie: %llu) -> fd[%d]\n", i, value, migrated_to);
> > +		err = bpf_map_update_elem(migrate_map_fd, &value, &migrated_to, BPF_NOEXIST);
> > +		err_exit(err == -1, "updating BPF migrate_map failed");
> > +	}
> > +}
> > +
> > +void test_connect(void)
> > +{
> > +	struct sockaddr_in addr;
> > +	socklen_t addr_len = sizeof(addr);
> > +	int i, err, client_fd;
> > +
> > +	addr.sin_family = AF_INET;
> > +	addr.sin_port = htons(80);
> > +	inet_pton(AF_INET, LOCALHOST, &addr.sin_addr.s_addr);
> > +
> > +	for (i = 0; i < NUM_SOCKS * 5; i++) {
> > +		client_fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
> > +		err_exit(client_fd == -1, "socket() for listener sockets failed");
> > +
> > +		err = connect(client_fd, (struct sockaddr *)&addr, addr_len);
> > +		err_exit(err == -1, "connect() failed");
> > +
> > +		close(client_fd);
> > +	}
> > +}
> > +
> > +void test_close(void)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < NUM_SOCKS - 1; i++)
> > +		close(server_fds[i]);
> > +}
> > +
> > +void test_accept(void)
> > +{
> > +	struct sockaddr_in addr;
> > +	socklen_t addr_len = sizeof(addr);
> > +	int cnt, client_fd;
> > +
> > +	fcntl(server_fds[NUM_SOCKS - 1], F_SETFL, O_NONBLOCK);
> > +
> > +	for (cnt = 0; cnt < NUM_SOCKS * 5; cnt++) {
> > +		client_fd = accept(server_fds[NUM_SOCKS - 1], (struct sockaddr *)&addr, &addr_len);
> > +		err_exit(client_fd == -1, "accept() failed");
> > +	}
> > +
> > +	printf("%d accepted, %d is expected\n", cnt, NUM_SOCKS * 5);
> > +}
> > +
> > +int main(void)
> I am pretty sure "make -C tools/testing/selftests/bpf"
> will not compile here because of double main() with
> the test_progs.c.
> 
> Please take a look at how other tests are written in
> tools/testing/selftests/bpf/prog_tests/. e.g.
> the test function in tcp_hdr_options.c is
> test_tcp_hdr_options().
> 
> Also, instead of bpf_object__open(), please use skeleton
> like most of the tests do.

I'm sorry... I will check other tests and rewrite this patch along them.
