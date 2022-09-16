Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D77A5BB090
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 17:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiIPPyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 11:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiIPPyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 11:54:22 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBCBAE872;
        Fri, 16 Sep 2022 08:54:21 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oZDf9-000Dui-3t; Fri, 16 Sep 2022 17:53:55 +0200
Received: from [2a02:168:f656:0:d16a:7287:ccf0:4fff] (helo=localhost.localdomain)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oZDf8-0008AZ-HO; Fri, 16 Sep 2022 17:53:54 +0200
Subject: Re: [bpf-next v2 1/2] libbpf: Add pathname_concat() helper
To:     Wang Yufen <wangyufen@huawei.com>, andrii@kernel.org,
        ast@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
References: <1663313820-29918-1-git-send-email-wangyufen@huawei.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8011ae39-d6ba-3dfa-07f1-1a548fd24560@iogearbox.net>
Date:   Fri, 16 Sep 2022 17:53:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1663313820-29918-1-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26660/Fri Sep 16 09:57:04 2022)
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/22 9:36 AM, Wang Yufen wrote:
> Move snprintf and len check to common helper pathname_concat() to make the
> code simpler.
> 
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>   tools/lib/bpf/libbpf.c | 76 +++++++++++++++++++-------------------------------
>   1 file changed, 29 insertions(+), 47 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 3ad1392..7ab977c 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -2096,19 +2096,30 @@ static bool get_map_field_int(const char *map_name, const struct btf *btf,
>   	return true;
>   }
>   
> +static int pathname_concat(const char *path, const char *name, char *buf)
> +{
> +	int len;
> +
> +	len = snprintf(buf, PATH_MAX, "%s/%s", path, name);
> +	if (len < 0)
> +		return -EINVAL;
> +	if (len >= PATH_MAX)
> +		return -ENAMETOOLONG;
> +
> +	return 0;
> +}
> +
>   static int build_map_pin_path(struct bpf_map *map, const char *path)
>   {
>   	char buf[PATH_MAX];
> -	int len;
> +	int err;
>   
>   	if (!path)
>   		path = "/sys/fs/bpf";
>   
> -	len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
> -	if (len < 0)
> -		return -EINVAL;
> -	else if (len >= PATH_MAX)
> -		return -ENAMETOOLONG;
> +	err = pathname_concat(path, bpf_map__name(map), buf);

Small nit, but would be good to not make the assumption that buf is always
PATH_MAX so lets add size_t len to pathname_concat().

> +	if (err)
> +		return err;
>   
>   	return bpf_map__set_pin_path(map, buf);
>   }
