Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC9DC59E7BB
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242870AbiHWQm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245185AbiHWQmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:42:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFA41175C1
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 06:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661260246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K3KIONbPiHyRMeK7Ev2jQpkhdNrH3jXKSsU32bty/nk=;
        b=JL3e9BAKn53GYGUdeiEOtGoqn4zdr2UtcUBUXjYiI/6amWmMyWBjB2n7JDw2MPd0IQkOfv
        6F6In/4iJG4N+RUiwHCQAqUQmNx9cGnf6SaCF+iNVksTF4zm53zi8excvJcLaZaisUGsuT
        27zW0rz3n5sjfPyjDIVh3Xg4esHPDE8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-316-cGbZ4x-XN_eueTWDyZ6wfw-1; Tue, 23 Aug 2022 09:10:43 -0400
X-MC-Unique: cGbZ4x-XN_eueTWDyZ6wfw-1
Received: by mail-qk1-f199.google.com with SMTP id m19-20020a05620a24d300b006bb85a44e96so12182536qkn.23
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 06:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=K3KIONbPiHyRMeK7Ev2jQpkhdNrH3jXKSsU32bty/nk=;
        b=ZKkR3AEas/X/CRihBi4ThwdMn9KOzNp4fLDyiGRcL2JYYU5sQN9Ur50IKnQh7PqkNf
         zFAyYNs8Zb89cQDKt012SQBCQYcs7y2wHNpTJgvJ5GwLQQZ6qFxClQgAc4MmZakHBLhb
         juP9wPphfm5nHmPqzsPReWyP+brBXXn3obfBbfF7o+9yfrkMnuubiC4KSZ07uwdpXtXm
         WlIlVN942XHFhCpMB6P/a24WXWADThKVd/eBtaHIgIoruEjlSEiaic5vy4UHJyrRlf9S
         SH0saJ/hF1Fh53xQhvaIklMAKf/9wKigFpLek88F+lFxI2Inu/1oHTVKuDdTFM6y+2IV
         QYUA==
X-Gm-Message-State: ACgBeo2ruCaW5iJMJU0T4X6ybapsri8qSQsCRFzYOpHbW5PGvpaMDpf+
        66IPh+9oOw7FTUdSU/vq+cvwKfOKGYaseCPcAyAjJhMBrEN/2VxCjo6Zu2sJeTXO5HsQbf23wjb
        eoIv1pIxcTpQb3Nte
X-Received: by 2002:ac8:4e4a:0:b0:343:7e05:d2a8 with SMTP id e10-20020ac84e4a000000b003437e05d2a8mr19418483qtw.67.1661260242848;
        Tue, 23 Aug 2022 06:10:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR40k3HniorFJFBf5+wfj6pczi8EhQyml3G2Dh8I4rf0W+nqJePB+WvUB4zQjJjHNIs8Kh/Rfw==
X-Received: by 2002:ac8:4e4a:0:b0:343:7e05:d2a8 with SMTP id e10-20020ac84e4a000000b003437e05d2a8mr19418454qtw.67.1661260242581;
        Tue, 23 Aug 2022 06:10:42 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-176.dyn.eolo.it. [146.241.97.176])
        by smtp.gmail.com with ESMTPSA id s13-20020a05620a254d00b006b633dc839esm13460029qko.66.2022.08.23.06.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 06:10:42 -0700 (PDT)
Message-ID: <6f147fbd31980c6155ea6e7deba26d8210ed6afd.camel@redhat.com>
Subject: Re: [PATCH 1/4] net: mediatek: sgmii: fix powering up the SGMII phy
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Couzens <lynxis@fe80.eu>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>
Date:   Tue, 23 Aug 2022 15:10:38 +0200
In-Reply-To: <20220820224538.59489-2-lynxis@fe80.eu>
References: <20220820224538.59489-1-lynxis@fe80.eu>
         <20220820224538.59489-2-lynxis@fe80.eu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sun, 2022-08-21 at 00:45 +0200, Alexander Couzens wrote:
> There are cases when the SGMII_PHYA_PWD register contains 0x9 which
> prevents SGMII from working. The SGMII still shows link but no traffic
> can flow. Writing 0x0 to the PHYA_PWD register fix the issue. 0x0 was
> taken from a good working state of the SGMII interface.

do you have access to register documentation? what does 0x9 actually
mean? is the '0' value based on just empirical evaluation?

Thanks!

Paolo

