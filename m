Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A13614C44
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 15:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiKAOJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 10:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKAOJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 10:09:54 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9401AF14
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 07:09:53 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oprxe-0002Z4-OQ; Tue, 01 Nov 2022 15:09:50 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oprxe-000M4f-HQ; Tue, 01 Nov 2022 15:09:50 +0100
Subject: Re: [PATCH v2] fix missing map name when creating a eBPF map
To:     mrpre <mrpre@163.com>, stephen@networkplumber.org
Cc:     netdev@vger.kernel.org
References: <20221027083808.3304abd6@hermes.local>
 <20221030073204.1876-1-mrpre@163.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ecd50658-d021-ef03-deac-868ad9416b4a@iogearbox.net>
Date:   Tue, 1 Nov 2022 15:09:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20221030073204.1876-1-mrpre@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26706/Tue Nov  1 08:52:34 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi mrpre,

On 10/30/22 8:32 AM, mrpre wrote:
> Signed-off-by: mrpre <mrpre@163.com>

Small form letter: Please indicate iproute2 in subject, add a proper commit message /
bug report and please also use an actual name instead of "mrpre" for the Signed-off-by.

Thanks a lot,
Daniel

> ---
>   lib/bpf_legacy.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
> index 4fabdcc8..0fff035b 100644
> --- a/lib/bpf_legacy.c
> +++ b/lib/bpf_legacy.c
> @@ -1264,7 +1264,7 @@ static int bpf_map_create(enum bpf_map_type type, uint32_t size_key,
>   			  uint32_t size_value, uint32_t max_elem,
>   			  uint32_t flags, int inner_fd, int btf_fd,
>   			  uint32_t ifindex, uint32_t btf_id_key,
> -			  uint32_t btf_id_val)
> +			  uint32_t btf_id_val, const char *name)
>   {
>   	union bpf_attr attr = {};
>   
> @@ -1278,6 +1278,7 @@ static int bpf_map_create(enum bpf_map_type type, uint32_t size_key,
>   	attr.btf_fd = btf_fd;
>   	attr.btf_key_type_id = btf_id_key;
>   	attr.btf_value_type_id = btf_id_val;
> +	strncpy(attr.map_name, name, sizeof(attr.map_name));
>   
>   	return bpf(BPF_MAP_CREATE, &attr, sizeof(attr));
>   }
> @@ -1682,7 +1683,7 @@ probe:
>   	errno = 0;
>   	fd = bpf_map_create(map->type, map->size_key, map->size_value,
>   			    map->max_elem, map->flags, map_inner_fd, ctx->btf_fd,
> -			    ifindex, ext->btf_id_key, ext->btf_id_val);
> +			    ifindex, ext->btf_id_key, ext->btf_id_val, name);
>   
>   	if (fd < 0 || ctx->verbose) {
>   		bpf_map_report(fd, name, map, ctx, map_inner_fd);
> 

