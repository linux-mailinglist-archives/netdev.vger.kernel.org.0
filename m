Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB6E5620C2
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 19:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbiF3RC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 13:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236397AbiF3RC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 13:02:57 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082342E0B0
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 10:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656608577; x=1688144577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SVV0UOzMVwYGZ9Z7n0qyzXr2Ior3SSX4RNlwfMsSVsM=;
  b=UgoyQ+EbP/WSgTEKs3kHexXA9bkDT0snOVrjLab1u5No9AZfQn+yvcqa
   9CrvUTDLFdY7yDegNNsBMF7ONMQpJ4GMcg07XymcanZg/p5d3lJWqI9iV
   15OhRXYKKYlH6LzlLyB9hOnhmFFLw1lOEIbgS2mYgptFQmpclOhLScFfP
   8=;
X-IronPort-AV: E=Sophos;i="5.92,234,1650931200"; 
   d="scan'208";a="213560209"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1box-d-0e176545.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 30 Jun 2022 17:02:57 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1box-d-0e176545.us-east-1.amazon.com (Postfix) with ESMTPS id F0BCC8B3B9;
        Thu, 30 Jun 2022 17:02:55 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 30 Jun 2022 17:02:54 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.38) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Thu, 30 Jun 2022 17:02:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <cdleonard@gmail.com>
CC:     <davem@davemloft.net>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <sachinp@linux.ibm.com>
Subject: [BUG] docker socket mounting fails in net-next
Date:   Thu, 30 Jun 2022 10:02:45 -0700
Message-ID: <20220630170245.56423-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <5fb8d86f-b633-7552-8ba9-41e42f07c02a@gmail.com>
References: <5fb8d86f-b633-7552-8ba9-41e42f07c02a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.38]
X-ClientProxiedBy: EX13D16UWC003.ant.amazon.com (10.43.162.15) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Leonard Crestez <cdleonard@gmail.com>
Date:   Thu, 30 Jun 2022 14:20:44 +0300
> Hello,
> 
> In recent net-next it is no longer possible to mount the docker socket 
> inside a container. Test case is very simple:
> 
> docker run -v/var/run/docker.sock:/var/run/docker.sock docker docker ps
> 
> Giving containers full access to the docker daemon this way is common 
> for CI systems where all code is trusted.
> 
> I bisected this problem to commit cf2f225e2653 ("af_unix: Put a socket 
> into a per-netns hash table."). Another issue was reported in this area:
> 
> https://lore.kernel.org/netdev/20220629174729.6744-1-kuniyu@amazon.com/T/
> 
> My test scenario is extremely simple, it should easily reproduce on any 
> generic distro running docker.

Thank you for report and repro!
I can reproduce it for now.  I will send a followup patch.

Best regards,
Kuniyuki


> 
> --
> Regards,
> Leonard
