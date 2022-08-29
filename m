Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC0E5A4FDB
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 17:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbiH2PIv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 29 Aug 2022 11:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiH2PIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 11:08:46 -0400
X-Greylist: delayed 332 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 29 Aug 2022 08:08:43 PDT
Received: from x61w.mirbsd.org (xdsl-85-197-1-163.nc.de [85.197.1.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA26F92F6C
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 08:08:43 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 15D6428EDE; Mon, 29 Aug 2022 17:03:08 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 6E3A228EDB;
        Mon, 29 Aug 2022 17:03:08 +0200 (CEST)
Date:   Mon, 29 Aug 2022 17:03:08 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     netdev@vger.kernel.org
Subject: Re: inter-qdisc communication?
In-Reply-To: <20220826170632.4c975f21@kernel.org>
Message-ID: <95259a4e-5911-6b7b-65c1-ca33312c23ec@tarent.de>
References: <5aea96db-9248-6cff-d985-d4cd91a429@tarent.de> <20220826170632.4c975f21@kernel.org>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=2.0 required=5.0 tests=BAYES_20,KHOP_HELO_FCRDNS,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(note the communication aspect is still open, see near the end)

On Fri, 26 Aug 2022, Jakub Kicinski wrote:

> How do you add latency on ingress? 🤔

I’ve found something that might do it.

https://serverfault.com/a/386791/189656 and
https://wiki.linuxfoundation.org/networking/netem#how_can_i_use_netem_on_incoming_traffic

So, basically:

$ extif=eth0  # or eth1 or wlan0 or…
$ sudo modprobe ifb  # once or via config
$ sudo ip link set dev ifb0 up
$ sudo tc qdisc add dev $extif handle FFFF: ingress
$ sudo tc filter add dev $extif parent FFFF: [… (see below) …]
$ sudo tc qdisc add dev ifb0 root myqdiscname opts…

All references to ifb seem to cargo-cult the following filter…

	protocol ip u32 match u32 0 0 flowid 1:1
	 action mirred egress redirect dev ifb0

… without explaining any of it. (I’ve concerned myself more with
the implementing of the qdisc than with the configuring, which my
coworkers did before, and I found the info quite… not easily
comprehensible.)

I’ve found that mirred means mirror or redirect, so the action
part’s probably fine. I’m very unsure of the protocol/match
part.

I require any and all traffic of all protocols to be redirected.
Not just IPv4, and not just traffic that matches anything. Can I
do that with the filter, and will this “trick” get me the effect
I want to have?

(I could just use netem but there’s still the issue of inter-
qdisc communication which I’d *very* much like to have, not just
for this but also for features that come later… and, perhaps, one
that’s already there — RAN “handover” emulation, i.e. stopping
all traffic for a few dozen ms or so.)

Thanks in advance,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
