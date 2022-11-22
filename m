Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A34633E5E
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbiKVOFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiKVOFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:05:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F53D20354
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 06:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669125797;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RhgdRkAbSgjlCLQ/dwJTtIG3mug5NVLJS7j9FGtckkU=;
        b=PJt5Q2AIOmXntOZT2www+EgtMCqw6Flrs0r6T7BL8BqKnpLtSHtAOTqrVVSqRTXeYX5mRX
        4YBkITM4YoMP5BC9qeU7aMIhpig8jUCBdRRgnw8E81KVTJxWd9LquPkmTM/acNa8VMoCMX
        8H5MKi92UNHidKu/WbirfUfO9u/0w3A=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-187-GvE4aIjuPjWke4fcVW1efA-1; Tue, 22 Nov 2022 09:03:10 -0500
X-MC-Unique: GvE4aIjuPjWke4fcVW1efA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23C762A5956D;
        Tue, 22 Nov 2022 14:03:10 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.16.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7654040C6EC6;
        Tue, 22 Nov 2022 14:03:09 +0000 (UTC)
From:   Aaron Conole <aconole@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, dev@openvswitch.org,
        Eelco Chaudron <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [RFC net-next 0/6] Allow excluding sw flow key from upcalls
Date:   Tue, 22 Nov 2022 09:03:01 -0500
Message-Id: <20221122140307.705112-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Userspace applications can choose to completely ignore the kernel provided
flow key and instead regenerate a fresh key for processing in userspace.
Currently, userspace ovs-vswitchd does this in some instances (for example,
MISS upcall command).  This means that kernel spends time to copy and send
the flow key into userspace without any benefit to the system.

Introduce a way for userspace to tell kernel not to send the flow key.
This lets userspace and kernel space save time and memory pressure.

This patch set is quite a bit larger because it introduces the ability to
decode a sw flow key into a compatible datapath-string.  We use this as a
method of implementing a test to show that the feature is working by
decoding and dumping the flow (to make sure we capture the correct packet).

Aaron Conole (6):
  openvswitch: exclude kernel flow key from upcalls
  selftests: openvswitch: add interface support
  selftests: openvswitch: add flow dump support
  selftests: openvswitch: adjust datapath NL message
  selftests: openvswitch: add upcall support
  selftests: openvswitch: add exclude support for packet commands

 include/uapi/linux/openvswitch.h              |    6 +
 net/openvswitch/datapath.c                    |   26 +-
 net/openvswitch/datapath.h                    |    2 +
 .../selftests/net/openvswitch/openvswitch.sh  |  101 +-
 .../selftests/net/openvswitch/ovs-dpctl.py    | 1069 ++++++++++++++++-
 5 files changed, 1183 insertions(+), 21 deletions(-)

-- 
2.34.3

