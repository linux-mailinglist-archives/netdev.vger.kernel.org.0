Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0143D52A235
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 14:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346567AbiEQM5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 08:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbiEQM5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 08:57:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29273C70B;
        Tue, 17 May 2022 05:57:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1070B8187F;
        Tue, 17 May 2022 12:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F19DC34113;
        Tue, 17 May 2022 12:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652792235;
        bh=IlTqF9xbixgS80kjZ5i3ygHg1P4Ovvouhn3bcvuv1sY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=UkI3ZVQrwGL42WAhfAYCrgQUj3szOBRzKGGqLOLUTdZWWjVHtbXjONSSW5a6myelv
         jufpLCBzKA28Eahta47EjXLGKyR30vmyvnE+7T/o+DAjiDpohSU0WprT8rDBgyvmJ2
         j7Vjm8H8UVdeBz9AqMxNbHd4x6DktefIhvbfDTcWRoYBm2JDSxfrcXrZKaEbs1NnBq
         1qFTp2/hJU9WaUGhHujoPJDA06ByAv2291SbJgMH8x7zc6SFMND4x+gzwMYHJK5J8O
         FCrzeX9N2Hys0811KNFWnyaBJp22X6RtVeCBpqIot+3Y5h/sBYyw2v9n06LcTQskCR
         j+knIXEfGac9g==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A904638E985; Tue, 17 May 2022 14:57:11 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     weiyongjun1@huawei.com, shaozhengchao@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH v2,bpf-next] samples/bpf: check detach prog exist or not
 in xdp_fwd
In-Reply-To: <20220517112748.358295-1-shaozhengchao@huawei.com>
References: <20220517112748.358295-1-shaozhengchao@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 17 May 2022 14:57:11 +0200
Message-ID: <87tu9ob9lk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
>  samples/bpf/xdp_fwd_user.c | 52 +++++++++++++++++++++++++++++++-------
>  1 file changed, 43 insertions(+), 9 deletions(-)
>
> diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
> index 1828487bae9a..2294486ef10a 100644
> --- a/samples/bpf/xdp_fwd_user.c
> +++ b/samples/bpf/xdp_fwd_user.c
> @@ -47,17 +47,51 @@ static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
>  	return err;
>  }
>  
> -static int do_detach(int idx, const char *name)
> +static int do_detach(int idx, const char *name, const char *prog_name)

two 'name' arguments is a bit confusing; could we rename the parameters
to 'ifindex', 'ifname' and 'app_name', then use 'prog_name' for the
stack variable below instead of 'namepad'?

>  {
> -	int err;
> +	int err = 1;
> +	__u32 info_len, curr_prog_id;
> +	struct bpf_prog_info prog_info = {};
> +	int prog_fd;
> +	char namepad[BPF_OBJ_NAME_LEN];

Reverse x-mas tree, please.

> +
> +	if (bpf_xdp_query_id(idx, xdp_flags, &curr_prog_id)) {
> +		printf("ERROR: bpf_xdp_query_id failed\n");

strerror(errno) might be nice to add to the error message, so users have
an inkling as to why the call is failing (same below).

> +		return err;
> +	}
> +
> +	if (!curr_prog_id) {
> +		printf("ERROR: flags(0x%x) xdp prog is not attached to %s\n",
> +			xdp_flags, name);
> +		return err;
> +	}
>  
> -	err = bpf_xdp_detach(idx, xdp_flags, NULL);
> -	if (err < 0)
> -		printf("ERROR: failed to detach program from %s\n", name);
> +	info_len = sizeof(prog_info);
> +	prog_fd = bpf_prog_get_fd_by_id(curr_prog_id);
> +	if (prog_fd < 0 && errno == ENOENT) {

Why the ENOENT check? This should error out regardless of the errno, no?

> +		printf("ERROR: bpf_prog_get_fd_by_id failed\n");

strerror(errno)

> +		return err;
> +	}
> +
> +	err = bpf_obj_get_info_by_fd(prog_fd, &prog_info, &info_len);
> +	if (err) {
> +		printf("ERROR: bpf_obj_get_info_by_fd failed\n");

strerror(errno)

> +		return err;
> +	}
> +	snprintf(namepad, sizeof(namepad), "%s_prog", prog_name);

If the binary somehow gets renamed, this may overflow and you'll end up
without a NULL byte terminating the string. So either check the input
length first, or make sure to set the last byte to '\0' after this
call...

> +
> +	if (strcmp(prog_info.name, namepad)) {
> +		printf("ERROR: %s isn't attached to %s\n", prog_name, name);
> +	} else {
> +		err = bpf_xdp_detach(idx, xdp_flags, NULL);

This call should be including an opts struct with the fd obtained above
as the old_prog_fd (so make sure it wasn't swapped out since the check).

> +		if (err < 0)
> +			printf("ERROR: failed to detach program from %s\n",
> +				name);

strerror(errno)

-Toke
