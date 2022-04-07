Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 269724F7839
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242340AbiDGHy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242323AbiDGHyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:54:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CFC8F1C42D9
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649317975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ioK6OvofKyIpy+vHQcfZR1zFpndRrQMZLUPba8CRcNw=;
        b=El9GrOm5iKQFBCior3ofya21rKyTrUfVQUdYOu8SU/blKittPt5vGwjrK2+b9+2Ki7F103
        hLYTva3SwQzmnEUlqMGnH0V9Hz+fJHftoroHR+W3KQzJncZyutwB+Q+NkL1eVOIBSvRA0G
        wV4Kj8kM1H+2OBDU+XaPYV0gscPB3cM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-52-yDek7xRGOhKsMC1QW0IqbQ-1; Thu, 07 Apr 2022 03:52:51 -0400
X-MC-Unique: yDek7xRGOhKsMC1QW0IqbQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DC06380409B;
        Thu,  7 Apr 2022 07:52:51 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 25E271121330;
        Thu,  7 Apr 2022 07:52:45 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id DC12B1C00FD; Thu,  7 Apr 2022 09:52:43 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Anna-Maria Behnsen <anna-maria@linutronix.de>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH v4 0/2] Upper bound kernel timers
Date:   Thu,  7 Apr 2022 09:52:40 +0200
Message-Id: <20220407075242.118253-1-asavkov@redhat.com>
In-Reply-To: <871qyb35q4.ffs@tglx>
References: <871qyb35q4.ffs@tglx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As previously discussed [1] we had a report of a regression in TCP keepalive
timer where timers were up to 4 minutes late resulting in disconnects.

This patchset tries to fix the problem by introducing upper bound kernel timers
and making tcp keepalive timer use those.

[1] https://lore.kernel.org/all/20210302001054.4qgrvnkltvkgikzr@treble/T/#u

---
Changes in v4:
  - Drop any attempts to be smart when calculating timer adjustment and always
    substract LVL_GRAN so that base clock lag won't be such a problem. This
    means that in some cases we will always be early, but all we want is not to
    be late.

Changes in v3:
  - A different approach: instead of introducing upper bound timers try to
    account for timer wheen granularity on timer (re)arming step.
  - Not sure whether moving lvl calculation into a separate function is worth
    it.
  - Had a hard time naming the upper_bount_timeout() function - any suggestions
    welcome.

Changes in v2:
  - TIMER_UPPER_BOUND flag description added as a comment in timer.h
  - Code style fixes
  - More elaborate commit message in timer commit

Artem Savkov (2):
  timer: add a function to adjust timeouts to be upper bound
  net: make tcp keepalive timer upper bound

 include/linux/timer.h           |  1 +
 kernel/time/timer.c             | 68 ++++++++++++++++++++++++++-------
 net/ipv4/inet_connection_sock.c |  2 +-
 3 files changed, 57 insertions(+), 14 deletions(-)

-- 
2.34.1

