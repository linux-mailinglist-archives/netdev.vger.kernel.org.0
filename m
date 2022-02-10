Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195A14B1594
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343545AbiBJSxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:53:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243255AbiBJSxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:53:33 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A82F54
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:53:33 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id u134so2739794vsu.8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X7W1XvPXzw7bcGLMbJw9NrN1G3trt/ksGDfAy2Ugjoc=;
        b=gBwajJ43bpuEpjzX5gr4qxwBupNp/3dRBQPNGahhl4HsiUCmkTE4LwuT9NPAXcLuxH
         u1ja6kgtYoJyh1qx2U6jCWuIKTLlx350UW505maQPz1udzgxvGgK1q00yQ4HoBXztGkK
         2bff6LSeOqfqhxbUkNDXZyXIiUwag4i8JI9BtK0wGgaX8uHfC0jwo2PEdU8KErvtu5Zl
         xsWMudB1dTeu5OKhMNgGjHkLDhtbEmuQMWpn5ARO9N04gnCcQ9rozJL8IEtn4H32IE8l
         1Cy1HuR//Twd8Rd8mGIxLSkigNZ0iIF+dbbRA8/hx15l5ohUpBHkU08wFYMbN6/MAE+k
         dUvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X7W1XvPXzw7bcGLMbJw9NrN1G3trt/ksGDfAy2Ugjoc=;
        b=wGDoijKLNtcgGzJIvLubQeQyVukzg0aVtJCL7xg8uKInwrpteIHqkobuYIFnlM+H5V
         Tb+OOekU08/6Cn1TTLG/DFreCJ4Ja3XRJCsYLY6ME/cnQL7ym9He8V7wKTRy5DPbxvDD
         TUiC6f4P/8bZ8MKN6szVYGE99mS2QzLPd97WZg2ITMOpEUpWP1/8yGHtXvLD/eZf5k/N
         okXIn17wMzZipFxeSgk8N4D9JzPsY+uxVlTYGONJj0UQXXpV2HnFZyLNjU1pCCkc2fL3
         N9iPCOIhAG2BY1ddC5G8aA1wtj6QA3JBruvV3lFobELSMZCKQJMDflze86nsTxuGPHLb
         lcng==
X-Gm-Message-State: AOAM5334RwwYxwjbf7JNSpIUUui3+kf5+ldzxY6jjZmZLoNVLfnjwlt0
        IV8G4u0qOBjzDGfRG0DUS5X/vjpNvQEPR1DZ5wY=
X-Google-Smtp-Source: ABdhPJykdek+wp8r9ymOdbJlvEbVUlzVIawoAoqfIGTGa9GLDurdL9MrXYPh4arvwvvdBPV1YNBD3XtzhKDWIkU9qiE=
X-Received: by 2002:a67:fc16:: with SMTP id o22mr1367582vsq.42.1644519212961;
 Thu, 10 Feb 2022 10:53:32 -0800 (PST)
MIME-Version: 1.0
References: <20210113154139.1803705-1-olteanv@gmail.com> <20210113154139.1803705-2-olteanv@gmail.com>
 <X/+FKCRgkqOtoWbo@lunn.ch> <20210114001759.atz5vehkdrire6p7@skbuf> <X/+YQlEkeNYXditV@lunn.ch>
In-Reply-To: <X/+YQlEkeNYXditV@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 10 Feb 2022 20:53:21 +0200
Message-ID: <CA+h21hoYOZZYhoD+QgDvm-Pe11EH5LgLtzRrYPQux_8a7AeHGw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/2] net: dsa: allow setting port-based QoS
 priority using tc matchall skbedit
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Thu, 14 Jan 2021 at 03:03, Andrew Lunn <andrew@lunn.ch> wrote:
> On Thu, Jan 14, 2021 at 02:17:59AM +0200, Vladimir Oltean wrote:
> > On Thu, Jan 14, 2021 at 12:41:28AM +0100, Andrew Lunn wrote:
> > > On Wed, Jan 13, 2021 at 05:41:38PM +0200, Vladimir Oltean wrote:
> > > > + int     (*port_priority_set)(struct dsa_switch *ds, int port,
> > > > +                              struct dsa_mall_skbedit_tc_entry *skbedit);
> > >
> > > The fact we can turn this on/off suggests there should be a way to
> > > disable this in the hardware, when the matchall is removed. I don't
> > > see any such remove support in this patch.
> >
> > I don't understand this comment, sorry. When the matchall filter
> > containing the skbedit action gets removed, DSA calls the driver's
> > .port_priority_set callback again, this time with a priority of 0.
> > There's nothing to "remove" about a port priority. I made an assumption
> > (which I still consider perfectly reasonable) that no port-based
> > prioritization means that all traffic gets classified to traffic class 0.
>
> That does not work for mv88e6xxx. Its default setup, if i remember
> correctly, is it looks at the TOS bits to determine priority
> classes. So in its default state, it is using all the available
> traffic classes.  It can also be configured to look at the VLAN
> priority, or the TCAM can set the priority class, or there is a per
> port default priority, which is what you are describing here. There
> are bits to select which of these happen on ingress, on a per port
> basis.
>
> So setting the port priority to 0 means setting the priority of
> zero. It does not mean go back to the default prioritisation scheme.
>
> I guess any switch which has a range of options for prioritisation
> selection will have a similar problem. It defaults to something,
> probably something a bit smarter than everything goes to traffic class
> 0.
>
>       Andrew

I was going through my old patches, and re-reading this conversation,
it appears one of us is misunderstanding something.

I looked at some Marvell datasheet and it has a similar QoS
classification pipeline to Vitesse switches. There is a port-based
default priority which can be overridden by IP DSCP, VLAN PCP, or
advanced QoS classification (TCAM).

The proposal I had was to configure the default port priority using tc
matchall skbedit priority. Advanced QoS classification would then be
expressed as tc-flower filters with a higher precedence than the
matchall (basically the "catchall"). PCP and DSCP, I don't know if
that can be expressed cleanly using tc. I think there's something in
the dcb ops, but I haven't studied that too deeply.

Anyway, I don't exactly understand your point, that an add/del is in
any way better than a "set". Even for Marvell, what I'm proposing here
would translate in a "set to 0" on "del" anyway. That's why this patch
set is RFC. I don't know if there's a better way to express a
port-based default priority than a matchall rule having the lowest
precedence.
