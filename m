Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A8C50E244
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 15:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbiDYNvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 09:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242260AbiDYNu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 09:50:58 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA3D4B1EB;
        Mon, 25 Apr 2022 06:47:52 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1niz47-0005KE-58; Mon, 25 Apr 2022 15:47:47 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1niz46-000Tyk-FH; Mon, 25 Apr 2022 15:47:46 +0200
Subject: Re: [PATCH bpf-next 1/4] libbpf: Define DEFAULT_BPFFS
To:     Yafang Shao <laoar.shao@gmail.com>, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220423140058.54414-1-laoar.shao@gmail.com>
 <20220423140058.54414-2-laoar.shao@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bdc0c787-fcca-551e-3ff5-2d2e21940fdb@iogearbox.net>
Date:   Mon, 25 Apr 2022 15:47:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220423140058.54414-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26523/Mon Apr 25 10:20:35 2022)
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/22 4:00 PM, Yafang Shao wrote:
> Let's use a macro DEFAULT_BPFFS instead of the hard-coded "/sys/fs/bpf".
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
[...]
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index cdbfee60ea3e..3784867811a4 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -28,6 +28,8 @@ LIBBPF_API __u32 libbpf_major_version(void);
>   LIBBPF_API __u32 libbpf_minor_version(void);
>   LIBBPF_API const char *libbpf_version_string(void);
>   
> +#define DEFAULT_BPFFS "/sys/fs/bpf"

Small nit, but given this is included in a lot of places potentially, it should
have a LIBBPF_ prefix to avoid collisions. Maybe: LIBBPF_BPFFS_DEFAULT_MNT

>   enum libbpf_errno {
>   	__LIBBPF_ERRNO__START = 4000,
>   
> @@ -91,7 +93,7 @@ struct bpf_object_open_opts {
>   	bool relaxed_core_relocs;
>   	/* maps that set the 'pinning' attribute in their definition will have
>   	 * their pin_path attribute set to a file in this directory, and be
> -	 * auto-pinned to that path on load; defaults to "/sys/fs/bpf".
> +	 * auto-pinned to that path on load; defaults to DEFAULT_BPFFS.
>   	 */
>   	const char *pin_root_path;
>   
> @@ -190,7 +192,7 @@ bpf_object__open_xattr(struct bpf_object_open_attr *attr);
>   
>   enum libbpf_pin_type {
>   	LIBBPF_PIN_NONE,
> -	/* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
> +	/* PIN_BY_NAME: pin maps by name (in DEFAULT_BPFFS by default) */
>   	LIBBPF_PIN_BY_NAME,
>   };
>   
> 

