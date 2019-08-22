Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B882998E82
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 10:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732015AbfHVI6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 04:58:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:48740 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731589AbfHVI6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 04:58:37 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0ivI-0000Ci-4d; Thu, 22 Aug 2019 10:58:24 +0200
Received: from [178.197.249.40] (helo=pc-63.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i0ivH-000AIc-Ig; Thu, 22 Aug 2019 10:58:23 +0200
Subject: Re: [RFC bpf-next 4/5] iproute2: Allow compiling against libbpf
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        andrii.nakryiko@gmail.com
References: <20190820114706.18546-1-toke@redhat.com>
 <20190820114706.18546-5-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9de36bbf-b70d-9320-c686-3033d0408276@iogearbox.net>
Date:   Thu, 22 Aug 2019 10:58:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190820114706.18546-5-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25548/Wed Aug 21 10:27:18 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/19 1:47 PM, Toke Høiland-Jørgensen wrote:
> This adds a configure check for libbpf and renames functions to allow
> lib/bpf.c to be compiled with it present. This makes it possible to
> port functionality piecemeal to use libbpf.
> 
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>   configure          | 16 ++++++++++++++++
>   include/bpf_util.h |  6 +++---
>   ip/ipvrf.c         |  4 ++--
>   lib/bpf.c          | 33 +++++++++++++++++++--------------
>   4 files changed, 40 insertions(+), 19 deletions(-)
> 
> diff --git a/configure b/configure
> index 45fcffb6..5a89ee9f 100755
> --- a/configure
> +++ b/configure
> @@ -238,6 +238,19 @@ check_elf()
>       fi
>   }
>   
> +check_libbpf()
> +{
> +    if ${PKG_CONFIG} libbpf --exists; then
> +	echo "HAVE_LIBBPF:=y" >>$CONFIG
> +	echo "yes"
> +
> +	echo 'CFLAGS += -DHAVE_LIBBPF' `${PKG_CONFIG} libbpf --cflags` >> $CONFIG
> +	echo 'LDLIBS += ' `${PKG_CONFIG} libbpf --libs` >>$CONFIG
> +    else
> +	echo "no"
> +    fi
> +}
> +
>   check_selinux()

More of an implementation detail at this point in time, but want to make sure this
doesn't get missed along the way: as discussed at bpfconf [0] best for iproute2 to
handle libbpf support would be the same way of integration as pahole does, that is,
to integrate it via submodule [1] to allow kernel and libbpf features to be in sync
with iproute2 releases and therefore easily consume extensions we're adding to libbpf
to aide iproute2 integration.

Thanks,
Daniel

   [0] http://vger.kernel.org/bpfconf2019.html#session-4
   [1] https://git.kernel.org/pub/scm/devel/pahole/pahole.git/commit/?id=21507cd3e97bc5692d97201ee68df044c6767e9a
