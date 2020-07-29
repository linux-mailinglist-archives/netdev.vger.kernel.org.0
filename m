Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD2C231C05
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728155AbgG2JWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:22:15 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:43167 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727849AbgG2JWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 05:22:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596014534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gfMmbbC8VgRw8IQ9ZtQih9sQCoQJENghyVj/1NXZj5U=;
        b=T9UoEIknSwUDf/2kxu5WvCZ3rTITlwy98ZFg9AFeQqJgkGyfmjq6EBz66jTLtqNt2xlCZk
        JctLLKTcgRtKptch61SSOElbupeK21LG6oWq+5pew8rRFqYFgqqTOPSkfTEF7u5/Wxa7ri
        ZnDeYSN6U9zAj8wq0QDpKJETv6Gayjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-JsuazCKzOVC8QSBFb1PA1Q-1; Wed, 29 Jul 2020 05:22:10 -0400
X-MC-Unique: JsuazCKzOVC8QSBFb1PA1Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D662C1800D4A;
        Wed, 29 Jul 2020 09:22:08 +0000 (UTC)
Received: from [10.72.13.120] (ovpn-13-120.pek2.redhat.com [10.72.13.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86C7179310;
        Wed, 29 Jul 2020 09:21:55 +0000 (UTC)
Subject: Re: [PATCH V4 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
To:     Eli Cohen <eli@mellanox.com>, Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     alex.williamson@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, shahafs@mellanox.com, parav@mellanox.com
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
 <20200728042405.17579-5-lingshan.zhu@intel.com>
 <20200728090438.GA21875@nps-server-21.mtl.labs.mlnx>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c87d4a5a-3106-caf2-2bc1-764677218967@redhat.com>
Date:   Wed, 29 Jul 2020 17:21:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200728090438.GA21875@nps-server-21.mtl.labs.mlnx>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/28 下午5:04, Eli Cohen wrote:
> On Tue, Jul 28, 2020 at 12:24:03PM +0800, Zhu Lingshan wrote:
>>   
>> +static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, int qid)
>> +{
>> +	struct vhost_virtqueue *vq = &v->vqs[qid];
>> +	const struct vdpa_config_ops *ops = v->vdpa->config;
>> +	struct vdpa_device *vdpa = v->vdpa;
>> +	int ret, irq;
>> +
>> +	spin_lock(&vq->call_ctx.ctx_lock);
>> +	irq = ops->get_vq_irq(vdpa, qid);
>> +	if (!vq->call_ctx.ctx || irq == -EINVAL) {
>> +		spin_unlock(&vq->call_ctx.ctx_lock);
>> +		return;
>> +	}
>> +
> If I understand correctly, this will cause these IRQs to be forwarded
> directly to the VCPU, e.g. will be handled by the guest/qemu.


Yes, if it can bypassed, the interrupt will be delivered to vCPU directly.


> Does this mean that the host will not handle this interrupt? How does it
> work in case on level triggered interrupts?


There's no guarantee that the KVM arch code can make sure the irq bypass 
work for any type of irq. So if they the irq will still need to be 
handled by host first. This means we should keep the host interrupt 
handler as a slowpath (fallback).


>
> In the case of ConnectX, I need to execute some code to acknowledge the
> interrupt.


This turns out to be hard for irq bypassing to work. Is it because the 
irq is shared or what kind of ack you need to do?

Thanks


>
> Can you explain how this should be done?
>

