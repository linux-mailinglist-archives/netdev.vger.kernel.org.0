Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFDE46F1D64
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 19:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346194AbjD1R1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 13:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346239AbjD1R1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 13:27:45 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B5C4EC7;
        Fri, 28 Apr 2023 10:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1682702858; x=1714238858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EB1JFeiQIaiAd+BcemyeU1EieGRkJBzun23zhdJkDaw=;
  b=aCPUNh3LbRr8q4S8x5/m5xkA5v1rhnPOEbiCtvcKTqdKFYgynetyFjJ5
   BQhdpYu+OOAiX8i4RTRuXInAHRVnKSFPt2Y/TQq4JzZZCtdQ0YDAj/TuM
   A2MM3E6o0UnHND7pL7PjonbhjM7QVjJeNBsN3BV0CYqaS3aNI+ISF7wIZ
   Y=;
X-IronPort-AV: E=Sophos;i="5.99,235,1677542400"; 
   d="scan'208";a="209268543"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 17:27:35 +0000
Received: from EX19MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com (Postfix) with ESMTPS id 0744B845B3;
        Fri, 28 Apr 2023 17:27:32 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 28 Apr 2023 17:27:32 +0000
Received: from 88665a182662.ant.amazon.com (10.106.101.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 28 Apr 2023 17:27:29 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stephen@networkplumber.org>
CC:     <johan.hedberg@gmail.com>, <linux-bluetooth@vger.kernel.org>,
        <luiz.dentz@gmail.com>, <marcel@holtmann.org>,
        <netdev@vger.kernel.org>, <kuniyu@amazon.com>
Subject: Re: Fw: [Bug 217383] New: Bluetooth: L2CAP: possible data race in __sco_sock_close()
Date:   Fri, 28 Apr 2023 10:27:21 -0700
Message-ID: <20230428172721.56267-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230428085239.1cb74647@hermes.local>
References: <20230428085239.1cb74647@hermes.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.101.39]
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Stephen Hemminger <stephen@networkplumber.org>
Date:   Fri, 28 Apr 2023 08:52:39 -0700
> Begin forwarded message:
> 
> Date: Fri, 28 Apr 2023 10:22:28 +0000
> From: bugzilla-daemon@kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 217383] New: Bluetooth: L2CAP: possible data race in __sco_sock_close()
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=217383
> 
>             Bug ID: 217383
>            Summary: Bluetooth: L2CAP: possible data race in
>                     __sco_sock_close()
>            Product: Networking
>            Version: 2.5
>           Hardware: All
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: islituo@gmail.com
>         Regression: No
> 
> Our static analysis tool finds a possible data race in the l2cap protocol
> in Linux 6.3.0-rc7:
> 
> In most calling contexts, the variable sk->sk_socket is accessed
> with holding the lock sk->sk_callback_lock. Here is an example:
> 
>   l2cap_sock_accept() --> Line 346 in net/bluetooth/l2cap_sock.c
>       bt_accept_dequeue() --> Line 368 in net/bluetooth/l2cap_sock.c
>           sock_graft() --> Line 240 in net/bluetooth/af_bluetooth.c
>               write_lock_bh(&sk->sk_callback_lock); --> Line 2081 in
> include/net/sock.h (Lock sk->sk_callback_lock)
>               sk_set_socket() --> Line 2084 in include/net/sock.h
>                   sk->sk_socket = sock; --> Line 2054 in include/net/sock.h
> (Access sk->sk_socket)
> 
> However, in the following calling context:
> 
>   sco_sock_shutdown() --> Line 1227 in net/bluetooth/sco.c
>       __sco_sock_close() --> Line 1243 in net/bluetooth/sco.c
>           BT_DBG(..., sk->sk_socket); --> Line 431 in net/bluetooth/sco.c
> (Access sk->sk_socket)

Those two sockets have different proto, BTPROTO_L2CAP and BTPROTO_SCO.
Also, we cannot shutdown() for not-yet-accepted socket, and both
l2cap_sock_accept() and sco_sock_shutdown() take lock_sock().


> 
> the variable sk->sk_socket is accessed without holding the lock
> sk->sk_callback_lock, and thus a data race may occur.
> 
> Reported-by: BassCheck <bass@buaa.edu.cn>
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are the assignee for the bug.
