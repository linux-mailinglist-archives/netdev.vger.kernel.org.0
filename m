Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51FC2DCB40
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 04:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgLQDVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 22:21:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727268AbgLQDVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 22:21:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608175218;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WxrLNClNxtWpF/I0GtAX4YWo409+WYEx0FJBCyJA26c=;
        b=TbTvdZK6aWftaIrTFvEOtp/IuXqhHjgABhgHt1bj1bNqqqeMBdsPgcFQ9rw6KkHXFL9krh
        LYpe9zaf/hK2TTFMDLGMcODtM+fvGyOy0NV5TCC9WzBbKa5CWlNNktUmCPBSGjI/TDxQmb
        wgG020reuOCc07Xkrl4t4vY66qcMNJ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-vxQ0rYcbPOmjdfQFLGLTwA-1; Wed, 16 Dec 2020 22:20:13 -0500
X-MC-Unique: vxQ0rYcbPOmjdfQFLGLTwA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8037800D62;
        Thu, 17 Dec 2020 03:20:11 +0000 (UTC)
Received: from [10.72.12.223] (ovpn-12-223.pek2.redhat.com [10.72.12.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7104A10074E0;
        Thu, 17 Dec 2020 03:19:58 +0000 (UTC)
Subject: Re: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg
 fails
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
References: <cover.1608065644.git.wangyunjian@huawei.com>
 <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
 <20201216042027-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <482e71e6-2c85-346f-d7f9-10db6a5c716b@redhat.com>
Date:   Thu, 17 Dec 2020 11:19:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201216042027-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/16 下午5:23, Michael S. Tsirkin wrote:
> On Wed, Dec 16, 2020 at 04:20:37PM +0800, wangyunjian wrote:
>> From: Yunjian Wang<wangyunjian@huawei.com>
>>
>> Currently we break the loop and wake up the vhost_worker when
>> sendmsg fails. When the worker wakes up again, we'll meet the
>> same error. This will cause high CPU load. To fix this issue,
>> we can skip this description by ignoring the error. When we
>> exceeds sndbuf, the return value of sendmsg is -EAGAIN. In
>> the case we don't skip the description and don't drop packet.
> Question: with this patch, what happens if sendmsg is interrupted by a signal?


Since we use MSG_DONTWAIT, we don't need to care about signal I think.

Thanks


>
>

