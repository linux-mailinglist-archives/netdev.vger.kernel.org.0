Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2801759C661
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237493AbiHVSbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237686AbiHVSbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:31:06 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC9B167E8
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 11:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661193065; x=1692729065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xKjoHPHfT3SNjM3GEPH8NfjEMrG8ZlBmiIDh4EolsrY=;
  b=vX7VFRTayCNR/i1ReW6L9kXgYDCMGoRNxl138xaYh5Kyzv5c4LkAISUL
   N3Fr3zVpbNROEa24uAMy+U9YKKXukB9jKsZ5R3UvXahzV+j9uI9HtSFmJ
   1uaBLajHU5jzS58wRGFrExq+S9Z5DGS8gnduqsrbIm3jgWylTqmH5xm3u
   I=;
X-IronPort-AV: E=Sophos;i="5.93,255,1654560000"; 
   d="scan'208";a="236167246"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1box-d-0e176545.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 18:30:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1box-d-0e176545.us-east-1.amazon.com (Postfix) with ESMTPS id 0E3509341B;
        Mon, 22 Aug 2022 18:30:51 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 22 Aug 2022 18:30:50 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 22 Aug 2022 18:30:48 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kuba@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuni1840@gmail.com>,
        <kuniyu@amazon.com>, <matthias.tafelmeier@gmx.net>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH v3 net 02/17] net: Fix data-races around weight_p and dev_weight_[rt]x_bias.
Date:   Mon, 22 Aug 2022 11:30:41 -0700
Message-ID: <20220822183041.19637-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220819170301.43675f1a@kernel.org>
References: <20220819170301.43675f1a@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D17UWB003.ant.amazon.com (10.43.161.42) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jakub Kicinski <kuba@kernel.org>
Date:   Fri, 19 Aug 2022 17:03:01 -0700
> On Thu, 18 Aug 2022 11:26:38 -0700 Kuniyuki Iwashima wrote:
> > -	dev_rx_weight = weight_p * dev_weight_rx_bias;
> > -	dev_tx_weight = weight_p * dev_weight_tx_bias;
> > +	WRITE_ONCE(dev_rx_weight,
> > +		   READ_ONCE(weight_p) * READ_ONCE(dev_weight_rx_bias));
> > +	WRITE_ONCE(dev_tx_weight,
> > +		   READ_ONCE(weight_p) * READ_ONCE(dev_weight_tx_bias));
> 
> Is there some locking on procfs writes? Otherwise one interrupted write
> may get overtaken by another and we'll end up with inconsistent values.

Thanks for catching!
procfs doesn't provide locking for writes, so we need a mutex like other
knobs.


> OTOH if there is some locking we shouldn't have to protect weight_p
> here.
