Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022DB60658C
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 18:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiJTQRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 12:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJTQRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 12:17:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56C110573
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 09:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666282649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p3NeV9vBHxbCMLWi56bhvobikWmfcIH0c/twjY3OeIs=;
        b=Pgs970Pwq8WuXV9pI2AEYnDj1+RMi4zmcuH6PUP1l2Kb+OH3RkX5F3UGa6P6WEr7fLVyVQ
        6Ugh5oTzwK2wwD69OOHWCkdD6ufvVlPQdAvncbPDWAZ00X39Dgz4Z1dn8Sedi95+53zjdC
        VJ6WkKDC2k1dHZ1cHo5mkbM81ERrG5k=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-479-gR4v7NI2McqE8TSkRHxm3Q-1; Thu, 20 Oct 2022 12:17:27 -0400
X-MC-Unique: gR4v7NI2McqE8TSkRHxm3Q-1
Received: by mail-pl1-f200.google.com with SMTP id h2-20020a170902f54200b0018553a8b797so7762826plf.9
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 09:17:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p3NeV9vBHxbCMLWi56bhvobikWmfcIH0c/twjY3OeIs=;
        b=6WKdB6FVFlirU0t4Dq/clbgnPM0JBIMROJPYJ8Q5x3zIt7AyaGAeZJtOqQqDyGYwrT
         JAREo1plXP2SaHAyCTjvPygcCIzOujnn0jDkEykVEyvxEbrmBvmt8s54oQHd0DDIMa1L
         TyH3Cn6mV8lMoFG2/H1nbshyVXNUHUQmvhSBj2DFJ14o+1p36YIjZSA9CRSpV1dpsTBv
         /mSbAhJUgWpAR3PCppI6WYAuMrBfywkl4jQB2+3bfjRzHgy7pf6SzrB3p1VRmt1OL5NV
         s2pcyxtG3blnDateQeC26oVHS834MCQKORuxbREDekVjyo86Vhd65KrX7okAKUfD6MRm
         f8BA==
X-Gm-Message-State: ACrzQf3jFdorx5OOOAIXxS6yeQfQWt06s2Bisn9I0CVGS8Xe+kIIPshz
        NTdZydDAnUd2ejvMpuY6Lz4k0riAA/a1qWazdbgs2+CuetSPpd/xZgKOAosT8ALxOZpRbVIZyiB
        PzE8HUGtYBrfVaQC/Q2daC9QpP32UUbuv
X-Received: by 2002:a17:903:18c:b0:185:5211:c6e8 with SMTP id z12-20020a170903018c00b001855211c6e8mr14880440plg.133.1666282646276;
        Thu, 20 Oct 2022 09:17:26 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4dvSw7/1Qjs6Ot90z0z1dTZnI83seEGnly47F0MY3ufBrinue7jtLaptN9FVl2IcX7Q/YVN7dijr+AYgbBNtI=
X-Received: by 2002:a17:903:18c:b0:185:5211:c6e8 with SMTP id
 z12-20020a170903018c00b001855211c6e8mr14880408plg.133.1666282645943; Thu, 20
 Oct 2022 09:17:25 -0700 (PDT)
MIME-Version: 1.0
References: <20221014103443.138574-1-ihuguet@redhat.com> <20221020075310.15226-1-ihuguet@redhat.com>
 <2945b16a-87b2-9489-cb4f-f578c368f814@marvell.com>
In-Reply-To: <2945b16a-87b2-9489-cb4f-f578c368f814@marvell.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 20 Oct 2022 18:17:12 +0200
Message-ID: <CACT4oucWb5Op1HZZo4cFKP3PUD9YZ516E5m=gx7NzfjWPwDt2A@mail.gmail.com>
Subject: Re: [PATCH v2 net] atlantic: fix deadlock at aq_nic_stop
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, mstarovo@pm.me,
        netdev@vger.kernel.org, Li Liang <liali@redhat.com>
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

On Thu, Oct 20, 2022 at 10:56 AM Igor Russkikh <irusskikh@marvell.com> wrot=
e:
>
>
>
> On 10/20/2022 9:53 AM, =C3=8D=C3=B1igo Huguet wrote:
> > NIC is stopped with rtnl_lock held, and during the stop it cancels the
> > 'service_task' work and free irqs.
>
> Hi =C3=8D=C3=B1igo, thanks for taking care of this.
>
> Just reviewed, overall looks reasonable for me. Unfortunately I don't rec=
all
> now why RTNL lock was used originally, most probably we've tried to secur=
e
> parallel "ip macsec configure something" commands execution.
>
> But the model with internal mutex looks safe for me.
>
> Unfortunately I now have no ability to verify your patch, edge usecase he=
re
> would be to try stress running in parallel:
> "ethtool -S <iface>"
> "ip macsec show"
> "ip macsec <change something>"
> Plus ideal would be link flipping.
>
> Have you tried something like that?

I will try to run that tomorrow, thanks!

>
> Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
>
> Regards,
>   Igor
>


--=20
=C3=8D=C3=B1igo Huguet

