Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D554CE4CC
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 13:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiCEMda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 07:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiCEMd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 07:33:29 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFA1C38
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 04:32:38 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id yy13so13876908ejb.2
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 04:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5OoA3AIO1+HummcEt7JiVlFD8HGCvCpggXSDPGx3O7E=;
        b=JUein4NhTKKskLZBwlt7kTb5sWGXSHM6cmH+KDloMIr57uUej+UQGhY0KM6A04X1zO
         r94qNWS6sHb6alhyIuAa8TjSXr5sLh82PWy8W8Ql5pgwCYlHyrPbshVNo4emVe+e3Wzn
         kNGjTffSui1tSYciNAv/dDHG8pEA3LMAE6Hy9iviT9wWNgTrGI4O9LeN0xN5+flqbYsG
         srU0abB0yNsrkhkzNG8XYx7egLs3Q+tdVpvdf/3uc75Mg1YHQkDzyqMLZ9WB2nckZzQ8
         97ZJ76dKasFItAl4jKSke2PriPLHPfe5793ig7TYf+UNci5Z2zzVJq5Y2m9QbeXV5IhQ
         dZdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5OoA3AIO1+HummcEt7JiVlFD8HGCvCpggXSDPGx3O7E=;
        b=xwKD6iDVsHfWsJvDnGhJEWivg8GgT3DvUyDVaV5koDPOuHhAv93s8pccLZKIQr4j+r
         ITFoXQzQPJyOc54NbeOc3cAjQWPCEixQlY6X4t3UHLoMwuB+NeXy/GpEB9Px3pyg4noJ
         NJR6nZGblJxgTEg2/HqcdKtmcjpmjgYjD6dNQb4km+WHRbeD2cK82HkyZEIxdOwLQv7z
         p3t7dTa3qKpmSsW/T+ixnapZ08eJ73plJTeN2QwGbHEqW4TlqlwvLtJ4GHksyI90g4cV
         cpAu4H/qpBAnNu3kWRgfKpmP+SY8MkZEydGOQrn2BQ3SZ+kBTwqtznx8q5Kvenrpw9pW
         bePA==
X-Gm-Message-State: AOAM531D/eotrtN0b13n/1bS0GelEix8HXq0WheqNdw7JutP+zJsul/6
        o/lV7bIXEzUfaFm3l4UdWXhuKLSbICg=
X-Google-Smtp-Source: ABdhPJxYmKddh6e8P/vg42S4VoyJP63alwjG+XFu0pt+N7nlcBr4NMzTuSsmxtcRg0Jft/l0Y1NWBw==
X-Received: by 2002:a17:906:9bd7:b0:6d6:e920:8d04 with SMTP id de23-20020a1709069bd700b006d6e9208d04mr2647999ejc.547.1646483557023;
        Sat, 05 Mar 2022 04:32:37 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id re27-20020a170906d8db00b006d76251f4e7sm2829003ejb.109.2022.03.05.04.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 04:32:36 -0800 (PST)
Date:   Sat, 5 Mar 2022 14:32:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH v2 net-next] net: dsa: unlock the rtnl_mutex when
 dsa_master_setup() fails
Message-ID: <20220305123234.z7dotdedlqdsokj6@skbuf>
References: <20220303140840.1818952-1-vladimir.oltean@nxp.com>
 <20220304205659.5e0c6997@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304205659.5e0c6997@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 08:56:59PM -0800, Jakub Kicinski wrote:
> On Thu,  3 Mar 2022 16:08:40 +0200 Vladimir Oltean wrote:
> > Subject: [PATCH v2 net-next] net: dsa: unlock the rtnl_mutex when dsa_master_setup() fails
> 
> Did you mean s/-next//?

I really meant net-next, but now I see that I was wrong.
What I did was:

git tag --contains c146f9bc195a
v5.17-rc1
v5.17-rc2
v5.17-rc3
v5.17-rc4
v5.17-rc5
v5.17-rc6

and from this I drew the incorrect conclusion that the patch was merged
during the v5.17 rc's, for inclusion in v5.18.

> 
> > After the blamed commit, dsa_tree_setup_master() may exit without
> > calling rtnl_unlock(), fix that.
> > 
> > Fixes: c146f9bc195a ("net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> > v1->v2: actually propagate the error code instead of always returning 0
