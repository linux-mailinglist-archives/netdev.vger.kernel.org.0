Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB7F788FF9
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 08:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726383AbfHKGZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 02:25:55 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:51314 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbfHKGZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 02:25:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hwhIS-00073e-LD; Sun, 11 Aug 2019 08:25:40 +0200
Message-ID: <f7de98001849bc98a0a084d2ffc369f4d9772d52.camel@sipsolutions.net>
Subject: Re: [PATCH] `iwlist scan` fails with many networks available
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Nylen <jnylen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 11 Aug 2019 08:25:39 +0200
In-Reply-To: <CABVa4NhutjvHPbyaxNeVpJjf-RMJdwEX-Yjk4bkqLC1DN3oXPA@mail.gmail.com> (sfid-20190811_040820_184767_595B1CDB)
References: <CABVa4NgWMkJuyB1P5fwQEYHwqBRiySE+fGQpMKt8zbp+xJ8+rw@mail.gmail.com>
         <CABVa4NhutjvHPbyaxNeVpJjf-RMJdwEX-Yjk4bkqLC1DN3oXPA@mail.gmail.com>
         (sfid-20190811_040820_184767_595B1CDB)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2019-08-11 at 02:08 +0000, James Nylen wrote:
> In 5.x it's still possible for `ieee80211_scan_results` (`iwlist
> scan`) to fail when too many wireless networks are available.  This
> code path is used by `wicd`.
> 
> Previously: https://lkml.org/lkml/2017/4/2/192

This has been known for probably a decade or longer. I don't know why
'wicd' still insists on using wext, unless it's no longer maintained at
all. nl80211 doesn't have this problem at all, and I think gives more
details about the networks found too.

> I've been applying this updated patch to my own kernels since 2017 with
> no issues.  I am sure it is not the ideal way to solve this problem, but
> I'm making my fix available in case it helps others.

I don't think silently dropping data is a good solution.

I suppose we could consider applying a workaround like this if it has a
condition checking that the buffer passed in is the maximum possible
buffer (65535 bytes, due to iw_point::length being u16), but below that
-E2BIG serves well-written implementations as an indicator that they
need to retry with a bigger buffer.

> Please advise on next steps or if this is a dead end.

I think wireless extensions are in fact a dead end and all software
(even 'wicd', which seems to be the lone holdout) should migrate to
nl80211 instead.

johannes

