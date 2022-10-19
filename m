Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4F8604FA7
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiJSSbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbiJSSbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:31:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF4215F30D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666204262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6UYO0POKEGMi/jghAsOmJKKHztGAXU7FUcThnC6RfTA=;
        b=NbsRH6ZtOrOxMfAXl3stS9JPN3VB2enlyHjnvMluTNtso3yAt6cI2Wdk/UTyqPRJGAQGUy
        b5YA5TT8UIlDuXa4zcFjJrgWetbfYGEX3HuEyDNd4Wcp/O+Iuu8+t/gQVUqXM4f0VUUGU6
        t15SosRZGIoTW+kQtLCx3a49/IzyAq8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-Rz0dEvSSOR6hgf_t4QGlBg-1; Wed, 19 Oct 2022 14:30:56 -0400
X-MC-Unique: Rz0dEvSSOR6hgf_t4QGlBg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60620381A729;
        Wed, 19 Oct 2022 18:30:55 +0000 (UTC)
Received: from RHTPC1VM0NT.redhat.com (unknown [10.22.8.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9992849BB63;
        Wed, 19 Oct 2022 18:30:54 +0000 (UTC)
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
Subject: [PATCH net 0/2] openvswitch: syzbot splat fix and introduce selftest
Date:   Wed, 19 Oct 2022 14:30:52 -0400
Message-Id: <20221019183054.105815-1-aconole@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
 .../selftests/net/openvswitch/openvswitch.sh  | 216 +++++++++
 .../selftests/net/openvswitch/ovs-dpctl.py    | 411 ++++++++++++++++++
 6 files changed, 644 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/openvswitch/Makefile
 create mode 100755 tools/testing/selftests/net/openvswitch/openvswitch.sh
 create mode 100644 tools/testing/selftests/net/openvswitch/ovs-dpctl.py

-- 
2.34.3

