Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA286C699C
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 14:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbjCWNgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 09:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjCWNgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 09:36:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD89298F9
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 06:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679578510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=n7AMhYl/psk6mNgSSEral9AUOQ+fKTl8zukF3yGM9fI=;
        b=CZUNQiZzFHS20gCs+nemHSani9u5pVBvEh8gdhixT+ZQKNUoUvsaeMeq1tF4iwBaI1VPbl
        Q5tyPO1F8LqzZj0nzTnDVq8i24x677/Wz3p3Ea5wVUVdP9tSVmOwKqBRG260E4nd9avOq8
        5RIfbKMK+EsiOM5xOj02Wg2q7V+OJvI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-Z898XBJPNTaK8Wm6N1xOTA-1; Thu, 23 Mar 2023 09:35:07 -0400
X-MC-Unique: Z898XBJPNTaK8Wm6N1xOTA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D6CD3C0ED70;
        Thu, 23 Mar 2023 13:35:06 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.225.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B73CF1410F1C;
        Thu, 23 Mar 2023 13:35:04 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 0/4] net/sched: act_tunnel_key: add support for TUNNEL_DONT_FRAGMENT
Date:   Thu, 23 Mar 2023 14:34:39 +0100
Message-Id: <cover.1679569719.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- patch 1 extends TC tunnel_key action to add support for TUNNEL_DONT_FRAGMENT 
- patch 2 extends tdc to skip tests when iproute2 support is missing
- patch 3 adds a tdc test case to verify functionality of the control plane
- patch 4 adds a net/forwarding test case to verify functionality of the data plane

v1->v2:
 - split patchset to have test cases in separate patches (thanks to
   Pedro Tammela)
 - change TCA_TUNNEL_KEY_NO_FRAG attribute, so the it is a flag istead
   of u8 (thanks to Jakub Kicinski)
 - add missing TEST_PROGS assignment (thanks to Jakub Kicinski)

Davide Caratti (4):
  net/sched: act_tunnel_key: add support for "don't fragment"
  selftests: tc-testing: extend the "skip" property
  selftests: tc-testing: add tunnel_key "nofrag" test case
  selftests: forwarding: add tunnel_key "nofrag" test case

 include/uapi/linux/tc_act/tc_tunnel_key.h     |   1 +
 net/sched/act_tunnel_key.c                    |   5 +
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_tunnel_key.sh | 161 ++++++++++++++++++
 .../creating-testcases/AddingTestCases.txt    |   4 +-
 .../tc-tests/actions/tunnel_key.json          |  25 +++
 tools/testing/selftests/tc-testing/tdc.py     |  21 ++-
 7 files changed, 211 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_tunnel_key.sh

-- 
2.39.2

