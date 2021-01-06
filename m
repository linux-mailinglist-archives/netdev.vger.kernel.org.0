Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7392EBF9F
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 15:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbhAFOb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 09:31:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbhAFOb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 09:31:57 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17DD6C06134C
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 06:31:16 -0800 (PST)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 106EVBn9026740
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 6 Jan 2021 15:31:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1609943471; bh=7XNa0Rd+0NgWJogTtC+lEigCFC/n3cqOlkpvGrlPRRU=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=OipCYN/07Ku9F4c4Hr8ZP9VXBfckvmwacDMgkU6CcCXkdx0p7DmdjjNc3M7mIxztt
         t1Aj6+sFHsY8spV8A9h6ZoaSCNQPScTSWSnpSvSZ6/x8jqs+vK8hd7yAtmvh4Vkrk+
         dk7MyXV/0poXREIWnqyxubFwgNCJU04p7XWwEmcQ=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1kx9qA-000meC-QN; Wed, 06 Jan 2021 15:31:10 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] qmi_wwan: Increase headroom for QMAP SKBs
Organization: m
References: <20210106122403.1321180-1-kristian.evensen@gmail.com>
Date:   Wed, 06 Jan 2021 15:31:10 +0100
In-Reply-To: <20210106122403.1321180-1-kristian.evensen@gmail.com> (Kristian
        Evensen's message of "Wed, 6 Jan 2021 13:24:03 +0100")
Message-ID: <87ft3e3zo1.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kristian Evensen <kristian.evensen@gmail.com> writes:

> When measuring the throughput (iperf3 + TCP) while routing on a
> not-so-powerful device (Mediatek MT7621, 880MHz CPU), I noticed that I
> achieved significantly lower speeds with QMI-based modems than for
> example a USB LAN dongle. The CPU was saturated in all of my tests.
>
> With the dongle I got ~300 Mbit/s, while I only measured ~200 Mbit/s
> with the modems. All offloads, etc.  were switched off for the dongle,
> and I configured the modems to use QMAP (16k aggregation). The tests
> with the dongle were performed in my local (gigabit) network, while the
> LTE network the modems were connected to delivers 700-800 Mbit/s.
>
> Profiling the kernel revealed the cause of the performance difference.
> In qmimux_rx_fixup(), an SKB is allocated for each packet contained in
> the URB. This SKB has too little headroom, causing the check in
> skb_cow() (called from ip_forward()) to fail. pskb_expand_head() is then
> called and the SKB is reallocated. In the output from perf, I see that a
> significant amount of time is spent in pskb_expand_head() + support
> functions.
>
> In order to ensure that the SKB has enough headroom, this commit
> increases the amount of memory allocated in qmimux_rx_fixup() by
> LL_MAX_HEADER. The reason for using LL_MAX_HEADER and not a more
> accurate value, is that we do not know the type of the outgoing network
> interface. After making this change, I achieve the same throughput with
> the modems as with the dongle.
>
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>

Nice work!

Just wondering: Will the same problem affect the usbnet allocated skbs
as well in case of raw-ip? They will obviously be large enough, but the
reserved headroom probably isn't when we put an IP packet there without
any L2 header?

In any case:

Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
