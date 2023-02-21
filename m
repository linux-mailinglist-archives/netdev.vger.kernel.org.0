Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5940E69E044
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 13:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbjBUMYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 07:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbjBUMYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 07:24:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420A41A7
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676982198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SNXFmKIe+V0KQQC9g0T60ZJMUB3rW25DANWb62cyY2c=;
        b=WOrNKOrJBVvHp8x4HY5H0OZgqxB+JEeVBTLbmkAAgSyOiW9VMKwWXPAsCNlL9A3BRo95AX
        FdXeyJTesvKdDBDoU2sMpjztRLkU9oGFFj0/gyW3U6Nk5PkGOV8ZWVZC9+V+21TjTNQd8F
        R9zYmEpbnK0ahBRqU+dE1IX6A0Qv/G8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-416-dzipoZcuOmqbJU5O3uxN2Q-1; Tue, 21 Feb 2023 07:17:14 -0500
X-MC-Unique: dzipoZcuOmqbJU5O3uxN2Q-1
Received: by mail-wm1-f72.google.com with SMTP id l23-20020a7bc457000000b003e206cbce8dso1980778wmi.7
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 04:17:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676981833;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SNXFmKIe+V0KQQC9g0T60ZJMUB3rW25DANWb62cyY2c=;
        b=m6ZgPTrgp0k2nVGSkRSi1ia9OQ5b9yei/vVu3Q/wGcSsLg7vVJwhgQQHxxUgc5NNle
         4ooi4DJpbqh2L1f0N+lv3S+QCTuhLnhXaWsOaQjCeDO4B3ZeOhevEiWuWD7aRqtQ4TYY
         TRduRVgoWb5gFhJGetNcZ3xyoea1QdORhYArtqQAh7tuDUhyQSfJgW0p1FLymB/3P3SP
         mFywOmI4G1ErEx0dKkaTEbNDxNhwFd1JMC8Vix4MFZ+dxvPS7wa45pkYhrTJeEjWw/NK
         tyFQE+cCwvEm920etwGASadI/44kLdfsGE6f/tH+Chdoydu68ttLl7Nb+/BuOnFQ3Ivt
         wuwA==
X-Gm-Message-State: AO0yUKXi2ubSKmcykPxZuveTbhPVncusQGG+lL3PpwtvZcjxsOQnhDET
        whEQj2lONXJuASDDEzZCruM0ivKlzN7qhYpynazn9dK49FS8c3bfBQ/IF02MxcsJPPL4C5YN4FY
        oTqvjZWSjYxhtirdR
X-Received: by 2002:a5d:4c85:0:b0:2c6:eaaa:ac1f with SMTP id z5-20020a5d4c85000000b002c6eaaaac1fmr2675999wrs.3.1676981833140;
        Tue, 21 Feb 2023 04:17:13 -0800 (PST)
X-Google-Smtp-Source: AK7set/lVTYGNh4HaCwtBDAJNc3LFnn0IQ5vN5n09FC9/X7Gp9R15fLBQbwKliTEdMyWa2pssfAD7A==
X-Received: by 2002:a5d:4c85:0:b0:2c6:eaaa:ac1f with SMTP id z5-20020a5d4c85000000b002c6eaaaac1fmr2675985wrs.3.1676981832813;
        Tue, 21 Feb 2023 04:17:12 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id z1-20020a5d4c81000000b002c560e6ea57sm4181149wrs.47.2023.02.21.04.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 04:17:12 -0800 (PST)
Message-ID: <5ae9c011b1b818badfd1291823fef812e9748077.camel@redhat.com>
Subject: Re: [PATCH net-next] net: phy: update obsolete comment about
 PHY_STARTING
From:   Paolo Abeni <pabeni@redhat.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-renesas-soc@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 21 Feb 2023 13:17:10 +0100
In-Reply-To: <20230221105711.39364-1-wsa+renesas@sang-engineering.com>
References: <20230221105711.39364-1-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-02-21 at 11:57 +0100, Wolfram Sang wrote:
> Commit 899a3cbbf77a ("net: phy: remove states PHY_STARTING and
> PHY_PENDING") missed to update a comment in phy_probe. Remove
> superfluous "Description:" prefix while we are here.
>=20
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.

