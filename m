Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AD41FD63A
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgFQUnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:43:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36944 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726496AbgFQUnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:43:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592426631;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6X65o6lwIrjd7HcvW2DZaxhRG6o6m70L09u+7mIfejg=;
        b=XMflF7mBFZ8t42mrzG9Xl8yRiGXaT2iYzAeGSnq8ei0BefAoraOg2h0BCPvh33G632GRiA
        7IBejNHDtp9qlH92qPHT0FKMv3YR6Z5YSAI5g7pcD7Su5qUK5i2Qqa4QuDqGBDr6AqOipC
        ZKRN0jbJlRnwjYmiUG78yMQqMpRn0S4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-6yOHE_BQNAOP_mWOzvp4Nw-1; Wed, 17 Jun 2020 16:43:49 -0400
X-MC-Unique: 6yOHE_BQNAOP_mWOzvp4Nw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 605EA1801256;
        Wed, 17 Jun 2020 20:43:48 +0000 (UTC)
Received: from jtoppins.rdu.csb (ovpn-112-156.rdu2.redhat.com [10.10.112.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9258512FE;
        Wed, 17 Jun 2020 20:43:47 +0000 (UTC)
Reply-To: jtoppins@redhat.com
Subject: Re: [PATCH net] ionic: no link check while resetting queues
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20200616011459.30966-1-snelson@pensando.io>
 <8fadc381-aa45-8710-fad7-c3cfdb01b802@redhat.com>
 <0d73be4b-6935-f8c4-765e-709e416edda2@pensando.io>
From:   Jonathan Toppins <jtoppins@redhat.com>
Organization: Red Hat
Message-ID: <2ecafd78-ceeb-6e19-4e4a-274b9807aa40@redhat.com>
Date:   Wed, 17 Jun 2020 16:43:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <0d73be4b-6935-f8c4-765e-709e416edda2@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/20 3:53 PM, Shannon Nelson wrote:
> On 6/17/20 12:41 PM, Jonathan Toppins wrote:
>> On 6/15/20 9:14 PM, Shannon Nelson wrote:
>>> If the driver is busy resetting queues after a change in
>>> MTU or queue parameters, don't bother checking the link,
>>> wait until the next watchdog cycle.
>>>
>>> Fixes: 987c0871e8ae ("ionic: check for linkup in watchdog")
>>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
>>> ---
>>>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>>> b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>>> index 9d8c969f21cb..bfadc4934702 100644
>>> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
>>> @@ -96,7 +96,8 @@ static void ionic_link_status_check(struct
>>> ionic_lif *lif)
>>>       u16 link_status;
>>>       bool link_up;
>>>   -    if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state))
>>> +    if (!test_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state) ||
>>> +        test_bit(IONIC_LIF_F_QUEUE_RESET, lif->state))
>>>           return;
>>>         link_status = le16_to_cpu(lif->info->status.link_status);
>>>
>> Would a firmware reset bit being asserted also cause an issue here
>> (IONIC_LIF_F_FW_RESET)? Meaning do we need to test for this bit as well?
>>
> 
> No, we actually want the link_status_check during the FW_RESET so that
> we can detect when the FW has come back up and Linked.  During that time
> we just don't want user processes poking at us, which is why the
> netif_device_detach()/netif_device_attach() are used there.
> 
> sln
> 

Ah ok, I missed that. Thanks.

Acked-by: Jonathan Toppins <jtoppins@redhat.com>

