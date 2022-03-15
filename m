Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237F24D93E2
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238502AbiCOFcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiCOFcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:32:09 -0400
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6854924A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 22:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1647322258; x=1678858258;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xrS/x0SWbsyZbBsm4mkx7QoWN554JDUYrmVMqWT+saE=;
  b=kYOCuZrQxXBjvsim2ttfDXqB4vC678LWptioPLUJGQdhAQ2ChOcGzZ2u
   RMCZ7LnpJGlG/oFokvJ+U33L8Eu+zy6tNdLwaLi0B5rAiAtLnY7r3SXeG
   g38Oh0nQY1sLkrjzG3agegyOMlOsRG4tQMe4N/4D146G4Bz+MA9RBHtZ0
   0=;
X-IronPort-AV: E=Sophos;i="5.90,182,1643673600"; 
   d="scan'208";a="202302952"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-718d0906.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 15 Mar 2022 05:30:57 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-718d0906.us-west-2.amazon.com (Postfix) with ESMTPS id 071483E1899;
        Tue, 15 Mar 2022 05:30:57 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Tue, 15 Mar 2022 05:30:47 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.9) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.32; Tue, 15 Mar 2022 05:30:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <netdev@vger.kernel.org>,
        <rao.shoaib@oracle.com>
Subject: Re: [PATCH net] af_unix: Support POLLPRI for OOB.
Date:   Tue, 15 Mar 2022 14:30:40 +0900
Message-ID: <20220315053040.70545-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315004503.46906-1-kuniyu@amazon.co.jp>
References: <20220315004503.46906-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.9]
X-ClientProxiedBy: EX13d09UWA002.ant.amazon.com (10.43.160.186) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date:   Tue, 15 Mar 2022 09:45:03 +0900
> From:   Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Mon, 14 Mar 2022 17:26:54 -0700
>> On 3/14/22 11:10, Shoaib Rao wrote:
>>>
>>> On 3/14/22 10:42, Eric Dumazet wrote:
>>>>
>>>> On 3/13/22 22:21, Kuniyuki Iwashima wrote:
>>>>> The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
>>>>> AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
>>>>> piece.
>>>>>
>>>>> In the selftest, normal datagrams are sent followed by OOB data, so 
>>>>> this
>>>>> commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first 
>>>>> test
>>>>> case.
>>>>>
>>>>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>>>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>>>>> ---
>>>>>   net/unix/af_unix.c                                  | 2 ++
>>>>>   tools/testing/selftests/net/af_unix/test_unix_oob.c | 6 +++---
>>>>>   2 files changed, 5 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>>>> index c19569819866..711d21b1c3e1 100644
>>>>> --- a/net/unix/af_unix.c
>>>>> +++ b/net/unix/af_unix.c
>>>>> @@ -3139,6 +3139,8 @@ static __poll_t unix_poll(struct file *file, 
>>>>> struct socket *sock, poll_table *wa
>>>>>           mask |= EPOLLIN | EPOLLRDNORM;
>>>>>       if (sk_is_readable(sk))
>>>>>           mask |= EPOLLIN | EPOLLRDNORM;
>>>>> +    if (unix_sk(sk)->oob_skb)
>>>>> +        mask |= EPOLLPRI;
>>>>
>>>>
>>>> This adds another data-race, maybe add something to avoid another 
>>>> syzbot report ?
>>>
>>> It's not obvious to me how there would be a race as it is just a check.
>>>
>> 
>> KCSAN will detect that whenever unix_poll() reads oob_skb,
>> 
>> its value can be changed by another cpu.
>> 
>> 
>> unix_poll() runs without holding a lock.
> 
> Thanks for pointing out!
> So, READ_ONCE() is necessary here, right?
> oob_skb is written under the lock, so I think there is no paired
> WRITE_ONCE(), but is it ok?

I've tested the prog below and KCSAN repoted the race.
Also, READ_ONCE() suppressed it.

Thank you Eric!
I'll post v2 with READ_ONCE().

---8<---
[   60.021825] ==================================================================
[   60.021999] BUG: KCSAN: data-race in unix_poll / unix_stream_sendmsg
[   60.021999] 
[   60.021999] write to 0xffff8880050d9ff0 of 8 bytes by task 175 on cpu 3:
[   60.021999]  unix_stream_sendmsg+0x9dc/0xbb0
[   60.021999]  sock_sendmsg+0x90/0xa0
[   60.021999]  __sys_sendto+0x138/0x190
[   60.021999]  __x64_sys_sendto+0x6d/0x80
[   60.021999]  do_syscall_64+0x38/0x80
[   60.021999]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   60.021999] 
[   60.021999] read to 0xffff8880050d9ff0 of 8 bytes by task 176 on cpu 2:
[   60.021999]  unix_poll+0xf4/0x1b0
[   60.021999]  sock_poll+0xa4/0x1e0
[   60.021999]  do_sys_poll+0x326/0x750
[   60.021999]  __x64_sys_poll+0x55/0x1f0
[   60.021999]  do_syscall_64+0x38/0x80
[   60.021999]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   60.021999] 
[   60.021999] value changed: 0xffff8880056bf000 -> 0xffff8880056bff00
[   60.021999] 
[   60.021999] Reported by Kernel Concurrency Sanitizer on:
[   60.021999] CPU: 2 PID: 176 Comm: unix_race_oob Not tainted 5.17.0-rc5-59531-gbdaabdfaadf8-dirty #9
[   60.021999] Hardware name: Red Hat KVM, BIOS 1.11.0-2.amzn2 04/01/2014
[   60.021999] ==================================================================
---8<---

