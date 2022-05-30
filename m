Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAE965388BA
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 23:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243281AbiE3VzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 17:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240312AbiE3VzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 17:55:22 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EEF56C08;
        Mon, 30 May 2022 14:55:19 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nvnLz-0001Zh-5r; Mon, 30 May 2022 23:55:11 +0200
Received: from [85.1.206.226] (helo=linux-2.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nvnLy-000Laq-UY; Mon, 30 May 2022 23:55:10 +0200
Subject: Re: [PATCH 1/2] libbpf: Retry map access with read-only permission
To:     Roberto Sassu <roberto.sassu@huawei.com>, ast@kernel.org,
        andrii@kernel.org, kpsingh@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220530084514.10170-1-roberto.sassu@huawei.com>
 <20220530084514.10170-2-roberto.sassu@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4089f118-662c-4ea2-131f-c8a9b702b6ca@iogearbox.net>
Date:   Mon, 30 May 2022 23:55:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220530084514.10170-2-roberto.sassu@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26557/Mon May 30 10:05:44 2022)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/22 10:45 AM, Roberto Sassu wrote:
> Retry map access with read-only permission, if access was denied when all
> permissions were requested (open_flags is set to zero). Write access might
> have been denied by the bpf_map security hook.
> 
> Some operations, such as show and dump, don't need write permissions, so
> there is a good chance of success with retrying.
> 
> Prefer this solution to extending the API, as otherwise a new mechanism
> would need to be implemented to determine the right permissions for an
> operation.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>   tools/lib/bpf/bpf.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 240186aac8e6..b4eec39021a4 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -1056,6 +1056,11 @@ int bpf_map_get_fd_by_id(__u32 id)
>   	attr.map_id = id;
>   
>   	fd = sys_bpf_fd(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
> +	if (fd < 0) {
> +		attr.open_flags = BPF_F_RDONLY;
> +		fd = sys_bpf_fd(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
> +	}
> +

But then what about bpf_obj_get() API in libbpf? attr.file_flags has similar
purpose as attr.open_flags in this case.

The other issue is that this could have upgrade implications, e.g. where an
application bailed out before, it is now passing wrt bpf_map_get_fd_by_id(),
but then suddenly failing during map update calls.

Imho, it might be better to be explicit about user intent w/o the lib doing
guess work upon failure cases (... or have the BPF LSM set the attr.open_flags
to BPF_F_RDONLY from within the BPF prog).

>   	return libbpf_err_errno(fd);
>   }
>   
> 

