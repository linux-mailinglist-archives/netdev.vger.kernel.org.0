Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C18731D132
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 20:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhBPTud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 14:50:33 -0500
Received: from mx.aristanetworks.com ([162.210.129.12]:59450 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhBPTub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 14:50:31 -0500
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Feb 2021 14:50:31 EST
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [10.243.128.7])
        by smtp.aristanetworks.com (Postfix) with ESMTP id 9E0D4400C84;
        Tue, 16 Feb 2021 11:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1613504351;
        bh=KzzeBl3CToKQoo8CnA55xVYHNnOE1Mri75OAXviGcJU=;
        h=Date:To:Subject:From:From;
        b=IzPgwbhGv4xxIi9ITir8JTH26SNR3V99r7mDBnsQ2M3jaQa37u4e4i2B4mqYB9Gai
         npWweKVWGJzvUMhlOBVdRMlF9m3Bx+70aBz+pEAwHOLxeOhDy8CBa1j7b+sOHUJNOh
         o0WcRgXOS1TrCk/f+bx07znjN9O/m9ZzNgxHjx7XgGB+V1FChhT9IwHMQhZ9ujvBOV
         pY4Nux49lEo0bt9AAOJv4QFxAvDuG7u0oXdE2sLy5wvoCj62+iUx7zoRegvdS2SucX
         r1+BXr68yxQVWuGQylWkMBchqAgU+5efbQFCmRFKTyJidIyCnqod1rOnOEDv81iyq+
         9JsK2xHgbuukA==
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id 88C9795C05D0; Tue, 16 Feb 2021 11:39:11 -0800 (PST)
Date:   Tue, 16 Feb 2021 11:39:11 -0800
To:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, fruggeri@arista.com
Subject: epoll: different edge-triggered behavior bewteen pipe and
 socketpair
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20210216193911.88C9795C05D0@us180.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pipe() and socketpair() have different behavior wrt edge-triggered
read epoll, in that no event is generated when data is written into
a non-empty pipe, but an event is generated if socketpair() is used
instead.
This simple modification of the epoll2 testlet from 
tools/testing/selftests/filesystems/epoll/epoll_wakeup_test.c
(it just adds a second write) shows the different behavior.
The testlet passes with pipe() but fails with socketpair() with 5.10.
They both fail with 4.19.
Is it fair to assume that 5.10 pipe's behavior is the correct one?

Thanks,
Francesco Ruggeri

/*
 *          t0
 *           | (ew)
 *          e0
 *           | (et)
 *          s0
 */
TEST(epoll2)
{
	int efd;
	int sfd[2];
	struct epoll_event e;

	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM, 0, sfd), 0);
	//ASSERT_EQ(pipe(sfd), 0);

	efd = epoll_create(1);
	ASSERT_GE(efd, 0);

	e.events = EPOLLIN | EPOLLET;
	ASSERT_EQ(epoll_ctl(efd, EPOLL_CTL_ADD, sfd[0], &e), 0);

	ASSERT_EQ(write(sfd[1], "w", 1), 1);
	EXPECT_EQ(epoll_wait(efd, &e, 1, 0), 1);

	ASSERT_EQ(write(sfd[1], "w", 1), 1);
	EXPECT_EQ(epoll_wait(efd, &e, 1, 0), 0);

	close(efd);
	close(sfd[0]);
	close(sfd[1]);
}


