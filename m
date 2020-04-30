Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081581BFE23
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgD3O0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:26:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:45862 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgD3O0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 10:26:32 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jUA8v-0008Np-49; Thu, 30 Apr 2020 16:26:25 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jUA8u-000XNU-Nn; Thu, 30 Apr 2020 16:26:24 +0200
Subject: Re: [PATCH -next] bpf: fix error return code in
 map_lookup_and_delete_elem()
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Mauricio Vasquez B <mauricio.vasquez@polito.it>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20200430081851.166996-1-weiyongjun1@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5813e11c-9aba-8273-e935-1ddb5a3f9b47@iogearbox.net>
Date:   Thu, 30 Apr 2020 16:26:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200430081851.166996-1-weiyongjun1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25798/Thu Apr 30 14:03:33 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 10:18 AM, Wei Yongjun wrote:
> Fix to return negative error code -EFAULT from the copy_to_user() error
> handling case instead of 0, as done elsewhere in this function.
> 
> Fixes: bd513cd08f10 ("bpf: add MAP_LOOKUP_AND_DELETE_ELEM syscall")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   kernel/bpf/syscall.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 3cea7602de78..68c22e9420fa 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1492,8 +1492,10 @@ static int map_lookup_and_delete_elem(union bpf_attr *attr)
>   	if (err)
>   		goto free_value;
>   
> -	if (copy_to_user(uvalue, value, value_size) != 0)
> +	if (copy_to_user(uvalue, value, value_size) != 0) {
> +		err = -EFAULT;
>   		goto free_value;
> +	}
>   

Good catch! Applied to bpf, thanks!
