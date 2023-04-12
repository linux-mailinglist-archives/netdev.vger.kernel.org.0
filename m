Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC196DE971
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 04:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjDLCcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 22:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjDLCcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 22:32:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98DD1BC8
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 19:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681266692;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jAS+m9m5VyUpKBchdiVlMAfxL5Qd4dYwrUH64TL4UNI=;
        b=JcIGSStvJBZY+zrGNz/KveqFAnP4Yu9Q7VUuyKXwgWOivr5Uy0//2KgrVqCHaxm22fabtU
        p7K/vm3e+++m3FBfdRcMvIjotzQAe3c6LFzMLd0Ci0UIwxMAmjSPPFyqDePKZLVO3ddkMG
        kvfs8+mbBSE9j4QMi9Hoct5s2mKhLho=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-qBO12-npNsy5sbt7pmMEiA-1; Tue, 11 Apr 2023 22:31:28 -0400
X-MC-Unique: qBO12-npNsy5sbt7pmMEiA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72C5438041C2;
        Wed, 12 Apr 2023 02:31:28 +0000 (UTC)
Received: from localhost (unknown [10.2.16.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CAE1F492B00;
        Wed, 12 Apr 2023 02:31:27 +0000 (UTC)
Date:   Tue, 11 Apr 2023 19:31:25 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>
Subject: Re: [RFC PATCH 2/9] iscsi: associate endpoints with a host
Message-ID: <20230412023125.GA1777710@localhost>
Mail-Followup-To: Hannes Reinecke <hare@suse.de>,
        Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <154c7602b3cc59f8af44439249ea5e5eb75f92d3.1675876734.git.lduncan@suse.com>
 <a9f8cc4f-5d60-be5e-d294-c4a9baa16ec4@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9f8cc4f-5d60-be5e-d294-c4a9baa16ec4@suse.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 05:23:26PM +0100, Hannes Reinecke wrote:
> On 2/8/23 18:40, Lee Duncan wrote:
> > From: Lee Duncan <lduncan@suse.com>
> > @@ -230,6 +230,7 @@ iscsi_create_endpoint(int dd_size)
> >   	ep->id = id;
> >   	ep->dev.class = &iscsi_endpoint_class;
> > +	ep->dev.parent = &shost->shost_gendev;
> >   	dev_set_name(&ep->dev, "ep-%d", id);
> >   	err = device_register(&ep->dev);
> >           if (err)
> 
> Umm... doesn't this change the sysfs layout?
> IE won't the endpoint node be moved under the Scsi_Host directory?
> 
> But even if it does: do we care?

It does, but it shouldn't matter. The Open-iSCSI tools look under the
subsystem, not the device path. Being a child of the host makes more
sense then being a floating virtual device.

I just re-tested with bnx2i to make sure moving an endpoint devpath in
sysfs didn't break anything.

- Chris

