Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363ED60CA52
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbiJYKua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232437AbiJYKu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:50:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D48B2DAB3
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666695024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pNiueuEunuGnI0CMSpWBepCg2v1habx1MbJneeWWfi4=;
        b=i5tMDy4iaNTzcMq1M49g7rvSaHF6I6jinu5wBStToiBE42fjdB6k9ZtXdDs8aPdaKNFZgU
        XblxdpN5pl2j2ZI7gOqpNOnTi2HO/ZTQH4jvu5S9mcipLlr3MOBxHU5C5YwNkzceUN3OWe
        8TSfp7qnO+G3ZB1ACIRUneZUfl1JWpQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-0zY3L0u9NJqOuWlKaIeevw-1; Tue, 25 Oct 2022 06:50:20 -0400
X-MC-Unique: 0zY3L0u9NJqOuWlKaIeevw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31FF9811E67;
        Tue, 25 Oct 2022 10:50:20 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.8.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 52FA52027061;
        Tue, 25 Oct 2022 10:50:19 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Kevin Sprague <ksprague0711@gmail.com>, dev@openvswitch.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH v2 net 0/2]  openvswitch: syzbot splat fix and introduce selftest
Date:   Tue, 25 Oct 2022 06:50:16 -0400
Message-Id: <20221025105018.466157-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot recently caught a splat when dropping features from
openvswitch datapaths that are in-use.  The WARN() call is
definitely too large a hammer for the situation, so change
to pr_warn.

Second patch in the series introduces a new selftest suite which
can help show that an issue is fixed.  This change might be
more suited to net-next tree, so it has been separated out
as an additional patch and can be either applied to either tree
based on preference.

Aaron Conole (2):
  openvswitch: switch from WARN to pr_warn
  selftests: add openvswitch selftest suite

 MAINTAINERS                                   |   1 +
 net/openvswitch/datapath.c                    |   3 +-
 tools/testing/selftests/Makefile              |   1 +
 .../selftests/net/openvswitch/Makefile        |  13 +
 .../selftests/net/openvswitch/openvswitch.sh  | 218 +++++++++++
 .../selftests/net/openvswitch/ovs-dpctl.py    | 351 ++++++++++++++++++
 6 files changed, 586 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/openvswitch/Makefile
 create mode 100755 tools/testing/selftests/net/openvswitch/openvswitch.sh
 create mode 100644 tools/testing/selftests/net/openvswitch/ovs-dpctl.py

-- 
2.34.3

