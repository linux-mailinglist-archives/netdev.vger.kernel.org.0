Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF8F654981
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 00:54:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiLVXyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 18:54:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLVXyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 18:54:52 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCAD26492
        for <netdev@vger.kernel.org>; Thu, 22 Dec 2022 15:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1671753291; x=1703289291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nhlk/j+EtQz7lTU2S0roOahGdsDJ5E4Ht1YUOhGgrkg=;
  b=pc4z0ZNJz9vwsOEZ93HTQdOQNuxigVwtOQ8M7DvJpdD9H3vChliAyKp1
   pumPIoDkNxBsNXdmm+5EN6BLuCtTQ7l1OZ+X0fsyaRau0qMvDs4KzB8DP
   hTFnIKR7dPB2/6yIMKFcctg/c28T9Rt3KjRVbM4U8KV0kKrhs/iSSBoLO
   A=;
X-IronPort-AV: E=Sophos;i="5.96,266,1665446400"; 
   d="scan'208";a="164500864"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2022 23:54:48 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com (Postfix) with ESMTPS id 7F806863A9;
        Thu, 22 Dec 2022 23:54:45 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 22 Dec 2022 23:54:44 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.134) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Thu, 22 Dec 2022 23:54:41 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <joannelkoong@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>,
        <jirislaby@kernel.org>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH RFC net 2/2] tcp: Add selftest for bind() and TIME_WAIT.
Date:   Fri, 23 Dec 2022 08:54:32 +0900
Message-ID: <20221222235432.96615-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAJnrk1Zc5Zz7c5CY8t14-Mg3SPmGFwCB6TFbPHfSSkexFJW8uw@mail.gmail.com>
References: <CAJnrk1Zc5Zz7c5CY8t14-Mg3SPmGFwCB6TFbPHfSSkexFJW8uw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D44UWC004.ant.amazon.com (10.43.162.209) To
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

From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Thu, 22 Dec 2022 13:41:11 -0800
> On Wed, Dec 21, 2022 at 7:14 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
> >
> > bhash2 split the bind() validation logic into wildcard and non-wildcard
> > cases.  Let's add a test to catch the same regression.
> >
> > Before the previous patch:
> >
> >   # ./bind_timewait
> >   TAP version 13
> >   1..2
> >   # Starting 2 tests from 3 test cases.
> >   #  RUN           bind_timewait.localhost.1 ...
> >   # bind_timewait.c:87:1:Expected ret (0) == -1 (-1)
> >   # 1: Test terminated by assertion
> >   #          FAIL  bind_timewait.localhost.1
> >   not ok 1 bind_timewait.localhost.1
> >   #  RUN           bind_timewait.addrany.1 ...
> >   #            OK  bind_timewait.addrany.1
> >   ok 2 bind_timewait.addrany.1
> >   # FAILED: 1 / 2 tests passed.
> >   # Totals: pass:1 fail:1 xfail:0 xpass:0 skip:0 error:0
> >
> > After:
> >
> >   # ./bind_timewait
> >   TAP version 13
> >   1..2
> >   # Starting 2 tests from 3 test cases.
> >   #  RUN           bind_timewait.localhost.1 ...
> >   #            OK  bind_timewait.localhost.1
> >   ok 1 bind_timewait.localhost.1
> >   #  RUN           bind_timewait.addrany.1 ...
> >   #            OK  bind_timewait.addrany.1
> >   ok 2 bind_timewait.addrany.1
> >   # PASSED: 2 / 2 tests passed.
> >   # Totals: pass:2 fail:0 xfail:0 xpass:0 skip:0 error:0
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> > ---
> >  tools/testing/selftests/net/.gitignore      |  1 +
> >  tools/testing/selftests/net/bind_timewait.c | 93 +++++++++++++++++++++
> >  2 files changed, 94 insertions(+)
> >  create mode 100644 tools/testing/selftests/net/bind_timewait.c
> >
> > diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> > index 9cc84114741d..a6911cae368c 100644
> > --- a/tools/testing/selftests/net/.gitignore
> > +++ b/tools/testing/selftests/net/.gitignore
> > @@ -1,5 +1,6 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >  bind_bhash
> > +bind_timewait
> >  csum
> >  cmsg_sender
> >  diag_uid
> > diff --git a/tools/testing/selftests/net/bind_timewait.c b/tools/testing/selftests/net/bind_timewait.c
> > new file mode 100644
> > index 000000000000..2d40403128ff
> > --- /dev/null
> > +++ b/tools/testing/selftests/net/bind_timewait.c
> > @@ -0,0 +1,93 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright Amazon.com Inc. or its affiliates. */
> > +
> > +#include "../kselftest_harness.h"
> 
> nit: Not sure if this matters or not, but from looking at the other
> selftests/net it seems like the convention is to have relative path
> #include defined below absolute path #includes.

