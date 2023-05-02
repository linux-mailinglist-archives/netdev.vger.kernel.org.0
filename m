Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4239F6F48D6
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 19:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbjEBRGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 13:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbjEBRGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 13:06:09 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0996E79;
        Tue,  2 May 2023 10:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683047149; x=1714583149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xbqdNl8h1rl6JFu/pYxFlGTf9KekIUwOgllFPNCblnU=;
  b=ZvF3GTNb/8Zw7xQivs8RTzmwNn8JgxZlxNgunOmP76DKr5Haz2qcrM7w
   xh3jDfxVFnHRj1qSaHxE4+KkZvh04oq9qugKeCbqumtRzKfFtL3k66MC0
   hMEqOTWQ7NGFZAxjFS0p5oI4g8Nntt8efasdxhOEclHh9DR787HMj+r0l
   U=;
X-IronPort-AV: E=Sophos;i="5.99,244,1677542400"; 
   d="scan'208";a="210257010"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2023 17:05:36 +0000
Received: from EX19MTAUWB002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com (Postfix) with ESMTPS id 10FC281CEB;
        Tue,  2 May 2023 17:05:29 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 2 May 2023 17:05:28 +0000
Received: from 88665a182662.ant.amazon.com (10.106.100.8) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 2 May 2023 17:05:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <ilia.gavrilov@infotecs.ru>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-sctp@vger.kernel.org>,
        <lucien.xin@gmail.com>, <lvc-project@linuxtesting.org>,
        <marcelo.leitner@gmail.com>, <netdev@vger.kernel.org>,
        <nhorman@tuxdriver.com>, <pabeni@redhat.com>,
        <simon.horman@corigine.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH net v2] sctp: fix a potential buffer overflow in sctp_sched_set_sched()
Date:   Tue, 2 May 2023 10:05:16 -0700
Message-ID: <20230502170516.39760-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230502130316.2680585-1-Ilia.Gavrilov@infotecs.ru>
References: <20230502130316.2680585-1-Ilia.Gavrilov@infotecs.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.106.100.8]
X-ClientProxiedBy: EX19D031UWA002.ant.amazon.com (10.13.139.96) To
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

From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Date:   Tue, 2 May 2023 13:03:24 +0000
> The 'sched' index value must be checked before accessing an element
> of the 'sctp_sched_ops' array. Otherwise, it can lead to buffer overflow.

OOB access ?
But it's not true because it does not happen in the first place.

> 
> Note that it's harmless since the 'sched' parameter is checked before
> calling 'sctp_sched_set_sched'.
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> ---
> V2:
>  - Change the order of local variables 
>  - Specify the target tree in the subject
>  net/sctp/stream_sched.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
> index 330067002deb..4d076a9b8592 100644
> --- a/net/sctp/stream_sched.c
> +++ b/net/sctp/stream_sched.c
> @@ -146,18 +146,19 @@ static void sctp_sched_free_sched(struct sctp_stream *stream)
>  int sctp_sched_set_sched(struct sctp_association *asoc,
>  			 enum sctp_sched_type sched)
>  {
> -	struct sctp_sched_ops *n = sctp_sched_ops[sched];
>  	struct sctp_sched_ops *old = asoc->outqueue.sched;
>  	struct sctp_datamsg *msg = NULL;
> +	struct sctp_sched_ops *n;
>  	struct sctp_chunk *ch;
>  	int i, ret = 0;
>  
> -	if (old == n)
> -		return ret;
> -
>  	if (sched > SCTP_SS_MAX)
>  		return -EINVAL;

I'd just remove this check instead because the same test is done
in the caller side, sctp_setsockopt_scheduler(), and this errno
is never returned.

This unnecessary test confuses a reader like sched could be over
SCTP_SS_MAX here.

Since the OOB access does not happen, I think this patch should
go to net-next without the Fixes tag after the merge window.

Thanks,
Kuniyuki


>  
> +	n = sctp_sched_ops[sched];
> +	if (old == n)
> +		return ret;
> +
>  	if (old)
>  		sctp_sched_free_sched(&asoc->stream);
>  
> -- 
> 2.30.2
