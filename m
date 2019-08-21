Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E0F97E0B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 17:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729510AbfHUPF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 11:05:57 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60534 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729424AbfHUPF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 11:05:57 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9B4DA180092;
        Wed, 21 Aug 2019 15:05:54 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 21 Aug
 2019 08:05:50 -0700
Subject: Re: [PATCH net-next 1/2] net: flow_offload: mangle 128-bit packet
 field with one action
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netfilter-devel@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <jakub.kicinski@netronome.com>,
        <jiri@resnulli.us>, <vladbu@mellanox.com>
References: <20190820105225.13943-1-pablo@netfilter.org>
 <f18d8369-f87d-5b9a-6c9d-daf48a3b95f1@solarflare.com>
 <20190820144453.ckme6oj2c4hmofhu@salvia>
 <c8a00a98-74eb-9f8d-660f-c2ea159dec91@solarflare.com>
 <20190820173344.3nrzfjboyztz3lji@salvia>
 <f4cf8a97-3322-d982-6068-d4c0ce997b1c@solarflare.com>
 <20190820183533.ykh7mnurpmegxb27@salvia>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <5f7f561d-36b5-2611-e051-4a1549e35f09@solarflare.com>
Date:   Wed, 21 Aug 2019 16:05:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190820183533.ykh7mnurpmegxb27@salvia>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24860.005
X-TM-AS-Result: No-7.468400-4.000000-10
X-TMASE-MatchedRID: QW5G6BKkLTobF9xF7zzuNfZvT2zYoYOwC/ExpXrHizz0nlq8x3d7MEI7
        9pzeweHtg07k8t5CAJP9FDOEyDIuTFoAjvFQR6XL9FQh3flUIh40AJe3B5qfBkl/J9Ro+MABD3b
        LdMpm5wQ6aYiWdCFc9Dq+dNqcVismNRmfUxjO48g2Uxn7RTIiMcnlJe2gk8vIs2A0jYj1s4DTfl
        TvFEeDIRgmCYbQRfj7CSP2yg+Ty9PvnOSC+jk4Dh/R5SKe31ARwdaE5TU9NVgk1SrS1we7Rezn6
        eE2grwnGzVk6wnvigU+PHq8e3nI3r9ZdlL8eonaC24oEZ6SpSlsZUSYh+N/e/q5f1QpZOPRRUu0
        Vzgx+BEpw8RyyTGkcQJ6n92yYrqggf1QCej4QZA=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.468400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24860.005
X-MDID: 1566399956-4gMPXNvFJNuD
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/08/2019 19:35, Pablo Neira Ayuso wrote:
> With one action that says "mangle an IPv6 at offset ip6 daddr field"
> the driver has more global view on what is going on, rather than
> having four actions to mangle four 32-bit words at some offset.
But the action doesn't say that, it still says "mangle four 32-bit
 words", it's just that they're now contiguous.  The driver doesn't
 know whether that's an IPv6 address or just a bunch of fields that
 happened to be next to one another.
(Besides, the driver can't rely on that 'global view', because if
 the actions did come from the TC uAPI, they're still going to be
 single u32 mangles.)

> If this patch adds some loops here is because I did not want to make
> too smart changes on the drivers.
The thing is, the drivers are already looping over TC actions, so they
 already naturally support multiple pedits.  You don't gain any
 expressiveness by combining them into batches of four, meanwhile you
 make the API less orthogonal and more laborious to implement.

> Please, allow for incremental updates on the flow_offload API to get
> it better now. Later we'll have way more drivers it will become harder
> to update this.
I'm not opposed to making the API better.  I just don't believe that
 this patch series achieves that.
