Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CC24EBCA7
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 10:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbiC3IW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 04:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244272AbiC3IWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 04:22:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53BB331374
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 01:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648628461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IO9KTSJjuWPlQ5rED48189b51lrDyfed52txFxWKnsw=;
        b=SITZHVIHBxdHc6mukVt/Thvc11uu70CcnGHM403By5t92/rJI7oXNH8nOr1nSRbFC6DAZV
        AR2IDTPaSf/dUbTDWDUMBvbvNcry5s35Dgbgo0eYoBtMFdvVa7hBg7Mnthf6B2KMWvJHvG
        M+Bq3UIj60q+wI3S5vi3BtTnb+VKCxg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-O-Hwf6t1Oky512CILG5EVQ-1; Wed, 30 Mar 2022 04:20:57 -0400
X-MC-Unique: O-Hwf6t1Oky512CILG5EVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E0203C11C67;
        Wed, 30 Mar 2022 08:20:51 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD97540CF8E4;
        Wed, 30 Mar 2022 08:20:49 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id A042D1C0162; Wed, 30 Mar 2022 10:20:46 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        asavkov@redhat.com, Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        dsahern@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] Upper bound kernel timers
Date:   Wed, 30 Mar 2022 10:20:44 +0200
Message-Id: <20220330082046.3512424-1-asavkov@redhat.com>
In-Reply-To: <87zglcfmcv.ffs@tglx>
References: <87zglcfmcv.ffs@tglx>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As previously discussed [1] we had a report of a regression in TCP keepaliv=
e=0D
timer where timers were up to 4 minutes late resulting in disconnects.=0D
=0D
This patchset tries to fix the problem by introducing upper bound kernel ti=
mers=0D
and making tcp keepalive timer use those.=0D
=0D
[1] https://lore.kernel.org/all/20210302001054.4qgrvnkltvkgikzr@treble/T/#u=
=0D
=0D
---=0D
Changes in v3:=0D
  - A different approach: instead of introducing upper bound timers try to=
=0D
    account for timer wheen granularity on timer (re)arming step.=0D
  - Not sure whether moving lvl calculation into a separate function is wor=
th=0D
    it.=0D
  - Had a hard time naming the upper_bount_timeout() function - any suggest=
ions=0D
    welcome.=0D
=0D
Changes in v2:=0D
  - TIMER_UPPER_BOUND flag description added as a comment in timer.h=0D
  - Code style fixes=0D
  - More elaborate commit message in timer commit=0D
=0D
Artem Savkov (2):=0D
  timer: add a function to adjust timeouts to be upper bound=0D
  net: make tcp keepalive timer upper bound=0D
=0D
 include/linux/timer.h           |  1 +=0D
 kernel/time/timer.c             | 92 ++++++++++++++++++++++++++++-----=0D
 net/ipv4/inet_connection_sock.c |  2 +-=0D
 3 files changed, 81 insertions(+), 14 deletions(-)=0D
=0D
-- =0D
2.34.1=0D
=0D

