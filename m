Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 861E76B52CB
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 22:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbjCJV0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 16:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbjCJV0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 16:26:06 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F56FDDB0F;
        Fri, 10 Mar 2023 13:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678483565; x=1710019565;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vrPJVdcUit+S8FGoD3UECE020RNm4lbU5S9sF3HNvCE=;
  b=CBrpRl1dUmdTFtWzEzOj2ZCPZ8MYi6+wh6aqVkd4JlzpPs0Oiq/+SSZE
   kpIaEO0xM4tBf1wBG0o8ViLqsRu3VWvANq1a0+i0c4DfafwJX9GzAKNX8
   qKkWjtRkzxeyip7DlpdXFUC7rqlpeweDuq173gAA22AOFOCOO76aY6cEt
   I=;
X-IronPort-AV: E=Sophos;i="5.98,250,1673913600"; 
   d="scan'208";a="317225453"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 21:25:59 +0000
Received: from EX19MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-3ef535ca.us-west-2.amazon.com (Postfix) with ESMTPS id ABED260D8B;
        Fri, 10 Mar 2023 21:25:58 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 10 Mar 2023 21:25:58 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.20) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Fri, 10 Mar 2023 21:25:55 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <pholzing@redhat.com>
CC:     <kuba@kernel.org>, <martin.lau@kernel.org>,
        <netdev@vger.kernel.org>, <regressions@lists.linux.dev>,
        <stable@vger.kernel.org>, <kuniyu@amazon.com>
Subject: Re: [REGRESSION] v6.1+ bind() does not fail with EADDRINUSE if dual stack is bound
Date:   Fri, 10 Mar 2023 13:25:47 -0800
Message-ID: <20230310212547.25491-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com>
References: <e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.20]
X-ClientProxiedBy: EX19D044UWB003.ant.amazon.com (10.13.139.168) To
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

From:   Paul Holzinger <pholzing@redhat.com>
Date:   Fri, 10 Mar 2023 17:01:31 +0100
> Hi all,
> 
> there seems to be a regression which allows you to bind the same port 
> twice when the first bind call bound to all ip addresses (i. e. dual stack).
> 
> A second bind call for the same port will succeed if you try to bind to 
> a specific ipv4 (e. g. 127.0.0.1), binding to 0.0.0.0 or an ipv6 address 
> fails correctly with EADDRINUSE.
> 
> I included a small c program below to show the issue. Normally the 
> second bind call should fail, this was the case before v6.1.
> 
> 
> I bisected the regression to commit 5456262d2baa ("net: Fix incorrect 
> address comparison when searching for a bind2 bucket").
> 
> I also checked that the issue is still present in v6.3-rc1.

Thanks for the detailed report.

It seems we should take care of the special case in
inet_bind2_bucket_match_addr_any().

I'll fix it.

Thanks,
Kuniyuki

> 
> 
> Original report: https://github.com/containers/podman/issues/17719
> 
> #regzbot introduced: 5456262d2baa
> 
> 
> ```
> 
> #include <sys/socket.h>
> #include <sys/un.h>
> #include <stdlib.h>
> #include <stdio.h>
> #include <netinet/in.h>
> #include <unistd.h>
> 
> int main(int argc, char *argv[])
> {
>      int ret, sock1, sock2;
>      struct sockaddr_in6 addr;
>      struct sockaddr_in addr2;
> 
>      sock1 = socket(AF_INET6, SOCK_STREAM, 0);
>      if (sock1 == -1)
>      {
>          perror("socket1");
>          exit(1);
>      }
>      sock2 = socket(AF_INET, SOCK_STREAM, 0);
>      if (sock2 == -1)
>      {
>          perror("socket2");
>          exit(1);
>      }
> 
>      memset(&addr, 0, sizeof(addr));
>      addr.sin6_family = AF_INET6;
>      addr.sin6_addr = in6addr_any;
>      addr.sin6_port = htons(8080);
> 
>      memset(&addr2, 0, sizeof(addr2));
>      addr2.sin_family = AF_INET;
>      addr2.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
>      addr2.sin_port = htons(8080);
> 
>      ret = bind(sock1, (struct sockaddr *)&addr, sizeof(addr));
>      if (ret == -1)
>      {
>          perror("bind1");
>          exit(1);
>      }
>      printf("bind1 ret: %d\n", ret);
> 
>      if ((listen(sock1, 5)) != 0)
>      {
>          perror("listen1");
>          exit(1);
>      }
> 
>      ret = bind(sock2, (struct sockaddr *)&addr2, sizeof(addr2));
>      if (ret == -1)
>      {
>          perror("bind2");
>          exit(1);
>      }
>      printf("bind2 ret: %d\n", ret);
> 
>      if ((listen(sock2, 5)) != 0)
>      {
>          perror("listen2");
>          exit(1);
>      }
> 
>      // uncomment pause() to see with ss -tlpn the bound ports
>      // pause();
> 
>      return 0;
> }
> 
> ```
> 
> 
> Best regards,
> 
> Paul
