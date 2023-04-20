Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0306E99C8
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjDTQnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbjDTQnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:43:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD9A2D6A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682008956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I6fTE8uyJF5qu0Pi8nEHi/Tjr/m72N2RiPgDazf02xk=;
        b=g2wGdshbUujWgVQlV2MrtmdV8Gr1EaWod+5ppH4DqROR58kBUO5SbUkhF/mb6JAGyw8TGO
        N/2XBVbguw6L12QIi9xbMzVENej+C4SeUnzrjvq9biIZm9lqmM096FLrjJUf4pB0h3P7iR
        RGlgwMSMGxCgKZbgmnoeJRYQBmQxCH4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-CJwRyV7GMX6wC-bShp44cQ-1; Thu, 20 Apr 2023 12:42:35 -0400
X-MC-Unique: CJwRyV7GMX6wC-bShp44cQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E4B6185A78F;
        Thu, 20 Apr 2023 16:42:34 +0000 (UTC)
Received: from localhost (unknown [10.2.16.204])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EB19B2026D16;
        Thu, 20 Apr 2023 16:42:33 +0000 (UTC)
Date:   Thu, 20 Apr 2023 09:42:32 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Lee Duncan <leeman.duncan@gmail.com>
Cc:     linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org, Lee Duncan <lduncan@suse.com>
Subject: Re: [RFC PATCH 2/9] iscsi: associate endpoints with a host
Message-ID: <20230420164232.GA27885@localhost>
Mail-Followup-To: Lee Duncan <leeman.duncan@gmail.com>,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        netdev@vger.kernel.org, Lee Duncan <lduncan@suse.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <154c7602b3cc59f8af44439249ea5e5eb75f92d3.1675876734.git.lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154c7602b3cc59f8af44439249ea5e5eb75f92d3.1675876734.git.lduncan@suse.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 09:40:50AM -0800, Lee Duncan wrote:
> Right now the iscsi_endpoint is only linked to a connection once that
> connection has been established.  For net namespace filtering of the
> sysfs objects, associate an endpoint with the host that it was
> allocated for when it is created.
> 
> Signed-off-by: Chris Leech <cleech@redhat.com>
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
> 
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 6b7603765383..212fa7aa9810 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -802,7 +802,7 @@ static struct iscsi_endpoint *iscsi_iser_ep_connect(struct Scsi_Host *shost,
>  	struct iser_conn *iser_conn;
>  	struct iscsi_endpoint *ep;
>  
> -	ep = iscsi_create_endpoint(0);
> +	ep = iscsi_create_endpoint(shost, 0);
>  	if (!ep)
>  		return ERR_PTR(-ENOMEM);

I started trying[1] to look at iSER, and I think this is a problem.
iSER is the only iSCSI driver that uses endpoint objects, but does not
require then to be bound to a host.  That means that
iscsi_iser_ep_connect can be called with a null shost.

So this fails, and not in a new namespace.
It just breaks iSER entirely.

I think we need to preserve support for the iscsi_endpoint device
having a virtual device path for iSER.

Also, enabling net namespace support for iSER might require the ability
to create an endpoint directly in a namespace instead of on a host.
Kind of like the create_session discussion for iscsi_tcp.

- Chris

[1] I say trying, becuase before going and borrowing an RDMA setup I
thought I'd give the kernel target and either siw or rxe a try. The
isert module seems to have issues with siw, and I think maybe any iWARP,
where setting enable_iser on a port will try and re-use the TCP port
number and fail due to it being in use.  With rxe my host failed, but
that's becuase of this create_endpoint issue.

