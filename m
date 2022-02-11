Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E594B2613
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350251AbiBKMn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:43:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234600AbiBKMn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:43:58 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D2FF75;
        Fri, 11 Feb 2022 04:43:57 -0800 (PST)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIVHC-000A3Z-Hc; Fri, 11 Feb 2022 13:43:50 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nIVHC-000Mo3-8S; Fri, 11 Feb 2022 13:43:50 +0100
Subject: Re: [PATCH 1/4] bpf: Add pin_name into struct bpf_prog_aux
To:     Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220211121145.35237-1-laoar.shao@gmail.com>
 <20220211121145.35237-2-laoar.shao@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <9db9fcb9-69de-5fb5-c80a-ade5f36ea039@iogearbox.net>
Date:   Fri, 11 Feb 2022 13:43:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220211121145.35237-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26450/Fri Feb 11 10:24:09 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/22 1:11 PM, Yafang Shao wrote:
> A new member pin_name is added into struct bpf_prog_aux, which will be
> set when the prog is set and cleared when the pinned file is removed.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>   include/linux/bpf.h      |  2 ++
>   include/uapi/linux/bpf.h |  1 +
>   kernel/bpf/inode.c       | 20 +++++++++++++++++++-
>   3 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 0ceb25b..9cf8055 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -933,6 +933,8 @@ struct bpf_prog_aux {
>   		struct work_struct work;
>   		struct rcu_head	rcu;
>   	};
> +
> +	char pin_name[BPF_PIN_NAME_LEN];
>   };

I'm afraid this is not possible. You are assuming a 1:1 relationship between prog
and pin location, but it's really a 1:n (prog can be pinned in multiple locations
and also across multiple mount instances). Also, you can create hard links of pins
which are not handled via bpf_obj_do_pin().

>   struct bpf_array_aux {
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c14fed8..bada5cc 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1217,6 +1217,7 @@ struct bpf_stack_build_id {
>   };
>   
>   #define BPF_OBJ_NAME_LEN 16U
> +#define BPF_PIN_NAME_LEN 64U
>   
>   union bpf_attr {
>   	struct { /* anonymous struct used by BPF_MAP_CREATE command */
> diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> index 4477ca8..f1a8811 100644
> --- a/kernel/bpf/inode.c
> +++ b/kernel/bpf/inode.c
> @@ -437,6 +437,8 @@ static int bpf_iter_link_pin_kernel(struct dentry *parent,
>   static int bpf_obj_do_pin(const char __user *pathname, void *raw,
>   			  enum bpf_type type)
>   {
> +	struct bpf_prog_aux *aux;
> +	struct bpf_prog *prog;
>   	struct dentry *dentry;
>   	struct inode *dir;
>   	struct path path;
> @@ -461,6 +463,10 @@ static int bpf_obj_do_pin(const char __user *pathname, void *raw,
>   
>   	switch (type) {
>   	case BPF_TYPE_PROG:
> +		prog = raw;
> +		aux = prog->aux;
> +		(void) strncpy_from_user(aux->pin_name, pathname, BPF_PIN_NAME_LEN);
> +		aux->pin_name[BPF_PIN_NAME_LEN - 1] = '\0';
>   		ret = vfs_mkobj(dentry, mode, bpf_mkprog, raw);
>   		break;
>   	case BPF_TYPE_MAP:
> @@ -611,12 +617,24 @@ static int bpf_show_options(struct seq_file *m, struct dentry *root)
>   
>   static void bpf_free_inode(struct inode *inode)
>   {
> +	struct bpf_prog_aux *aux;
> +	struct bpf_prog *prog;
>   	enum bpf_type type;
>   
>   	if (S_ISLNK(inode->i_mode))
>   		kfree(inode->i_link);
> -	if (!bpf_inode_type(inode, &type))
> +	if (!bpf_inode_type(inode, &type)) {
> +		switch (type) {
> +		case BPF_TYPE_PROG:
> +			prog = inode->i_private;
> +			aux = prog->aux;
> +			aux->pin_name[0] = '\0';
> +			break;
> +		default:
> +			break;
> +		}
>   		bpf_any_put(inode->i_private, type);
> +	}
>   	free_inode_nonrcu(inode);
>   }
>   
> 

