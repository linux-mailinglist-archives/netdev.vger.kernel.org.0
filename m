Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091455A335D
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 03:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiH0BQn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Aug 2022 21:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbiH0BQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 21:16:42 -0400
X-Greylist: delayed 20510 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 26 Aug 2022 18:16:41 PDT
Received: from x61w.mirbsd.org (2001-4dd7-6b78-0-21f-3bff-fe0d-cbb1.ipv6dyn.netcologne.de [IPv6:2001:4dd7:6b78:0:21f:3bff:fe0d:cbb1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F7993223
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 18:16:41 -0700 (PDT)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id EC0A229265; Sat, 27 Aug 2022 03:16:38 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id E4AB728DF6;
        Sat, 27 Aug 2022 03:16:38 +0200 (CEST)
Date:   Sat, 27 Aug 2022 03:16:38 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     netdev@vger.kernel.org
Subject: Re: inter-qdisc communication?
In-Reply-To: <20220826180641.1e856c1d@kernel.org>
Message-ID: <52171289-4135-35c1-7ff0-fb2396cca2cf@tarent.de>
References: <5aea96db-9248-6cff-d985-d4cd91a429@tarent.de> <20220826170632.4c975f21@kernel.org> <49bb3aa4-a6d0-7f38-19eb-37f270443e7e@tarent.de> <20220826180641.1e856c1d@kernel.org>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=2.0 required=5.0 tests=BAYES_40,KHOP_HELO_FCRDNS,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Aug 2022, Jakub Kicinski wrote:

> These days the recommendation for adding workload specific sauce 
> at the qdisc layer is to use the fq qdisc (mq + fq if you have 
> a multi queue device) and add a BPF program on top (cls-bpf)
> which sets transmission times for each packet.

We started with fq_codel layered on htb (though tbf probably would
have sufficed) for bw limiting, but this turned out to both do too
much and be too hard to extend. I also added deep packet inspection
and relayfs/debugfs reporting so it’s quite a bit…

… plus this also wouldn’t help me on the ingress side.

> Obviously you can still write a qdisc if you wish or your needs 
> are sufficiently hardcore.

After months of working with the above scenario, I finally think
I understand enough to do so, and for our testbed a basic FIFO
setup as backing suffices, though I did a three-FIFO setup similar
to the default qdisc. The added juice is where my headaches lie…

(The customer is not only ok with this being developed as FOSS but
even requested this so I could link if there’s actual interest, or
desire to critique ;)

> On the docs, nothing official AFAIK, if it doesn't pop up in 
> the first two pages of Google results it probably doesn't exist :(

Yeah :/

Worse, many of these things that *do* show up no longer exist.
I find references to documentation that used to be either in the
Linux tree or in manpages all the time :(

At this point I’d be glad for something on the API docs level,
what functions I need to provide, what can I call, what can I
expect, what is expected of me. These things. I figured out the
watchdog thing can be used for packet pacing which I used for
bw limiting in the new qdisc even.

But now… shared state between different LKMs even? Also, I’ve
never programmed in a multithreaded environment before save for
a tiny network demo in Java™… not needed it in my decades (my
main personal experience lays in an old BSD).

bye,
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
