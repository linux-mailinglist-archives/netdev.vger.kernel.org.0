Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B87123A60
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 00:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfLQXA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 18:00:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36090 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725886AbfLQXA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 18:00:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576623625;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TeyfSfcy2/gKXzO/2RTn9jZ1RablsVYGzjK20YCcvwg=;
        b=cBaUd7POVqka53ltZ4jJZIi8W2I/QYEa5h3vaRJ4CGk10nWWCn46jsmqf75+4qI5tPiHIK
        kuU/5oz7pWaAqFht3XobHCpEhW3U+QhCvmijy7Pp+KhufplAJlv3puuQ+z8abeo2uDH1gZ
        6TUPWJoRml7ZptNw5cSh66hUiGSNkD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-EqlvVBC0MqKnahVQa9ATkw-1; Tue, 17 Dec 2019 18:00:21 -0500
X-MC-Unique: EqlvVBC0MqKnahVQa9ATkw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 212F88024CF;
        Tue, 17 Dec 2019 23:00:20 +0000 (UTC)
Received: from new-host-5.redhat.com (ovpn-204-91.brq.redhat.com [10.40.204.91])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 87D9C60C18;
        Tue, 17 Dec 2019 23:00:17 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Vlad Buslov <vladbu@mellanox.com>, Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH net 0/2] net/sched: cls_u32: fix refcount leak
Date:   Wed, 18 Dec 2019 00:00:03 +0100
Message-Id: <cover.1576623250.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

a refcount leak in the error path of u32_change() has been recently
introduced. It can be observed with the following commands:

  [root@f31 ~]# tc filter replace dev eth0 ingress protocol ip prio 97 \
  > u32 match ip src 127.0.0.1/32 indev notexist20 flowid 1:1 action drop
  RTNETLINK answers: Invalid argument
  We have an error talking to the kernel
  [root@f31 ~]# tc filter replace dev eth0 ingress protocol ip prio 98 \
  > handle 42:42 u32 divisor 256
  Error: cls_u32: Divisor can only be used on a hash table.
  We have an error talking to the kernel
  [root@f31 ~]# tc filter replace dev eth0 ingress protocol ip prio 99 \
  > u32 ht 47:47
  Error: cls_u32: Specified hash table not found.
  We have an error talking to the kernel

they all legitimately return -EINVAL; however, they leave semi-configured
filters at eth0 tc ingress:

 [root@f31 ~]# tc filter show dev eth0 ingress
 filter protocol ip pref 97 u32 chain 0
 filter protocol ip pref 97 u32 chain 0 fh 800: ht divisor 1
 filter protocol ip pref 98 u32 chain 0
 filter protocol ip pref 98 u32 chain 0 fh 801: ht divisor 1
 filter protocol ip pref 99 u32 chain 0
 filter protocol ip pref 99 u32 chain 0 fh 802: ht divisor 1

With older kernels, filters were unconditionally considered empty (and
thus de-refcounted) on the error path of ->change().
After commit 8b64678e0af8 ("net: sched: refactor tp insert/delete for
concurrent execution"), filters were considered empty when the walk()
function didn't set 'walker.stop' to 1.
Finally, with commit 6676d5e416ee ("net: sched: set dedicated tcf_walker
flag when tp is empty"), tc filters are considered empty unless the walke=
r
function is called with a non-NULL handle. This last change doesn't fit
cls_u32 design, because at least the "root hnode" is (almost) always
non-NULL, as it's allocated in u32_init().

- patch 1/2 is a proposal to restore the original kernel behavior, where
  no filter was installed in the error path of u32_change().
- patch 2/2 adds tdc selftests that can be ued to verify the correct
  behavior of u32 in the error path of ->change().

Davide Caratti (2):
  net/sched: cls_u32: fix refcount leak in the error path of
    u32_change()
  tc-testing: initial tdc selftests for cls_u32

 net/sched/cls_u32.c                           |  25 +++
 .../tc-testing/tc-tests/filters/tests.json    |  22 --
 .../tc-testing/tc-tests/filters/u32.json      | 205 ++++++++++++++++++
 3 files changed, 230 insertions(+), 22 deletions(-)
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/u=
32.json

--=20
2.23.0

