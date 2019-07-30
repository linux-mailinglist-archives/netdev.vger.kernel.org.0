Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5E27B3E9
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfG3UCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:02:36 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:49958 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbfG3UCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 16:02:36 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 633AC140089;
        Tue, 30 Jul 2019 20:02:34 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 30 Jul
 2019 13:02:30 -0700
Subject: Re: [RFC PATCH net-next 0/3] net: batched receive in GRO path
From:   Edward Cree <ecree@solarflare.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>
References: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
 <c80a9e7846bf903728327a1ca2c3bdcc078057a2.camel@redhat.com>
 <677040f4-05d1-e664-d24a-5ee2d2edcdbd@solarflare.com>
 <1735314f-3c6a-45fc-0270-b90cc4d5d6ba@gmail.com>
 <4516a34a-5a88-88ef-e761-7512dff4f3ce@solarflare.com>
 <38ff0ce0-7e26-1683-90f0-adc9c0ac9abe@gmail.com>
 <927da9ee-c2fc-8556-fbeb-e26ea1c98d1e@solarflare.com>
 <d7ca6e7a-b80e-12e8-9050-c25b8b92bf26@gmail.com>
 <a30137b4-1b01-df6e-c771-c5ddd1cfc490@solarflare.com>
Message-ID: <d7e1665f-807d-e5a7-01a5-ee411e4b967a@solarflare.com>
Date:   Tue, 30 Jul 2019 21:02:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <a30137b4-1b01-df6e-c771-c5ddd1cfc490@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24810.005
X-TM-AS-Result: No-2.710700-4.000000-10
X-TMASE-MatchedRID: VfovoVrt/obmLzc6AOD8DfHkpkyUphL9jHhXj1NLbjBSw5Q5cFoXDYy+
        AfTlDGN1ivAi4K698nv303d0Xu5kOt3aQrftNh+sLyz9QvAyHjq++wkLapaddxlLPW+8b7Sa5su
        eCC+qhXdEtH2LywAwaweVY2lBlw7gAM0/G7XUdePykdOisNw8ygIbyV+avmzj0SxMhOhuA0QFda
        zC65CWD2CvPgSERlEIhd5kI3o9+M/yEOzoYJM0nXH7HV/mO4UTprzcyrz2L11/Z0SyQdcmEBQHK
        cqebMTmHqgUZTJwkRGz9Xcgq3OOrI9oUcx9VMLggxsfzkNRlfLdB/CxWTRRuwihQpoXbuXFxpgT
        d/zf2b03Ursl1lB77qOUJys1AD66+4UACK+RSTuofK4KSi50sbCvT+c7SAC2J4DWLneOqb6h1cf
        P1wneY9fFGZDAMnnJatIHicZOMH4XNif4eWqnz5x7WsNeU26IiY14e+tx2CaeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.710700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24810.005
X-MDID: 1564516955-9BsG7NRFe_5m
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/07/2019 22:49, Edward Cree wrote:
> One thing that's causing me some uncertainty: busy_poll_stop() does a
>  napi->poll(), which can potentially gro_normal_one() something.  But
>  when I tried to put a gro_normal_list() just after that, I ran into
>  list corruption because it could race against the one in
>  napi_complete_done().
Turns out that the bh_disables are a red herring, we're racing against a
 napi poll on a different CPU.
I *think* that the sequence of events is
- enter busy_poll_stop
- enter napi->poll
- napi->poll calls napi_complete_done(), which schedules a new napi
- that new napi runs, on another CPU
- meanwhile, busy_poll_stop returns from napi->poll; if it then does a
  gro_normal_list it can race with the one on the other CPU from the new
  napi-poll.
Which means that...
> Questions that arise from that:
> 1) Is it safe to potentially be adding to the rx_list (gro_normal_one(),
>    which in theory can end up calling gro_normal_list() as well) within
>    busy_poll_stop()?  I haven't ever seen a splat from that, but it seems
>    every bit as possible as what I have been seeing.
... this isn't a problem, because napi->poll() will do all of its
 gro_normal_one()s before it calls napi_complete_done().

Just gathering some final performance numbers, then I'll post the updated
 patches (hopefully) later tonight.

-Ed
