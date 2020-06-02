Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501E01EB6D0
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 09:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgFBHxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 03:53:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30767 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725835AbgFBHxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 03:53:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591084396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9fXPh1Sc70qevQYVJkCzgdC36xMAEASZNp7tv9X5TZ0=;
        b=Yxdxx1Kra5F8zM1Zvza9/fWW8ZLNCh0vHkHB4cbycRGI+O0H9JhthG6FHmoSjPA5iGi/JK
        7gltpe53WnFDJDApKNqkX2NW671rcKQ3147NvIQ9OecACbdTe38jTjuGRRNezGiBJGzI8e
        B+QgZFPYeTTYxEUPk8QorLLovazXRjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-D6Cl2oSjMqCzW72UuhGHAw-1; Tue, 02 Jun 2020 03:53:14 -0400
X-MC-Unique: D6Cl2oSjMqCzW72UuhGHAw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32F38100CD40;
        Tue,  2 Jun 2020 07:53:13 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0410119C79;
        Tue,  2 Jun 2020 07:53:01 +0000 (UTC)
Date:   Tue, 2 Jun 2020 09:53:00 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, toke@redhat.com, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org, brouer@redhat.com
Subject: Re: [PATCH bpf-next 4/6] bpf: cpumap: add the possibility to attach
 an eBPF program to cpumap
Message-ID: <20200602095300.486ae35c@carbon>
In-Reply-To: <2543519aa9cdb368504cb6043fad6cae6f6ec745.1590960613.git.lorenzo@kernel.org>
References: <cover.1590960613.git.lorenzo@kernel.org>
        <2543519aa9cdb368504cb6043fad6cae6f6ec745.1590960613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 May 2020 23:46:49 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
> index 57402276d8af..24ab0a6b9772 100644
> --- a/kernel/bpf/cpumap.c
> +++ b/kernel/bpf/cpumap.c
> @@ -51,6 +51,10 @@ struct xdp_bulk_queue {
>  /* CPUMAP value */
>  struct bpf_cpumap_val {
>  	u32 qsize;	/* queue size */
> +	union {
> +		int fd;	/* program file descriptor */
> +		u32 id;	/* program id */
> +	} prog;
>  };
  
Please name the union 'bpf_prog' and not 'prog'.
We should match what David Ahern did for devmap.

Even-though we are NOT exposing this in the UAPI header-file, this still
becomes a UAPI interface (actually kABI).  The struct member names are
still important, even-though this is a binary layout, because the BTF
info is basically documenting this API.

Notice when kernel is compiled with BTF info, you (or end-user) can use
pahole to "reverse" the struct layout (comments don't survive, so we
need descriptive member names):

$ pahole bpf_devmap_val
struct bpf_devmap_val {
	__u32                      ifindex;              /*     0     4 */
	union {
		int                fd;                   /*     4     4 */
		__u32              id;                   /*     4     4 */
	} bpf_prog;                                      /*     4     4 */
	struct {
		unsigned char      data[24];             /*     8    24 */
	} storage;                                       /*     8    24 */

	/* size: 32, cachelines: 1, members: 3 */
	/* last cacheline: 32 bytes */
};

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer


$ bpftool btf dump file /sys/kernel/btf/vmlinux format c | grep -A10 'struct bpf_devmap_val {'
struct bpf_devmap_val {
	__u32 ifindex;
	union {
		int fd;
		__u32 id;
	} bpf_prog;
	struct {
		unsigned char data[24];
	} storage;
};

