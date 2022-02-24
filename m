Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573424C29C2
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 11:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbiBXKml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 05:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231672AbiBXKmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 05:42:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BEA116A58B
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 02:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645699329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ae5cFQNdc0p3hFbpsaaNC1IeyCU41i7xtv/27lyslL4=;
        b=S0ZDBZ+TeitTlk7NKdw/EP/iCv8achLn3fuHQCvTNINQlIWSy+0nf/RuA+ZILYJ9coEKbh
        EoLaJE+vIfbJ0xbOkH2FWml2mK3QclZTanDLrftkE2/hQ1p0nRujNGthdUX6z0uwB3HQ+c
        TLKT0RI8L7k1pVZH61vioWZi651ieAU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-385-WRuhcsptOwCvRstI-Qbm7Q-1; Thu, 24 Feb 2022 05:42:04 -0500
X-MC-Unique: WRuhcsptOwCvRstI-Qbm7Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A3C25126;
        Thu, 24 Feb 2022 10:42:02 +0000 (UTC)
Received: from localhost (unknown [10.39.195.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F9BF83197;
        Thu, 24 Feb 2022 10:41:46 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, saeedm@nvidia.com, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        leonro@nvidia.com, kwankhede@nvidia.com, mgurtovoy@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V8 mlx5-next 09/15] vfio: Define device migration
 protocol v2
In-Reply-To: <20220224004622.GD409228@nvidia.com>
Organization: Red Hat GmbH
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-10-yishaih@nvidia.com> <87ley17bsq.fsf@redhat.com>
 <20220224004622.GD409228@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Thu, 24 Feb 2022 11:41:44 +0100
Message-ID: <87ilt47dhz.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Feb 23, 2022 at 06:06:13PM +0100, Cornelia Huck wrote:
>> On Sun, Feb 20 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

>> > +/*
>> > + * Indicates the device can support the migration API through
>> > + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If present flags must be non-zero and
>> > + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE is supported. The RUNNING and
>> 
>> I'm having trouble parsing this. I think what it tries to say is that at
>> least one of the flags defined below must be set?
>> 
>> > + * ERROR states are always supported if this GET succeeds.
>> 
>> What about the following instead:
>> 
>> "Indicates device support for the migration API through
>> VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If present, the RUNNING and ERROR
>> states are always supported. Support for additional states is indicated
>> via the flags field; at least one of the flags defined below must be
>> set."
>
> Almost, 'at least VFIO_MIGRATION_STOP_COPY must be set'

It feels a bit odd to split the mandatory states between a base layer
(RUNNING/ERROR) and the ones governed by VFIO_MIGRATION_STOP_COPY. Do we
want to keep the possibility of a future implementation that does not
use the semantics indicated by VFIO_MIGRATION_STOP_COPY? If yes, it
should be "one of the flags" and the flags that require
VFIO_MIGRATION_STOP_COPY to be set as well need to note that
dependency. If not, we should explicitly tag VFIO_MIGRATION_STOP_COPY as
mandatory (so that the flag's special status is obvious.)

