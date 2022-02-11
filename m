Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0A74B318B
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353918AbiBKXzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:55:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244501AbiBKXzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:55:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265F4D57;
        Fri, 11 Feb 2022 15:55:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9072B823AC;
        Fri, 11 Feb 2022 23:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2744EC340E9;
        Fri, 11 Feb 2022 23:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644623698;
        bh=i3EIrcFRguUXkqO7NnUo44bcQNMcHfq5i1j7dhUK3BE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T2u4mUJRSHXvmISE7SHPptFnL0d5aMWT0gGipehf5HypFRpseXdYhlVpAIF8YR0b1
         Op5DeQ1e5++DotOGzJuHz+MfCNY/2ZJ8/UW6UHOektdMWRIw+0fV0X4htmQtweiUdF
         xNQ0rnbjQ/FQ50MztmKPGpjvCJ+Lw2y/5M8dYP6ghUlha12V1xWYulpdEdEFVVSqLg
         09oPlGeN81wvUlgbAN5RmY94dvNnfPwsGQ1+e7rJdP+3JKa1VSUtp4vWeyVu6Bq8YU
         n6vETtJYIqCmooBtpGN+EuG8l0lBarcqcfOJYOyMXv8ju/jWV+B1MXd7qSqPlpvH/O
         obXy3VjzS6vgg==
Date:   Fri, 11 Feb 2022 15:54:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kernel-team@fb.com>,
        <sfr@canb.auug.org.au>
Subject: Re: [PATCH bpf-next] bpf: fix bpf_prog_pack build for
 ppc64_defconfig
Message-ID: <20220211155456.0195575a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211014915.2403508-1-song@kernel.org>
References: <20220211014915.2403508-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 17:49:15 -0800 Song Liu wrote:
> bpf_prog_pack causes build error with powerpc ppc64_defconfig:
> 
> kernel/bpf/core.c:830:23: error: variably modified 'bitmap' at file scope
>   830 |         unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
>       |                       ^~~~~~

No idea what this error means but...

> Fix it by turning bitmap into a 0-length array.
> 
> Fixes: 57631054fae6 ("bpf: Introduce bpf_prog_pack allocator")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  kernel/bpf/core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index 42d96549a804..44623c9b5bb1 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -827,7 +827,7 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>  struct bpf_prog_pack {
>  	struct list_head list;
>  	void *ptr;
> -	unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
> +	unsigned long bitmap[];

This is really asking to be DECLARE_BITMAP(), does that fix the issue?

>  };
>  
>  #define BPF_PROG_MAX_PACK_PROG_SIZE	BPF_PROG_PACK_SIZE
> @@ -840,7 +840,7 @@ static struct bpf_prog_pack *alloc_new_pack(void)
>  {
>  	struct bpf_prog_pack *pack;
>  
> -	pack = kzalloc(sizeof(*pack), GFP_KERNEL);
> +	pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(BPF_PROG_CHUNK_COUNT), GFP_KERNEL);

Otherwise you may want to use struct_size(pack, bitmap, BITS...).
One of the bots will soon send us a patch to do that.

>  	if (!pack)
>  		return NULL;
>  	pack->ptr = module_alloc(BPF_PROG_PACK_SIZE);

