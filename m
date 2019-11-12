Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A70EF8832
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 06:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfKLFrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 00:47:07 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27524 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725783AbfKLFrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 00:47:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573537626;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UBqjouGw3TH1iaQ7iP1CayKO4c2WZUu/AVL/DYGbLDM=;
        b=QFTUytoaPqSrw4YDgCusZzXtQvYzY3PaRYo4c8Hd97/Rdq3bkedp1X+GBzPQ3uH5yF1nGz
        RYMXJqoV20XaJbTOaOMxhU4Hr9ezuHXjrzSoQnMvfuOEBSVYYdsry9oMNzHv/Fj1wri4U/
        737210uAj5wrJ02wAvFM95qdcR0GNSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-jR0LROUlONuAV20I3GQI8Q-1; Tue, 12 Nov 2019 00:47:02 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82B98801E4F;
        Tue, 12 Nov 2019 05:47:01 +0000 (UTC)
Received: from localhost (ovpn-112-54.rdu2.redhat.com [10.10.112.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBD085C883;
        Tue, 12 Nov 2019 05:46:59 +0000 (UTC)
Date:   Mon, 11 Nov 2019 21:46:58 -0800 (PST)
Message-Id: <20191111.214658.1031500406952713920.davem@redhat.com>
To:     olof@lixom.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mdio-octeon: Fix pointer/integer casts
From:   David Miller <davem@redhat.com>
In-Reply-To: <20191111004211.96425-1-olof@lixom.net>
References: <20191111004211.96425-1-olof@lixom.net>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: jR0LROUlONuAV20I3GQI8Q-1
X-Mimecast-Spam-Score: 0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Olof Johansson <olof@lixom.net>
Date: Sun, 10 Nov 2019 16:42:11 -0800

> -static inline void oct_mdio_writeq(u64 val, u64 addr)
> +static inline void oct_mdio_writeq(u64 val, void __iomem *addr)
>  {
> -=09cvmx_write_csr(addr, val);
> +=09cvmx_write_csr((u64)addr, val);
>  }

I hate stuff like this, I think you really need to fix this from the bottom
up or similar.  MMIO and such addresses are __iomem pointers, period.

