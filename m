Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2973F57C9E5
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 13:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233171AbiGULps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 07:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiGULpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 07:45:47 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9A68213B;
        Thu, 21 Jul 2022 04:45:46 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id g1so1779896edb.12;
        Thu, 21 Jul 2022 04:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z0+wVeznGOhrF2PQZAZsTW98eQP0pfgcFl8bmcvRHk4=;
        b=jBQ3tHqiU5j8c9PUfH8HkZF0hFZ6L33OoB2KBuDZ3Wu49WOzt54VTcmDCjYkTO5hCU
         T65wKmm6bApDnSyDdsa8Fs6ks/4NNBGe+C7ZtioowfqwqVL1d4J69vy98i3EdknV+fM4
         UBTMhQGMAgDrpC2iWVTGvP+qNS6o+bWD3jTFA8Dh09jneWhaZHjsZdgLoPLeFnAwsYH1
         9dPUju5cUfAn5ZtvIxpbWJw4laOv0MSk8GeWv+TRThzn1ZX2qp+PtmUgLS1LW9fJ5+mq
         F3UvE/gBF3SUgMoP8OqsQqZ9c1PSRvzAMrvN4Mg2BDAIHYbs6YGCCOD/7fUCpbn/+2x8
         QyyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z0+wVeznGOhrF2PQZAZsTW98eQP0pfgcFl8bmcvRHk4=;
        b=LJRu649JJsEwu9/WQO8DDVQT5MgNsUFl+cKV5pC06SVGniS1t4dvNkkwGSSPSQo1ET
         lPBLks4rNdhbD89UgsN4hmnb9uyyLEBxPkXidu8AUPrD4KBC1X/C+KtU2RfrZ6hQ3zV/
         U2GgxKsJ/pOkoFyKPe1EBoxmV4CxwBIs99X+RPxsBjYzaIohZzYpH2fZFza20FdJwhTx
         H3GJ6zfqYZ0nEFHhdeS/JfqiYpI0K9gNMducooTKGDJlINM5n43LhAQ7bUN5M9edduu+
         dcqHMf+VHRTG33WDMltVHFD/SsaXiDD9VZPqlXxVCXF3Kk9yAvCtdjuUt5GaXuI3knDY
         Rf9w==
X-Gm-Message-State: AJIora+gUXt0jkhSOdnN0eK9zpxTMBTVip6Qct+2yPCFg8p/U1gZnxJd
        gITbFlV7EEfbfOdmevONbXQ=
X-Google-Smtp-Source: AGRyM1tL0AuwhW8Q9+cnhtPSM6/usR06tvWsKej6gm85BQK/JC0IDnM6icXBsHNzrgRibg5NVrHXAQ==
X-Received: by 2002:a05:6402:11c7:b0:43a:c61c:21cd with SMTP id j7-20020a05640211c700b0043ac61c21cdmr56153170edw.108.1658403944462;
        Thu, 21 Jul 2022 04:45:44 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id kw26-20020a170907771a00b0072124df085bsm788710ejc.15.2022.07.21.04.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 04:45:43 -0700 (PDT)
Date:   Thu, 21 Jul 2022 14:45:40 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans S <schultz.hans@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
Message-ID: <20220721114540.ovm22rtnwqs77nfb@skbuf>
References: <Yr2LFI1dx6Oc7QBo@shredder>
 <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder>
 <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <20220717134610.k3nw6mam256yxj37@skbuf>
 <20220717140325.p5ox5mhqedbyyiz4@skbuf>
 <CAKUejP6g3HxS=Scj-2yhsQRJApxnq1e31Nkcc995s7gzfMJOew@mail.gmail.com>
 <20220717183852.oi6yg4tgc5vonorp@skbuf>
 <CAKUejP7WyL2r03EiZU4hA63u2e=Wz3KM4X=rDdji5pdZ0ptaZg@mail.gmail.com>
 <CAKUejP7WyL2r03EiZU4hA63u2e=Wz3KM4X=rDdji5pdZ0ptaZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUejP7WyL2r03EiZU4hA63u2e=Wz3KM4X=rDdji5pdZ0ptaZg@mail.gmail.com>
 <CAKUejP7WyL2r03EiZU4hA63u2e=Wz3KM4X=rDdji5pdZ0ptaZg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 09:20:57PM +0200, Hans S wrote:
> On Sun, Jul 17, 2022 at 8:38 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Sun, Jul 17, 2022 at 06:22:57PM +0200, Hans S wrote:
> > > On Sun, Jul 17, 2022 at 4:03 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > Yes, it creates an FDB entry in the bridge without the locked flag
> > > set, and sends an ADD_TO_DEVICE notice with it.
> > > And furthermore link-local packets include of course EAPOL packets, so
> > > that's why +learning is a problem.
> >
> > So if we fix that, and make the dynamically learned FDB entry be locked
> > because the port is locked (and offload them correctly in mv88e6xxx),
> > what would be the problem, exactly? The +learning is what would allow
> > these locked FDB entries to be created, and would allow the MAB to work.
> > User space may still decide to not authorize this address, and it will
> > remain locked.
> 
> The alternative is to have -learning and let the driver only enable
> the PAV to admit the interrupts, which is what this implementation
> does.
> The plus side of this is that having EAPOL packets triggering locked
> entries from the bridge side is not really so nice IMHO. In a
> situation with 802.1X and MAB on the same port, there will then not be
> any triggering of MAB when initiating the 802.1X session, which I
> think is the best option. It then also lessens the confusion between
> hostapd and the daemon that handles MAB sessions.

Why is it "not really so nice" to "trigger MAB" (in fact only to learn a
locked entry on a locked port) when initiating the 802.1X session?
You can disable link-local learning via the bridge option if you're
really bothered by that. When you have MAB enabled on an 802.1X port,
I think it's reasonable to expect that there will be some locked entries
which user space won't ever unlock via MAB. If those entries happen to
be created as a side effect of the normal EAPOL authentication process,
I don't exactly see where is the functional problem. This shouldn't
block EAPOL from proceeding any further, because this protocol uses
link-local packets which are classified as control traffic, and that
isn't subject to FDB lookups but rather always trapped to CPU, so locked
or not, it should still be received.

I'm only pointing out the obvious here, we need an opt in for MAB, and
the implemented behavior I've seen here kind of points to mapping this
to "+learning +locked", where the learning process creates locked FDB entries.
