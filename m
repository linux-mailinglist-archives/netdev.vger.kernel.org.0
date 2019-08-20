Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A96E89603A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 15:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfHTNgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 09:36:52 -0400
Received: from www62.your-server.de ([213.133.104.62]:48650 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbfHTNgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 09:36:52 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i04Jd-0000lu-Ho; Tue, 20 Aug 2019 15:36:49 +0200
Received: from [178.197.249.40] (helo=pc-63.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i04Jd-000MPw-8g; Tue, 20 Aug 2019 15:36:49 +0200
Subject: Re: [PATCH bpf-next] bpf: add BTF ids in procfs for file descriptors
 to BTF objects
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com
References: <20190820095233.17097-1-quentin.monnet@netronome.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fcb2e528-6750-2192-befe-dd68ca36fc62@iogearbox.net>
Date:   Tue, 20 Aug 2019 15:36:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190820095233.17097-1-quentin.monnet@netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25547/Tue Aug 20 10:27:49 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/19 11:52 AM, Quentin Monnet wrote:
> Implement the show_fdinfo hook for BTF FDs file operations, and make it
> print the id and the size of the BTF object. This allows for a quick
> retrieval of the BTF id from its FD; or it can help understanding what
> type of object (BTF) the file descriptor points to.
> 
> Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
>   kernel/bpf/btf.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 5fcc7a17eb5a..39e184f1b27c 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3376,6 +3376,19 @@ void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
>   	btf_type_ops(t)->seq_show(btf, t, type_id, obj, 0, m);
>   }
>   
> +#ifdef CONFIG_PROC_FS
> +static void bpf_btf_show_fdinfo(struct seq_file *m, struct file *filp)
> +{
> +	const struct btf *btf = filp->private_data;
> +
> +	seq_printf(m,
> +		   "btf_id:\t%u\n"
> +		   "data_size:\t%u\n",
> +		   btf->id,
> +		   btf->data_size);

Looks good, exposing btf_id makes sense to me in order to correlate with applications.
Do you have a concrete use case for data_size to expose it this way as opposed to fetch
it via btf_get_info_by_fd()? If not, I'd say lets only add btf_id in there.

> +}
> +#endif
> +
>   static int btf_release(struct inode *inode, struct file *filp)
>   {
>   	btf_put(filp->private_data);
> @@ -3383,6 +3396,9 @@ static int btf_release(struct inode *inode, struct file *filp)
>   }
>   
>   const struct file_operations btf_fops = {
> +#ifdef CONFIG_PROC_FS
> +	.show_fdinfo	= bpf_btf_show_fdinfo,
> +#endif
>   	.release	= btf_release,
>   };
>   
> 

Thanks,
Daniel
