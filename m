Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80AE4E8CD3
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 17:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390544AbfJ2QfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 12:35:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390460AbfJ2QfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 12:35:22 -0400
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E507765F4C
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 16:35:21 +0000 (UTC)
Received: by mail-wr1-f69.google.com with SMTP id t2so5434498wri.18
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 09:35:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FQnLYx2QWY4cuAKWiCGGUv4yf2h+qdP8BhSsdB+2sT0=;
        b=dayaQ66M1gDFKu6ngr8OZztEhV58qo3pKrma4QdGs3AsoCsHkzcn2rYMwPJtjZbsGf
         xUziT3mXm2BmzEkAKR9Ro1iH10PVJ4X/B/DqLU/DYeZnwBquoPMwhxm9KzV2sEM24uC0
         xjP5Xr7SpZpgIeI3dmOSTcpZxyXS99WtYoY7nbvntLbOidGkoR7Nk+r1w5CTQJ3jr8nX
         APWZK764b3jJ37uXkWzXLEpoIZsQsKHFVXIPKq+jv++gxUSlKEn2eJTAVezbDc7Ml3x/
         6jdjzj3uespD1/MqmMLpBteUfAO8B9XYs6iiq8qiakU4aHHndCVkB3dCPls4K6Te+e5I
         r3Ww==
X-Gm-Message-State: APjAAAVr0jBdnFApxcmDmd2KHBLfmflcMkpKEOc8M4wNH9XLI5FayscH
        NrAHRgu3h4WFHhtmHpKi5JhJaylH3YKfYm9oKdjQ5S7ON2CZWdOK22ikMiYiFyniifxiGnex+BU
        Jvhjohuc/GFpb19ex
X-Received: by 2002:a1c:a9cb:: with SMTP id s194mr5321606wme.92.1572366920614;
        Tue, 29 Oct 2019 09:35:20 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx29BHLiojOUxFUuXNicrwQ7MqELEUWM6W1qCELpsBAD/xgXR4ttLraQVt+y1hgrjzLl0jEJQ==
X-Received: by 2002:a1c:a9cb:: with SMTP id s194mr5321583wme.92.1572366920428;
        Tue, 29 Oct 2019 09:35:20 -0700 (PDT)
Received: from steredhat (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id r19sm18295914wrr.47.2019.10.29.09.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 09:35:19 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:35:16 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Stefan Hajnoczi <stefanha@gmail.com>
Cc:     netdev@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-hyperv@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dexuan Cui <decui@microsoft.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: Re: [PATCH net-next 12/14] vsock/vmci: register vmci_transport only
 when VMCI guest/host are active
Message-ID: <20191029163516.td6wk7lf5pmytwtk@steredhat>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-13-sgarzare@redhat.com>
 <20191027081752.GD4472@stefanha-x1.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027081752.GD4472@stefanha-x1.localdomain>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 27, 2019 at 09:17:52AM +0100, Stefan Hajnoczi wrote:
> On Wed, Oct 23, 2019 at 11:55:52AM +0200, Stefano Garzarella wrote:
> > +static int __init vmci_transport_init(void)
> > +{
> > +	int features = VSOCK_TRANSPORT_F_DGRAM;
> 
> Where is this variable used?

It is introduced in the previous patch "vsock: add multi-transports support",
and it is used in the vsock_core_register(), but since now the
vmci_transport_init() registers the vmci_transport only with DGRAM
feature, I can remove this variable and I can use directly the
VSOCK_TRANSPORT_F_DGRAM.

I'll fix in the v3.

Thanks,
Stefano
