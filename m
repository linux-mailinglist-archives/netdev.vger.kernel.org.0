Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82EFC17A717
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgCEOER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:04:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726209AbgCEOEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:04:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583417055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JJEPv5d9gi0yzJVgRiEGDLZEl6htk15Hra7XzGoT3L8=;
        b=iiu095RjN96UJwzsWTff0LDLqYCLR/G6J3cnvl2mRadgSqZ5Zj0XSfn+MJM6wJoSZLNpPN
        51wr6pfGAob5ldQkYJE3J9UdGd7QsbcRubFLO4KxEK0HgK7jfqBihG0fbMSFPuABK+LZKs
        adXALKX5bbxa0tw1BpRMcUvCxXtxBU0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-536KfwbPNZq1W7ZT8G9u5w-1; Thu, 05 Mar 2020 09:04:12 -0500
X-MC-Unique: 536KfwbPNZq1W7ZT8G9u5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B9DEA0CC5;
        Thu,  5 Mar 2020 14:04:11 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 229F54DA62;
        Thu,  5 Mar 2020 14:04:01 +0000 (UTC)
Date:   Thu, 5 Mar 2020 15:04:00 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, jgross@suse.com,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next v2] xen-netfront: add basic XDP support
Message-ID: <20200305150347.740b209f@carbon>
In-Reply-To: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
References: <1583158874-2751-1-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Mar 2020 17:21:14 +0300
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
> index 286054b..81a6023 100644
> --- a/drivers/net/xen-netback/xenbus.c
> +++ b/drivers/net/xen-netback/xenbus.c
> @@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info *be,
>  	}
>  }
>  
> +static void read_xenbus_fronetend_xdp(struct backend_info *be,
> +				      struct xenbus_device *dev)

Strange spelling of this function name: 'fronetend'

> +{
> +	struct xenvif *vif = be->vif;
> +	unsigned int val;
> +	int err;
> +
> +	err = xenbus_scanf(XBT_NIL, dev->otherend,
> +			   "feature-xdp", "%u", &val);
> +	if (err < 0)
> +		return;
> +	vif->xdp_enabled = val;
> +}
> +
>  /**
>   * Callback received when the frontend's state changes.
>   */
> @@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device *dev,
>  		set_backend_state(be, XenbusStateConnected);
>  		break;
>  
> +	case XenbusStateReconfiguring:
> +		read_xenbus_fronetend_xdp(be, dev);
                            ^^^^^^^^
> +		xenbus_switch_state(dev, XenbusStateReconfigured);
> +		break;
> +

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

