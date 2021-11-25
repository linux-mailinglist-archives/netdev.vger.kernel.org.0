Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B253645DDDE
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356242AbhKYPtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:49:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48311 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235524AbhKYPrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 10:47:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637855043;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IND/nv7I6LjJjnJ279SuBroS+fprnXL/+EV0ln5A7HM=;
        b=KhEmr7cbX6mu4ilbOCEwRMxqj4V6/JKTUz+RntW7WJkcLI50RyP9irHifwYWCNhQMl54n5
        wHSR5ITBqlzuKxyBcD4mDxQgbHm4a1w1LmpI354hg5YG/pWHGUaCXlnQgJ6wDM5fN07S2+
        /FwErzGx1LjvhTYIaXat6u5rhHkItlo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-BjLlZVKEPxqP8kQLJEBiYg-1; Thu, 25 Nov 2021 10:43:58 -0500
X-MC-Unique: BjLlZVKEPxqP8kQLJEBiYg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB3EE1006AA0;
        Thu, 25 Nov 2021 15:43:56 +0000 (UTC)
Received: from x230 (unknown [10.39.192.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E662860C17;
        Thu, 25 Nov 2021 15:43:53 +0000 (UTC)
Date:   Thu, 25 Nov 2021 16:43:49 +0100
From:   Stefan Assmann <sassmann@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 06/12] iavf: Add trace while removing device
Message-ID: <20211125154349.ozf6jfq5kmzoou4j@x230>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
 <20211124171652.831184-7-anthony.l.nguyen@intel.com>
 <20211124154811.6d9c48cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20211125065049.hwubag5eherksrle@x230>
 <20211125071316.69c3319a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211125071316.69c3319a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-25 07:13, Jakub Kicinski wrote:
> On Thu, 25 Nov 2021 07:50:49 +0100 Stefan Assmann wrote:
> > On 2021-11-24 15:48, Jakub Kicinski wrote:
> > > On Wed, 24 Nov 2021 09:16:46 -0800 Tony Nguyen wrote:  
> > > > Add kernel trace that device was removed.
> > > > Currently there is no such information.
> > > > I.e. Host admin removes a PCI device from a VM,
> > > > than on VM shall be info about the event.
> > > > 
> > > > This patch adds info log to iavf_remove function.  
> > > 
> > > Why is this an important thing to print to logs about?
> > > If it is why is PCI core not doing the printing?
> > 
> > From personal experience I'd say this piece of information has value,
> > especially when debugging it can be interesting to know exactly when
> > the driver was removed.
> 
> But there isn't anything specific to iavf here, right? If it really 
> is important then core should be doing the printing for all drivers.
> 
> Actually, I can't come up with any uses for this print on the spot.
> What debugging scenarios do you have in mind?

There was a lot of trouble with iavf in terms of device reset, device
unbinding (DPDK), stress testing of driver load/unload issues. When
looking through the crash logs it was not always easy to determine if
the driver was still loaded.
Especially on problems that weren't easy to reproduce.

So for iavf having that information would have been valuable. Not sure
if that justifies a PCI core message or if others might find that too
verbose.

  Stefan

