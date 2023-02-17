Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14AD69AB80
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 13:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjBQM36 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 07:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjBQM34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 07:29:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFEB6607E
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 04:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676636949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZSy58O64DJOv7D1jHMu2v+VHVqpH566rNe66Y/TgWVg=;
        b=TXdQwcByq0t5337H+PlKjeoF9ZhVPsx4hYCPefO+skWQeaHXNGe5sHQIHtbLJHi6IZdKU1
        c2dP5Qy6z7nQEjUDJBZidsby+wBJbIDe4+fS6TVk8MvUFTpCK65zWbajFP3uyZPBMU8nrc
        5LMYeGO86nVgTcmqKrRN+F3+GawMkPc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-V_HMX_JuNgGx85YlomDdWA-1; Fri, 17 Feb 2023 07:29:05 -0500
X-MC-Unique: V_HMX_JuNgGx85YlomDdWA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 505C2101A521;
        Fri, 17 Feb 2023 12:29:05 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DA3A404CD84;
        Fri, 17 Feb 2023 12:29:04 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH v2 net-next 0/2] net: default_rps_mask follow-up
Date:   Fri, 17 Feb 2023 13:28:48 +0100
Message-Id: <cover.1676635317.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch namespacify the setting. In the common case, once
proper isolation is in place in the main namespace, forwarding
to/from each child netns will allways happen on the desidered CPUs.

Any additional RPS stage inside the child namespace will not provide
additional isolation and could hurt performance badly if picking a
CPU on a remote node.

The 2nd patch adds more self-tests coverage.

Paolo Abeni (2):
  net: make default_rps_mask a per netns attribute
  self-tests: more rps self tests

 include/linux/netdevice.h                     |  1 -
 include/net/netns/core.h                      |  5 ++
 net/core/net-sysfs.c                          | 23 ++++++---
 net/core/sysctl_net_core.c                    | 51 ++++++++++++++-----
 .../testing/selftests/net/rps_default_mask.sh | 41 ++++++++++-----
 5 files changed, 88 insertions(+), 33 deletions(-)

-- 
2.39.1

