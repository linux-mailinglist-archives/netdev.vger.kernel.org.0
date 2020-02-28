Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B4217380B
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgB1NPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:15:33 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52528 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725796AbgB1NPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:15:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582895732;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zDwjiDI4UEV491J7uFvApxtZY76EKo/ZT1+xx/9jw44=;
        b=Urou0e5pIRVW5o/gheLhR4e/zhHDLkAfXpbXH4scjlD/orB/6olcA1zbFdq/JTMa9WlEZH
        04zGCMMHpQIrijV9T3b47H7UsFL3/YhuvCOgt1SkaMjswdGUDE+Dh8Grr33+PN1A7RMI8d
        1EKilxr7KDqMYKieoAVKSafj47B0Kf8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-4fictPBnMTuzwITIDL0sww-1; Fri, 28 Feb 2020 08:15:30 -0500
X-MC-Unique: 4fictPBnMTuzwITIDL0sww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16D93107ACC7;
        Fri, 28 Feb 2020 13:15:28 +0000 (UTC)
Received: from sandy.ghostprotocols.net (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A84AB90F5B;
        Fri, 28 Feb 2020 13:15:26 +0000 (UTC)
Received: by sandy.ghostprotocols.net (Postfix, from userid 1000)
        id 91A3B4AC9; Fri, 28 Feb 2020 10:15:23 -0300 (BRT)
Date:   Fri, 28 Feb 2020 10:15:23 -0300
From:   Arnaldo Carvalho de Melo <acme@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 17/18] perf tools: Set ksymbol dso as loaded on arrival
Message-ID: <20200228131523.GB4010@redhat.com>
References: <20200226130345.209469-1-jolsa@kernel.org>
 <20200226130345.209469-18-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226130345.209469-18-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Feb 26, 2020 at 02:03:44PM +0100, Jiri Olsa escreveu:
> There's no special load action for ksymbol data on
> map__load/dso__load action, where the kernel is getting
> loaded. It only gets confused with kernel kallsyms/vmlinux
> load for bpf object, which fails and could mess up with
> the map.
> 
> Disabling any further load of the map for ksymbol related dso/map.

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/machine.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index fb5c2cd44d30..463ada5117f8 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -742,6 +742,7 @@ static int machine__process_ksymbol_register(struct machine *machine,
>  		map->start = event->ksymbol.addr;
>  		map->end = map->start + event->ksymbol.len;
>  		maps__insert(&machine->kmaps, map);
> +		dso__set_loaded(dso);
>  	}
>  
>  	sym = symbol__new(map->map_ip(map, map->start),
> -- 
> 2.24.1

