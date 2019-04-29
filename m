Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B97F3E1CB
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 14:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728161AbfD2MCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 08:02:39 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:48030 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728024AbfD2MCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 08:02:39 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 68B641400A8;
        Mon, 29 Apr 2019 12:02:37 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 29 Apr
 2019 05:02:33 -0700
Subject: Re: [PATCH] rds: ib: force endiannes annotation
To:     Nicholas Mc Guire <der.herr@hofr.at>
CC:     Nicholas Mc Guire <hofrat@osadl.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <rds-devel@oss.oracle.com>,
        <linux-kernel@vger.kernel.org>
References: <1556518178-13786-1-git-send-email-hofrat@osadl.org>
 <20443fd3-bd1e-9472-8ca3-e3014e59f249@solarflare.com>
 <20190429111836.GA17830@osadl.at>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <2ffed5fc-a372-3f90-e655-bcbc740eed33@solarflare.com>
Date:   Mon, 29 Apr 2019 13:02:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429111836.GA17830@osadl.at>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24580.005
X-TM-AS-Result: No-14.176100-4.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfsOwH4pD14DsPHkpkyUphL9+WzVGPiSY8jkVi/vHE4dwPM+
        9Fw01I7GRQLzGM7KIBh9cJyW2BrvG9lnkI1u79lBnprizKKMwma1d0Fs4VikB0S/boWSGMtd9P1
        gJOQHwkv5O2/3eJ45TlT7pLySGeP0n19mXmEdfVlfLa2Qr61pJCGi0ftsSkQygrAXgr/AjP3ZSx
        a9R97yPI6kPNsstSO0xcKxQpPhJ/bdM4TtXgVTNLlwTkBCo+04i/ymJ2FVg5SbKItl61J/yZkw8
        KdMzN86KrauXd3MZDWXf5sC39gVVMrUvx27s9YcSJo1rqxdGLyzw2JSXY5EclrsV/jyG+zxXwji
        hSrlWBo=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--14.176100-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24580.005
X-MDID: 1556539358-e9OzWke6H3iF
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2019 12:18, Nicholas Mc Guire wrote:
> On Mon, Apr 29, 2019 at 12:00:06PM +0100, Edward Cree wrote:
>> Again, a __force cast doesn't seem necessary here.  It looks like the
>>  code is just using the wrong types; if all of src, dst and uncongested
>>  were __le64 instead of uint64_t, and the last two lines replaced with
>>  rds_cong_map_updated(map, le64_to_cpu(uncongested)); then the semantics
>>  would be kept with neither sparse errors nor __force.
>>
>> __force is almost never necessary and mostly just masks other bugs or
>>  endianness confusion in the surrounding code.  Instead of adding a
>>  __force, either fix the code to be sparse-clean or leave the sparse
>>  warning in place so that future developers know there's something not
>>  right.
>>
> changing uncongested to __le64 is not an option here - it would only move
> the sparse warnings to those other locatoins where the ports that 
> became uncongested are being or'ed into uncongested.
That's why I say to change *src and *dst too.  Sparse won't mind the
 conversion from void * to __le64 * when they're assigned, and the only
 operations we do on them...
>                         uncongested |= ~(*src) & *dst;
>                         *dst++ = *src++;
... are some bitwise ops on the values (bitwise ops are legal in any
 endianness) and incrementation of the pointers (which cares only about
 the pointee size, not type).

-Ed
