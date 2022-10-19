Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0576039AD
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiJSGSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:18:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJSGSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:18:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F247B604B1
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666160324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zhAOSb/lD+R9IBWpRceTo0lfO8ZoEWk+ycewN8bL1Sg=;
        b=bhREponBt3fEXQLa3fxW/8/Y8qN/VnoAROVw9dMz16qq2wnatvmfua+CywIxFEGVxZFgE8
        agLP2SEBFfLElundP3c+36yzHYH8CV154JkZ+7SeiTiYHLcTViqSBHnm78PTWqs38Itvus
        3eMhchTEKWixtzJqb5d8mt13BfDETBM=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-455-ddCHRt77PmKWZfCoQDVEpA-1; Wed, 19 Oct 2022 02:18:42 -0400
X-MC-Unique: ddCHRt77PmKWZfCoQDVEpA-1
Received: by mail-pg1-f200.google.com with SMTP id h186-20020a636cc3000000b0045a1966a975so9129986pgc.5
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:18:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhAOSb/lD+R9IBWpRceTo0lfO8ZoEWk+ycewN8bL1Sg=;
        b=0fu5R67E7Ki2rxD64kq/T41VkCy1HCwDnOB9Xq/k2NqLuNZkDWEyoR2PAubEULWKh5
         jA6WFGfTVWhUXFHLqVfkldncWRC++cqLodrZ4k0ouSsDgu7aqsC73UbY8plBLmF+WTOX
         JlgKr8bRlnSk2bGIitulq+OrRjB0/BV1y8mY2DF4ktVqgS1a36HCqxEUnydCL8clLmSK
         S4Z0JC1JbFUUjOB9B7MQoGkCo7M15+g6V0I3srNxm9SBUAkAVpwTgexajOe5jynvY3oF
         7oZ8DN9AjoKdpZIZmlP3w86qKiDoXegQUxccJ9HYYjDGc3LeNlOHE3tl6S4Wx/U8gFi7
         c7Dg==
X-Gm-Message-State: ACrzQf1ygC9Soj/sW2LHARJ4f/mLSmpGkLY30RPHajncecK0c7IVMmYC
        I5Fopr+ThN6wCKt5B6WG8kLbO34cQdyLdkHlLOzJccLccxO+X+wGi5IYmm/nNLQ+K7RJ/b8Rzq1
        m8Anq9RPNv1m51pqoSlicHZkDsxRklS/M
X-Received: by 2002:a17:903:18c:b0:185:5211:c6e8 with SMTP id z12-20020a170903018c00b001855211c6e8mr6936065plg.133.1666160321371;
        Tue, 18 Oct 2022 23:18:41 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Ebc9PI+8jtCh+IyukxRr2g3kVw3bThGSMZbApmEnzrh9APxOYiWijG+Q2lH2yo1+6LvNL2gwWWPVLsqy7rvQ=
X-Received: by 2002:a17:903:18c:b0:185:5211:c6e8 with SMTP id
 z12-20020a170903018c00b001855211c6e8mr6936044plg.133.1666160321065; Tue, 18
 Oct 2022 23:18:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221014103443.138574-1-ihuguet@redhat.com> <Y0lSYQ99lBSqk+eH@lunn.ch>
 <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
 <Y0llmkQqmWLDLm52@lunn.ch> <CACT4oudn-sS16O7_+eihVYUqSTqgshbbqMFRBhgxkgytphsN-Q@mail.gmail.com>
 <Y0rNLpmCjHVoO+D1@lunn.ch> <CACT4oucrz5gDazdAF3BpEJX8XTRestZjiLAOxSHGAxSqf_o+LQ@mail.gmail.com>
 <Y03y/D8WszbjmSwZ@lunn.ch> <20221017194404.0f841a52@kernel.org>
 <CACT4oueGEDLzZLXdd_Pt+tK=CpkMM7uE9ubVL9i6wTO7VkzccA@mail.gmail.com> <20221018085906.76f70073@kernel.org>
In-Reply-To: <20221018085906.76f70073@kernel.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Wed, 19 Oct 2022 08:18:29 +0200
Message-ID: <CACT4oud9B-yCD5jVWRt9c4JXq2_Ap-qMkr9y3xJ5cgTTggYT1w@mail.gmail.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, irusskikh@marvell.com,
        dbogdanov@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Li Liang <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 5:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 18 Oct 2022 08:15:38 +0200 =C3=8D=C3=B1igo Huguet wrote:
> > Interesting solution, I didn't even think of something like this.
> > However, despite not being 100% sure, I think that it's not valid in
> > this case because the work's task communicates with fw and uses
> > resources that are deinitialized at ndo_stop. That's why I think that
> > just holding a reference to the device is not enough.
>
> You hold a reference to the netdev just to be able to take rtnl_lock()
> and check if it's still running. If it is UP you're protected from it
> going down due to rtnl_lock you took. If it's DOWN, as you say, it's not
> safe to access all the bits so just unlock and return.
>
> But because you're holding the reference it's safe to cancel_work()
> without _sync on down, because the work itself will check if it should
> have been canceled.
>
> Dunno if that's a good explanation :S

Yes, now I get it.

However, I think I won't use this strategy this time: rtnl_lock is
only needed in the work task if IS_ENABLED(CONFIG_MACSEC). Acquiring
rtnl_lock every time if macsec is not enabled wouldn't be protecting
anything, so it would be a waste. I think that the strategy suggested
by Andrew of adding a dedicated mutex to protect atlantic's macsec
operations makes more sense in this case. Do you agree?

--=20
=C3=8D=C3=B1igo Huguet

