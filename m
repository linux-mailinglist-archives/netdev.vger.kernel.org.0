Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3AB456D47
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 11:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhKSKbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 05:31:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbhKSKbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 05:31:41 -0500
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F75C061574;
        Fri, 19 Nov 2021 02:28:38 -0800 (PST)
Received: from iva8-d2cd82b7433e.qloud-c.yandex.net (iva8-d2cd82b7433e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a88e:0:640:d2cd:82b7])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 6613D2E0EB6;
        Fri, 19 Nov 2021 13:28:36 +0300 (MSK)
Received: from myt6-10e59078d438.qloud-c.yandex.net (myt6-10e59078d438.qloud-c.yandex.net [2a02:6b8:c12:5209:0:640:10e5:9078])
        by iva8-d2cd82b7433e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id h0SLQKlaHl-SZsmtVuA;
        Fri, 19 Nov 2021 13:28:36 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1637317716; bh=0S0aDUeUy14R8avbT19YlFnvfDh9CegCSsSnm81HkKk=;
        h=In-Reply-To:References:Date:From:To:Subject:Message-ID:Cc;
        b=4LfxMCgTJBgMtcj/KSPBQHo9ceJv+E2UB75ltX57bloMNqQmwnlQQuuRvL7Zt+0rr
         n4gwslYK/2Tu0H8pagKGWAhzvQJtMjOVWCvAY5TiHFPOpkHMMHlAvrhZQzxU2w4P9A
         eoyN1+CKRK0ezRXjH583/Db0MvjjTC+rlGuZPPWA=
Authentication-Results: iva8-d2cd82b7433e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from [IPv6:2a02:6b8:0:107:3e85:844d:5b1d:60a] (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by myt6-10e59078d438.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id xIDPXLIdDn-SZw4QS1L;
        Fri, 19 Nov 2021 13:28:35 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
Subject: Re: [PATCH 1/6] vhost: get rid of vhost_poll_flush() wrapper
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211115153003.9140-1-arbn@yandex-team.com>
 <20211116144119.56ph52twuyc4jtdr@steredhat>
From:   Andrey Ryabinin <arbn@yandex-team.com>
Message-ID: <aff42feb-6ca5-1d9a-6ecf-74c213abfaa6@yandex-team.com>
Date:   Fri, 19 Nov 2021 13:30:10 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211116144119.56ph52twuyc4jtdr@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/16/21 5:41 PM, Stefano Garzarella wrote:
> On Mon, Nov 15, 2021 at 06:29:58PM +0300, Andrey Ryabinin wrote:

>> void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
>> {
>>     if (!dev->worker)
>> @@ -663,7 +655,7 @@ void vhost_dev_stop(struct vhost_dev *dev)
>>     for (i = 0; i < dev->nvqs; ++i) {
>>         if (dev->vqs[i]->kick && dev->vqs[i]->handle_kick) {
>>             vhost_poll_stop(&dev->vqs[i]->poll);
>> -            vhost_poll_flush(&dev->vqs[i]->poll);
>> +            vhost_work_dev_flush(dev->vqs[i]->poll.dev);
> 
> Not related to this patch, but while looking at vhost-vsock I'm wondering if we can do the same here in vhost_dev_stop(), I mean move vhost_work_dev_flush() outside the loop and and call it once. (In another patch eventually)
> 

Yeah, seems reasonable. I can't see any reason why would subsequent vhost_poll_stop() require the vhost_work_dev_flush() in between.
