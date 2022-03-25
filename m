Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEB64E7CBF
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbiCYUck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 16:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiCYUcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 16:32:39 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC902ADD;
        Fri, 25 Mar 2022 13:31:01 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id c62so10478441edf.5;
        Fri, 25 Mar 2022 13:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=688sj//6ZYYmXeEOBA9mO+3iA2HUWbMyva2TmireD9U=;
        b=kB/tVx6DI6Rgd6ixZLqpV4Fomxj2NvOTH7zcKgx4vW3AyK/a5uKj7pBDt7VIJSZcTt
         yFyfwpI8ZA6TINWZ0ypY4Ul0qmcqdEQLmSIj9sb+p4d1/6p4jbwjtKAtUZxsGLgIXIkH
         rWTswGSYlZlr797QZICFUjlmaasJ+TmHSOuLwE4eGz0j4u2p1Wl/rwjvZsstXDmRvVGr
         CbuUEfYoqB4dvOnE8+fYS0vSqQEAx2JTeq0d9BPFkWls0GQWb8CuRsVXeSsh62ETyp3n
         s1EF9/9+bQE0FCDMT4PcH23ASib0CKeaE8GEehwEn9WLltLeQzexfYF+yWEmoUkADJiD
         CgNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=688sj//6ZYYmXeEOBA9mO+3iA2HUWbMyva2TmireD9U=;
        b=rtp/44m11S7TctEv6tmUkq72BKtatCmA28vsOxrMMgOFpuuCGcB1lfgjVQNbnG+OiM
         NHgAyzJnRa6nbfna83QwKVIaGkO/XwY6zNz50uyxojyfIAx52dCyDWBJKijPB1HpzEA/
         z1jy/XvE8gmuivmVeHyLMN6nZZqLZE9kNPVoqgWBQVhz7z1akfmumXoDSvju10P1yWKc
         IRVTabop3rjlXgK36IcKcfj3GoJSRDvC7FV72I1DM5OZpzkkVoX1fKAhgPpltMfGlEOV
         yXSS+0sJUF9ANilZimXaYO9vfSO52UP3HEdkhw9i5R/ovLSkSDvQjVA+khbq6UJ49MUR
         eZfg==
X-Gm-Message-State: AOAM532yZvVaYmSdUojvbKwHWMNzQG99D6Lvk8SZdOr8Uniech7C/XU5
        XHh8SixqkZnMr3kvDf6b8In5Je5yR64=
X-Google-Smtp-Source: ABdhPJyyV0hsBOrPNn7eKSgqfeP2ZMo+aiWYXa5UNMoWgR3oUZZRiCP+f6kWAjWOPtrDOU7PIpGRCQ==
X-Received: by 2002:a05:6402:40d5:b0:419:496b:5ab0 with SMTP id z21-20020a05640240d500b00419496b5ab0mr578673edb.284.1648240259548;
        Fri, 25 Mar 2022 13:30:59 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id b19-20020aa7dc13000000b00418eef0a019sm3237740edu.34.2022.03.25.13.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 13:30:59 -0700 (PDT)
Date:   Fri, 25 Mar 2022 22:30:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: switchdev: add support for
 offloading of fdb locked flag
Message-ID: <20220325203057.vrw5nbwqctluc6u3@skbuf>
References: <20220323144304.4uqst3hapvzg3ej6@skbuf>
 <86lewzej4n.fsf@gmail.com>
 <20220324110959.t4hqale35qbrakdu@skbuf>
 <86v8w3vbk4.fsf@gmail.com>
 <20220324142749.la5til4ys6zva4uf@skbuf>
 <86czia1ned.fsf@gmail.com>
 <20220325132102.bss26plrk4sifby2@skbuf>
 <86fsn6uoqz.fsf@gmail.com>
 <20220325140003.a4w4hysqbzmrcxbq@skbuf>
 <86tubmt408.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86tubmt408.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 05:01:59PM +0100, Hans Schultz wrote:
> > An attacker sweeping through the 2^47 source MAC address range is a
> > problem regardless of the implementations proposed so far, no?
> 
> The idea is to have a count on the number of locked entries in both the
> ATU and the FDB, so that a limit on entries can be enforced.

I can agree with that.

Note that as far as I understand regular 802.1X, these locked FDB
entries are just bloatware if you don't need MAC authentication bypass,
because the source port is already locked, so it drops all traffic from
an unknown MAC SA except for the link-local packets necessary to run
EAPOL, which are trapped to the CPU.

So maybe user space should opt into the MAC authentication bypass
process, really, since that requires secure CPU-assisted learning, and
regular 802.1X doesn't. It's a real additional burden that shouldn't be
ignored or enabled by default.

> > If unlimited growth of the mv88e6xxx locked ATU entry cache is a
> > concern (which it is), we could limit its size, and when we purge a
> > cached entry in software is also when we could emit a
> > SWITCHDEV_FDB_DEL_TO_BRIDGE for it, right?
> 
> I think the best would be dynamic entries in both the ATU and the FDB
> for locked entries.

Making locked (DPV=0) ATU entries be dynamic (age out) makes sense.
Since you set the IgnoreWrongData for source ports, you suppress ATU
interrupts for this MAC SA, which in turn means that a station which is
unauthorized on port A can never redeem itself when it migrates to port B,
for which it does have an authorization, since software never receives
any notice that it has moved to a new port.

But making the locked bridge FDB entry be dynamic, why does it matter?
I'm not seeing this through. To denote that it can migrate, or to denote
that it can age out? These locked FDB entries are 'extern_learn', so
they aren't aged out by the bridge anyway, they are aged out by whomever
added them => in our case the SWITCHDEV_FDB_DEL_TO_BRIDGE that I mentioned.

> How the two are kept in sync is another question, but if there is a
> switchcore, it will be the 'master', so I don't think the bridge
> module will need to tell the switchcore to remove entries in that
> case. Or?

The bridge will certainly not *need* to tell the switch to delete a
locked FDB entry, but it certainly *can* (and this is in fact part of
the authorization process, replace an ATU entry with DPV=0 with an ATU
entry with DPV=BIT(port)).

I feel as if I'm missing the essence of your reply.
