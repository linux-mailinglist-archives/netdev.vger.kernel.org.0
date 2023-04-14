Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 929226E2423
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 15:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjDNNSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 09:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDNNSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 09:18:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C834C1BCE
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 06:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681478275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=faG4ngp9zarM9MWRIRINoyw+JZqEQUFiPnJHj9gIPT8=;
        b=H2JZdqSylVJSgG32aHm0AGaeuZ8WMZg7jPEHW4I/8tOOAIhWiZ4d9Y4tWFiNGUO4KPAYMU
        +Q47yz43p8p8BY6ZAX8t1HUjIWpMrF+50eyTuPIgCiMVVC7Z8Z16pCrvtXaIPnx1FkTz1m
        yNu8Xa+fd8vZYlTJq1ndtk11RiMDQyE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-z0w0qiGjOjqabwvnaW_m7g-1; Fri, 14 Apr 2023 09:17:51 -0400
X-MC-Unique: z0w0qiGjOjqabwvnaW_m7g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0212B185A78F;
        Fri, 14 Apr 2023 13:17:51 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.8.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A43CC158BB;
        Fri, 14 Apr 2023 13:17:50 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dev@openvswitch.org, Pravin Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 0/3] selftests: openvswitch: add support for testing upcall interface
Date:   Fri, 14 Apr 2023 09:17:47 -0400
Message-Id: <20230414131750.4185160-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing selftest suite for openvswitch will work for regression
testing the datapath feature bits, but won't test things like adding
interfaces, or the upcall interface.  Here, we add some additional
test facilities.

First, extend the ovs-dpctl.py python module to support the OVS_FLOW
and OVS_PACKET netlink families, with some associated messages.  These
can be extended over time, but the initial support is for more well
known cases (output, userspace, and CT).

Next, extend the test suite to test upcalls by adding a datapath,
monitoring the upcall socket associated with the datapath, and then
dumping any upcalls that are received.  Compare with expected ARP
upcall via arping.

Aaron Conole (3):
  selftests: openvswitch: add interface support
  selftests: openvswitch: add flow dump support
  selftests: openvswitch: add support for upcall testing

 .../selftests/net/openvswitch/openvswitch.sh  |   89 +-
 .../selftests/net/openvswitch/ovs-dpctl.py    | 1276 ++++++++++++++++-
 2 files changed, 1349 insertions(+), 16 deletions(-)

-- 
2.39.2

