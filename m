Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEE31E6FD
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 04:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfEOC5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 22:57:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726218AbfEOC5d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 22:57:33 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 319FF307D93E;
        Wed, 15 May 2019 02:57:33 +0000 (UTC)
Received: from [10.72.12.103] (ovpn-12-103.pek2.redhat.com [10.72.12.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D27A5608A6;
        Wed, 15 May 2019 02:57:28 +0000 (UTC)
Subject: Re: [PATCH net] vhost_net: fix possible infinite loop
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ppandit@redhat.com
References: <1556177599-56248-1-git-send-email-jasowang@redhat.com>
 <20190425131021-mutt-send-email-mst@kernel.org>
 <f4b4ff70-d64f-c3fb-fe2e-97ef6c55bda0@redhat.com>
 <999ef863-2994-e0c0-fbb1-a6e92de3fd24@redhat.com>
 <20190512125959-mutt-send-email-mst@kernel.org>
 <a0d99d7a-2323-a6a8-262d-9fdc5d926384@redhat.com>
 <20190514173016-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4b51161e-37b1-cf76-d418-1574b8f6e73b@redhat.com>
Date:   Wed, 15 May 2019 10:57:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514173016-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 15 May 2019 02:57:33 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/15 上午5:39, Michael S. Tsirkin wrote:
> Let me try to explain again.
> At the moment how does handle_tx_copy exit?
> It's for(;;) so you know you need to look for a break.
>
> When reading code you also notice there's a goto done
> which could exit the loop. if you scan forward
> you notice that it does not.
> This is confusing, but oh well. Worth fixing maybe ...
>
> Now you add the next round check.
> And there is also special code that
> detects whether you exited with break
> and whenever you did it acts specially.
>
> Yea it works. But I think it's clearer if we
> just make things obvious.
> If we want something to happen on error then
>
> 	if (error)
> 		handle
> 		break
>
> is imho clearer than
>
> 	flag = true
> 	if (error)
> 		break
> 	flag = false
>
>
> if (flag)
> 	handle
>
> in partucular - less branches on data path.
>
> you point out code duplication correctly,
> but we can solve it just by adding functions.
> like i suggested.


Ok, I think I get you.

Will try in next version.

Thanks

