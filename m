Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9D35B7A33
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232001AbiIMSxE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 13 Sep 2022 14:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiIMSw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:52:28 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328C247BA1
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 11:38:02 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 525911410D3;
        Tue, 13 Sep 2022 20:38:00 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id anxBlDDJCDL0; Tue, 13 Sep 2022 20:37:54 +0200 (CEST)
Received: from x61w.mirbsd.org (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 28AF31403CD;
        Tue, 13 Sep 2022 20:37:54 +0200 (CEST)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 36B3B61666; Tue, 13 Sep 2022 20:37:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 2F30960094;
        Tue, 13 Sep 2022 20:37:53 +0200 (CEST)
Date:   Tue, 13 Sep 2022 20:37:53 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Haye.Haehne@telekom.de
cc:     netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
In-Reply-To: <FR2P281MB29597303CA232BBEF6E328DF90479@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM>
Message-ID: <d0755144-c038-8332-1084-b62cc9c6499@tarent.de>
References: <FR2P281MB2959684780DC911876D2465590419@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <FR2P281MB2959EBC7E6CE9A1A8D01A01F90419@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de> <CAHNKnsQGwV9Z9dSrKusLV7qE+Xw_4eqEDtHKTVJxuuy6H+pWRA@mail.gmail.com>
 <cd3867e0-b645-c6cd-3464-29ffb142de5e@tarent.de> <FR2P281MB29597303CA232BBEF6E328DF90479@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Haye,

> I could retest the crash scenario of the qdisc, it occurs in the
> context of tc change /reconfiguration. When I define a static qdisc
> setup, the iperf udp stream with 50M (qdisc rate 20M) is stable.

thanks. (By the way, gstscream/scripts/sysctl.sh from SCReAM indeed
allows me to fill the queue fully with locally originating traffic.)

> So you should indeed take a deeper look into the processing during
> reconfiguration.

I did have a look. I could not reproduce the crash just with changing
qdisc things, not even a lot of times (100 Hz).

I tried:

$ sudo mksh -c 'qq=0; while sleep 0.01; do
	if (( ++qq == 500 )); then lim=50; qq=0; else lim=10240; fi
	tc qdisc change dev eth1 handle 1: janz rate 20mbit limit $lim
    done'

(changing the qdisc 100 times a second; every five seconds the limit
goes WAY down, to show the dropping code isn’t the cause either)

3x $ iperf -u -c 10.82.222.129 -t 600 -b 40M -S 0x01

(for some reason, IPv6 did not work with iperf for me)

$ sudo mksh -c 'while sleep 0.25; do tc -s qdisc show dev eth1 | fgrep backlog; done'

(for monitoring)


Evidently, what I’m changing, or how often, isn’t sufficient to trigger
the issue. Let’s phone tomorrow to try to figure out a good reproducer,
I might need to use jenscli with the data rate pattern you use, which is
less self-contained than I would normally prefer in a reproducer…

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
