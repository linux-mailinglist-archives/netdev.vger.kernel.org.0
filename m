Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53313215E7
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhBVMOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:14:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60537 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhBVMOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:14:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613995965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AhDS7E5Sv0xDYBYjviNIqwY+arwhTl2iWtkaDmSPDJU=;
        b=fOPhqz2A+XkuObJEP4ed0bm/M6SYgRTNhdE8yUjCDd0CgBxeIci1T697SkZ0bMbrdcIFiw
        ZvOqAI2k9csDZM+DS9GVxKluApsCXsl8YVU4EyWR+757y8Wu76ISHN7INn3rwXd3tvxRVD
        ipZs1O/LQULePbd/WM5GLZou5wqCHZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-5zd8Js_yOqCTO8wFXPiJjg-1; Mon, 22 Feb 2021 07:12:43 -0500
X-MC-Unique: 5zd8Js_yOqCTO8wFXPiJjg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAAE8107ACE3;
        Mon, 22 Feb 2021 12:12:41 +0000 (UTC)
Received: from horizon.localdomain (ovpn-113-140.rdu2.redhat.com [10.10.113.140])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8563919C79;
        Mon, 22 Feb 2021 12:12:41 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id B2C60C008A; Mon, 22 Feb 2021 09:12:39 -0300 (-03)
Date:   Mon, 22 Feb 2021 09:12:39 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     wenxu@ucloud.cn
Cc:     kuba@kernel.org, mleitner@redhat.com, netdev@vger.kernel.org,
        jhs@mojatatu.com, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH net-next] net/sched: cls_flower: validate ct_state for
 invalid and reply flags
Message-ID: <20210222121239.GA2960@horizon.localdomain>
References: <1613974190-12108-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1613974190-12108-1-git-send-email-wenxu@ucloud.cn>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 02:09:50PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Add invalid and reply flags validate in the fl_validate_ct_state.

This makes the checking complete if compared to ovs'
validate_ct_state().

...
> +	if (state & TCA_FLOWER_KEY_CT_FLAGS_INVALID &&
> +	    state & ~(TCA_FLOWER_KEY_CT_FLAGS_TRACKED |
> +		      TCA_FLOWER_KEY_CT_FLAGS_INVALID)) {
> +		NL_SET_ERR_MSG_ATTR(extack, tb,
> +				    "when inv is set, only trk also be set");

The message is missing the verb:
+				    "when inv is set, only trk may also be set");

Other than this, LGTM.

> +		return -EINVAL;
> +	}
> +
> +	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> +	    state & TCA_FLOWER_KEY_CT_FLAGS_REPLY) {
> +		NL_SET_ERR_MSG_ATTR(extack, tb,
> +				    "new and rpl are mutually exclusive");
> +		return -EINVAL;
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 1.8.3.1
> 

