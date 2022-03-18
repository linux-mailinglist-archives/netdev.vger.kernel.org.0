Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0DC4DDA60
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 14:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbiCRNVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 09:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiCRNVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 09:21:07 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B72C17C40B;
        Fri, 18 Mar 2022 06:19:47 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y22so10256282eds.2;
        Fri, 18 Mar 2022 06:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BbGAlf0EmAgXlRj+2JMlCkobYzhN57bh1dokSTQjOWs=;
        b=fM3jgWv5DnT+6qxziTK3Gafb23V5t7n+p+sS6PKhT8QpL5WGP6pQyoyOfHO6/EzmgN
         4KsyNYpY8aUwzmq6/30Sf/mTZLJq3Fyq7SvOloc4fM6H9Ny0a4wZx95jL8CQiUJOfojK
         zO/UPrFcSUDBX0sVWitdzrQP6mLcocW3U7BYJiVsZ6L80so3BrUp5lx2QPVFW0BsEP7T
         JwQoDSmEZPMNjtTvL6YHq9XcFtRt1Y+sTAWAJxPlxgqO5nPE5IVieworafUO41RSvMqr
         togJQxerUnwrXtqEEg/iu9Ea38eo+oFP20XDYKRwNc4NhaRpHRkcjuX21XPmexWpUFG2
         brJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BbGAlf0EmAgXlRj+2JMlCkobYzhN57bh1dokSTQjOWs=;
        b=JORueoOSO/roQn7Yn0/6wIuXg3uhsd1q9HAkl0E7ZJuVzYr1LkBnPdoUf2hQaN4ViC
         sGdr1jtdVWhdKCjIWnrABQb8nBjDKQdzFpFBmXtA/2KGvt9K+1SSFzMMVUhXFFYxA2fI
         /jHCY1d6K/RaVFGf5l1Bi83Yr4Ac3YKKQOhrGvVwPknFtmD3oqZbvxSWqck6/bcffqMl
         ZjtMYaxLDpFT9Nme25zSAWX5LxgxkcZXa9k4Bqg/GscuINJkkQm/AyDBKRzyOXQX6TVt
         ChDt2uVUTLYZ414UpXofAKZZP4GkLuf8JwRA7nVF+GqxoK7C1toa62ScGctMmyteSIIY
         ZuNw==
X-Gm-Message-State: AOAM5310rerLY4J7/bE3ImawYxKIe4h5xBWwlyJRlROTlWqIknLBSCiz
        kkvTQJDDrzZG9Si8L55BCG8=
X-Google-Smtp-Source: ABdhPJxLPH1C00eELL5tKmohaNpQSpzPlpyKDYoaYWX+GoHfw5lFMx7iFX/m0iBbJH0FW6MW0C4yig==
X-Received: by 2002:a50:99cd:0:b0:418:d6c2:2405 with SMTP id n13-20020a5099cd000000b00418d6c22405mr9365405edb.342.1647609585698;
        Fri, 18 Mar 2022 06:19:45 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id i22-20020a170906251600b006d6d9081f46sm3677768ejb.150.2022.03.18.06.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 06:19:45 -0700 (PDT)
Date:   Fri, 18 Mar 2022 15:19:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220318131943.hc7z52beztqlzwfq@skbuf>
References: <86lex9hsg0.fsf@gmail.com>
 <YjNDgnrYaYfviNTi@lunn.ch>
 <20220317153625.2ld5zgtuhoxbcgvo@skbuf>
 <86ilscr2a4.fsf@gmail.com>
 <20220317161808.psftauoz5iaecduy@skbuf>
 <8635jg5xe5.fsf@gmail.com>
 <20220317172013.rhjvknre5w7mfmlo@skbuf>
 <86tubvk24r.fsf@gmail.com>
 <20220318121400.sdc4guu5m4auwoej@skbuf>
 <86pmmjieyl.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pmmjieyl.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 02:10:26PM +0100, Hans Schultz wrote:
> In the offloaded case there is no difference between static and dynamic
> flags, which I see as a general issue. (The resulting ATU entry is static
> in either case.)

It _is_ a problem. We had the same problem with the is_local bit.
Independently of this series, you can add the dynamic bit to struct
switchdev_notifier_fdb_info and make drivers reject it.

> These FDB entries are removed when link goes down (soft or hard). The
> zero DPV entries that the new code introduces age out after 5 minutes,
> while the locked flagged FDB entries are removed by link down (thus the
> FDB and the ATU are not in sync in this case).

Ok, so don't let them disappear from hardware, refresh them from the
driver, since user space and the bridge driver expect that they are
still there.
