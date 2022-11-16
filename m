Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFAE462C611
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 18:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbiKPRNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 12:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234201AbiKPRNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 12:13:09 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5245158BDE
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 09:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1668618789; x=1700154789;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RTrP3CxnYhPNtO/dD+lKUvdyRLlZvEOZ39TRRx6b9mU=;
  b=S5ft1FGhSkKgQpFNRtpoTyrWiGG5PE5/1PSs1sG1UAoJ5YH8qQWyT0Ti
   FuateG4IIdzbLuTC1l5MtycEqVNEvHgYoF4HMG7sic9ZtwMPnF9AjwK4s
   FcZhNMoXOhcYRBomjDt78VOe6cRFIp4uyufz8m/3WtoSDyd4flBZ21n6z
   k=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 17:13:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-m6i4x-5eae960a.us-west-2.amazon.com (Postfix) with ESMTPS id 02A1441796;
        Wed, 16 Nov 2022 17:13:03 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 16 Nov 2022 17:13:03 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.14) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Wed, 16 Nov 2022 17:13:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <stephen@networkplumber.org>
CC:     <netdev@vger.kernel.org>
Subject: Fw: [Bug 216694] New: [Syzkaller & bisect] There is inet_csk_get_port WARNING in v6.1-rc4 kernel
Date:   Wed, 16 Nov 2022 09:12:53 -0800
Message-ID: <20221116171253.47853-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221116085854.0dcfa44d@hermes.local>
References: <20221116085854.0dcfa44d@hermes.local>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.14]
X-ClientProxiedBy: EX13D27UWB003.ant.amazon.com (10.43.161.195) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Stephen Hemminger <stephen@networkplumber.org>
Date:   Wed, 16 Nov 2022 08:58:54 -0800
> Begin forwarded message:
> 
> Date: Wed, 16 Nov 2022 08:44:26 +0000
> From: bugzilla-daemon@kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 216694] New: [Syzkaller & bisect] There is inet_csk_get_port WARNING in v6.1-rc4 kernel
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=216694
> 
>             Bug ID: 216694
>            Summary: [Syzkaller & bisect] There is inet_csk_get_port
>                     WARNING in v6.1-rc4 kernel
>            Product: Networking
>            Version: 2.5
>     Kernel Version: v6.1-rc4
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: pengfei.xu@intel.com
>         Regression: No
> 
> "WARNING inet_csk_get_port" is found in v6.1-rc4 kernel.
> 
> And first bad commit is: 28044fc1d4953b07acec0da4d2fc4784c57ea6fb
> "net: Add a bhash2 table hashed by port and address"
> 
> Reproduced code from syzkaller, kconfig and full information is in the link:
> https://github.com/xupengfe/syzkaller_logs/tree/main/221108_215733_inet_csk_get_port
> 
> 
> Related discusstion link in LKML community:
> https://lore.kernel.org/lkml/Y2xyHM1fcCkh9AKU@xpf.sh.intel.com/

I'm working on the issue and will post a fix.

https://lore.kernel.org/netdev/20221110201925.96741-1-kuniyu@amazon.com/
https://lore.kernel.org/netdev/20221110203432.97668-1-kuniyu@amazon.com/

Thank you!
