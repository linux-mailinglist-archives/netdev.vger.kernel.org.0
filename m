Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9E5101AE5
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 09:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfKSIFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 03:05:03 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52499 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727073AbfKSIFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 03:05:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574150701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1MlTih8cCQ4S/hqFZ1/WTgoAoxUoAz6EyWx3ksJycWc=;
        b=gNvTuQkQ3smjtYEp9fEd+i+05A2cxj0GAY9HZG3wqKW3ozPJNVBrBXPv5IHenTOYl6NjwG
        n/2mH3AapXl9icqJWszGK5zl4r2uTUuS64IpK0s/rlKSsixjR3EIavQWsDT1goCU5yWdvU
        MsoJ2eZOE62CDixGovwjEFNAFpA0iks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-h9I2qfHvO1OqTNLBkQCu4Q-1; Tue, 19 Nov 2019 03:04:58 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEFAB107ACC4;
        Tue, 19 Nov 2019 08:04:56 +0000 (UTC)
Received: from [10.72.12.74] (ovpn-12-74.pek2.redhat.com [10.72.12.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A5FF166074;
        Tue, 19 Nov 2019 08:04:52 +0000 (UTC)
Subject: Re: [net-next v2 1/1] virtual-bus: Implementation of Virtual Bus
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com, jgg@ziepe.ca,
        parav@mellanox.com, Kiran Patil <kiran.patil@intel.com>
References: <20191115223355.1277139-1-jeffrey.t.kirsher@intel.com>
 <20191118074834.GA130507@kroah.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d3ee845d-cc9f-a4f7-2f21-511fde61dd5e@redhat.com>
Date:   Tue, 19 Nov 2019 16:04:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191118074834.GA130507@kroah.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: h9I2qfHvO1OqTNLBkQCu4Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/11/18 =E4=B8=8B=E5=8D=883:48, Greg KH wrote:
> +Virtbus drivers
> +~~~~~~~~~~~~~~~
> +Virtbus drivers register with the virtual bus to be matched with virtbus
> +devices.  They expect to be registered with a probe and remove callback,
> +and also support shutdown, suspend, and resume callbacks.  They otherwis=
e
> +follow the standard driver behavior of having discovery and enumeration
> +handled in the bus infrastructure.
> +
> +Virtbus drivers register themselves with the API entry point virtbus_drv=
_reg
> +and unregister with virtbus_drv_unreg.
> +
> +Device Enumeration
> +~~~~~~~~~~~~~~~~~~
> +Enumeration is handled automatically by the bus infrastructure via the
> +ida_simple methods.
> +
> +Device naming and driver binding
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +The virtbus_device.dev.name is the canonical name for the device. It is
> +built from two other parts:
> +
> +        - virtbus_device.name (also used for matching).
> +        - virtbus_device.id (generated automatically from ida_simple cal=
ls)
> +
> +This allows for multiple virtbus_devices with the same name, which will =
all
> +be matched to the same virtbus_driver. Driver binding is performed by th=
e
> +driver core, invoking driver probe() after finding a match between devic=
e and driver.
> +
> +Virtual Bus API entry points
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +struct virtbus_device *virtbus_dev_alloc(const char *name, void *data)


Hi:

Several questions about the name parameter here:

- If we want to have multiple types of device to be attached, some=20
convention is needed to avoid confusion during the match. But if we had=20
such one (e.g prefix or suffix), it basically another bus?
- Who decides the name of this virtbus dev, is it under the control of=20
userspace? If yes, a management interface is required.

Thanks


> +int virtbus_dev_register(struct virtbus_device *vdev)
> +void virtbus_dev_unregister(struct virtbus_device *vdev)
> +int virtbus_drv_register(struct virtbus_driver *vdrv, struct module *own=
er)
> +void virtbus_drv_unregister(struct virtbus_driver *vdrv)

