Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4319157CD30
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiGUOUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiGUOUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:20:09 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F316EA3;
        Thu, 21 Jul 2022 07:20:07 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id m8so2344190edd.9;
        Thu, 21 Jul 2022 07:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qXv6CUvSTMfPvvXNvz/Br6ygFjjEQtW3IZorN82JkiU=;
        b=P+0nQPKeA3PoGFzwFw3rHozuSxcxC8sThvgWr85Jgf8I0HLON9ganDXQeF+CXi03M8
         QjR7MJw6kirPoUgYH+Giho7PJvp2ReSEvld3BVDqJP1IlxeQfywVwXtpsBRJSXX4+jWb
         plznFF7jPvGt3gwaqtL2/00LYhCFhrX8Q2iWYZFHKd/mPx6Mpu3FViZ6AsRPoG3iofQI
         H3FmIsHff9UoPwOJzMMdft7cHqTf5qN4rDyGg8bdoUwiX6nh+bYwn2P7RsU/suilsCsu
         3pYjs4Ujkes4hhtM+BsOvm8IEzRBpXWF+HOV66ewkbbfBisnVv6XU9Kv1t4SKZAjMJNo
         0u+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qXv6CUvSTMfPvvXNvz/Br6ygFjjEQtW3IZorN82JkiU=;
        b=bchfPPGoVgR6mRbVMdStTaaep7JZadvGRQHdRRNwST70mhK69yqckrp7YmIC210KS+
         WrRcl/lWD1hGZPYIZLz3N7w6+M7TY+o3Bj0aJZAEpjISUw0FsZ70Xvi25MzsqRc3tXM9
         W1SEiwRTOphZJl30GWnBfhwdYf2rVuELYFLktSB9T7qdoq/DSWRoaw+eBkJvk9Z0y7rQ
         Q+4s3hgLUZRAuDivTB/YzqNHnaoh8/eqyDGw1raMfWglyvd5A1NVe97bzTwZS1alf3PH
         PLFmyUZ6vvpqBVJAAUrhk8dBZaMdPmeHDl3Be+Y3Pfsc1mi9C9eYcR4m9oBuoOXh03bW
         Z30A==
X-Gm-Message-State: AJIora8GfmBKWXBl5GJ7xDGeBJfcN7KJknS/QECB32pmRq/hY4O0QS96
        1tC8Ga7R16jpAd/+/lJT+AY=
X-Google-Smtp-Source: AGRyM1uGxCFM+uC51rrnQKpnRyzGOk2xs0Ei7v+HkEZHqj5CW5fMsFpSjcMs9VwNKiAXPxxspRRC+w==
X-Received: by 2002:a05:6402:159a:b0:43b:ba6c:d0e2 with SMTP id c26-20020a056402159a00b0043bba6cd0e2mr8810492edv.418.1658413205937;
        Thu, 21 Jul 2022 07:20:05 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id w12-20020a05640234cc00b0043bc5ee3ec4sm1105646edc.22.2022.07.21.07.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 07:20:04 -0700 (PDT)
Date:   Thu, 21 Jul 2022 17:20:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@kapio-technology.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <20220721142001.twcmiyvhvlxmp24j@skbuf>
References: <20220708115624.rrjzjtidlhcqczjv@skbuf>
 <723e2995314b41ff323272536ef27341@kapio-technology.com>
 <YsqPWK67U0+Iw2Ru@shredder>
 <d3f674dc6b4f92f2fda3601685c78ced@kapio-technology.com>
 <Ys69DiAwT0Md+6ai@shredder>
 <648ba6718813bf76e7b973150b73f028@kapio-technology.com>
 <YtQosZV0exwyH6qo@shredder>
 <4500e01ec4e2f34a8bbb58ac9b657a40@kapio-technology.com>
 <20220721115935.5ctsbtoojtoxxubi@skbuf>
 <YtlUWGdgViyjF6MK@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtlUWGdgViyjF6MK@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 04:27:52PM +0300, Ido Schimmel wrote:
> I tried looking information about MAB online, but couldn't find
> detailed material that answers my questions, so my answers are based
> on what I believe is logical, which might be wrong.

I'm kind of in the same situation here.

> Currently, the bridge will forward packets to a locked entry which
> effectively means that an unauthorized host can cause the bridge to
> direct packets to it and sniff them. Yes, the host can't send any
> packets through the port (while locked) and can't overtake an existing
> (unlocked) FDB entry, but it still seems like an odd decision. IMO, the
> situation in mv88e6xxx is even worse because there an unauthorized host
> can cause packets to a certain DMAC to be blackholed via its zero-DPV
> entry.
> 
> Another (minor?) issue is that locked entries cannot roam between locked
> ports. Lets say that my user space MAB policy is to authorize MAC X if
> it appears behind one of the locked ports swp1-swp4. An unauthorized
> host behind locked port swp5 can generate packets with SMAC X,
> preventing the true owner of this MAC behind swp1 from ever being
> authorized.

In the mv88e6xxx offload implementation, the locked entries eventually
age out from time to time, practically giving the true owner of the MAC
address another chance every 5 minutes or so. In the pure software
implementation of locked FDB entries I'm not quite sure. It wouldn't
make much sense for the behavior to differ significantly though.

> It seems like the main purpose of these locked entries is to signal to
> user space the presence of a certain MAC behind a locked port, but they
> should not be able to affect packet forwarding in the bridge, unlike
> regular entries.

So essentially what you want is for br_handle_frame_finish() to treat
"dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);" as NULL if
test_bit(BR_FDB_LOCKED, &dst->flags) is true?

> Regarding a separate knob for MAB, I tend to agree we need it. Otherwise
> we cannot control which locked ports are able to populate the FDB with
> locked entries. I don't particularly like the fact that we overload an
> existing flag ("learning") for that. Any reason not to add an explicit
> flag ("mab")? At least with the current implementation, locked entries
> cannot roam between locked ports and cannot be refreshed, which differs
> from regular learning.

Well, assuming we model the software bridge closer to mv88e6xxx (where
locked FDB entries can roam after a certain time), does this change things?
In the software implementation I think it would make sense for them to
be able to roam right away (the age-out interval in mv88e6xxx is just a
compromise between responsiveness to roaming and resistance to DoS).
