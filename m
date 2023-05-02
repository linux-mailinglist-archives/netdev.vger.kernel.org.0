Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7884B6F43CB
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 14:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbjEBMZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 08:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233833AbjEBMZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 08:25:17 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55943A90;
        Tue,  2 May 2023 05:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683030316; x=1714566316;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AfQaRre7+aO2SPhdUxafi6pwxZAOj0wcrW0qgwl0DRA=;
  b=vz5Qenk7OuaTD3XCR5GkCwsy22N3JNHkA2fqPju9RelJQvh3ecdD3lKA
   AN5rEiulaCpM7f9urK1suXsoRGqw4b3NScGojLreBTm5bh3NKi3mvZtrU
   7pc3CfzkD3mYWKiuiHSGkT5qpMkaCOX98Q9LB0/Q00regjvk0iwnng8+V
   cbAmjyTW7ra5kPWMCoeUBrwXMfdEdkdG7lrlJ5jCCOcWrUqesTkywQNNF
   jq3z0YneX15NLNuyKEvVYhB61Pnb/7PYxMaFZ//pcw7T7JwIsJi9mDZqp
   MMprr1Qt7VQuIS7m4suk17l4dMqDCY4k8ANxwHE0JR6DaB5/vPbq53Q3d
   w==;
X-IronPort-AV: E=Sophos;i="5.99,244,1677567600"; 
   d="scan'208";a="209234570"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 May 2023 05:25:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 2 May 2023 05:25:00 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Tue, 2 May 2023 05:24:59 -0700
Date:   Tue, 2 May 2023 14:24:59 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
CC:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Message-ID: <20230502122459.inxuqa5rt3iluec4@soft-dev3-1>
References: <20230502082622.2392659-1-Ilia.Gavrilov@infotecs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20230502082622.2392659-1-Ilia.Gavrilov@infotecs.ru>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 05/02/2023 08:26, Gavrilov Ilia wrote:

Hi,

> 
> The 'sched' index value must be checked before accessing an element
> of the 'sctp_sched_ops' array. Otherwise, it can lead to buffer overflow.
> 
> Note that it's harmless since the 'sched' parameter is checked before
> calling 'sctp_sched_set_sched'.

If the 'sched' parameter is already checked, is it not better to remove
the check from this function?

> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")

I am not sure how much this is net material because as you said, this
issue can't happen.
But don't forget to specify the target tree in the subject. You can do
that when creating the patch using:
git format-patch ... --subject-prefix "PATCH net"

> Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> ---
>  net/sctp/stream_sched.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
> index 330067002deb..a339917d7197 100644
> --- a/net/sctp/stream_sched.c
> +++ b/net/sctp/stream_sched.c
> @@ -146,18 +146,19 @@ static void sctp_sched_free_sched(struct sctp_stream *stream)
>  int sctp_sched_set_sched(struct sctp_association *asoc,
>                          enum sctp_sched_type sched)
>  {
> -       struct sctp_sched_ops *n = sctp_sched_ops[sched];
> +       struct sctp_sched_ops *n;
>         struct sctp_sched_ops *old = asoc->outqueue.sched;
>         struct sctp_datamsg *msg = NULL;
>         struct sctp_chunk *ch;
>         int i, ret = 0;
> 
> -       if (old == n)
> -               return ret;
> -
>         if (sched > SCTP_SS_MAX)
>                 return -EINVAL;
> 
> +       n = sctp_sched_ops[sched];
> +       if (old == n)
> +               return ret;
> +
>         if (old)
>                 sctp_sched_free_sched(&asoc->stream);
> 
> --
> 2.30.2

-- 
/Horatiu
