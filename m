Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFE36997AA
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBPOlc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Feb 2023 09:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjBPOlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:41:31 -0500
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EBF4D616
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:41:27 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id dz21so3570109edb.13
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:41:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fIiKUa8aKsyGZwhA90THS3YUvs4NqT1IIF3+HgBUH4Q=;
        b=B5TJGvoVFMeWYe261eg1dRrmLWxSKqReXg5xLIkfEePZsiZqCDns2squIENIs8dxLM
         4AYzJ1NFaRJDmsYFuXakZsV3CdFBBOiMwwTKF9V3+U8v7r/lqiMwSMZ7St6n+krmIdTT
         TfwjV5IG+7CDwuOmH1VhtKHyaIU/M8BpY3JjcvXnnza7j3z1GqP1eOpjLqscRZV4j6wV
         UzfEjejXvt5C8giuhoh2gNNSrXzpPux1j/TsXXYAeN9bMXEa6B+7VE9UrQGp0V2EwQYs
         r3qltAxDz8wya36C0zw20hE/Ab7l+pubJqj6EvSNYlnGrpvUHAbLyG4WyBVC1CWWpXVq
         Odgg==
X-Gm-Message-State: AO0yUKUrPMbZ7LW1caHzY9QViyKAgCJSOuc1WJzyGRDfXLLhD56zKdwH
        P8qK7Daf1Mv5pF5s+YHwipM=
X-Google-Smtp-Source: AK7set9CPgLCMQxqBxtyscPGBsyNvK5YWbQPCnJLjp8gk4vOV42NKpCLqvU2ILlxmaXc2eSNfS9y9w==
X-Received: by 2002:a17:906:99d5:b0:8af:2fa1:619e with SMTP id s21-20020a17090699d500b008af2fa1619emr2243078ejn.18.1676558485345;
        Thu, 16 Feb 2023 06:41:25 -0800 (PST)
Received: from [10.148.80.132] ([195.228.69.10])
        by smtp.gmail.com with ESMTPSA id p25-20020a17090653d900b008aac35b1c2esm894131ejo.173.2023.02.16.06.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 06:41:24 -0800 (PST)
Message-ID: <aa6e590e59fb3e360676a5ada5f80d01e0011d14.camel@inf.elte.hu>
Subject: Re: [PATCH v6 net-next 02/13] net/sched: mqprio: refactor
 offloading and unoffloading to dedicated functions
From:   Ferenc Fejes <fejes@inf.elte.hu>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     peti.antal99@gmail.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Date:   Thu, 16 Feb 2023 15:41:23 +0100
In-Reply-To: <20230216142846.bjura4mf2f64tmcr@skbuf>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
         <20230204135307.1036988-3-vladimir.oltean@nxp.com>
         <ede5e9a2f27bf83bfb86d3e8c4ca7b34093b99e2.camel@inf.elte.hu>
         <20230216142846.bjura4mf2f64tmcr@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir!

On Thu, 2023-02-16 at 16:28 +0200, Vladimir Oltean wrote:
> Hi Ferenc,
> 
> On Thu, Feb 16, 2023 at 02:05:22PM +0100, Ferenc Fejes wrote:
> > This patch just code refactoring or it modifies the default
> > behavior of
> > the offloading too? I'm asking it in regards of the veth interface.
> > When you configure mqprio, the "hw" parameter is mandatory. By
> > default,
> > it tries to configure it with "hw 1". However as a result, veth
> > spit
> > back "Invalid argument" error (before your patches). Same happens
> > after
> > this patch too, right?
> 
> Yup. iproute2 has a default queue configuration built in, if nothing
> else is specified, and this has "hw 1":
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/tc/q_mqprio.c#n36
> 
> > For veth hardware offloading makes no sense, but giving the "hw 0"
> > argument explicitly as mqprio parameter might counterintuitive.
> 
> Agree that giving the right nlattrs to mqprio and trying to slalom
> through their validation is a frustrating minesweeper game. I have
> some
> patches which add some netlink EXT_ACK messages to make this a bit
> less
> sour. I'm regression-testing those, together with some other mqprio
> changes and I hope to send them soon.

Nice, good to hear!

> 
> OTOH, "hw 1" is mandatory with the "mode", "shaper", "min_rate" and
> "max_rate" options. This is logical when you think about it (driver
> has
> to act upon them), but indeed it makes mqprio difficult to configure.
> 
> With veth, you need to use multi-queue to make use of mqprio/taprio,
> have you done that?
> 
> ip link add veth0 numtxqueues 8 numrxqueues 8 type veth peer name
> veth1

Yes, usually I done it with ethtool --set-channels veth0 tx 8 but I
guess that both resulting the same.

Best,
Ferenc

