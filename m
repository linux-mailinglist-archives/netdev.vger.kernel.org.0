Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8738068E06A
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjBGSqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjBGSqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:46:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579B421948
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 10:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675795562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=f3igKs0fI4XEJ36DFwB+tAKGSkzLtpJmitEUhqpqQBI=;
        b=Z/BABa99kVsZtUUxe777rQ9jDBRblcCX1Tp1gQxMlF5m9VQKOMAPAbZaR9m5PiRdUzaynv
        NZIAD7m5JqemWrvDsVKgrzOxQlIqrdxA3eq9CsT1QY08imUhU85lM5tXczmlC3gfTwBR7I
        EgYXiYCRIMeCr2ar9opUhsnQwFH53tA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-169-EuyT_FK8P7Skw34JUfycew-1; Tue, 07 Feb 2023 13:46:00 -0500
X-MC-Unique: EuyT_FK8P7Skw34JUfycew-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DF0D1800077;
        Tue,  7 Feb 2023 18:45:59 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.110])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C69A4400D9D0;
        Tue,  7 Feb 2023 18:45:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Subject: [PATCH v4 net-next 0/4] net: introduce rps_default_mask
Date:   Tue,  7 Feb 2023 19:44:54 +0100
Message-Id: <cover.1675789134.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Real-time setups try hard to ensure proper isolation between time
critical applications and e.g. network processing performed by the
network stack in softirq and RPS is used to move the softirq 
activity away from the isolated core.

If the network configuration is dynamic, with netns and devices
routinely created at run-time, enforcing the correct RPS setting
on each newly created device allowing to transient bad configuration
became complex.

Additionally, when multi-queue devices are involved, configuring rps
in user-space on each queue easily becomes very expensive, e.g.
some setups use veths with per cpu queues.

These series try to address the above, introducing a new
sysctl knob: rps_default_mask. The new sysctl entry allows
configuring a netns-wide RPS mask, to be enforced since receive 
queue creation time without any fourther per device configuration
required.

Additionally, a simple self-test is introduced to check the 
rps_default_mask behavior.

v3 -> v4:
 - fix build warning

v2 -> v3:
 - reduce code duplication
 - rebased

Paolo Abeni (4):
  net-sysctl: factor out cpumask parsing helper
  net-sysctl: factor-out rpm mask manipulation helpers
  net: introduce default_rps_mask netns attribute
  self-tests: introduce self-tests for RPS default mask

 Documentation/admin-guide/sysctl/net.rst      |  6 ++
 include/linux/netdevice.h                     |  1 +
 net/core/dev.h                                |  2 +
 net/core/net-sysfs.c                          | 79 +++++++++++-------
 net/core/sysctl_net_core.c                    | 81 ++++++++++++++-----
 tools/testing/selftests/net/Makefile          |  1 +
 tools/testing/selftests/net/config            |  3 +
 .../testing/selftests/net/rps_default_mask.sh | 57 +++++++++++++
 8 files changed, 182 insertions(+), 48 deletions(-)
 create mode 100755 tools/testing/selftests/net/rps_default_mask.sh

-- 
2.39.1

