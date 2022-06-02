Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CD053B576
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 10:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbiFBIza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 04:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiFBIz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 04:55:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8273929C107;
        Thu,  2 Jun 2022 01:55:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14A8EB81EFC;
        Thu,  2 Jun 2022 08:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBC5C385A5;
        Thu,  2 Jun 2022 08:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654160125;
        bh=r78DM0Wp+cO4uP5J+DDcSdxZzpS4QO/M9XYiEnYZJd8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=HkN82rYCiYxiTa4GlCFcPgghdGCvF1ItoParmyyYidK2QTEsvMOqiV653dpSAFbHD
         mxtGG2oH91TIGW/ZvbTKqUdU/LUbMc1AKpzkjpYurILBDLJeOLj8PxMzMvoKn2q/CI
         2MR7w7DIzil6spbOIWPQs6PfC4z7EVSFpGUiQvFnsi+sIwEK8x34l4coGMGMHctmi2
         ph0pMPK8h1+ZhjxAKz4j+Cq2hZO3dZzjup4ny297kAbryFuOhq90/LTCrkc4DeDYSW
         5I+uh+ClobcJAG4Kvx9avtxOuYGhTfLw4JTbT0IK5mdYyoiWhp3VlvIsTTmvtQT/6S
         Cz3Wt5ziLfSxw==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C0E30405243; Thu,  2 Jun 2022 10:55:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     weiyongjun1@huawei.com, shaozhengchao@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH v5,bpf-next] samples/bpf: check detach prog exist or not
 in xdp_fwd
In-Reply-To: <20220602011915.264431-1-shaozhengchao@huawei.com>
References: <20220602011915.264431-1-shaozhengchao@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 02 Jun 2022 10:55:20 +0200
Message-ID: <87v8tjsavb.fsf@toke.dk>
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

You missed one 'return errno', see below:

> ---
>  samples/bpf/xdp_fwd_user.c | 55 +++++++++++++++++++++++++++++++++-----
>  1 file changed, 49 insertions(+), 6 deletions(-)
>
> diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
> index 1828487bae9a..d321e6aa9364 100644
> --- a/samples/bpf/xdp_fwd_user.c
> +++ b/samples/bpf/xdp_fwd_user.c
> @@ -47,17 +47,60 @@ static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
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
>  
> -	err = bpf_xdp_detach(idx, xdp_flags, NULL);
> -	if (err < 0)
> -		printf("ERROR: failed to detach program from %s\n", name);
> +	if (!curr_prog_id) {
> +		printf("ERROR: flags(0x%x) xdp prog is not attached to %s\n",
> +		       xdp_flags, ifname);
> +		return err;
> +	}
>  
> +	info_len = sizeof(prog_info);
> +	prog_fd = bpf_prog_get_fd_by_id(curr_prog_id);
> +	if (prog_fd < 0) {
> +		printf("ERROR: bpf_prog_get_fd_by_id failed (%s)\n",
> +		       strerror(errno));
> +		return errno;

This should just be 'return prog_fd' to propagate the error...

-Toke
