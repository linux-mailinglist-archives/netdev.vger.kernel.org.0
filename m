Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7BD357766D
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 15:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbiGQNqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 09:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiGQNqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 09:46:18 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1C81208E;
        Sun, 17 Jul 2022 06:46:15 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r6so12070031edd.7;
        Sun, 17 Jul 2022 06:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3snnUZxZCWHMhOcKHlOWclrI7YiFMnqf91pq4umLDns=;
        b=eRc4tc5JtUvdUWPkURoFV8ez0+p3D+QqcBJWlyuztniK9aVQ5p/exfDXy4rZ7kX00B
         OBbIn+33j4UdZ/3Ce0/Zxvyfq8yic3QaCQlbYYwuc8RGTkAYvZ+PAa0vHlvlGwXsBULL
         07tsJIqkMWlgkO4I4C3pNkKYUgvpKS2WmrGBqekKyFh6l+AKIFY0aNgl4Y4cE2gCTInw
         KwAQZ3IH604GUPeVM02HXQFY3c1rCd10i/1BOfrYvy6t/SVAyyuiHddolM1H3Ex2KBRt
         PX6/ThilnY/EBfhO9wPGVEUWRnsHzxe/p/m0QiErcuZaQKUoobeCeIWBNFOZRMTHorH2
         9vtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3snnUZxZCWHMhOcKHlOWclrI7YiFMnqf91pq4umLDns=;
        b=6YabqSvCLeidMEIQ3zM0DbHKy90lKVkNSg/KiG/qCNRt1hbql/k5mOipH+1D/haJ7L
         HcMN1RN1ZN163nBbarkz/UgvzGJ98XVkFpCLtkHFcjOdpso5Ha+mt3EeCSW6x4O5Z3Rs
         XYIfdnN/vl0gndOGtZ7X6ciwtMOnwVjC9/HWGcH74ezCVzSiIdIar3Yu3JSvqzNk7Htd
         fOFTej6pFEe7WdsJJeZHQJJ8WyS+q/Z1k9Jh1jCGjUyJUe9OP46GtR7BKTBMHNT570Ac
         GxuTW3YWmDQ4qZJ07HCjmYaMHDu3abTrZF2dOqgFH7Gz0E0bZHFVr4qJniW4k/B3e0Ca
         bGpA==
X-Gm-Message-State: AJIora8ybAKIkiLz/NPf7CotpsgI12D+8mgJdDtWjDYGrHTwXH5/8tHa
        ib+KI51z8cBnZ4tv/inB8GM=
X-Google-Smtp-Source: AGRyM1uxl3lB+c2VdqKlGjDQ+XKGduVZ6JN4M6RmG/QPQEd7S6Dde6PS2FwsH7wUcA4xOS8U8CGhfg==
X-Received: by 2002:a05:6402:c92:b0:43a:7177:5be7 with SMTP id cm18-20020a0564020c9200b0043a71775be7mr31827872edb.224.1658065574143;
        Sun, 17 Jul 2022 06:46:14 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id d27-20020a056402401b00b0043a8f5ad272sm6770681eda.49.2022.07.17.06.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 06:46:13 -0700 (PDT)
Date:   Sun, 17 Jul 2022 16:46:10 +0300
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
Message-ID: <20220717134610.k3nw6mam256yxj37@skbuf>
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder>
 <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder>
 <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hans,

On Fri, Jul 01, 2022 at 06:07:10PM +0200, Hans S wrote:
> On Fri, Jul 1, 2022 at 3:51 PM Ido Schimmel <idosch@nvidia.com> wrote:
> >
> > On Fri, Jul 01, 2022 at 09:47:24AM +0200, Hans S wrote:
> > > One question though... wouldn't it be an issue that the mentioned
> > > option setting is bridge wide, while the patch applies a per-port
> > > effect?
> >
> > Why would it be an issue? To me, the bigger issue is changing the
> > semantics of "locked" in 5.20 compared to previous kernels.
> >
> > What is even the use case for enabling learning when the port is locked?
> > In current kernels, only SAs from link local traffic will be learned,
> > but with this patch, nothing will be learned. So why enable learning in
> > the first place? As an administrator, I mark a port as "locked" so that
> > only traffic with SAs that I configured will be allowed. Enabling
> > learning when the port is locked seems to defeat the purpose?
> >
> > It would be helpful to explain why mv88e6xxx needs to have learning
> > enabled in the first place. IIUC, the software bridge can function
> > correctly with learning disabled. It might be better to solve this in
> > mv88e6xxx so that user space would not need to enable learning on the SW
> > bridge and then work around issues caused by it such as learning from
> > link local traffic.
> 
> There is several issues when learning is turned off with the mv88e6xxx driver:
> 
> Mac-Auth requires learning turned on, otherwise there will be no miss
> violation interrupts afair.
> Refreshing of ATU entries does not work with learning turn off, as the
> PAV is set to zero when learning is turned off.
> This then further eliminates the use of the HoldAt1 feature and
> age-out interrupts.
> 
> With dynamic ATU entries (an upcoming patch set), an authorized unit
> gets a dynamic ATU entry, and if it goes quiet for 5 minutes, it's
> entry will age out and thus get removed.
> That also solves the port relocation issue as if a device relocates to
> another port it will be able to get access again after 5 minutes.

I think the discussion derailed at this exact point, when you responded
that "Mac-Auth requires learning turned on".

What precise feature do you describe when you say "Mac-Auth"? Do you
mean 802.1X MAC-based authentication in general (where data plane
packets on a locked port are dropped unless their MAC SA is in the FDB,
and populating the FDB is *entirely* up to user space, there aren't any
locked FDB entries on locked ports), or MAC authentication *bypass*
(where the kernel auto-adds locked FDB entries on locked ports)?

I *think* it's just the bypass that requires learning in mv88e6xxx.
But the bypass (the feature where the kernel auto-adds locked FDB
entries on locked ports) doesn't exist in net-next.

Here, what happens is that a locked port learns the MAC SA from the
traffic it didn't drop, i.e. link-local. In other words, the bridge
behaves as expected and instructed: +locked +learning will cause just
that. It's the administrator's fault for not disabling learning.
It's also the mv88e6xxx driver's fault for not validating the "locked" +
"learning" brport flag *combination* until it properly supports "+locked
+learning" (the feature you are currently working on).

I'm still confused why we don't just say that "+locked -learning" means
plain 802.1X, "+locked +learning" means MAB where we learn locked FDB entries.
