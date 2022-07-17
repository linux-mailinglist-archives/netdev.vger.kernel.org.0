Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C185E5777CA
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 20:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbiGQSjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 14:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGQSi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 14:38:59 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855ED26DF;
        Sun, 17 Jul 2022 11:38:57 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id eq6so12654188edb.6;
        Sun, 17 Jul 2022 11:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rTFmINRCtqE/PJSK+GbEjiZlx18s0u636RQP7OKv+PI=;
        b=FSw3Uh0aCHj2G4vLpNTO+ihKkjxUkreF/gNi8Cwu8jTP5BYI/PmJN4f5vcm48Llc0R
         BaDo3GnIbfA/JJNU+Ps7EqK7vtcgHtt6cRTQ9+bUKx1JyHJAiJhMy4wvs2m9j8uIMgud
         2Ppct74C67RPgKUlKcQcLrjDP666o2f0kPGLHoVPERzXZ+2vN88dFOChUlWYQxm5gNjT
         Lhc9R58TMeoAjDblGIwoAFWOzPRSGWWPO4t1R7tftZ7ImdUf8H43HDuGWklh9B+KjlMu
         kbx0DQuCXe0+1Rj1uSv7OinF2S6PY4Z59g0cAgY6DTw1OOy4pptk9e/Zk6K7bZ4XQ4QH
         uf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rTFmINRCtqE/PJSK+GbEjiZlx18s0u636RQP7OKv+PI=;
        b=gKKMwn6uy+rX2UkTGo/jEoUksaWlRSsKHPFfjOFo+GAWn+3k0lOy0Fpcf8G9OVpjV2
         TH13N8KfF4V+yl28qXYxe9Tvke4Dl5hy3DoN5vriyhYIAhzCScI0NMW0xqoOuCXN2iwk
         4Gsot35pPLntupgfx6b4T5g0iXs7o2VTmvYlkQAr3ggs87HGKYIfNRPrx5JM2hvyhzEn
         oZDbPZCKoCCnWeRu8ihZZ2IfcB5ws1xGJ+EpoSwUVFKYVT4Mhsppyt2PvyMynWsU3P1p
         fCOHXMLThms344ymvTynZCMd0k5rBNUG/JzeipjtREc2mvFuC2WyasSHRxXE6o7Bv6S2
         wzZA==
X-Gm-Message-State: AJIora9UZkxQfobJ51t6OBMuFwB/Q67cU0/h0JNgKnSMEM4TDal5XzvC
        5bHBPNfKfxcQUUCTxuecjWByyipSaX0=
X-Google-Smtp-Source: AGRyM1tk93eaC6IDq42PmwwrpHj5mupJZfCSM0zCfRbWL4Y3LieDgdqQ0zD1eisXUSf+AS2bpT2Gnw==
X-Received: by 2002:a05:6402:190e:b0:43a:e914:8c11 with SMTP id e14-20020a056402190e00b0043ae9148c11mr31803058edz.281.1658083135892;
        Sun, 17 Jul 2022 11:38:55 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id r17-20020a056402035100b0043a6a7048absm7119672edw.95.2022.07.17.11.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 11:38:55 -0700 (PDT)
Date:   Sun, 17 Jul 2022 21:38:52 +0300
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
Message-ID: <20220717183852.oi6yg4tgc5vonorp@skbuf>
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder>
 <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder>
 <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <20220717134610.k3nw6mam256yxj37@skbuf>
 <20220717140325.p5ox5mhqedbyyiz4@skbuf>
 <CAKUejP6g3HxS=Scj-2yhsQRJApxnq1e31Nkcc995s7gzfMJOew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUejP6g3HxS=Scj-2yhsQRJApxnq1e31Nkcc995s7gzfMJOew@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 17, 2022 at 06:22:57PM +0200, Hans S wrote:
> On Sun, Jul 17, 2022 at 4:03 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Sun, Jul 17, 2022 at 04:46:10PM +0300, Vladimir Oltean wrote:
> > > Here, what happens is that a locked port learns the MAC SA from the
> > > traffic it didn't drop, i.e. link-local. In other words, the bridge
> > > behaves as expected and instructed: +locked +learning will cause just
> > > that. It's the administrator's fault for not disabling learning.
> > > It's also the mv88e6xxx driver's fault for not validating the "locked" +
> > > "learning" brport flag *combination* until it properly supports "+locked
> > > +learning" (the feature you are currently working on).
> > >
> > > I'm still confused why we don't just say that "+locked -learning" means
> > > plain 802.1X, "+locked +learning" means MAB where we learn locked FDB entries.
> >
> > Or is it the problem that a "+locked +learning" bridge port will learn
> > MAC SA from link-local traffic, but it will create FDB entries without
> > the locked flag while doing so? The mv88e6xxx driver should react to the
> > 'locked' flag from both directions (ADD_TO_DEVICE too, not just ADD_TO_BRIDGE).
> 
> Yes, it creates an FDB entry in the bridge without the locked flag
> set, and sends an ADD_TO_DEVICE notice with it.
> And furthermore link-local packets include of course EAPOL packets, so
> that's why +learning is a problem.

So if we fix that, and make the dynamically learned FDB entry be locked
because the port is locked (and offload them correctly in mv88e6xxx),
what would be the problem, exactly? The +learning is what would allow
these locked FDB entries to be created, and would allow the MAB to work.
User space may still decide to not authorize this address, and it will
remain locked.
