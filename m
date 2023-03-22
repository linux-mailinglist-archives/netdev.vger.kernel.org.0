Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18CD56C3F3D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 01:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCVAoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 20:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCVAoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 20:44:07 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B661B2F6;
        Tue, 21 Mar 2023 17:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679445846; x=1710981846;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iOvNHogHw969vKlcxixxLuHiGmXJLT1uyknvGNdo50Q=;
  b=OW74Xcz7D3IYkuiX45zolQ1tp2FPrkpYD4Kq1XNfWh6y9LO124MGHE1f
   wOMKBE/ikyKSzh1aFB/hJdFyAgIcUDXCFo4WR2xYhqoaF3zeRFKRVv7Ot
   Eg/hyFtMKERNytNB9aWPC5qQt0APLXxXXTUO9wmygK4ZRs5hWokgZKgZ5
   M=;
X-IronPort-AV: E=Sophos;i="5.98,280,1673913600"; 
   d="scan'208";a="196002635"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 00:44:02 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id 29B4580EF2;
        Wed, 22 Mar 2023 00:43:57 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Wed, 22 Mar 2023 00:43:57 +0000
Received: from 88665a182662.ant.amazon.com (10.94.217.231) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 22 Mar 2023 00:43:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <aleksandr.mikhalitsyn@canonical.com>
CC:     <arnd@arndb.de>, <brauner@kernel.org>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <edumazet@google.com>,
        <keescook@chromium.org>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <leon@kernel.org>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mzxreary@0pointer.de>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 1/3] scm: add SO_PASSPIDFD and SCM_PIDFD
Date:   Tue, 21 Mar 2023 17:43:42 -0700
Message-ID: <20230322004342.29904-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230321183342.617114-2-aleksandr.mikhalitsyn@canonical.com>
References: <20230321183342.617114-2-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.94.217.231]
X-ClientProxiedBy: EX19D039UWB004.ant.amazon.com (10.13.138.57) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=0.3 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date:   Tue, 21 Mar 2023 19:33:40 +0100
> Implement SCM_PIDFD, a new type of CMSG type analogical to SCM_CREDENTIALS,
> but it contains pidfd instead of plain pid, which allows programmers not
> to care about PID reuse problem.
> 
> Idea comes from UAPI kernel group:
> https://uapi-group.org/kernel-features/
> 
> Big thanks to Christian Brauner and Lennart Poettering for productive
> discussions about this.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Lennart Poettering <mzxreary@0pointer.de>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks,
Kuniyuki
