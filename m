Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBE96F00B8
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242997AbjD0GTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 02:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbjD0GTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:19:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DBC2D64
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682576332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+4kZo/Qbsaq4JKoenok4QRcquDwl+aQlQuXVveIPMFE=;
        b=ZD6NvahWc5TAZ0ZfOf8oIxLxY9HZHmFTKcnIBsk4euKo6/CbKzaSM4Ye8LPbESVB9NWyws
        YtoStk+tufqjCk5iks/3nhCW2JDozEHD2B6zPTCVvfsbgUPYbQyibLd8ZvD9Ujkr1e3ISv
        jIqM6Xq0ZJ3vxqMnPNPSw9G5VIxFhMg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-5H_432DyNYmEjRgZoGbQDA-1; Thu, 27 Apr 2023 02:18:50 -0400
X-MC-Unique: 5H_432DyNYmEjRgZoGbQDA-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-3edbe09ba35so12376061cf.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:18:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682576330; x=1685168330;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+4kZo/Qbsaq4JKoenok4QRcquDwl+aQlQuXVveIPMFE=;
        b=MG38W9y9uJfR1nxVetVzCTd1fkUs+lA5wipscXa9m1xHwUzM7G3tmYeXbyuKWRX8aR
         JwaZEzrvrBAa2+1yot4tnMWK9SgZvmKZUVQUtCYh7cSZcsMHYVKEXBx3qzKZAutNrCuW
         D82AmZWUIg4bMI3DxHYAu07Qh2OgeLDFgfPdOLksYkyethME/26OYgOIWg6i765irnTn
         Ql76fOYXyUBtyrEZMapttb6kLYBNsqcciiKCFUI6SCNenZLqiE6l3UFYF8Q8Tq4xVHIk
         PSdnH7rCEW9thkWUntfNeMpJIiL6r/qjlAys8p9nldVGy8t0EQKjiOPJTBYZcLtNcs+4
         ssIQ==
X-Gm-Message-State: AC+VfDzZe85CfRLbzyvSghldvba9zWPCLwuWFQRJJyWgpvPYCBB0txhr
        sQa1CHVFuiF6hwUXilRzw038UNhXoURgzbYm1e/Sl5HD9BFJyAI5/Ekc1H9NzkquJvy9h56ramj
        zcqxWjjJlG1DXmVwl
X-Received: by 2002:a05:622a:510:b0:3ef:37fa:e1d6 with SMTP id l16-20020a05622a051000b003ef37fae1d6mr675632qtx.2.1682576330128;
        Wed, 26 Apr 2023 23:18:50 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6M3/VRdjINH6Lpid2UADYjmHq2IzUQQv8BAmzJH74JKD2o/Ksr5DLhlEIi9Rh6sSZ82ZN6WQ==
X-Received: by 2002:a05:622a:510:b0:3ef:37fa:e1d6 with SMTP id l16-20020a05622a051000b003ef37fae1d6mr675612qtx.2.1682576329885;
        Wed, 26 Apr 2023 23:18:49 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-21.dyn.eolo.it. [146.241.243.21])
        by smtp.gmail.com with ESMTPSA id w8-20020a05620a444800b0074e026a6a43sm5694786qkp.9.2023.04.26.23.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 23:18:49 -0700 (PDT)
Message-ID: <69928a2f43bea996380fa311a38ab0d1e4cdcf08.camel@redhat.com>
Subject: Re: [net-next Patch v10 0/8] octeontx2-pf: HTB offload support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvell.com,
        edumazet@google.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, maxtram95@gmail.com, corbet@lwn.net
Date:   Thu, 27 Apr 2023 08:18:44 +0200
In-Reply-To: <20230426054731.5720-1-hkelam@marvell.com>
References: <20230426054731.5720-1-hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-04-26 at 11:17 +0530, Hariprasad Kelam wrote:
> octeontx2 silicon and CN10K transmit interface consists of five
> transmit levels starting from MDQ, TL4 to TL1. Once packets are
> submitted to MDQ, hardware picks all active MDQs using strict
> priority, and MDQs having the same priority level are chosen using
> round robin. Each packet will traverse MDQ, TL4 to TL1 levels.
> Each level contains an array of queues to support scheduling and
> shaping.
>=20
> As HTB supports classful queuing mechanism by supporting rate and
> ceil and allow the user to control the absolute bandwidth to
> particular classes of traffic the same can be achieved by
> configuring shapers and schedulers on different transmit levels.

## Form letter - net-next-closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.
--=20
pw-bot: defer


