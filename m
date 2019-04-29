Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC3D9E115
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 13:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfD2LL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 07:11:27 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:52276 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727819AbfD2LL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 07:11:26 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id C22A560006A;
        Mon, 29 Apr 2019 11:11:23 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 29 Apr
 2019 04:11:19 -0700
Subject: Re: [PATCH] net_sched: force endianness annotation
To:     Nicholas Mc Guire <der.herr@hofr.at>
CC:     Nicholas Mc Guire <hofrat@osadl.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1556430899-11018-1-git-send-email-hofrat@osadl.org>
 <07d36e94-aad4-a263-bf09-705ee1dd59ed@solarflare.com>
 <20190429104414.GB17493@osadl.at>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <eb4449ae-70db-c487-9c47-301225734943@solarflare.com>
Date:   Mon, 29 Apr 2019 12:11:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429104414.GB17493@osadl.at>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24580.005
X-TM-AS-Result: No-1.536500-4.000000-10
X-TMASE-MatchedRID: cgbqQT5W8hcOwH4pD14DsPHkpkyUphL9O69hrW/YgWEA6s2mIXI3kEiM
        B4CWhnR4u6ilxywUcf3ICNxBaY9fXITbRrXUOpijKkmNLLBos7D4h+uI7dxXxLWZRTTpSHog7/J
        GRZ8PgCeVu5TRVGSDESu5f3xEk+/3pUxzcSQ8HaSXXOyNnX/prFYPArum7kxlLQOOgimiPKajxY
        yRBa/qJUl4W8WVUOR/9xS3mVzWUuCMx6OO8+QGvucHxr/YAuamj7P44VS7adN119JNcU7kqe7ip
        daarOdTxI1DqzRBr//WpoNhF+t/c2ejIkpQ4ELxgESWhk0zdQcrAvj/GqkNw9Q17CngTb9OBKmZ
        VgZCVnezGTWRXUlrxxtsJUxyzWNSVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.536500-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24580.005
X-MDID: 1556536286-Yp76MjzM6jjh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2019 11:44, Nicholas Mc Guire wrote:
> be16_to_cpu((__force __be16)val) should be a NOP on big-endian as well
Yes.  But it's semiotically wrong to call be16_to_cpu() on a cpu-endian
 value; if the existing behaviour is desired, it ought to be implemented
 differently.
> The problem with using swab16 is that it is impating the binary significantly
> so I'm not sure if the change is really side-effect free
It's not; it changes the behaviour.  That's why I brought up the question
 of the intended behaviour — it's unclear whether the current (no-op on BE)
 behaviour is correct or whether it's a bug in the original code.
Better to leave the sparse error in place — drawing future developers'
 attention to something being possibly wrong here — than to mask it with a
 synthetic 'fix' which we don't even know if it's correct or not.

> but I just am unsure if
> -                   val = be16_to_cpu(val);
> +                   val = swab16(val);
> is actually equivalent.
If you're not sure about such things, maybe you shouldn't be touching
 endianness-related code.  swab is *not* a no-op, either on BE or LE.

-Ed
