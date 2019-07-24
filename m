Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C9072F13
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 14:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbfGXMjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 08:39:23 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52908 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGXMjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 08:39:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hqGYC-0005nl-5P; Wed, 24 Jul 2019 14:39:20 +0200
Message-ID: <91f918911b7a33c84d7a620e75a1d8155a239237.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] net: mac80211: Fix possible null-pointer
 dereferences in ieee80211_xmit_fast_finish()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 24 Jul 2019 14:39:16 +0200
In-Reply-To: <20190724123633.10145-1-baijiaju1990@gmail.com> (sfid-20190724_143645_528233_F6E5B778)
References: <20190724123633.10145-1-baijiaju1990@gmail.com>
         (sfid-20190724_143645_528233_F6E5B778)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-07-24 at 20:36 +0800, Jia-Ju Bai wrote:
> In ieee80211_xmit_fast_finish(), there is an if statement on line 3356
> to check whether key is NULL:
>     if (key)
> 
> When key is NULL, it is used on line 3388:
>     switch (key->conf.cipher)
> and line 3393:
>     pn = atomic64_inc_return(&key->conf.tx_pn);
> and line 3396:
>     crypto_hdr[3] = 0x20 | (key->conf.keyidx << 6);
> 
> Thus, possible null-pointer dereferences may occur.

No, this cannot happen, because pn_offs can only be non-zero when there
is a key. Maybe we should pass the fast_tx pointer instead of the
pn_offs/key from it, but the two are coupled.

johannes

