Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2400C5E1FE
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 12:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfGCKXK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 06:23:10 -0400
Received: from www62.your-server.de ([213.133.104.62]:57778 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGCKXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 06:23:10 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hicPq-0001hf-Lz; Wed, 03 Jul 2019 12:23:06 +0200
Received: from [2a02:1205:5054:6d70:b45c:ec96:516a:e956] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hicPq-000T17-ES; Wed, 03 Jul 2019 12:23:06 +0200
Subject: Re: [PATCH] bpf, libbpf: Smatch: Fix potential NULL pointer
 dereference
To:     Leo Yan <leo.yan@linaro.org>, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20190702102531.23512-1-leo.yan@linaro.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b834fba1-5b2c-4406-8275-1cf8383655e3@iogearbox.net>
Date:   Wed, 3 Jul 2019 12:23:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190702102531.23512-1-leo.yan@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25499/Wed Jul  3 10:03:10 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2019 12:25 PM, Leo Yan wrote:
> Based on the following report from Smatch, fix the potential
> NULL pointer dereference check.
> 
>   tools/lib/bpf/libbpf.c:3493
>   bpf_prog_load_xattr() warn: variable dereferenced before check 'attr'
>   (see line 3483)
> 
> 3479 int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
> 3480                         struct bpf_object **pobj, int *prog_fd)
> 3481 {
> 3482         struct bpf_object_open_attr open_attr = {
> 3483                 .file           = attr->file,
> 3484                 .prog_type      = attr->prog_type,
>                                        ^^^^^^
> 3485         };
> 
> At the head of function, it directly access 'attr' without checking if
> it's NULL pointer.  This patch moves the values assignment after
> validating 'attr' and 'attr->file'.
> 
> Signed-off-by: Leo Yan <leo.yan@linaro.org>
> ---
>  tools/lib/bpf/libbpf.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 197b574406b3..809b633fa3d9 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3479,10 +3479,7 @@ int bpf_prog_load(const char *file, enum bpf_prog_type type,
>  int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
>  			struct bpf_object **pobj, int *prog_fd)
>  {
> -	struct bpf_object_open_attr open_attr = {
> -		.file		= attr->file,
> -		.prog_type	= attr->prog_type,
> -	};

Applied, thanks! Fyi, I retained the zeroing of open_attr as otherwise if we ever
extend struct bpf_object_open_attr in future, we'll easily miss this and pass in
garbage to bpf_object__open_xattr().
