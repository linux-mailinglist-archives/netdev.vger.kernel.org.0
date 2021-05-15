Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE5023815A9
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 06:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhEOEFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 00:05:04 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:52722 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhEOEFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 00:05:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621051432; x=1652587432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lKlm11oTruNcGp45nu4kx52EdjVLFovLOhlr/dJBTTE=;
  b=GdT9gLOr0nkW9jtjUpUt6zlmcBh4nh5a866pVIGTesc2qIMHUx20tT5D
   W4c6V5I8sGQp3gqzHSNxzDATA0Vig+6EAxEsjv8KyiOhIxpHErTmuPLoT
   e68NKlthC4zY6AloTjDCHKz5zAc9nFH2dog8zW9TRmyKMSd3WAF6Ztgxa
   g=;
X-IronPort-AV: E=Sophos;i="5.82,300,1613433600"; 
   d="scan'208";a="113785288"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 15 May 2021 04:03:50 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 308C7C0334;
        Sat, 15 May 2021 04:03:49 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:03:48 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.216) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:03:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 02/11] tcp: Add num_closed_socks to struct sock_reuseport.
Date:   Sat, 15 May 2021 13:03:40 +0900
Message-ID: <20210515040340.80160-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210515004918.rhtnsbvowtp6mudj@kafai-mbp>
References: <20210515004918.rhtnsbvowtp6mudj@kafai-mbp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.216]
X-ClientProxiedBy: EX13D40UWC002.ant.amazon.com (10.43.162.191) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Fri, 14 May 2021 17:49:18 -0700
> On Mon, May 10, 2021 at 12:44:24PM +0900, Kuniyuki Iwashima wrote:
> > As noted in the following commit, a closed listener has to hold the
> > reference to the reuseport group for socket migration. This patch adds a
> > field (num_closed_socks) to struct sock_reuseport to manage closed sockets
> > within the same reuseport group. Moreover, this and the following commits
> > introduce some helper functions to split socks[] into two sections and keep
> > TCP_LISTEN and TCP_CLOSE sockets in each section. Like a double-ended
> > queue, we will place TCP_LISTEN sockets from the front and TCP_CLOSE
> > sockets from the end.
> > 
> >   TCP_LISTEN---------->       <-------TCP_CLOSE
> >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> >   | 0 | 1 |  ...  | i |  ...  | j |  ...  | k |
> >   +---+---+  ---  +---+  ---  +---+  ---  +---+
> > 
> >   i = num_socks - 1
> >   j = max_socks - num_closed_socks
> >   k = max_socks - 1
> > 
> > This patch also extends reuseport_add_sock() and reuseport_grow() to
> > support num_closed_socks.
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Thank you!
