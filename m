Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3E74A5E1A
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 15:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239159AbiBAOTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 09:19:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239002AbiBAOT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 09:19:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643725169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kYjnMC9tPGNeYuQS/9IzugsptRNBQAJSLzF0SEucIUg=;
        b=C398VwF2ErYD/oTb45xWTydO///2QvZpra32lq7ectYrAtx+1iLYUN/YfZ1wBy+bFxTpCs
        4gWmwWIBEWWmVd9IQCx/Yce6Zznzu8UXvlMqYT8Y7+9eTDyOBAxKAwZ5KMIbR9RzqFJ14K
        tqnf8DwaKkWt1E+5TMMjisbG07w65IU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-w-Zc9dibPL6gj8-g7kb4IA-1; Tue, 01 Feb 2022 09:19:25 -0500
X-MC-Unique: w-Zc9dibPL6gj8-g7kb4IA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B68DD8144E4;
        Tue,  1 Feb 2022 14:19:23 +0000 (UTC)
Received: from localhost (unknown [10.39.194.79])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3A7A4708D3;
        Tue,  1 Feb 2022 14:19:20 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
In-Reply-To: <20220201135231.GF1786498@nvidia.com>
Organization: Red Hat GmbH
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-11-yishaih@nvidia.com> <874k5izv8m.fsf@redhat.com>
 <20220201121325.GB1786498@nvidia.com> <87sft2yd50.fsf@redhat.com>
 <20220201125444.GE1786498@nvidia.com> <87mtjayayi.fsf@redhat.com>
 <20220201135231.GF1786498@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 01 Feb 2022 15:19:18 +0100
Message-ID: <87k0eey8ih.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 01, 2022 at 02:26:29PM +0100, Cornelia Huck wrote:
>
>> > We can certainly defer the kernels removal patch for a release if it
>> > makes qemu's life easier?
>> 
>> No, I'm only talking about the QEMU implementation (i.e. the code that
>> uses the v1 definitions and exposes x-enable-migration). Any change in
>> the headers needs to be done via a sync with upstream Linux.
>
> If we leave the v1 and v2 defs in the kernel header then qemu can sync
> and do the trivial rename and keep going as-is.
>
> Then we can come with the patches to qemu update to v2, however that
> looks.
>
> We'll clean the kernel header in the next cylce.

I'm not sure we're talking about the same things here...

My proposal is:

- remove the current QEMU implementation of vfio migration for 7.0 (it's
  experimental, and if there's anybody experimenting with that, they can
  stay on 6.2)
- continue with getting this proposal for the kernel into good shape, so
  that it can hopefully make the next merge window
(- also continue to get the documentation into good shape)
- have an RFC for QEMU that contains a provisional update of the
  relevant vfio headers so that we can discuss the QEMU side (and maybe
  shoot down any potential problems in the uapi before they are merged
  in the kernel)

I don't think a "dual version header" would really help here. If we
don't want to rip out the old QEMU implementation yet, I can certainly
also live with that. We just need to be mindful once the changes hit
Linus' tree, but it is quite likely that QEMU would be in freeze by
then. As long as updating the headers leads to an obvious failure, it's
managable (although the removal would still be my preferred approach.)

Alex, what do you think?

