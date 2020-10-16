Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F052E290380
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 12:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395510AbgJPKve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 06:51:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30499 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2395506AbgJPKve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 06:51:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602845492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=GkfFNwAqoW9BuR2LY2PKLxlnrijd81H/UT1PERKb7QE=;
        b=MkCL/yHFwOB1XgsNHMUbLBuIuOkCeig/C+fGnB5lvb2ws/H03EebC7D8YsJlESML23Acza
        ELdAawGL3jTUuVbiK37b+Cy63DiMEMaoTFmG6+XZQBI6pagCuTqQbEaamR/8OxVeytgN0a
        6eTO1vynkZwqGkCL7Dtffbjd9aCExcg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-mgPwAOS5MUi2z70sNwLCPA-1; Fri, 16 Oct 2020 06:51:30 -0400
X-MC-Unique: mgPwAOS5MUi2z70sNwLCPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71BA1102120B;
        Fri, 16 Oct 2020 10:51:29 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-168.ams2.redhat.com [10.36.112.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B65960E1C;
        Fri, 16 Oct 2020 10:51:28 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [RFC PATCH 0/2] tcp: factor out a couple of helpers
Date:   Fri, 16 Oct 2020 12:51:06 +0200
Message-Id: <cover.1602840570.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming improvement in MPTCP subflows management will require to keep write
data enqueued at the MPTCP level. As a side effect, such data could be sent
via orphaned TCP subflows after close().

To implement the above MPTCP needs to cope directly with memory allocation
failures in do_tcp_sendpages(). The solution proposed in patch 1/2 
is to factor-out the relevant slice of do_tcp_sendpages().

Other possible alternatives could be:
- duplicating the relevant code inside MPTCP (will require exposing a few
  additional TCP helpers) 
or
- add an explicit check for orphaned socket in do_tcp_sendpages()

Additionally, due to the above, we will need to dispose of already orphaned
TCP subflows, avoiding racing with tcp_done(). We need to check the
subflow status and destroy it atomically. The solution proposed in patch 2/2
is to factor-out the unlocked body of tcp_close().

These changes are part of a quite larger MPTCP series, with all the other
patches touching only MPTCP code. To hopefully simplify the review, such
patches are not included here. Please advice if you prefer otherwise
- e.g. the whole series as RFC.

Paolo Abeni (2):
  tcp: factor out tcp_build_frag()
  tcp: factor out __tcp_close() helper

 include/net/tcp.h |   4 ++
 net/ipv4/tcp.c    | 128 +++++++++++++++++++++++++++-------------------
 2 files changed, 78 insertions(+), 54 deletions(-)

-- 
2.26.2

