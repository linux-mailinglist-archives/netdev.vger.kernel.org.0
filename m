Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607986DE3C2
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjDKSUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDKSUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:20:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DB25240
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681237191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mAc9R2NlOKWjR2PE+m5zaGvaSX1lOZHMdVV04kPoutU=;
        b=DE8cWQTbA1ABF8qpFbvXVULNjvL+jYlcYFXQAgHH4rVUZ3PU989618iVPSIf9g5eeuEVVJ
        W7m52rx97xz6TZ2DMMThHtjTLToqu3ho3mXX+Ur792/BikCPaAXXBAuzh3O4ePuSdHK4VE
        L3ZOCPo3drkHaD2usQYnn8/LTp8mI9Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-Jhv8xwOrMcuRFBV00TV5Dw-1; Tue, 11 Apr 2023 14:19:47 -0400
X-MC-Unique: Jhv8xwOrMcuRFBV00TV5Dw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 727961C08960;
        Tue, 11 Apr 2023 18:19:47 +0000 (UTC)
Received: from localhost (unknown [10.2.16.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DFEFF2166B30;
        Tue, 11 Apr 2023 18:19:46 +0000 (UTC)
Date:   Tue, 11 Apr 2023 11:19:45 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        Lee Duncan <leeman.duncan@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 11/11] iscsi: force destroy sesions when a network
 namespace exits
Message-ID: <20230411181945.GB1234639@localhost>
Mail-Followup-To: Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        Lee Duncan <leeman.duncan@gmail.com>, netdev@vger.kernel.org
References: <83de4002-6846-2f90-7848-ef477f0b0fe5@suse.de>
 <20230410191033.1069293-3-cleech@redhat.com>
 <85458436-702f-2e38-c7cc-ff7329731eda@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85458436-702f-2e38-c7cc-ff7329731eda@suse.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 08:21:22AM +0200, Hannes Reinecke wrote:
> On 4/10/23 21:10, Chris Leech wrote:
> > The namespace is gone, so there is no userspace to clean up.
> > Force close all the sessions.
> > 
> > This should be enough for software transports, there's no implementation
> > of migrating physical iSCSI hosts between network namespaces currently.
> > 
> Ah, you shouldn't have mentioned that.
> (Not quite sure how being namespace-aware relates to migration, though.)
> We should be checking/modifying the iSCSI offload drivers, too.
> But maybe with a later patch.

I shouldn't have left that opening ;-)

The idea with this design is to keep everything rooted on the
iscsi_host, and for physical HBAs those stay assigned to init_net.
With this patch set, offload drivers remain unusable in a net namespace
other than init_net. They simply are not visible.

By migration, I was implying the possibilty of assigment of an HBA
iscsi_host into a namespace like you can do with a network interface.
Such an iscsi_host would then need to be migrated back to init_net on
namespace exit.

I don't think it works to try and share an iscsi_host across namespaces,
and manage different sessions. The iSCSI HBAs have a limited number of
network configurations, exposed as iscsi_iface objects, and I don't want
to go down the road of figuring out how to share those.

- Chris

