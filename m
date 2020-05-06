Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BE11C7138
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 15:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgEFM77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:59:59 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:3969 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728081AbgEFM77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:59:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1588769999; x=1620305999;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=hzNQ5w8A6cYw04c6yt2I+QRIddI3RMJ0UShL/31p7vY=;
  b=O7wbrp3+hc61Ubb6f/QioHNMd4ypqhClz5kTK/WeNPwDYHLg0vhvW0kb
   s4sMXUe5gIYJHmiOg39qy2v2mi/E3ZkuLVa/Qt3Cgi4/qrTYHOYQcVUvW
   GCg6EBe8P7obU+wQWWDAKaS/uAeSQDmKo2qm4VDshxATOCMiER/QTuYuX
   4=;
IronPort-SDR: xgLqf4VcV6A5KTjgLiK+37uZzeJclYtKvvSu+1j2P9BEIN7sDK2pOZZGVgYvWutqahP88n8hsS
 1u5J2RKWL8Ow==
X-IronPort-AV: E=Sophos;i="5.73,359,1583193600"; 
   d="scan'208";a="43050805"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 06 May 2020 12:59:57 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-1968f9fa.us-west-2.amazon.com (Postfix) with ESMTPS id D9095A2400;
        Wed,  6 May 2020 12:59:55 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 6 May 2020 12:59:55 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.180) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 6 May 2020 12:59:48 +0000
From:   SeongJae Park <sjpark@amazon.com>
To:     "Paul E. McKenney" <paulmck@kernel.org>
CC:     SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <sj38.park@gmail.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, <snu@amazon.com>,
        <amit@kernel.org>, <stable@vger.kernel.org>
Subject: Re: Re: Re: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
Date:   Wed, 6 May 2020 14:59:26 +0200
Message-ID: <20200506125926.29844-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200505184955.GO2869@paulmck-ThinkPad-P72> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.180]
X-ClientProxiedBy: EX13D12UWA003.ant.amazon.com (10.43.160.50) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TL; DR: It was not kernel's fault, but the benchmark program.

So, the problem is reproducible using the lebench[1] only.  I carefully read
it's code again.

Before running the problem occurred "poll big" sub test, lebench executes
"context switch" sub test.  For the test, it sets the cpu affinity[2] and
process priority[3] of itself to '0' and '-20', respectively.  However, it
doesn't restore the values to original value even after the "context switch" is
finished.  For the reason, "select big" sub test also run binded on CPU 0 and
has lowest nice value.  Therefore, it can disturb the RCU callback thread for
the CPU 0, which processes the deferred deallocations of the sockets, and as a
result it triggers the OOM.

We confirmed the problem disappears by offloading the RCU callbacks from the
CPU 0 using rcu_nocbs=0 boot parameter or simply restoring the affinity and/or
priority.

Someone _might_ still argue that this is kernel problem because the problem
didn't occur on the old kernels prior to the Al's patches.  However, setting
the affinity and priority was available because the program received the
permission.  Therefore, it would be reasonable to blame the system
administrators rather than the kernel.

So, please ignore this patchset, apology for making confuse.  If you still has
some doubts or need more tests, please let me know.

[1] https://github.com/LinuxPerfStudy/LEBench
[2] https://github.com/LinuxPerfStudy/LEBench/blob/master/TEST_DIR/OS_Eval.c#L820
[3] https://github.com/LinuxPerfStudy/LEBench/blob/master/TEST_DIR/OS_Eval.c#L822


Thanks,
SeongJae Park
