Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF5E602437
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiJRGP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiJRGP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:15:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4422585AAB
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666073752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HKvF/C7a55gz0ZPABHWbVMJgMSS5shpGJwHfnlfI1es=;
        b=FsjVhfCBC4UVqyJ1a8WBbjzNki+qjn4N1kznITHUNUiozudkW4kwUGQs+01be/p4/f0Kke
        M1D+CI4hN56kJlaNK1ZMpADEaRVM0MZEC+Q+0ddXbb4F3ma2OhXJcyD6AxEHQB9X/cCg4X
        veS/tlrlAB54qpTP7sRww2T1dPQWinU=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-669-zcVZFp9NOuSxk120SBB8IQ-1; Tue, 18 Oct 2022 02:15:51 -0400
X-MC-Unique: zcVZFp9NOuSxk120SBB8IQ-1
Received: by mail-pl1-f198.google.com with SMTP id l11-20020a170902f68b00b0018545b06649so6311005plg.2
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:15:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HKvF/C7a55gz0ZPABHWbVMJgMSS5shpGJwHfnlfI1es=;
        b=bTcdEOukNZ95gP45luJwXosQUFlbd156koXPjhWz3LgnongMTOguIBFFgdtIbq/inZ
         IRcLF7rGZ9Or2xuS5JZKmuZioJ1hkt8Kv1nYqD7/3BD1NsHkjAWhfyax8A8dxYUQ0zYd
         IFo19/5oT1v0oPAve2ClBQLAJXovUSYGZZmj1SoZoyu+SkyUXOQvpdfSzJHKbO1rNX+B
         HsqKvcpX/c/yuCE7/sEtyxQOUp8RM7KwfXqWgIiUvkdhqQiIWfL7oeNoJGvaHzqua++D
         0P2etVu7dAsQCUslwOJ8Y4QUNHu7NHj0eayGubEqAK7aHXAYzxHbEcR7n8EOQhhlUATg
         7lEA==
X-Gm-Message-State: ACrzQf04BaHLwCFj+MfUUrm7K407H6ozA8iHpDkh2ehVwPsXcV3zcV32
        uvu3yW1lJkAtrrRBpJCF4s/aGNMh15bQ7cwNOD/TIKCuvHDL2HX21Eepy6TyLukvba6vh+oVFCj
        3hjZNiswTyUBRra/a8B3NEiB5ceYyLJfp
X-Received: by 2002:a17:903:2285:b0:185:44df:d916 with SMTP id b5-20020a170903228500b0018544dfd916mr1469479plh.120.1666073750079;
        Mon, 17 Oct 2022 23:15:50 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4hK8R14yn11uSpUj6vuWAF5x5kwtCFfLqxf4qz4572EqD3HlY/lD+QUIdJL/iP8nzBndxxvkthCSE3Ch62FK4=
X-Received: by 2002:a17:903:2285:b0:185:44df:d916 with SMTP id
 b5-20020a170903228500b0018544dfd916mr1469456plh.120.1666073749776; Mon, 17
 Oct 2022 23:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221014103443.138574-1-ihuguet@redhat.com> <Y0lSYQ99lBSqk+eH@lunn.ch>
 <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
 <Y0llmkQqmWLDLm52@lunn.ch> <CACT4oudn-sS16O7_+eihVYUqSTqgshbbqMFRBhgxkgytphsN-Q@mail.gmail.com>
 <Y0rNLpmCjHVoO+D1@lunn.ch> <CACT4oucrz5gDazdAF3BpEJX8XTRestZjiLAOxSHGAxSqf_o+LQ@mail.gmail.com>
 <Y03y/D8WszbjmSwZ@lunn.ch> <20221017194404.0f841a52@kernel.org>
In-Reply-To: <20221017194404.0f841a52@kernel.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Tue, 18 Oct 2022 08:15:38 +0200
Message-ID: <CACT4oueGEDLzZLXdd_Pt+tK=CpkMM7uE9ubVL9i6wTO7VkzccA@mail.gmail.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, irusskikh@marvell.com,
        dbogdanov@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Li Liang <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 4:44 AM Jakub Kicinski <kuba@kernel.org> wrote:
> FWIW the work APIs return a boolean to tell you if the work was
> actually scheduled / canceled, and you can pair that with a reference
> count of the netdev to avoid the typical _sync issues.
>
> trigger()
>         ASSERT_RTNL();
>         if (schedule_work(netdev_priv->bla))
>                 netdev_hold();
>
> work()
>         rtnl_lock();
>         if (netif_running())
>                 do_ya_thing();
>         netdev_put();
>         rtnl_unlock();
>
> stop()
>         ASSERT_RTNL();
>         if (cancel_work(bla))
>                 netdev_put();
>
> I think.
>

Interesting solution, I didn't even think of something like this.
However, despite not being 100% sure, I think that it's not valid in
this case because the work's task communicates with fw and uses
resources that are deinitialized at ndo_stop. That's why I think that
just holding a reference to the device is not enough.

--=20
=C3=8D=C3=B1igo Huguet

