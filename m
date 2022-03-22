Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8D04E3D37
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 12:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbiCVLKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 07:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234127AbiCVLJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 07:09:52 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC07D71EED;
        Tue, 22 Mar 2022 04:08:10 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id w4so21178789edc.7;
        Tue, 22 Mar 2022 04:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9ZYK2bO0oPIhpErMM+q2xzW2Mm6s9oaP61Irqyq44+o=;
        b=Nvd7dfWXP+MA7dn8CeB7ApslVwt7Ch4qLfscmiSOHeFbaOF9/tK1poS1ifcMe3ghNg
         DnCEz0wXmVONAozXAWG/QpUZ4hiqnzDPu35fl+Oht/1JY2MNekzvFurIZPRK9t/7rxZS
         jQDTi9f0zRetFMQRsN1rLdQSRxaaGPNqka4iqCdbRHdX/PjP+gv6AxOPBUGud1P0psXO
         BCooV9cbBp7iFmg4K8E0k9YVVMJWkK8r3oJTpljeWkfSp9Y9W+mb7xk88H/CNd5BtcM3
         SSlFK/VVUIZV5bVyZBvk+zDc7RNpT/k+MCpku+Wej43wkkN4k2xU3ruiYTp8mggUiK4h
         ez/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9ZYK2bO0oPIhpErMM+q2xzW2Mm6s9oaP61Irqyq44+o=;
        b=HsAp2N3h172GtlVWR95NBX/hb2uesgsrhBAYVXhwNqBES8dYtJXhqMnbcKrvJl5RIj
         Zes2/MW1P7+l8br73fsO2rt0xKtbzqKOdTFZqETjpaT5kB/34jSuXGC863uK+G5wSoem
         iIUPGu37NNUQdnELpqeO8NKMQHRMNGwvyPM0qmPi8yFuxfgC4PFNqZJjnF6NoWGSH4Ch
         TVugiMJjoGkOppmLAf5GpxETcnK0+MsDKqo9foAP/L9TnUK5jlSZcpX5HI1JxoIbos7m
         nD7X5XDCxXffmG+OV/9PmR3VZmyiyJ6DNkqLUTbqOePXsVyonFx9b2T1DN+Z6Mgus8sj
         HGOg==
X-Gm-Message-State: AOAM531CNtHaT5Dd1ZZ4TxIuntHAdf7JyGYk0y/Barj75on1pZ1MixEg
        daMmZfwoeSa3oZ9TKRm5y3A=
X-Google-Smtp-Source: ABdhPJxwzHI14us8PNdJyGZCDFh1poffoPsaBjmk5C1HtrUqXOCt2KvM/2Sr02yEmj1OjpVrpDyDEQ==
X-Received: by 2002:a05:6402:168a:b0:3fb:600e:4cc3 with SMTP id a10-20020a056402168a00b003fb600e4cc3mr27599944edv.32.1647947288419;
        Tue, 22 Mar 2022 04:08:08 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id u9-20020a170906124900b006ce88a505a1sm8482338eja.179.2022.03.22.04.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 04:08:07 -0700 (PDT)
Date:   Tue, 22 Mar 2022 13:08:06 +0200
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
Message-ID: <20220322110806.kbdb362jf6pbtqaf@skbuf>
References: <20220317153625.2ld5zgtuhoxbcgvo@skbuf>
 <86ilscr2a4.fsf@gmail.com>
 <20220317161808.psftauoz5iaecduy@skbuf>
 <8635jg5xe5.fsf@gmail.com>
 <20220317172013.rhjvknre5w7mfmlo@skbuf>
 <86tubvk24r.fsf@gmail.com>
 <20220318121400.sdc4guu5m4auwoej@skbuf>
 <86pmmjieyl.fsf@gmail.com>
 <20220318131943.hc7z52beztqlzwfq@skbuf>
 <86a6dixnd2.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86a6dixnd2.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 12:01:13PM +0100, Hans Schultz wrote:
> On fre, mar 18, 2022 at 15:19, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Fri, Mar 18, 2022 at 02:10:26PM +0100, Hans Schultz wrote:
> >> In the offloaded case there is no difference between static and dynamic
> >> flags, which I see as a general issue. (The resulting ATU entry is static
> >> in either case.)
> >
> > It _is_ a problem. We had the same problem with the is_local bit.
> > Independently of this series, you can add the dynamic bit to struct
> > switchdev_notifier_fdb_info and make drivers reject it.
> >
> >> These FDB entries are removed when link goes down (soft or hard). The
> >> zero DPV entries that the new code introduces age out after 5 minutes,
> >> while the locked flagged FDB entries are removed by link down (thus the
> >> FDB and the ATU are not in sync in this case).
> >
> > Ok, so don't let them disappear from hardware, refresh them from the
> > driver, since user space and the bridge driver expect that they are
> > still there.
> 
> I have now tested with two extra unmanaged switches (each connected to a
> seperate port on our managed switch, and when migrating from one port to
> another, there is member violations, but as the initial entry ages out,
> a new miss violation occurs and the new port adds the locked entry. In
> this case I only see one locked entry, either on the initial port or
> later on the port the host migrated to (via switch).
> 
> If I refresh the ATU entries indefinitly, then this migration will for
> sure not work, and with the member violation suppressed, it will be
> silent about it.

Manual says that migrations should trigger miss violations if configured
adequately, is this not the case?

> So I don't think it is a good idea to refresh the ATU entries
> indefinitely.
> 
> Another issue I see, is that there is a deadlock or similar issue when
> receiving violations and running 'bridge fdb show' (it seemed that
> member violations also caused this, but not sure yet...), as the unit
> freezes, not to return...

Have you enabled lockdep, debug atomic sleep, detect hung tasks, things
like that?
