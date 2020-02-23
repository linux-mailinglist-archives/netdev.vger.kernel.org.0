Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A8F169A2A
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 22:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgBWVG6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 16:06:58 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:33733 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWVG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 16:06:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582492017; x=1614028017;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=rKs4hdy8HchQxtjEJyVCGVAU1D/Z9zl5JGO+nG2cS4U=;
  b=mZnnnnHckGqFFImiRu7ECTS15NmZBMimOrFkXEzDMsCAaLKeT05+9Ori
   kHZa9mWFNBoTDQWZXv3e5hj+urjgOKO7Q5ycnhRwH50cBLdhh/smr6MjA
   GYPkwl/1+v6P6s3PotrsrCWZWdRbjY6RGntxh0vVcmB4YG3wYBx0i8LPm
   o=;
IronPort-SDR: ey3VGhbF9XcF4DIMbK0h5ZpclVIRR0NBICYLVYzKX4FyYFrHzuF9aP0LhxuLc9akr1xNjONCRk
 RY1+LKG21mQQ==
X-IronPort-AV: E=Sophos;i="5.70,477,1574121600"; 
   d="scan'208";a="17780433"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 23 Feb 2020 21:06:55 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1e-97fdccfd.us-east-1.amazon.com (Postfix) with ESMTPS id 37CDDA2165;
        Sun, 23 Feb 2020 21:06:53 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 23 Feb 2020 21:06:53 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.108) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 23 Feb 2020 21:06:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kuniyu@amazon.co.jp>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuznet@ms2.inr.ac.ru>, <netdev@vger.kernel.org>,
        <osa-contribution-log@amazon.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 0/3] Improve bind(addr, 0) behaviour.
Date:   Mon, 24 Feb 2020 06:06:45 +0900
Message-ID: <20200223210645.34584-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200222010749.75690-1-kuniyu@amazon.co.jp>
References: <20200222010749.75690-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.108]
X-ClientProxiedBy: EX13d09UWA002.ant.amazon.com (10.43.160.186) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Date:   Sat, 22 Feb 2020 10:07:49 +0900
> I also tested with two users. I am sorry about having tested in python,
> I will rewrite it in C later.
> 
> Both of user-a and user-b can get the same port, but one of them failed to
> call listen().

I wrote a test in C and the result was the same.
If all of the sockets bound to the same port have SO_REUSEADDR and
SO_REUSEPORT enabled, two users can bind(), but can only one user listen().

If you would think these patches are safe, I'll respin the patches with
the correct conditon of the 3rd patch.

Thanks.

=====
#include <arpa/inet.h>
#include <errno.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>


int main(void) {
	struct sockaddr_in local_addr;
	uid_t euid[2] = {1001, 1002};
	int fd[2], error, i, port;
	int len = sizeof(local_addr);
	int reuseaddr = 1, reuseport = 1;
	char ip_str[16];

	for (i = 0; i < 2; i++) {
		if (seteuid(euid[i]) != 0)
			goto error;

		fd[i] = socket(AF_INET, SOCK_STREAM, 0);

		setsockopt(fd[i], SOL_SOCKET, SO_REUSEADDR, &reuseaddr, sizeof(int));
		setsockopt(fd[i], SOL_SOCKET, SO_REUSEPORT, &reuseport, sizeof(int));

		local_addr.sin_family = AF_INET;
		local_addr.sin_addr.s_addr = inet_addr("10.0.2.15");
		local_addr.sin_port = 0;

		error = bind(fd[i], (struct sockaddr *)&local_addr, len);

		memset(&local_addr, 0, sizeof(local_addr));
		getsockname(fd[i], (struct sockaddr *)&local_addr, &len);
		inet_ntop(AF_INET, &local_addr.sin_addr, ip_str, sizeof(ip_str));
		port = ntohs(local_addr.sin_port);

		printf("euid: %d\tbound to %s:%u\n", euid[i], ip_str, port);

		if (error != 0)
			goto error;

		if (seteuid(0) != 0)
			goto error;
	}

	for (i = 0; i < 2; i++) {
		if (seteuid(euid[i]) != 0)
			goto error;

		error = listen(fd[i], 5);

		if (error < 0)
			printf("euid: %d\tlisten failed\n", euid[i]);
		else
			printf("euid: %d\tlisten succeeded\n", euid[i]);

		if (seteuid(0) != 0)
			goto error;		
	}

	return 0;
error:
	printf("error: %d, %s\n", errno, strerror(errno));
	return -1;
}
=====

===result===
# id user-a
uid=1001(user-a) gid=1001(user-a) groups=1001(user-a)
# id user-b
uid=1002(user-b) gid=1002(user-b) groups=1002(user-b)
# sysctl -w net.ipv4.ip_local_port_range="32768 32768"
[   30.060036] ip_local_port_range: prefer different parity for start/end values.
net.ipv4.ip_local_port_range = 32768 32768
# ./seteuid 
euid: 1001	bound to 10.0.2.15:32768
euid: 1002	bound to 10.0.2.15:32768
euid: 1001	listen succeeded
euid: 1002	listen failed
============