Will fix.


> 
> > +
> > +#include <sys/socket.h>
> > +#include <netinet/in.h>
> > +#include <netinet/tcp.h>
> 
> nit: i don't think we need this netinet/tcp.h include

Good catch, I was seeing an old man page.


> 
> > +
> > +FIXTURE(bind_timewait)
> > +{
> > +       struct sockaddr_in addr;
> > +       socklen_t addrlen;
> > +};
> > +
> > +FIXTURE_VARIANT(bind_timewait)
> > +{
> > +       __u32 addr_const;
> > +};
> > +
> > +FIXTURE_VARIANT_ADD(bind_timewait, localhost)
> > +{
> > +       .addr_const = INADDR_LOOPBACK
> > +};
> > +
> > +FIXTURE_VARIANT_ADD(bind_timewait, addrany)
> > +{
> > +       .addr_const = INADDR_ANY
> > +};
> > +
> > +FIXTURE_SETUP(bind_timewait)
> > +{
> > +       self->addr.sin_family = AF_INET;
> > +       self->addr.sin_port = 0;
> > +       self->addr.sin_addr.s_addr = htonl(variant->addr_const);
> > +       self->addrlen = sizeof(self->addr);
> > +}
> > +
> > +FIXTURE_TEARDOWN(bind_timewait)
> > +{
> > +}
> > +
> > +void create_timewait_socket(struct __test_metadata *_metadata,
> > +                           FIXTURE_DATA(bind_timewait) *self)
> > +{
> > +       int server_fd, client_fd, child_fd, ret;
> > +       struct sockaddr_in addr;
> > +       socklen_t addrlen;
> > +
> > +       server_fd = socket(AF_INET, SOCK_STREAM, 0);
> > +       ASSERT_GT(server_fd, 0);
> 
> If any of these assertions fail, do we leak fds because we don't get
> to calling the close()s at the end of this function? Do we need to
> have the fds cleaned up in the teardown fixture function?

I think exit() cleans up fds in the case.  IIUC, the parent process
catches SIGABRT in __wait_for_test(), but the child does not call
FIXTURE_TEARDOWN().

Thank you!


> 
> > +
> > +       ret = bind(server_fd, (struct sockaddr *)&self->addr, self->addrlen);
> > +       ASSERT_EQ(ret, 0);
> > +
> > +       ret = listen(server_fd, 1);
> > +       ASSERT_EQ(ret, 0);
> > +
> > +       ret = getsockname(server_fd, (struct sockaddr *)&self->addr, &self->addrlen);
> > +       ASSERT_EQ(ret, 0);
> > +
> > +       client_fd = socket(AF_INET, SOCK_STREAM, 0);
> > +       ASSERT_GT(client_fd, 0);
> > +
> > +       ret = connect(client_fd, (struct sockaddr *)&self->addr, self->addrlen);
> > +       ASSERT_EQ(ret, 0);
> > +
> > +       addrlen = sizeof(addr);
> > +       child_fd = accept(server_fd, (struct sockaddr *)&addr, &addrlen);
> > +       ASSERT_GT(child_fd, 0);
> > +
> > +       close(child_fd);
> > +       close(client_fd);
> > +       close(server_fd);
> > +}
> > +
> > +TEST_F(bind_timewait, 1)
> > +{
> > +       int fd, ret;
> > +
> > +       create_timewait_socket(_metadata, self);
> > +
> > +       fd = socket(AF_INET, SOCK_STREAM, 0);
> > +       ASSERT_GT(fd, 0);
> > +
> > +       ret = bind(fd, (struct sockaddr *)&self->addr, self->addrlen);
> > +       ASSERT_EQ(ret, -1);
> > +       ASSERT_EQ(errno, EADDRINUSE);
> > +
> > +       close(fd);
> > +}
> > +
> > +TEST_HARNESS_MAIN
> > --
> > 2.30.2
