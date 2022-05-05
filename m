Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B7C51C06E
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379252AbiEENWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379077AbiEENWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:22:00 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.129.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A43414C7AA
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 06:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651756700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y4U5A3QRLZZuYGkS/ZCvQGsfk/VtHZAdLZlUMBaLLSs=;
        b=Zhh/KFFvRRwJJFEQR5t5Rm6wxPCeX5j4vv7gyi5MabDbEx0tv45y5bhq3fJWUFVXy2n9+c
        EzQ22X9IVxQQynIxDTW3OkRrlMUTRO1xuDAyh42QpYAwfv/fw2vdMQik3h1IwltVWVxBQn
        2f9cJgz7cR82uKStdJC+03Q0nj5igFk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-139-x5RIIweAMa-7fGeTvQYMFA-1; Thu, 05 May 2022 09:18:14 -0400
X-MC-Unique: x5RIIweAMa-7fGeTvQYMFA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53086397968C;
        Thu,  5 May 2022 13:18:14 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 159987B64;
        Thu,  5 May 2022 13:18:14 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id ED0F51C0223; Thu,  5 May 2022 15:18:12 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Anna-Maria Behnsen <anna-maria@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH v5 0/2] Upper bound kernel timers
Date:   Thu,  5 May 2022 15:18:09 +0200
Message-Id: <20220505131811.3744503-1-asavkov@redhat.com>
In-Reply-To: <87zgkwjtq2.ffs@tglx>
References: <87zgkwjtq2.ffs@tglx>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
Changes in v5:
  - The least intrusive and most straightforward approach. This avoids touching
    any of existing code. The timeout supplied is always reduced by a known
    timer wheel error margin of 12.5%.
  - Commit message adjustments.

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
 kernel/time/timer.c             | 14 ++++++++++++++
 net/ipv4/inet_connection_sock.c |  2 +-
 3 files changed, 16 insertions(+), 1 deletion(-)

-- 
2.34.1

