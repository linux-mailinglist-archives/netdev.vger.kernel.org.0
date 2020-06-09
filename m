Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E0A1F3A91
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 14:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgFIMXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 08:23:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27111 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728005AbgFIMXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 08:23:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591705410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d3aWiXtS8cF+u5/TS5j+n1u7AbVcRqeRZ4SH9J+GaOc=;
        b=QJv+STammPSsvqrJs8xbwuuoU8RUYbGzevD02eTQm0ZeVsyXR27RpMsWfQf7Y74jN4ykwQ
        d7lOoj/OexalxWcPigXWkS/n+n/2fwfQJFJaUTLJ5dx9Hg6whC53MHSiC2jJ4+AW349A9C
        /Fx42yU7BKmHRpfcBWojYPOMoB3gwyo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-mSCxeT0HPrWtom8qduK5cQ-1; Tue, 09 Jun 2020 08:23:26 -0400
X-MC-Unique: mSCxeT0HPrWtom8qduK5cQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CEF2107B266;
        Tue,  9 Jun 2020 12:23:24 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C715F5D9C9;
        Tue,  9 Jun 2020 12:23:19 +0000 (UTC)
Date:   Tue, 9 Jun 2020 14:23:15 +0200
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Gaurav Singh <gaurav1086@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP (eXpress Data Path)),
        bpf@vger.kernel.org (open list:XDP (eXpress Data Path)),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] bpf: alloc_record_per_cpu Add null check after malloc
Message-ID: <20200609142315.4d131599@carbon>
In-Reply-To: <20200609120804.10569-1-gaurav1086@gmail.com>
References: <20200609120804.10569-1-gaurav1086@gmail.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  9 Jun 2020 08:08:03 -0400
Gaurav Singh <gaurav1086@gmail.com> wrote:

> The memset call is made right after malloc call. To fix this, add the null check right after malloc and then do memset.
> 

Did you read the section about how long lines should be in desc?


> Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
> ---
>  samples/bpf/xdp_rxq_info_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_user.c
> index 4fe47502ebed..490b07b7df78 100644
> --- a/samples/bpf/xdp_rxq_info_user.c
> +++ b/samples/bpf/xdp_rxq_info_user.c
> @@ -202,11 +202,11 @@ static struct datarec *alloc_record_per_cpu(void)
>  
>  	size = sizeof(struct datarec) * nr_cpus;
>  	array = malloc(size);
> -	memset(array, 0, size);
>  	if (!array) {
>  		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
>  		exit(EXIT_FAIL_MEM);
>  	}
> +	memset(array, 0, size);
>  	return array;
>  }

Looking at code, this bug happen in more places. Please fix up all locations.

I think this fix should go through the "bpf" tree.
Please read:
 https://github.com/torvalds/linux/blob/master/Documentation/bpf/bpf_devel_QA.rst

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

