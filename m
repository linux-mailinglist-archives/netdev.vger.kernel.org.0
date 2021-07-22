Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57683D264D
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 16:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhGVOOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 10:14:16 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:60692 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhGVONw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 10:13:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1626965667; x=1658501667;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DiE62y6EAG8RCk8KyorSc4tTd/WOy3cYzu/SgE8mgA0=;
  b=qHaRnzQW9A5gQFzuxZaPDfaS8NV40t0NHwW0r7IC1NqBYQ+o3fIwgr5E
   quk3APmnYh2Jl1GLDPbQ5bGYTQxPtD72c8SVdjje7dPm2UpR+cIcbQSvJ
   DRUIgK4bMbHDnys+6ZMNp0gg57ibIyNvpryEVhPkumj8UCDBcVSL8iw6R
   Q=;
X-IronPort-AV: E=Sophos;i="5.84,261,1620691200"; 
   d="scan'208";a="128619845"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-76e0922c.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 22 Jul 2021 14:54:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2c-76e0922c.us-west-2.amazon.com (Postfix) with ESMTPS id D9153E2A38;
        Thu, 22 Jul 2021 14:54:22 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 22 Jul 2021 14:54:21 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.66) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Thu, 22 Jul 2021 14:54:17 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <edumazet@google.com>, <kernel-team@fb.com>,
        <ncardwell@google.com>, <netdev@vger.kernel.org>,
        <ycheng@google.com>, <yhs@fb.com>, <kuniyu@amazon.co.jp>
Subject: Re: [PATCH v2 bpf-next 0/8] bpf: Allow bpf tcp iter to do bpf_(get|set)sockopt
Date:   Thu, 22 Jul 2021 23:53:41 +0900
Message-ID: <20210722145341.72566-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210701200535.1033513-1-kafai@fb.com>
References: <20210701200535.1033513-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D23UWA003.ant.amazon.com (10.43.160.194) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Thu, 1 Jul 2021 13:05:35 -0700
> This set is to allow bpf tcp iter to call bpf_(get|set)sockopt.
> 
> With bpf-tcp-cc, new algo rollout happens more often.  Instead of
> restarting the applications to pick up the new tcp-cc, this set
> allows the bpf tcp iter to call bpf_(get|set)sockopt(TCP_CONGESTION).
> It is not limited to TCP_CONGESTION, the bpf tcp iter can call
> bpf_(get|set)sockopt() with other options.  The bpf tcp iter can read
> into all the fields of a tcp_sock, so there is a lot of flexibility
> to select the desired sk to do setsockopt(), e.g. it can test for
> TCP_LISTEN only and leave the established connections untouched,
> or check the addr/port, or check the current tcp-cc name, ...etc.
> 
> Patch 1-4 are some cleanup and prep work in the tcp and bpf seq_file.
> 
> Patch 5 is to have the tcp seq_file iterate on the
> port+addr lhash2 instead of the port only listening_hash.
> 
> Patch 6 is to have the bpf tcp iter doing batching which
> then allows lock_sock.  lock_sock is needed for setsockopt.
> 
> Patch 7 allows the bpf tcp iter to call bpf_(get|set)sockopt.

I have a comment on the first patch, but the series looks good to me.

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
