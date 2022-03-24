Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795B54E6224
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349672AbiCXLLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244414AbiCXLLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:11:34 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA945F279;
        Thu, 24 Mar 2022 04:10:02 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id b24so5173298edu.10;
        Thu, 24 Mar 2022 04:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KGZCltwDEuDtdVSTj/+aDb5ZKdS2bNxeO6n+gHL1s2Q=;
        b=VQmoFj/1OxbLjhEevHycJOV96wtzwVXDTG8oDW9GtUIQIVolXMvxMqn+JKbmzg8hd1
         uboUfIWYCacKNsgCMye9OjMf+c6fg4zVFW2qML6XY8eTLCyjNIj0gvrmEKN9TYH/A5Ip
         OkPKKd8oNJ+i3gIYzubWAPs/m+CWZF0zP0RqeonRNd4n7HBde2w4cJYTlHg+OxjIK1Uj
         q2kXuknsBXmmjOPwp5lH20phuj8WowouMTSzS/A3/ssA0nxWxG1x5CRwdRSqEGE5QT8o
         zAw5QnbhiMssMF5Nh7Mw31r99GtNiIpZvS3R8WVXV+btUgxowO/mki0j/TQbiMuqfx1f
         MwcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KGZCltwDEuDtdVSTj/+aDb5ZKdS2bNxeO6n+gHL1s2Q=;
        b=5Uh9LntZYPgzMqUj8kOS8UbzDheIGaaGE0eEFaiUkhx4GNi7YFcayiDh58x2LiCk9C
         OnkgorVNCwta6I5GwnQsqoI9gsapDll5zlE2UzH7WNG9tqjIlg7FSFTTGiVDXIe/8oH+
         c0pQKrAxuQ3/aAHFZlCJ8FdOtVvzVeAZL+82WkeirLlljxVhC5TUbPz5BhQzoeVsK9Ad
         FY68onDs4Uxkp2gEpF06QlcaBw8D27vBATXjR4Kw1N1BCP9/VsCm6UqIsgW+CNNLt0y0
         isIJsH9CPxB2l8Xu6pgCQk5kHOjNiSJnEaVxb0m/00UqlbGk+OMlAiOKxLOX1GS/F436
         VVBw==
X-Gm-Message-State: AOAM531aTUSZnqzZrLGPyWHMECP+4a/H+o9aHWmTgYZuRuvoTUvPyLu9
        9nPvW72xFZKSONAJdQtY4Ns=
X-Google-Smtp-Source: ABdhPJwRBSpzI9YIHk7R1WcuxN+goDcQhY1G+dR99KVCSgiPmyee2NQj6GEh2XoLBgicaL6K3d0OzQ==
X-Received: by 2002:a05:6402:5303:b0:416:13c0:3e75 with SMTP id eo3-20020a056402530300b0041613c03e75mr5955489edb.299.1648120201320;
        Thu, 24 Mar 2022 04:10:01 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id u18-20020a17090617d200b006db07a16cf5sm997290eje.77.2022.03.24.04.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 04:10:00 -0700 (PDT)
Date:   Thu, 24 Mar 2022 13:09:59 +0200
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
Message-ID: <20220324110959.t4hqale35qbrakdu@skbuf>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
 <86o81whmwv.fsf@gmail.com>
 <20220323123534.i2whyau3doq2xdxg@skbuf>
 <86wngkbzqb.fsf@gmail.com>
 <20220323144304.4uqst3hapvzg3ej6@skbuf>
 <86lewzej4n.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86lewzej4n.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 11:32:08AM +0100, Hans Schultz wrote:
> On ons, mar 23, 2022 at 16:43, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Wed, Mar 23, 2022 at 01:49:32PM +0100, Hans Schultz wrote:
> >> >> Does someone have an idea why there at this point is no option to add a
> >> >> dynamic fdb entry?
> >> >> 
> >> >> The fdb added entries here do not age out, while the ATU entries do
> >> >> (after 5 min), resulting in unsynced ATU vs fdb.
> >> >
> >> > I think the expectation is to use br_fdb_external_learn_del() if the
> >> > externally learned entry expires. The bridge should not age by itself
> >> > FDB entries learned externally.
> >> >
> >> 
> >> It seems to me that something is missing then?
> >> My tests using trafgen that I gave a report on to Lunn generated massive
> >> amounts of fdb entries, but after a while the ATU was clean and the fdb
> >> was still full of random entries...
> >
> > I'm no longer sure where you are, sorry..
> > I think we discussed that you need to enable ATU age interrupts in order
> > to keep the ATU in sync with the bridge FDB? Which means either to
> > delete the locked FDB entries from the bridge when they age out in the
> > ATU, or to keep refreshing locked ATU entries.
> > So it seems that you're doing neither of those 2 things if you end up
> > with bridge FDB entries which are no longer in the ATU.
> 
> Any idea why G2 offset 5 ATUAgeIntEn (bit 10) is set? There is no define
> for it, so I assume it is something default?

No idea, but I can confirm that the out-of-reset value I see for
MV88E6XXX_G2_SWITCH_MGMT on 6190 and 6390 is 0x400. It's best not to
rely on any reset defaults though.
