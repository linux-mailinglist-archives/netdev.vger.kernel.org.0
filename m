Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B32634004F
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 08:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhCRHfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 03:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhCRHf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 03:35:26 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE040C06174A
        for <netdev@vger.kernel.org>; Thu, 18 Mar 2021 00:35:25 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616052922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fNpgBIfZj7cZtQhHFcbUOdV660Af3gyKNIhJMLqhBT4=;
        b=aMi+JuVjRFeJuBVAybnqr5WFwWLci2xl5Ztpjn7JHbvZwsbdowMD/oiW/jaxs48/2wjzWT
        ozMkNONMlmbQFhcqzgciD/RQGU//CuhJT15ydlCk2v4UM36BkxtHYYbLhU/IeF7GLNPms+
        FZ/WjvfPdRRYQY7fjy6glvB4S1qttSiZXCCfvXM55SkjGEg7f/QlZP4HFo95xxFP03YQSu
        cu+0R+2o3ljgZTCQqaTYA6pJhnzv0u4LMbYoxGPkShbqshZ8tromrBzVxvO09Mr2H1WECd
        0GQLw+Qlh0lkfx0FuRuVEbm7bbBReZC41qrbLeCVlHVQQPjzpbEJaKVrWuN/Xw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616052922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fNpgBIfZj7cZtQhHFcbUOdV660Af3gyKNIhJMLqhBT4=;
        b=2ie2EzwrhS45Pli4LMqsft1nTP6DE96hJl70nZf6gdfiqTVZwcL1MHrZOkr/Lo5qBgTtVi
        WVIfw2qp0FT6oRBw==
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 0/1] taprio: Handle short intervals and large packets
Date:   Thu, 18 Mar 2021 08:34:54 +0100
Message-Id: <20210318073455.17281-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

there is a problem with the software implementation of TAPRIO and TCP
communication. When using short intervals e.g. below one millisecond, large
packets won't be transmitted. That's because the software implementation takes
the packet length and calculates the transmission time. If the transmission time
is larger than the configured interval, no packet will be transmitted. Fix that
by segmenting the skb for the software implementation.

Tested with software only and full hardware offloading applied using iperf3.

Vinicius, do you mind testing as well?

Changes since RFC:

 * Move segmentation, so that timestamps for tx assisted mode are
   calculated for the segments
 * Skip it for the full hardware offloading case

Previous versions:

 * https://lkml.kernel.org/netdev/20210312092823.1429-1-kurt@linutronix.de/

Kurt Kanzenbach (1):
  taprio: Handle short intervals and large packets

 net/sched/sch_taprio.c | 64 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 10 deletions(-)

-- 
2.20.1

