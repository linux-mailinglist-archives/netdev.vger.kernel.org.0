Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14424EAE54
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 15:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236453AbiC2NX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 09:23:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiC2NX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 09:23:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 666C64090F
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 06:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648560103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DbPYdZedfRIYwRtWtwiurEBq9rlw3/Z3627UEFaws4Q=;
        b=MUrl5d0VaGKyAx7h3jh6rGEIp7Vj0LwrKv5luQZ0MnN5k5+/YwY8cIxPedzqzzghMmTkYw
        5fy7YXB4mVnDNPhqkwVNfK2Rl7RVSoZktSKWsVdMBcTI2EILn9XrXogI/aGtEVwaAT08/9
        Dl48oZ6lqNQ5tf+1m163yDWfw1cH8gQ=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-259-eMaQ7xx3OPG0fFDJh265Xw-1; Tue, 29 Mar 2022 09:21:42 -0400
X-MC-Unique: eMaQ7xx3OPG0fFDJh265Xw-1
Received: by mail-wr1-f69.google.com with SMTP id h11-20020a5d430b000000b001f01a35a86fso5016443wrq.4
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 06:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DbPYdZedfRIYwRtWtwiurEBq9rlw3/Z3627UEFaws4Q=;
        b=r4D++UqiA+KVxMf4xILhw8g23AZIPaYwCWYKXehi6ylddV4R9l9QqFYqjAnjF4WVOL
         yJd/zyNs05ncc60GgcHOLnqcq7+GrLo5y95Vzl9hS2GiboRpvDQSKFwWBDbHZo8DY5UG
         Q3gauIbMMll/FxzsX6RPFWu5IA/pRPuGGlszZmMODMPDJg2BPsfxeA9cYnQnCFROxAEg
         Aja8RVfl2vb5RoSKIaBM60czoiguFTJprj2sJxPZc/tBP9IiPTpUQFD4hnYVmTG14/dU
         bKl7vK+mKIbsoZbpumTNC5hY+XN81nWPVUUNeifPMTjk8vG3dncl8WDzjj9TiNp9dW3e
         aing==
X-Gm-Message-State: AOAM533qoMEmXcJ0sYS0pk279bPe0X2Z1cbZGkvuQx6pw1L1Ra8yb8tj
        4wi2sLRH7o5a+wR58Vrh6lRfHMwVgGfCHDE+r0ObpskH7pgWYZTdzs1bBNFJOijEp+xLPlnM7rm
        tGxXCPLEdlGJLfhDF
X-Received: by 2002:a05:600c:3c9b:b0:380:be98:6204 with SMTP id bg27-20020a05600c3c9b00b00380be986204mr6779615wmb.121.1648560100542;
        Tue, 29 Mar 2022 06:21:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzl9LIYqQwpEBLet+cMvsUzNJ5sSJCYaaxqrq4nxiJn5Wk2pBJM71QoJyVjOihyPtZrz/6JhQ==
X-Received: by 2002:a05:600c:3c9b:b0:380:be98:6204 with SMTP id bg27-20020a05600c3c9b00b00380be986204mr6779585wmb.121.1648560100327;
        Tue, 29 Mar 2022 06:21:40 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-135.dyn.eolo.it. [146.241.232.135])
        by smtp.gmail.com with ESMTPSA id bh16-20020a05600c3d1000b0038ceba454f9sm2240271wmb.20.2022.03.29.06.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 06:21:39 -0700 (PDT)
Message-ID: <21f0fb45d30a1a2fa98a370e3e8ef303e1f79846.camel@redhat.com>
Subject: Re: [PATCH net] sctp: count singleton chunks in assoc user stats
From:   Paolo Abeni <pabeni@redhat.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 29 Mar 2022 15:21:38 +0200
In-Reply-To: <20220329130050.vwo5zcbgr7z2qpg5@t14s.localdomain>
References: <3369a5f0a632571d7439377175051039db29f91d.1648522807.git.jamie.bainbridge@gmail.com>
         <20220329130050.vwo5zcbgr7z2qpg5@t14s.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-03-29 at 10:00 -0300, Marcelo Ricardo Leitner wrote:
> On Tue, Mar 29, 2022 at 01:13:36PM +1000, Jamie Bainbridge wrote:
> > singleton chunks (INIT, and less importantly SHUTDOWN and SHUTDOWN-
> > COMPLETE) are not counted in SCTP_GET_ASOC_STATS "sas_octrlchunks"
> > counter available to the assoc owner.
> > 
> > INIT (and the SHUTDOWN chunks) are control chunks so they should be
> > counted as such.
> > 
> > Add counting of singleton chunks so they are properly accounted for.
> > 
> > Signed-off-by: Jamie Bainbridge <jamie.bainbridge@gmail.com>
> > ---
> >  net/sctp/outqueue.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
> > index a18609f608fb786b2532a4febbd72a9737ab906c..e2d7c955f07c80da17c7525159aaf8a053432ae3 100644
> > --- a/net/sctp/outqueue.c
> > +++ b/net/sctp/outqueue.c
> > @@ -914,6 +914,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
> >  				ctx->asoc->base.sk->sk_err = -error;
> >  				return;
> >  			}
> > +			ctx->asoc->stats.octrlchunks++;
> >  			break;
> >  
> >  		case SCTP_CID_ABORT:
> 
> Please also fix it for pmtu probes a bit below. They are heartbeats
> being handled specially as singletons as well.

Since a v2 is needed, please add also a suitable fixes tag - possibly:

Fixes: 196d67593439 ("sctp: Add support to per-association statistics via a new SCTP_GET_ASSOC_STATS call")

Thanks!

Paolo

