Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC274E60EE
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 10:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349141AbiCXJQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 05:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343943AbiCXJQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 05:16:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C64C3F30E
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 02:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648113305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OJgscDC9GXXgE5qcEpR/61U9wQz24uDUwpyxgmBF8s0=;
        b=EmnSNLyue7YsoaOE+oCUqket0+DEpPEcGoLKZUMgN2JAEIu2NGxQTAapG5r7g4IAdBExDH
        bR0p7DmrwSZmx9xkw3/FBeqqbSM78ZGQeaoQPOnOQEKpO2f8bWXxgx4iyUlJ0UPVutLJO3
        VLk/eELqExDD0SGNOs+tIiEf46fIbi0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-ChabECUPNA6WQ63NdpyE_w-1; Thu, 24 Mar 2022 05:15:04 -0400
X-MC-Unique: ChabECUPNA6WQ63NdpyE_w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8156F1066559;
        Thu, 24 Mar 2022 09:15:03 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 31BCB403176;
        Thu, 24 Mar 2022 09:15:03 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 346E41C02C1; Thu, 24 Mar 2022 10:15:02 +0100 (CET)
From:   Artem Savkov <asavkov@redhat.com>
To:     tglx@linutronix.de, jpoimboe@redhat.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH v2 0/2] Upper bound mode for kernel timers
Date:   Thu, 24 Mar 2022 10:14:58 +0100
Message-Id: <20220324091500.2638745-1-asavkov@redhat.com>
In-Reply-To: <20220323184026.wkj55y55jbeumngs@treble>
References: <20220323184026.wkj55y55jbeumngs@treble>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
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

Changes in v2:
  - TIMER_UPPER_BOUND flag description added as a comment in timer.h
  - Code style fixes
  - More elaborate commit message in timer commit

Artem Savkov (2):
  timer: introduce upper bound timers
  net: make tcp keepalive timer upper bound

 include/linux/timer.h           |  6 +++++-
 kernel/time/timer.c             | 36 ++++++++++++++++++++-------------
 net/ipv4/inet_connection_sock.c |  2 +-
 3 files changed, 28 insertions(+), 16 deletions(-)

-- 
2.34.1

