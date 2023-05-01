Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059326F3034
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 12:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbjEAKcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 06:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbjEAKcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 06:32:05 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671621B7
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 03:32:02 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ptQow-00043c-1B;
        Mon, 01 May 2023 12:31:50 +0200
Date:   Mon, 1 May 2023 11:31:46 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Greg Ungerer <gerg@kernel.org>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        bartel.eerdekens@constell8.be, netdev <netdev@vger.kernel.org>
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
Message-ID: <ZE-VEuhiPygZYGPe@makrotopia.org>
References: <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <20230429173522.tqd7izelbhr4rvqz@skbuf>
 <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
 <20230429185657.jrpcxoqwr5tcyt54@skbuf>
 <d3a73d34-efd7-2f37-1362-9a2fe5a21592@arinc9.com>
 <20230501100930.eemwoxmwh7oenhvb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230501100930.eemwoxmwh7oenhvb@skbuf>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 01, 2023 at 01:09:30PM +0300, Vladimir Oltean wrote:
> On Sat, Apr 29, 2023 at 10:52:12PM +0300, Arınç ÜNAL wrote:
> > On 29.04.2023 21:56, Vladimir Oltean wrote:
> > > On Sat, Apr 29, 2023 at 09:39:41PM +0300, Arınç ÜNAL wrote:
> > > > Are you fine with the preferred port patch now that I mentioned port 6
> > > > would be preferred for MT7531BE since it's got 2.5G whilst port 5 has
> > > > got 1G? Would you like to submit it or leave it to me to send the diff
> > > > above and this?
> > > 
> > > No, please tell me: what real life difference would it make to a user
> > > who doesn't care to analyze which CPU port is used?
> > 
> > They would get 2.5 Gbps download/upload bandwidth in total to the CPU,
> > instead of 1 Gbps. 3 computers connected to 3 switch ports would each get
> > 833 Mbps download/upload speed to/from the CPU instead of 333 Mbps.
> 
> In theory, theory and practice are the same. In practice, they aren't.
> Are you able to obtain 833 Mbps concurrently over 3 user ports?

Probably the 2.5 GBit/s won't saturate, but I do manage to get more
than 1 Gbit/s total (using the hardware flow offloading capability to
NAT-route WAN<->LAN and simultanously have a WiFi client access a NAS
device which also connects to a LAN port. I use MT7915E+MT7975D mPCIe
module with BPi-R2)

Using PHY muxing to directly map the WAN port to GMAC2 is also an
option, but would be limiting the bandwidth for those users who just
want all 5 ports to be bridged. Hence I do agree with Arınç that the
best would be to use the TRGMII link on GMAC1 for the 4 WAN ports and
prefer using RGMII link on GMAC2 for the WAN port, but keep using DSA.
