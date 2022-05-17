Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9445B529FED
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 13:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235583AbiEQLBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 07:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiEQLBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 07:01:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18EA3380
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 04:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652785299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BrhK3jD5Qa9gQ7Vs1Y+Ne1Qf8j5la2u4aORR5m1raZc=;
        b=QnBqMgDodw/3JEnEg2hsjXJWDaaAGnPtd8nsu2J6hqIbVwx2yKHXF2SGYrk5KueiDW2erO
        usJh2iOIWE2Q4Eah4PrhqC8IkhotjeQeSIWYXTD35Kh27wmek24PQIJoGjlfpduv+pAqHC
        i1SGFoJYWmgQgKRXANbNt0K7cpmDr5o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-E7qPUVoTP2OgWOZ7HIqEbQ-1; Tue, 17 May 2022 07:01:37 -0400
X-MC-Unique: E7qPUVoTP2OgWOZ7HIqEbQ-1
Received: by mail-wr1-f69.google.com with SMTP id s16-20020adfeb10000000b0020cc4e5e683so4564675wrn.6
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 04:01:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=BrhK3jD5Qa9gQ7Vs1Y+Ne1Qf8j5la2u4aORR5m1raZc=;
        b=bzpCbR5odi+6maWGD/3K2dlos/c9jSqxBMTAgbmsX8dNKaXU0zD7tkw/XtcCxQWij5
         jDbM3S1Io+0cQW2jXV1km7wxAVobDDbql2XlJ+KOVk27IXzElgzCBzh7FjaTWjTr9OWB
         Ni9xgRicTbwAURJLkSc0K3Jb3ynAbV65DE0aai1N1KFrLRSBZ6dJ+eMuJwxyZbNiY3lw
         rzxuRfd2cOzUco7lwmOKN6jtAOOHsDsM/X9Zckhk61CYaAUeP6X8xg+jRg3JoM+FQckf
         9SFpFMVNyAdZLRlAoHxaP8kTf1mI3UU8yfShRPaPTxVv5FzuhG2Uxk2jwe/CrosdkQLG
         cubw==
X-Gm-Message-State: AOAM5326ujiIcWJyIMcqiYiQIyvyBHGDHW6jiyV7L7OY34iSh+miC0Ga
        m+ytSugdcKc0xKxo/G3rMGJzI2FxX/1Ot8RXXA/JCTZrGPffS2cLoW0GOjJa8Mpodzhihc42Rof
        83RbBLy9k+Qczz0XV
X-Received: by 2002:a05:600c:600b:b0:395:b668:b3fa with SMTP id az11-20020a05600c600b00b00395b668b3famr29330948wmb.46.1652785296286;
        Tue, 17 May 2022 04:01:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxMRuY9ReOFw5Qyh6OZdfkNXpYJoURR2ENsa7RCkBVqemkJ2q5MEUHzO2v1l/KhNWfXp9To7g==
X-Received: by 2002:a05:600c:600b:b0:395:b668:b3fa with SMTP id az11-20020a05600c600b00b00395b668b3famr29330911wmb.46.1652785295850;
        Tue, 17 May 2022 04:01:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id h16-20020adf9cd0000000b0020c5253d8casm11580176wre.22.2022.05.17.04.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 04:01:35 -0700 (PDT)
Message-ID: <163e90e736803c670ce88f2b2b1174eddc1060a2.camel@redhat.com>
Subject: Re: [PATCH v2] net: phy: marvell: Add errata section 5.1 for Alaska
 PHY
From:   Paolo Abeni <pabeni@redhat.com>
To:     Stefan Roese <sr@denx.de>, netdev@vger.kernel.org
Cc:     Leszek Polak <lpolak@arri.de>,
        Marek =?ISO-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Date:   Tue, 17 May 2022 13:01:34 +0200
In-Reply-To: <20220516070859.549170-1-sr@denx.de>
References: <20220516070859.549170-1-sr@denx.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-05-16 at 09:08 +0200, Stefan Roese wrote:
> From: Leszek Polak <lpolak@arri.de>
> 
> As per Errata Section 5.1, if EEE is intended to be used, some register
> writes must be done once after every hardware reset. This patch now adds
> the necessary register writes as listed in the Marvell errata.
> 
> Without this fix we experience ethernet problems on some of our boards
> equipped with a new version of this ethernet PHY (different supplier).
> 
> The fix applies to Marvell Alaska 88E1510/88E1518/88E1512/88E1514
> Rev. A0.
> 
> Signed-off-by: Leszek Polak <lpolak@arri.de>
> Signed-off-by: Stefan Roese <sr@denx.de>
> Cc: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: David S. Miller <davem@davemloft.net>

It's not clear to me if you are targeting -net or net-next, could you
please clarify? In case this is for -net, please add a suitable fixes
tag, thanks!

/P

