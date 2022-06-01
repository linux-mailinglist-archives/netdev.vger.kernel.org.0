Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88E753A069
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 11:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351034AbiFAJbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 05:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351074AbiFAJbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 05:31:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF8287A15;
        Wed,  1 Jun 2022 02:31:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3C2561525;
        Wed,  1 Jun 2022 09:31:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075FBC385A5;
        Wed,  1 Jun 2022 09:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654075889;
        bh=q4poYj+BRht8GXruvK1w1TZdcsRrzubhd/fGLHHrnnk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=siA+xPQZb10gKzIYyU3EwcK9DwzYXbvARkuuf8KyXKLiIw33gbdSlv0jWxzWWxWyC
         qz1ITlIeOjaO2NEoNkQmGO0cX4KmwC11DX6UkFYP4lNzTDIMh2KlNXmHeAR6C1pKTz
         WCzUMiIfCLMmH43TFzq+osRyDNJpYmFfxLWRfBT2QOoIrNrRJ4UKMRfIdQmlJjgO9z
         YbBb9GinP0eFBWgKOQ1nqJ69RvycfYG1XFfGEX5g8/re/Ftd20f2w0jW8z9Fri700a
         m/p1G9YQxfp2DHnJT9HItFqicCGueOP5xZy0wFkPZOmlBSLWWMlv01rHdoOam8OhZj
         GfukFZRhg/Ypg==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 50B3C4051AD; Wed,  1 Jun 2022 11:25:28 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     weiyongjun1@huawei.com, shaozhengchao@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH v4,bpf-next] samples/bpf: check detach prog exist or not
 in xdp_fwd
In-Reply-To: <20220531121804.194901-1-shaozhengchao@huawei.com>
References: <20220531121804.194901-1-shaozhengchao@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 01 Jun 2022 11:25:28 +0200
Message-ID: <87pmjs7n1z.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

The logic looks good now, just spotted one issue with the use of 'return
errno' (which I just realised I suggested on the last version, sorry
about that).

>  samples/bpf/xdp_fwd_user.c | 62 ++++++++++++++++++++++++++++++++------
>  1 file changed, 53 insertions(+), 9 deletions(-)
>
> diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
> index 1828487bae9a..a4ba53891653 100644
> --- a/samples/bpf/xdp_fwd_user.c
> +++ b/samples/bpf/xdp_fwd_user.c
> @@ -47,17 +47,61 @@ static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
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
> +		return -errno;

The printf above may override errno, so this could return 0; the actual
return value is not really used by the caller, so you could just always
'return -1' or 'return err'.

> +	}
> +
> +	if (!curr_prog_id) {
> +		printf("ERROR: flags(0x%x) xdp prog is not attached to %s\n",
> +		       xdp_flags, ifname);
> +		goto err_out;

Doesn't really need a label, just do a direct return here as well.

> +	}
>  
> -	err = bpf_xdp_detach(idx, xdp_flags, NULL);
> -	if (err < 0)
> -		printf("ERROR: failed to detach program from %s\n", name);
> +	info_len = sizeof(prog_info);
> +	prog_fd = bpf_prog_get_fd_by_id(curr_prog_id);
> +	if (prog_fd < 0) {
> +		printf("ERROR: bpf_prog_get_fd_by_id failed (%s)\n",
> +		       strerror(errno));
> +		return -errno;

Same issue as above with errno being overwritten.

> +	}
> +
> +	err = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &info_len);
> +	if (err) {
> +		printf("ERROR: bpf_obj_get_info_by_fd failed (%s)\n",
> +		       strerror(errno));
> +		goto close_out;
> +	}
> +	snprintf(prog_name, sizeof(prog_name), "%s_prog", app_name);
> +	prog_name[BPF_OBJ_NAME_LEN - 1] = '\0';
> +
> +	if (strcmp(prog_info.name, prog_name)) {
> +		printf("ERROR: %s isn't attached to %s\n", app_name, ifname);
> +		err = 1;
> +	} else {

You can save a level of indentation by adding a 'goto close_out' after
'err=1' instead of using an 'else' block.

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
> +close_out:
> +	close(prog_fd);
> +err_out:

don't need the err_out label, see above.

-Toke
