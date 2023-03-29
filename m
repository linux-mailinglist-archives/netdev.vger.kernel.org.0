Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3F56CD712
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjC2J4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjC2J4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:56:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0107FDD
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 02:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680083758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=4lHbo4R2P9xPbcKjWgR5bNDsfFG9dmaeeResTItH6bc=;
        b=XV9cvkoz+N0jCm/jQIwQkSTc/8JAxbPF6GAJm6Ku6I4NWHAESDIsnawMy9rqdEyb4uW1di
        p9eHrpgJCASBFNR5ktpPzu6VMF4SplHEH01W7ERv1owtNN2zWagZ8CtWVVzm3CGPfL71gT
        1ieLk2MKM/q70sodTlDN5NDBgpFUG08=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-aLOpQ4qCPYW4fTbo97tf9A-1; Wed, 29 Mar 2023 05:55:55 -0400
X-MC-Unique: aLOpQ4qCPYW4fTbo97tf9A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D4433C10148;
        Wed, 29 Mar 2023 09:55:54 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.226.60])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C02E718EC2;
        Wed, 29 Mar 2023 09:55:52 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 0/4] net/sched: act_tunnel_key: add support for TUNNEL_DONT_FRAGMENT
Date:   Wed, 29 Mar 2023 11:54:51 +0200
Message-Id: <cover.1680082990.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
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

v3->v4:
 - remove misleading "failure" wording in the printout (thanks to Pedro
   Tammela)
 - fix permissions (+x) of net/forwarding kselftest 

v2->v3:
 - introduce new "dependsOn" property instead of extending "skip"
   (suggested by Pedro Tammela)
 - fix wrong indentation (thanks to Jakub Kicinski)

v1->v2:
 - split patchset to have test cases in separate patches (thanks to
   Pedro Tammela)
 - change TCA_TUNNEL_KEY_NO_FRAG attribute, so that it is a flag istead
   of u8 (thanks to Jakub Kicinski)
 - add missing TEST_PROGS assignment (thanks to Jakub Kicinski)

Davide Caratti (4):
  net/sched: act_tunnel_key: add support for "don't fragment"
  selftests: tc-testing: add "depends_on" property to skip tests
  selftests: tc-testing: add tunnel_key "nofrag" test case
  selftests: forwarding: add tunnel_key "nofrag" test case

 include/uapi/linux/tc_act/tc_tunnel_key.h     |   1 +
 net/sched/act_tunnel_key.c                    |   5 +
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_tunnel_key.sh | 161 ++++++++++++++++++
 .../creating-testcases/AddingTestCases.txt    |   2 +
 .../tc-tests/actions/tunnel_key.json          |  25 +++
 tools/testing/selftests/tc-testing/tdc.py     |  13 ++
 7 files changed, 208 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_tunnel_key.sh

-- 
2.39.2

