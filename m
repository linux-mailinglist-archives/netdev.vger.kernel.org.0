Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7EB06CF4F
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 16:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390356AbfGROBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 10:01:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbfGROBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 10:01:24 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5D9730C1E24;
        Thu, 18 Jul 2019 14:01:22 +0000 (UTC)
Received: from [10.72.12.199] (ovpn-12-199.pek2.redhat.com [10.72.12.199])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E45B61B7F;
        Thu, 18 Jul 2019 14:01:13 +0000 (UTC)
Subject: Re: [PATCH] virtio-net: parameterize min ring num_free for virtio
 receive
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        ? jiang <jiangkidd@hotmail.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xdp-newbies@vger.kernel.org" <xdp-newbies@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "jiangran.jr@alibaba-inc.com" <jiangran.jr@alibaba-inc.com>
References: <BYAPR14MB32056583C4963342F5D817C4A6C80@BYAPR14MB3205.namprd14.prod.outlook.com>
 <20190718085836-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bdd30ef5-4f69-8218-eed0-38c6daac42db@redhat.com>
Date:   Thu, 18 Jul 2019 22:01:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190718085836-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 18 Jul 2019 14:01:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/7/18 下午9:04, Michael S. Tsirkin wrote:
> On Thu, Jul 18, 2019 at 12:55:50PM +0000, ? jiang wrote:
>> This change makes ring buffer reclaim threshold num_free configurable
>> for better performance, while it's hard coded as 1/2 * queue now.
>> According to our test with qemu + dpdk, packet dropping happens when
>> the guest is not able to provide free buffer in avail ring timely.
>> Smaller value of num_free does decrease the number of packet dropping
>> during our test as it makes virtio_net reclaim buffer earlier.
>>
>> At least, we should leave the value changeable to user while the
>> default value as 1/2 * queue is kept.
>>
>> Signed-off-by: jiangkidd<jiangkidd@hotmail.com>
> That would be one reason, but I suspect it's not the
> true one. If you need more buffer due to jitter
> then just increase the queue size. Would be cleaner.
>
>
> However are you sure this is the reason for
> packet drops? Do you see them dropped by dpdk
> due to lack of space in the ring? As opposed to
> by guest?
>
>

Besides those, this patch depends on the user to choose a suitable 
threshold which is not good. You need either a good value with 
demonstrated numbers or something smarter.

Thanks