---8<---
#include <errno.h>
#include <poll.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/un.h>
#include <sys/wait.h>

#define offsetof(type, member) ((size_t)&((type *)0)->member)
#define SUNADDR "\0test\0"
#define ADDRLEN (socklen_t)(offsetof(struct sockaddr_un, sun_path) + 6)

int setup_server(void)
{
	struct sockaddr_un addr = {
		.sun_family = AF_UNIX,
		.sun_path = SUNADDR,
	};
	int err, fd;

	fd = socket(AF_UNIX, SOCK_STREAM | SOCK_NONBLOCK, 0);
	if (fd == -1) {
		perror("socket");
		goto out;
	}

	err = bind(fd, (struct sockaddr *)&addr, ADDRLEN);
	if (err == -1) {
		perror("bind");
		goto err;
	}

	err = listen(fd, 32);
	if (err == -1) {
		perror("listen");
		goto err;
	}

out:
	return fd;

err:
	close(fd);
	return err;
}

int setup_client(void)
{
	struct sockaddr_un addr = {
		.sun_family = AF_UNIX,
		.sun_path = SUNADDR,
	};
	int err, fd;

	fd = socket(AF_UNIX, SOCK_STREAM | SOCK_NONBLOCK, 0);
	if (fd == -1) {
		perror("socket");
		goto out;
	}

	err = connect(fd, (struct sockaddr *)&addr, ADDRLEN);
	if (err == -1) {
		perror("connect");
		goto err;
	}

out:
	return fd;

err:
	close(fd);
	return err;
}

int setup_child(int server)
{
	struct sockaddr_un addr;
	socklen_t len;
	int child;

	child = accept(server, (struct sockaddr *)&addr, &len);
	if (child == -1)
		perror("accept");

	return child;
}

int sender(int client)
{
	char c = 'a';
	int ret;

	printf("start sender\n");

	while (1) {
		ret = send(client, &c, sizeof(c), MSG_OOB);
		if (ret != 1 || errno)
			perror("send");
	}

	return 0;
}


int receiver(int child)
{
	struct pollfd pfds[1];
	char buf[1024];
	int ret;

	pfds[0].fd = child;
	pfds[0].events = POLLIN | POLLPRI;

	printf("start receiver\n");

	while (1) {
		poll(pfds, 1, -1);

		ret = recv(child, buf, sizeof(buf), MSG_OOB);
		if (ret < 0 || errno)
			perror("recv (MSG_OOB)");

		ret = recv(child, buf, sizeof(buf), 0);
		if (ret < 0 || errno)
			perror("recv");
	}

	return 0;
}

int main(void)
{
	int server, client, child;
	int status;
	pid_t pid;

	server = setup_server();
	if (server == -1)
		goto out;

	client = setup_client();
	if (client == -1)
		goto close_server;

	child = setup_child(server);
	if (child == -1)
		goto close_client;

	pid = fork();
	if (pid == 0)
		return sender(client);

	pid = fork();
	if (pid == 0)
		return receiver(child);

	wait(&status);

	close(child);
close_client:
	close(client);
close_server:
	close(server);
out:
	return 0;
}
---8<---
