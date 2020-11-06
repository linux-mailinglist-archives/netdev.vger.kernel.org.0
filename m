Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B0D2A9938
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 17:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgKFQOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 11:14:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726074AbgKFQOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 11:14:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604679244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EFW0/AjI5D48SWseHJMzco2NAKnAG+greLgwTvNixSU=;
        b=LM2PfXz6a1Gyu0otTn8kLN94ErjZ0cAbyxdF8DxITs4ou5gX5F2YtPZbdLES0TQGb6teZV
        7ZgJH6qaViva2rYhXeXovI6qPpJHEsVZxEsAWhof30ezRgELUpiS19fwPj3kzNrTuaxMxp
        D5KAgHdHBV0jniL6EvRyC8GF+KyGcuM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-P6_JqA-JOW-edsjyXRGGtA-1; Fri, 06 Nov 2020 11:14:00 -0500
X-MC-Unique: P6_JqA-JOW-edsjyXRGGtA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6CD13E06A1;
        Fri,  6 Nov 2020 16:13:58 +0000 (UTC)
Received: from carbon (unknown [10.36.110.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 986331002C18;
        Fri,  6 Nov 2020 16:13:55 +0000 (UTC)
Date:   Fri, 6 Nov 2020 17:13:52 +0100
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Alex Shi <alex.shi@linux.alibaba.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/xdp: remove unused macro REG_STATE_NEW
Message-ID: <20201106171352.5c51342d@carbon>
In-Reply-To: <1604641431-6295-1-git-send-email-alex.shi@linux.alibaba.com>
References: <1604641431-6295-1-git-send-email-alex.shi@linux.alibaba.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 13:43:51 +0800
Alex Shi <alex.shi@linux.alibaba.com> wrote:

> To tame gcc warning on it:
> net/core/xdp.c:20:0: warning: macro "REG_STATE_NEW" is not used
> [-Wunused-macros]

Hmm... REG_STATE_NEW is zero, so it is implicitly set via memset zero.
But it is true that it is technically not directly used or referenced.

It is mentioned in a comment, so please send V2 with this additional change:

$ git diff
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 48aba933a5a8..6e1430971ac2 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -175,7 +175,7 @@ int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
                return -ENODEV;
        }
 
-       /* State either UNREGISTERED or NEW */
+       /* State either UNREGISTERED or zero */
        xdp_rxq_info_init(xdp_rxq);
        xdp_rxq->dev = dev;
        xdp_rxq->queue_index = queue_index;


> Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> Cc: "David S. Miller" <davem@davemloft.net> 
> Cc: Jakub Kicinski <kuba@kernel.org> 
> Cc: Alexei Starovoitov <ast@kernel.org> 
> Cc: Daniel Borkmann <daniel@iogearbox.net> 
> Cc: Jesper Dangaard Brouer <hawk@kernel.org> 
> Cc: John Fastabend <john.fastabend@gmail.com> 
> Cc: netdev@vger.kernel.org 
> Cc: bpf@vger.kernel.org 
> Cc: linux-kernel@vger.kernel.org 
> ---
>  net/core/xdp.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 48aba933a5a8..3d88aab19c89 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -19,7 +19,6 @@
>  #include <trace/events/xdp.h>
>  #include <net/xdp_sock_drv.h>
>  
> -#define REG_STATE_NEW		0x0
>  #define REG_STATE_REGISTERED	0x1
>  #define REG_STATE_UNREGISTERED	0x2
>  #define REG_STATE_UNUSED	0x3



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

