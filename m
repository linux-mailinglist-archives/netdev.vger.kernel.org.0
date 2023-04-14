Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA796E2DBA
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 01:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjDNXzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 19:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjDNXzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 19:55:35 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EC1A5CE
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 16:54:54 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1pnTEn-0005um-0G;
        Sat, 15 Apr 2023 01:53:53 +0200
Date:   Sat, 15 Apr 2023 00:53:49 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
Message-ID: <ZDnnjcG5uR9gQrUb@makrotopia.org>
References: <896514df-af33-6408-8b33-d8fd06e671ef@arinc9.com>
 <ZDnYSVWTUe5NCd1w@makrotopia.org>
 <e10aa146-c307-8a14-3842-ae50ceabf8cc@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e10aa146-c307-8a14-3842-ae50ceabf8cc@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 02:23:16AM +0300, Arınç ÜNAL wrote:
> On 15.04.2023 01:48, Daniel Golle wrote:
> > On Sat, Apr 15, 2023 at 01:41:07AM +0300, Arınç ÜNAL wrote:
> > > Hey there,
> > > 
> > > I've been working on the MT7530 DSA subdriver. While doing some tests, I
> > > realised mt7530_probe() runs twice. I moved enabling the regulators from
> > > mt7530_setup() to mt7530_probe(). Enabling the regulators there ends up
> > > with exception warnings on the first time. It works fine when
> > > mt7530_probe() is run again.
> > > 
> > > This should not be an expected behaviour, right? Any ideas how we can make
> > > it work the first time?
> > 
> > Can you share the patch or work-in-progress tree which will allow me
> > to reproduce this problem?
> 
> I tested this on vanilla 6.3-rc6. There's just the diff below that is
> applied. I encountered it on the standalone MT7530 on my Bananapi BPI-R2. I
> haven't tried it on MCM MT7530 on MT7621 SoC yet.
> 
> > 
> > It can of course be that regulator driver has not yet been loaded on
> > the first run and -EPROBE_DEFER is returned in that case. Knowing the
> > value of 'err' variable below would hence be valuable information.
> 
> Regardless of enabling the regulator on either mt7530_probe() or
> mt7530_setup(), dsa_switch_parse_of() always fails.

So dsa_switch_parse_of() can return -EPROBE_DEFER if the ethernet
driver responsible for the CPU port has not yet been loaded.

See net/dsa/dsa.c (inside function dsa_port_parse_of):
[...]
1232)                master = of_find_net_device_by_node(ethernet);
1233)                of_node_put(ethernet);
1234)                if (!master)
1235)                        return -EPROBE_DEFER;
[...]

Hence it would be important to include the value of 'err' in your
debugging printf output, as -EPROBE_DEFER can be an expected and
implicitely intended reality and nothing is wrong then.
