Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FC04A5C69
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbiBAMjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:39:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232056AbiBAMjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:39:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643719172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LIIvM4dVi2LnXmvwnS5mrkueKyfjeZf4au7wWwvXJD4=;
        b=d6X4x4aPDaEBRuKmWSzxTAj7WMPS2dIlDu9PnAPNoNrX/DPlSiHRmtRL3UDwQSV33UO6Ko
        vtPx+UuX46d3sCiXKi7vrjsMPsKRj0C+8QBBwRBVyvgNp2qQFLyu+5ZSIvRWwVoLnz7qYf
        N0Toa6RmKNwFhO5wuJHW1tDawEug7/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-345-WAcR_MP0O9K5vDFE_VGb2A-1; Tue, 01 Feb 2022 07:39:27 -0500
X-MC-Unique: WAcR_MP0O9K5vDFE_VGb2A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4F0018B9EC3;
        Tue,  1 Feb 2022 12:39:25 +0000 (UTC)
Received: from localhost (unknown [10.39.194.79])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D5BC6E1EB;
        Tue,  1 Feb 2022 12:39:25 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 10/15] vfio: Remove migration protocol v1
In-Reply-To: <20220201121325.GB1786498@nvidia.com>
Organization: Red Hat GmbH
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-11-yishaih@nvidia.com> <874k5izv8m.fsf@redhat.com>
 <20220201121325.GB1786498@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Tue, 01 Feb 2022 13:39:23 +0100
Message-ID: <87sft2yd50.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Feb 01, 2022 at 12:23:05PM +0100, Cornelia Huck wrote:
>> On Sun, Jan 30 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
>> 
>> > From: Jason Gunthorpe <jgg@nvidia.com>
>> >
>> > v1 was never implemented and is replaced by v2.
>> >
>> > The old uAPI definitions are removed from the header file. As per Linus's
>> > past remarks we do not have a hard requirement to retain compilation
>> > compatibility in uapi headers and qemu is already following Linus's
>> > preferred model of copying the kernel headers.
>> 
>> If we are all in agreement that we will replace v1 with v2 (and I think
>> we are), we probably should remove the x-enable-migration stuff in QEMU
>> sooner rather than later, to avoid leaving a trap for the next
>> unsuspecting person trying to update the headers.
>
> Once we have agreement on the kernel patch we plan to send a QEMU
> patch making it support the v2 interface and the migration
> non-experimental. We are also working to fixing the error paths, at
> least least within the limitations of the current qemu design.

I'd argue that just ripping out the old interface first would be easier,
as it does not require us to synchronize with a headers sync (and does
not require to synchronize a headers sync with ripping it out...)

> The v1 support should remain in old releases as it is being used in
> the field "experimentally".

Of course; it would be hard to rip it out retroactively :)

But it should really be gone in QEMU 7.0.

Considering adding the v2 uapi, we might get unlucky: The Linux 5.18
merge window will likely be in mid-late March (and we cannot run a
headers sync before the patches hit Linus' tree), while QEMU 7.0 will
likely enter freeze in mid-late March as well. So there's a non-zero
chance that the new uapi will need to be deferred to 7.1.

