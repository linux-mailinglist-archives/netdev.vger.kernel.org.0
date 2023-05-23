Return-Path: <netdev+bounces-4487-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E96470D1C8
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:53:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07F5F28118F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 02:53:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008F94C98;
	Tue, 23 May 2023 02:53:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E974315A0
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:53:43 +0000 (UTC)
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E25DCA;
	Mon, 22 May 2023 19:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1684810423; x=1716346423;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wGfPfOgkUe4uOICPdB8msh2VfBA1m4x1APSIg9XveEc=;
  b=iBJFK5qq/pjt7hDGpyGz6+9+HjRC3xqOMK/9RQqKKenZHwr8/ExPUzcW
   n5RvLqVz1tLbSKWKNPQ9oZLzMBvMQmzXI9l8r3sZ+fKdqYaZ/66H9sBNF
   Nj2oMd7Xsmr4Ap83FWXo6E8TVvP6HqiVI5bnZ/e7MJJImVyjqnK3HU8oo
   4=;
X-IronPort-AV: E=Sophos;i="6.00,185,1681171200"; 
   d="scan'208";a="327787396"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2023 02:53:31 +0000
Received: from EX19D020EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com (Postfix) with ESMTPS id 3FA1D40D7B;
	Tue, 23 May 2023 02:53:29 +0000 (UTC)
Received: from EX19D026EUB004.ant.amazon.com (10.252.61.64) by
 EX19D020EUA003.ant.amazon.com (10.252.50.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 23 May 2023 02:53:28 +0000
Received: from uc3ecf78c6baf56.ant.amazon.com (10.119.183.60) by
 EX19D026EUB004.ant.amazon.com (10.252.61.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 23 May 2023 02:53:25 +0000
From: Andrew Paniakin <apanyaki@amazon.com>
To: Andrew Paniakin <apanyaki@amazon.com>
CC: <luizcap@amazon.com>, <benh@amazon.com>, Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik
	<kadlec@blackhole.kfki.hu>, "David S. Miller" <davem@davemloft.net>,
	<netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix register ordering
Date: Mon, 22 May 2023 19:53:12 -0700
Message-ID: <20230523025312.1690992-1-apanyaki@amazon.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230523023514.1672418-1-apanyaki@amazon.com>
References:
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.183.60]
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
 EX19D026EUB004.ant.amazon.com (10.252.61.64)
Precedence: Bulk
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Please ignore this patch as I forgot to add the stable ML.
I will re-send it.

On Mon, 22 May 2023 19:35:14 -0700 Andrew Paniakin <apanyaki@amazon.com> wrote:

> From: Florian Westphal <fw@strlen.de>
> 
> commit d209df3e7f7002d9099fdb0f6df0f972b4386a63 upstream
> 

