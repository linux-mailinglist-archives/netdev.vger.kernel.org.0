Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E989F197ADA
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 13:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbgC3LfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 07:35:09 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:28505 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729915AbgC3LfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 07:35:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585568102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/yKFIjqFad0brG+IqtxaXWXaU5bUtQPPGHJ+K52Qhck=;
        b=HowYcfq/dkDcdTcuiriO5m4mcOPyXGxmUotU84SAethaJYG3T2m9Qt1S4BvswPmmglicIY
        DCL307YwQB9gEXLtvDZoufid0bNwEct2/MrxCn4IvIurI491CYhImNL+Nd6A+gFDwt/PQ+
        bpuvfFu3yh7yqe85SdAYcIBnu4SzMus=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-qZAMEnE7NK6C_EuYeAOraQ-1; Mon, 30 Mar 2020 07:34:56 -0400
X-MC-Unique: qZAMEnE7NK6C_EuYeAOraQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 711B7107ACC7;
        Mon, 30 Mar 2020 11:34:53 +0000 (UTC)
Received: from carbon (unknown [10.40.208.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41E9B100EBAD;
        Mon, 30 Mar 2020 11:34:46 +0000 (UTC)
Date:   Mon, 30 Mar 2020 13:34:42 +0200
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
To:     Mao Wenan <maowenan@huawei.com>
Cc:     <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <jwi@linux.ibm.com>,
        <toshiaki.makita1@gmail.com>, <jianglidong3@jd.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH net] veth: xdp: use head instead of hard_start
Message-ID: <20200330133442.132bde0c@carbon>
In-Reply-To: <20200330102631.31286-1-maowenan@huawei.com>
References: <20200330102631.31286-1-maowenan@huawei.com>
Organization: Red Hat Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Mar 2020 18:26:31 +0800
Mao Wenan <maowenan@huawei.com> wrote:

> xdp.data_hard_start is mapped to the first
> address of xdp_frame, but the pointer hard_start
> is the offset(sizeof(struct xdp_frame)) of xdp_frame,
> it should use head instead of hard_start to
> set xdp.data_hard_start. Otherwise, if BPF program
> calls helper_function such as bpf_xdp_adjust_head, it
> will be confused for xdp_frame_end.

I have noticed this[1] and have a patch in my current patchset for
fixing this.  IMHO is is not so important fix right now, as the effect
is that you currently only lose 32 bytes of headroom.

[1] https://lore.kernel.org/netdev/158446621887.702578.17234304084556809684.stgit@firesoul/

Fixing this now is going to be annoying and cause merge conflicts for
my patchset.  If you insist on fixing this now, you need to improve
commit message and also fix patch, see below.

> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  drivers/net/veth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index d4cbb9e8c63f..5ea550884bf8 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -506,7 +506,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
>  		struct xdp_buff xdp;
>  		u32 act;
>  
> -		xdp.data_hard_start = hard_start;
> +		xdp.data_hard_start = head;

You also need update/remove the other lines doing this.

>  		xdp.data = frame->data;
>  		xdp.data_end = frame->data + frame->len;
>  		xdp.data_meta = frame->data - frame->metasize;



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

