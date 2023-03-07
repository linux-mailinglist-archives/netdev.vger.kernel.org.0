Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B31656AD386
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 01:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCGA46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 19:56:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjCGA45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 19:56:57 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE86B4D625
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 16:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678150616; x=1709686616;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=N/C3Y5pzRvo7wBoP0uW3mPJBJ+iAoy4QrLO7EEgHu8Y=;
  b=VdGNQJCeVtgYh6SfGkL5EHxWIcNtRif4b0e8/jmeLQNPVoElvuc8/bvK
   pENWY0DTYtlWNDnhfQF4l2hoT2DYryqQoR6lB4xoCaKn3CzsFXgXxKQWR
   Vaou5dZKvnXSYEGxQENVAstT9tEtaLoOy8ZmFQrSE1rnWIbuNMo+vwBRH
   o=;
X-IronPort-AV: E=Sophos;i="5.98,238,1673913600"; 
   d="scan'208";a="315492567"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 00:56:50 +0000
Received: from EX13MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com (Postfix) with ESMTPS id 208C580F41;
        Tue,  7 Mar 2023 00:56:49 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB002.ant.amazon.com (10.43.161.202) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Tue, 7 Mar 2023 00:56:48 +0000
Received: from 88665a182662.ant.amazon.com (10.187.170.29) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 7 Mar 2023 00:56:46 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <aahringo@redhat.com>
CC:     <cluster-devel@redhat.com>, <cong.wang@bytedance.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <peilin.ye@bytedance.com>, <kuniyu@amazon.com>
Subject: Re: introduce function wrapper for sk_data_ready() call?
Date:   Mon, 6 Mar 2023 16:56:38 -0800
Message-ID: <20230307005638.76597-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <CAK-6q+hVu8xST=zreEdH3ne+kUY-zGriRwHAR9OpCxTwPFwOSw@mail.gmail.com>
References: <CAK-6q+hVu8xST=zreEdH3ne+kUY-zGriRwHAR9OpCxTwPFwOSw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.29]
X-ClientProxiedBy: EX19D038UWC002.ant.amazon.com (10.13.139.238) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 6 Mar 2023 07:47:02 -0500
> 
> Hi,
> 
> I saw that in 6.3-rc1 the following patch introduced something in dlm
> socket application handling 40e0b0908142 ("net/sock: Introduce
> trace_sk_data_ready()"). I am asking myself if we could instead
> introduce a wrapper in net/ protocol family implementations and they
> do such trace event calls there inside the socket implementation
> instead of letting the application layer do it. It looks pretty
> generic for me and it does not trace any application specific
> information.

I think you cannot apply the same logic to some functions which call
trace_sk_data_ready() twice, e.g. subflow_data_ready, tls_data_ready().

Then, only such functions need an additional trace_sk_data_ready(),
which is not clean, I think.

Thanks,
Kuniyuki


> 
> I did something similar for sk_error_report(), see e3ae2365efc1 ("net:
> sock: introduce sk_error_report").
> 
> Thanks.
> 
> - Alex
