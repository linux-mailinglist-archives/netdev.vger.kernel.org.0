Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C43588118
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 19:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiHBReA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 13:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiHBRd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 13:33:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B051491C2
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 10:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659461637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b6gNkP9cr0dLWUMhdzO4N+ByXd87OsQpygpKO2V1C0Q=;
        b=Dv98ljrtGn+KRb3IdQjTXzEpeJ8bIUyI6Vt+6+NxEPp04G8ZawrlOJIqWjNeMI3HxEBYcG
        vCMx7i4Ft2gRJ/jL//3YNvXiFYskn4XoaMTcHYkAhDYqlbPDdYTxMawnZqIXCsp/eqPteh
        R+IPjOcNCYF2hUfooAsT+bJAZLaK4+Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-T20vhHYBMqGJ6lsMKcLjvg-1; Tue, 02 Aug 2022 13:33:56 -0400
X-MC-Unique: T20vhHYBMqGJ6lsMKcLjvg-1
Received: by mail-wr1-f72.google.com with SMTP id x5-20020adfbb45000000b0021ee56506dfso3724457wrg.11
        for <netdev@vger.kernel.org>; Tue, 02 Aug 2022 10:33:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=b6gNkP9cr0dLWUMhdzO4N+ByXd87OsQpygpKO2V1C0Q=;
        b=0lnSGU7BdoBQb96bcERj9SuaT/KgzAr1nxHQMx51PlQNkHm6sDm0m/k5kxvU4ZCxH8
         P2B95EX/YHN3gQkJFFQgj38YGwTcEJhBokHTUOKcdcyDuOyJlcBYgR4cw/t2mdjlgjv8
         3UoeROEIEljVuphcXrPcCwEY9ui614f1OH1PokvZg42Iv1ARKbzKYWaQzVf6AhpSrqzB
         KGIO+Rpx0e6TRilGCVQH30JnY+5RR+q2I8z+9luQoKwGPh5gN7fqhjcP4oVWY3I/EP61
         CWLK/SjcwnhHoylaCrGcXAMLGLKm4Ri4k2oVpQtRE26FY2HKyaNJDZH0JmN8gzUuqsQh
         +GvA==
X-Gm-Message-State: ACgBeo3WOxKnlScj3My/tvoiY1C2bpMM5iNfByuUuZBl6RelzMMifXvp
        f17DY/L4tQ15NDkPEliRUd9vmGbE6v8App2SzRjB7OzaGIImZsSafPZxsiXZ+cRBc1jjVOspuLp
        mrDq/Yb/4ZjLWX+pA
X-Received: by 2002:a5d:64aa:0:b0:21e:be27:6dfb with SMTP id m10-20020a5d64aa000000b0021ebe276dfbmr14288278wrp.456.1659461635016;
        Tue, 02 Aug 2022 10:33:55 -0700 (PDT)
X-Google-Smtp-Source: AA6agR68uYJ/QRN/NFTeqOuUAcuMo+13P7GZCy6NXrVtRl9mYt60saFpZR1udH29n9mLKLdmtgXqeQ==
X-Received: by 2002:a5d:64aa:0:b0:21e:be27:6dfb with SMTP id m10-20020a5d64aa000000b0021ebe276dfbmr14288260wrp.456.1659461634824;
        Tue, 02 Aug 2022 10:33:54 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-118-222.dyn.eolo.it. [146.241.118.222])
        by smtp.gmail.com with ESMTPSA id r41-20020a05600c322900b003a2e89d1fb5sm22314135wmp.42.2022.08.02.10.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 10:33:54 -0700 (PDT)
Message-ID: <e11a02756a3253362a1ef17c8b43478b68cc15ba.camel@redhat.com>
Subject: Re: [PATCH v3 net 1/4] net: bonding: replace dev_trans_start() with
 the jiffies of the last ARP/NS
From:   Paolo Abeni <pabeni@redhat.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Date:   Tue, 02 Aug 2022 19:33:52 +0200
In-Reply-To: <20220802163027.z4hjr5en2vcjaek5@skbuf>
References: <20220731124108.2810233-1-vladimir.oltean@nxp.com>
         <20220731124108.2810233-2-vladimir.oltean@nxp.com> <1547.1659293635@famine>
         <20220731191327.cey4ziiez5tvcxpy@skbuf> <5679.1659402295@famine>
         <20220802014553.rtyzpkdvwnqje44l@skbuf>
         <d04773ee3e6b6dee88a1362bbc537bf51b020238.camel@redhat.com>
         <20220802091110.036d40dd@kernel.org>
         <20220802163027.z4hjr5en2vcjaek5@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-08-02 at 16:30 +0000, Vladimir Oltean wrote:
> On Tue, Aug 02, 2022 at 09:11:10AM -0700, Jakub Kicinski wrote:
> > On Tue, 02 Aug 2022 11:05:19 +0200 Paolo Abeni wrote:
> > > In any case, this looks like a significative rework, do you mind
> > > consider it for the net-next, when it re-open?
> > 
> > It does seem like it could be a lot for stable.

I'm sorry, I did not intend to block the series. It looked to me there
was no agreement on this, and I was wondering if a net-next target
would allow a clean solution to make eveyone happy.

I now see it's relevant to have something we can queue for stable.

I'm ok with Jay suggestion:
> Alternatively, would it be more comfortable to just put this
> patch (1/4) to stable and not backport the others? 

The above works for me - I thought it was not ok for Jay, but since he
is proposing such sulution, I guess I was wrong.

Paolo


