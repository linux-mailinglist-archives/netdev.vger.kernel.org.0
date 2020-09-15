Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E594126A08B
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgIOIUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:20:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726361AbgIOIUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:20:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600157999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tvwl3r1gtQ/vI6amnctmoViryXc61AUea/91GxxvZOQ=;
        b=bSlHOhVtlYxn0+sLmI9/apRK9Wu/9YlvmgjDjn7OfUrrmUbYaUu902+yy9IZhFqdU+I0tT
        pSUNIED4BnKcXbdbX77A16sulrV2gpbpTUcBHty8A9brt0ncCJmRDUmJgo6aT5naYyHYdE
        KsI14vCAO+8ee0CIJ7tRqFd2EHkNpUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-cDtDwTJQNG2DyR0IvAZcgQ-1; Tue, 15 Sep 2020 04:19:55 -0400
X-MC-Unique: cDtDwTJQNG2DyR0IvAZcgQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 98280801AF1;
        Tue, 15 Sep 2020 08:19:48 +0000 (UTC)
Received: from ceranb (unknown [10.40.194.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D635A7512A;
        Tue, 15 Sep 2020 08:19:42 +0000 (UTC)
Date:   Tue, 15 Sep 2020 10:19:41 +0200
From:   Ivan Vecera <ivecera@redhat.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next 5/8] bridge: Add SWITCHDEV_FDB_FLUSH_TO_BRIDGE
 notifier
Message-ID: <20200915101941.7c18be01@ceranb>
In-Reply-To: <20200910172351.5622-6-jwi@linux.ibm.com>
References: <20200910172351.5622-1-jwi@linux.ibm.com>
        <20200910172351.5622-6-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Sep 2020 19:23:48 +0200
Julian Wiedmann <jwi@linux.ibm.com> wrote:

> From: Alexandra Winter <wintera@linux.ibm.com>
> 
> so the switchdev can notifiy the bridge to flush non-permanent fdb entries
> for this port. This is useful whenever the hardware fdb of the switchdev
> is reset, but the netdev and the bridgeport are not deleted.
> 
> Note that this has the same effect as the IFLA_BRPORT_FLUSH attribute.
> 
> CC: Jiri Pirko <jiri@resnulli.us>
> CC: Ivan Vecera <ivecera@redhat.com>
> CC: Roopa Prabhu <roopa@nvidia.com>
> CC: Nikolay Aleksandrov <nikolay@nvidia.com>
> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> ---
>  include/net/switchdev.h | 1 +
>  net/bridge/br.c         | 5 +++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index ff2246914301..53e8b4994296 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -203,6 +203,7 @@ enum switchdev_notifier_type {
>  	SWITCHDEV_FDB_ADD_TO_DEVICE,
>  	SWITCHDEV_FDB_DEL_TO_DEVICE,
>  	SWITCHDEV_FDB_OFFLOADED,
> +	SWITCHDEV_FDB_FLUSH_TO_BRIDGE,
>  
>  	SWITCHDEV_PORT_OBJ_ADD, /* Blocking. */
>  	SWITCHDEV_PORT_OBJ_DEL, /* Blocking. */
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index b6fe30e3768f..401eeb9142eb 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -183,6 +183,11 @@ static int br_switchdev_event(struct notifier_block *unused,
>  		br_fdb_offloaded_set(br, p, fdb_info->addr,
>  				     fdb_info->vid, fdb_info->offloaded);
>  		break;
> +	case SWITCHDEV_FDB_FLUSH_TO_BRIDGE:
> +		fdb_info = ptr;
> +		/* Don't delete static entries */
> +		br_fdb_delete_by_port(br, p, fdb_info->vid, 0);
> +		break;
>  	}
>  
>  out:

Acked-by: Ivan Vecera <ivecera@redhat.com>

