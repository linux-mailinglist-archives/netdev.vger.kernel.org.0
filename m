Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8877D4E511E
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 12:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243791AbiCWLSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 07:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239168AbiCWLSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 07:18:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B9F378922
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 04:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648034208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mnoovn4iIxQv1+UzkN6Wleh5OeGZAIr5QweFyWnmYAk=;
        b=Pf3Hj9VT6q6TQFNY6F6UQJg1xQ/RK5snvY45ZJmPFfKZwm5OvWd1P1CHDYo5+zTilmSMBV
        zjsycCdCo+h0Pz+KQ+FQaZKVrrCCdXZmHWR0BIqwaUfAxJD51RkYGZ+/nCVOSqiZOM4JPQ
        UMYmyQVjeocHO6o5tBGkk7tOCFHnvh8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-dR4WZOF0Nc-6z-9VayGMMA-1; Wed, 23 Mar 2022 07:16:47 -0400
X-MC-Unique: dR4WZOF0Nc-6z-9VayGMMA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C90D318A6581;
        Wed, 23 Mar 2022 11:16:46 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5BF3112132C;
        Wed, 23 Mar 2022 11:16:46 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 49D591C0223; Wed, 23 Mar 2022 12:16:45 +0100 (CET)
From:   Artem Savkov <asavkov@redhat.com>
To:     tglx@linutronix.de, jpoimboe@redhat.com, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH 0/2] Upper bound mode for kernel timers
Date:   Wed, 23 Mar 2022 12:16:40 +0100
Message-Id: <20220323111642.2517885-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

Artem Savkov (2):
  timer: introduce upper bound timers
  net: make tcp keepalive timer upper bound

 include/linux/timer.h           |  3 ++-
 kernel/time/timer.c             | 36 ++++++++++++++++++++-------------
 net/ipv4/inet_connection_sock.c |  2 +-
 3 files changed, 25 insertions(+), 16 deletions(-)

-- 
2.34.1

