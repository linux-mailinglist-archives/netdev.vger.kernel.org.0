Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0940864AF1
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfGJQr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 12:47:27 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:55972 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727165AbfGJQr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 12:47:27 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2BCD040070;
        Wed, 10 Jul 2019 16:47:25 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 10 Jul
 2019 09:47:21 -0700
Subject: Re: [RFC PATCH net-next 0/3] net: batched receive in GRO path
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>
References: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
 <c80a9e7846bf903728327a1ca2c3bdcc078057a2.camel@redhat.com>
 <677040f4-05d1-e664-d24a-5ee2d2edcdbd@solarflare.com>
 <1735314f-3c6a-45fc-0270-b90cc4d5d6ba@gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <4516a34a-5a88-88ef-e761-7512dff4f3ce@solarflare.com>
Date:   Wed, 10 Jul 2019 17:47:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1735314f-3c6a-45fc-0270-b90cc4d5d6ba@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24750.005
X-TM-AS-Result: No-1.571100-4.000000-10
X-TMASE-MatchedRID: u7Yf2n7Ca/3mLzc6AOD8DfHkpkyUphL9aKq1Yhw50ju67Q3uPo9KI8qa
        e4dFK5zKWQbTJ68QuVgwM6XxbfFDF9ntXMKAeEZYKUnZzo2UQD0Cn5QffvZFlSvFSzw3D/Z+FC0
        shQ7P5QKZQvuRS/d9xOJUZnVqfmBS7eqO+VpGDY0c9jA4mLo8uZthyTejrpTsDO+DX+rUwfaNBv
        RmKMdxcES9ojFaMNsGJ9LZaXmTvAb/Q0LySR/sSS8s/ULwMh46SoCG4sefl8S6Gxh0eXo7a/Slq
        /vsgUCjapTP1D222pJYoGkvWSLgrttRKUVZdq2UngIgpj8eDcByZ8zcONpAscRB0bsfrpPIFT1P
        Bs+MVY2YLcIscfQKLDPPdt+L67zi3ZJLzGeB/Uh+/JWaE7g4fdfdCZqlbZQgOIimLL04lKpHVcQ
        OfND0uglGNT8kn/fodROh5seJw72b/YhpVXpyjYfMZMegLDIeGU0pKnas+RbnCJftFZkZizYJYN
        FU00e7N+XOQZygrvY=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.571100-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24750.005
X-MDID: 1562777245-S2O_3yhlTMg5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/07/2019 16:41, Eric Dumazet wrote:
> On 7/10/19 4:52 PM, Edward Cree wrote:
>> Hmm, I was caught out by the call to napi_poll() actually being a local
>>  function pointer, not the static function of the same name.  How did a
>>  shadow like that ever get allowed?
>> But in that case I _really_ don't understand napi_busy_loop(); nothing
>>  in it seems to ever flush GRO, so it's relying on either
>>  (1) stuff getting flushed because the bucket runs out of space, or
>>  (2) the next napi poll after busy_poll_stop() doing the flush.
>> What am I missing, and where exactly in napi_busy_loop() should the
>>  gro_normal_list() call go?
> Please look at busy_poll_stop()
I did look there, but now I've looked again and harder, and I think I get it:
busy_poll_stop() calls napi->poll(), which (eventually, possibly in the
 subsequent poll that we schedule if rc == budget) calls napi_complete_done()
 which does the flush.
In which case, the same applies to the napi->rx_list, which similarly gets
 handled in napi_complete_done().  So I don't think napi_busy_loop() needs a
 gro_normal_list() adding to it(?)

As a general rule, I think we need to gro_normal_list() in those places, and
 only those places, that call napi_gro_flush().  But as I mentioned in the
 patch 3/3 description, I'm still confused by the (few) drivers that call
 napi_gro_flush() themselves.

-Ed
