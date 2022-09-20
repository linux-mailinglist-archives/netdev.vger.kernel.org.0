Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877715BE267
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbiITJvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiITJvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:51:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D766AA15
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663667480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7sRu5eFKZGmIxnr7DYKSnzGauzTFG6ySgN2OFRnN+7c=;
        b=KY9IeDrmEtgfaoIyaWhKMkDr70/tagbt/8MTNr774zavhbh3chGMLv+Rp1QoGtNezapuri
        ADgca/9s/yRpejEkhnnnrU58SzEYENhvEvcJHMtaJGrppkSElbJQnt7pTQhyYnrXpF1+na
        Eixgy4PM+jPQA/f3syVRdasyu/Yz9bM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-196-zM-qFI47Pqm3-zmhNPdpJA-1; Tue, 20 Sep 2022 05:51:19 -0400
X-MC-Unique: zM-qFI47Pqm3-zmhNPdpJA-1
Received: by mail-qk1-f198.google.com with SMTP id d18-20020a05620a241200b006ce80a4d74aso1485162qkn.6
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 02:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=7sRu5eFKZGmIxnr7DYKSnzGauzTFG6ySgN2OFRnN+7c=;
        b=0klCK2bvKekELStl752MGNB8PTHdIKdKHv5UrXlVci4k3TuE+WzSMfnuVYWQV3DnIW
         +Kg8ig+JHfnMBoynl4lCU6BU1V4DrjwaqZmYeO9dPtPqpykaFxq3AF81zpMjZXgVDV0g
         HD4v6qP1cuO9ykN2dGf5tuN5t72NMrn+Hw2+6ZebMkJT1GUcaS6wMVJD2qsE11859PXz
         MdF0zvicd5mkK2kT5MLTHpRoZMHbWb/DcdwYGH7kplS7jJna66HsaPJ2ghVheVLwLv9e
         xFzynRB1RfYAY6JJ5QeBJwRy2UjzdFl5VijTGp9zIRKuqRWuj70/lu1qQub5yE1YXQvn
         +nTw==
X-Gm-Message-State: ACrzQf14ovLWTPmAdwWBXRyb0Prs9zCDXcu6SoNEu8dVFfbv3CEsaL6Q
        U23J6uICLMSkXbFyzlxHn8M/STFF9+UIq7rrDrihS8LSensLqRhvf5isOxBwALjSGqQ2PswV0BM
        RdyxXKFwDNb7uBTqo
X-Received: by 2002:a05:620a:4723:b0:6ce:9a32:52a9 with SMTP id bs35-20020a05620a472300b006ce9a3252a9mr15985080qkb.673.1663667478662;
        Tue, 20 Sep 2022 02:51:18 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM56mBNffswy/l5r7QVEtCSGWqSS3Rp5r4j8Wehz4PGbuCXL+babe7KhKFaSRJRZ1uBrlOzziw==
X-Received: by 2002:a05:620a:4723:b0:6ce:9a32:52a9 with SMTP id bs35-20020a05620a472300b006ce9a3252a9mr15985060qkb.673.1663667478310;
        Tue, 20 Sep 2022 02:51:18 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-90.dyn.eolo.it. [146.241.114.90])
        by smtp.gmail.com with ESMTPSA id u6-20020ae9c006000000b006ce51b541dfsm750095qkk.36.2022.09.20.02.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 02:51:17 -0700 (PDT)
Message-ID: <855e9d047fba033af54c2368091d0c6e102d6f86.camel@redhat.com>
Subject: Re: [PATCH net 0/2] Revert fec PTP changes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        =?ISO-8859-1?Q?Cs=F3k=E1s?= Bence <csokas.bence@prolan.hu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>
Date:   Tue, 20 Sep 2022 11:51:13 +0200
In-Reply-To: <9165d763-ec2c-3014-cebf-121934ad93f3@leemhuis.info>
References: <20220912070143.98153-1-francesco.dolcini@toradex.com>
         <20220912122857.b6g7r23esks43b3t@pengutronix.de>
         <20220912123833.GA4303@francesco-nb.int.toradex.com>
         <9165d763-ec2c-3014-cebf-121934ad93f3@leemhuis.info>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-09-20 at 09:45 +0200, Thorsten Leemhuis wrote:
> On 12.09.22 14:38, Francesco Dolcini wrote:
> > On Mon, Sep 12, 2022 at 02:28:57PM +0200, Marc Kleine-Budde wrote:
> > > On 12.09.2022 09:01:41, Francesco Dolcini wrote:
> > > > Revert the last 2 FEC PTP changes from Csókás Bence, they are causing multiple
> > > > issues and we are at 6.0-rc5.
> > > > 
> > > > Francesco Dolcini (2):
> > > >   Revert "fec: Restart PPS after link state change"
> > > >   Revert "net: fec: Use a spinlock to guard `fep->ptp_clk_on`"
> > > 
> > > Nitpick: I would revert "net: fec: Use a spinlock to guard
> > > `fep->ptp_clk_on`" first, as it's the newer patch.
> > 
> > Shame on me, I do 100% agree, I inverted the 2 patches last second.
> 
> What's the status of this patchset? It seems it didn't make any progress
> in the past few days, or am I missing something?

Due to some unfortunate circumstances, we have quite a bit of backlog
in the netdev patchwork. We are working to process it, and the above
revert will be processed before the next rc.

Cheers,

Paolo

