Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF393A80D8
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhFONmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbhFONly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:41:54 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC43C0613A4
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 06:39:29 -0700 (PDT)
Received: from miraculix.mork.no (fwa219.mork.no [192.168.9.219])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 15FDdFNe019424
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Tue, 15 Jun 2021 15:39:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1623764355; bh=My55Lzw4OBw6bjlSvJWeLszsGJQBBGn/dwPvPUTOFu8=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=RQVyxXWjV41lm7FudE8LgmuWPqvvjBs/Nqnr54zDSmX7Repz+s/gqm69GZtUVJO4n
         EcToysIyyR1hc1Cosrys0USmUkbCee3lWpIsPlX3I5hSrRr85Yb4kPd9rcKeKdCzCV
         5IaQ52oS8988wOSJRg+oaTY2aOmOwX3JYSh+pu8Q=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94.2)
        (envelope-from <bjorn@mork.no>)
        id 1lt9He-000aYB-GN; Tue, 15 Jun 2021 15:39:14 +0200
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
Organization: m
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
        <8735tky064.fsf@miraculix.mork.no>
        <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKfDRXgQLvTpeowOe=17xLqYbVRcem9N2anJRSjMcQm6=OnH1A@mail.gmail.com>
        <877divwije.fsf@miraculix.mork.no>
        <CAKfDRXivs063y2sq0p8C1s1ayyt3b5DgxKH6smcvXucrGq=KHA@mail.gmail.com>
        <CAKfDRXhraBRXwaDb6T3XMtGpwK=X2hd8+ONWLSmJhQjGurBMmw@mail.gmail.com>
Date:   Tue, 15 Jun 2021 15:39:14 +0200
In-Reply-To: <CAKfDRXhraBRXwaDb6T3XMtGpwK=X2hd8+ONWLSmJhQjGurBMmw@mail.gmail.com>
        (Kristian Evensen's message of "Tue, 15 Jun 2021 13:04:02 +0200")
Message-ID: <871r93w8l9.fsf@miraculix.mork.no>
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
> On Tue, Jun 15, 2021 at 12:51 PM Kristian Evensen
> <kristian.evensen@gmail.com> wrote:
>> I think this would be a really nice solution. The same (at least
>> FLAG_MULTI_PACKET + usbnet_skb_return) could be applied to pass
>> through as well, giving us consistent handling of aggregated packets.
>> While we might not save a huge number of lines, I believe the
>> resulting code will be easier to understand.
>
> Apologies for the noise. When I check the code again, I see that as
> long as FLAG_MULTI_PACKET is set, then we end up with usbnet freeing
> the skb (we will always jump to done in rx_process()). So for the
> pass-through case, I believe your initial suggestion of having
> rx_fixup return 1 is the way to go.

Yes, if we are to use FLAG_MULTI_PACKET then we must call
usbnet_skb_return() for all the non-muxed cases.  There is no clean way
to enable FLAG_MULTI_PACKET on-demand.

I am fine with either solution.  Whatever Jakub wants :-)


Bj=C3=B8rn
