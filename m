Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB3B68E512
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjBHAhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjBHAhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:45 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBD53F28C
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1675816649; x=1707352649;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TXf8epdKjacmvwPKE63N3nqPXcTzKAgiFILhw+II5Bs=;
  b=QVbNn5dzrhmmEJp8Cf47fo4ejXj5bAAMEEqwF4H/f7HduEGV9zKp3Nmw
   UgBTtgre16ykXichrjn8SUkB8UwofNqQxLOeIA7tWnt4hD3PRUFVkaTJ/
   U93f/6ESyvcpcv1u2V5Vu6DIdv0PcuAos03YVx1DrWGqk1cF4CRZeLtxC
   E=;
X-IronPort-AV: E=Sophos;i="5.97,279,1669075200"; 
   d="scan'208";a="296404935"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 00:37:27 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-m6i4x-25ac6bd5.us-east-1.amazon.com (Postfix) with ESMTPS id 9CB3643D8A;
        Wed,  8 Feb 2023 00:37:24 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 8 Feb 2023 00:37:23 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.198) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Wed, 8 Feb 2023 00:37:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <edumazet@google.com>
CC:     <christophpaasch@icloud.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.com>,
        <matthieu.baerts@tessares.net>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <syzkaller@googlegroups.com>
Subject: Re: [PATCH v1 net] net: Remove WARN_ON_ONCE(sk->sk_forward_alloc) from sk_stream_kill_queues().
Date:   Tue, 7 Feb 2023 16:37:13 -0800
Message-ID: <20230208003713.83105-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CANn89iK9oc20Jdi_41jb9URdF210r7d1Y-+uypbMSbOfY6jqrg@mail.gmail.com>
References: <CANn89iK9oc20Jdi_41jb9URdF210r7d1Y-+uypbMSbOfY6jqrg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D43UWC004.ant.amazon.com (10.43.162.42) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 7 Feb 2023 20:25:19 +0100
> On Tue, Feb 7, 2023 at 7:37 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > In commit b5fc29233d28 ("inet6: Remove inet6_destroy_sock() in
> > sk->sk_prot->destroy()."), we delay freeing some IPv6 resources
> > from sk->destroy() to sk->sk_destruct().
> >
> > Christoph Paasch reported the commit started triggering
> > WARN_ON_ONCE(sk->sk_forward_alloc) in sk_stream_kill_queues()
> > (See [0 - 2]).
> >
> > For example, if inet6_sk(sk)->rxopt is not zero by setting
> > IPV6_RECVPKTINFO or its friends, tcp_v6_do_rcv() clones a skb
> > and calls skb_set_owner_r(), which charges it to sk.
> 
> skb_set_owner_r() in this place seems wrong.
> This could lead to a negative sk->sk_forward_alloc
> (because we have not sk_rmem_schedule() it ?)
> 
> Do you have a repro ?

I created a repro and confirmed sk->sk_forward_alloc was always positive.

---8<---
#include <stdio.h>

#include <sys/socket.h>
#include <netinet/in.h>

#define IPV6_FLOWINFO		11

int main(void)
{
	struct sockaddr_in6 addr = {
		.sin6_family = AF_INET6,
		.sin6_addr = in6addr_any,
		.sin6_port = htons(0),
	};
	int fd, ret = 0;
	socklen_t len;

	ret = socket(AF_INET6, SOCK_STREAM, IPPROTO_IP);
	perror("socket");
	if (ret < 0)
		return ret;

	fd = ret;
	ret = setsockopt(fd, SOL_IPV6, IPV6_FLOWINFO, &(int){1}, sizeof(int));
	perror("setsockopt");

	ret = bind(fd, (struct sockaddr *)&addr, sizeof(addr));
	perror("bind");
	if (ret)
		goto out;

	len = sizeof(addr);
	ret = getsockname(fd, (struct sockaddr *)&addr, &len);
	perror("getsockname");
	if (ret)
		goto out;

	ret = connect(fd, (struct sockaddr *)&addr, len);
	perror("connect");
	if (ret)
		goto out;

out:
	close(fd);

	return ret;
}
---8<---
