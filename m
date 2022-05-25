Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30462533B89
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 13:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242731AbiEYLPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 07:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242942AbiEYLPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 07:15:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF1294192;
        Wed, 25 May 2022 04:15:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0288FB81CA3;
        Wed, 25 May 2022 11:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E18DC385B8;
        Wed, 25 May 2022 11:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653477330;
        bh=MsdbkVlYtrgkT4W07at59fEGoLNJC4CRitFwyTCa1hI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=TfskDXstcbI3M0FA3iakW6qeBj5kPi8k0M7qG1bgJwNqUng53JPtiwwZsZUEpngxB
         oDI/kPfGO01mDzCW7sB1g6tEuwU83ZZX2H7lGRaIw9bYIXoR06bIriKeWnHGRBGI36
         zEa41fjh7rZs6gMvSx7+nM1sPMnhENCvRFcb/dGOwl1oHmTVtxCY4UZmuflsFDMDfc
         uW0hA+8yZfmxwmrYmGBaEQtu4CYkeP10YNuCLbGzqjdExerbkGsvB43gnwdGpoPohI
         vcFdWEEyep5tvUzReMHx7pHDur5DZrGflSJ25Rw2ZGLcw7InVlemJTAdGg62Qbcyn2
         oZ3pfdKREgoSw==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1845D3DED4A; Wed, 25 May 2022 13:15:28 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     weiyongjun1@huawei.com, shaozhengchao@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH v3,bpf-next] samples/bpf: check detach prog exist or not
 in xdp_fwd
In-Reply-To: <20220521043509.389007-1-shaozhengchao@huawei.com>
References: <20220521043509.389007-1-shaozhengchao@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 25 May 2022 13:15:28 +0200
Message-ID: <87o7zloobz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> writes:

> Before detach the prog, we should check detach prog exist or not.
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  samples/bpf/xdp_fwd_user.c | 59 ++++++++++++++++++++++++++++++++------
>  1 file changed, 50 insertions(+), 9 deletions(-)
>
> diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
> index 1828487bae9a..03a50f64e99a 100644
> --- a/samples/bpf/xdp_fwd_user.c
> +++ b/samples/bpf/xdp_fwd_user.c
> @@ -47,17 +47,58 @@ static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
>  	return err;
>  }
>  
> -static int do_detach(int idx, const char *name)
> +static int do_detach(int ifindex, const char *ifname, const char *app_name)
>  {
> -	int err;
> +	LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
> +	struct bpf_prog_info prog_info = {};
> +	char prog_name[BPF_OBJ_NAME_LEN];
> +	__u32 info_len, curr_prog_id;
> +	int prog_fd;
> +	int err = 1;
> +
> +	if (bpf_xdp_query_id(ifindex, xdp_flags, &curr_prog_id)) {
> +		printf("ERROR: bpf_xdp_query_id failed (%s)\n",
> +		       strerror(errno));
> +		return err;
> +	}
> +
> +	if (!curr_prog_id) {
> +		printf("ERROR: flags(0x%x) xdp prog is not attached to %s\n",
> +		       xdp_flags, ifname);
> +		return err;
> +	}
>  
> -	err = bpf_xdp_detach(idx, xdp_flags, NULL);
> -	if (err < 0)
> -		printf("ERROR: failed to detach program from %s\n", name);
> +	info_len = sizeof(prog_info);
> +	prog_fd = bpf_prog_get_fd_by_id(curr_prog_id);

This fd is never closed again; you'll need to replace the 'return err'
statement below with a 'goto err' and add a label at the end that closes
the fd before returning - see comments below.

> +	if (prog_fd < 0) {
> +		printf("ERROR: bpf_prog_get_fd_by_id failed (%s)\n",
> +		       strerror(errno));
> +		return err;

err is not actually set here; you could either 'return prog_fd' or
'return -errno'.

> +	}
> +
> +	err = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &info_len);
> +	if (err) {
> +		printf("ERROR: bpf_obj_get_info_by_fd failed (%s)\n",
> +		       strerror(errno));
> +		return err;

make this 'goto err'...
> +	}
> +	snprintf(prog_name, sizeof(prog_name), "%s_prog", app_name);
> +	prog_name[BPF_OBJ_NAME_LEN - 1] = '\0';
> +
> +	if (strcmp(prog_info.name, prog_name)) {
> +		printf("ERROR: %s isn't attached to %s\n", app_name, ifname);
> +		err = 1;
> +	} else {
> +		opts.old_prog_fd = prog_fd;
> +		err = bpf_xdp_detach(ifindex, xdp_flags, &opts);
> +		if (err < 0)
> +			printf("ERROR: failed to detach program from %s (%s)\n",
> +			       ifname, strerror(errno));
> +		/* TODO: Remember to cleanup map, when adding use of shared map
> +		 *  bpf_map_delete_elem((map_fd, &idx);
> +		 */
> +	}
>  
> -	/* TODO: Remember to cleanup map, when adding use of shared map
> -	 *  bpf_map_delete_elem((map_fd, &idx);
> -	 */
...and add something like:

err:
        close(prog_fd);
>  	return err;
>  }
>  
> @@ -169,7 +210,7 @@ int main(int argc, char **argv)
>  			return 1;
>  		}
>  		if (!attach) {
> -			err = do_detach(idx, argv[i]);
> +			err = do_detach(idx, argv[i], prog_name);
>  			if (err)
>  				ret = err;
>  		} else {
> -- 
> 2.17.1
