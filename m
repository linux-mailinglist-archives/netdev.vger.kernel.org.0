Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AF3E58340C
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiG0U0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 16:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiG0U0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 16:26:19 -0400
Received: from smtp-42ac.mail.infomaniak.ch (smtp-42ac.mail.infomaniak.ch [IPv6:2001:1600:4:17::42ac])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CDAB4504B
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 13:26:18 -0700 (PDT)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4LtQKP2DcxzMqR8X;
        Wed, 27 Jul 2022 22:26:17 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4LtQKN5kMNzlqV0d;
        Wed, 27 Jul 2022 22:26:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1658953577;
        bh=hLCaudxmTLn46TzdaaEDyaJ1LW+mZoCAbGYIV24EY24=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=BrVNFm3AcZPEr7U7GUUVSRzgny1p6Xmv13vAfms1zeANQ833+rFqI4pHRBS/ZQI+v
         2i/EFqXJsrTWeu56U4mX3TjGQBcvXBWxpdW5L8H3Lzh3k5KMzlMRduz287SLWgcRdq
         SfAInsit0fLrzUWeMvDac007zsjyMBBFCV7UDxjU=
Message-ID: <78b7cd69-46d2-2868-8c9c-f4f29958a679@digikod.net>
Date:   Wed, 27 Jul 2022 22:26:16 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <20220621082313.3330667-18-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v6 17/17] samples/landlock: adds network demo
In-Reply-To: <20220621082313.3330667-18-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 21/06/2022 10:23, Konstantin Meskhidze wrote:
> This commit adds network demo. It's possible to
> allow a sandoxer to bind/connect to a list of
> particular ports restricting networks actions to
> the rest of ports.
> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v5:
> * Makes network ports sandboxing optional.
> * Fixes some logic errors.
> * Formats code with clang-format-14.
> 
> Changes since v4:
> * Adds ENV_TCP_BIND_NAME "LL_TCP_BIND" and
> ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT" variables
> to insert TCP ports.
> * Renames populate_ruleset() to populate_ruleset_fs().
> * Adds populate_ruleset_net() and parse_port_num() helpers.
> * Refactors main() to support network sandboxing.
> 
> ---
>   samples/landlock/sandboxer.c | 118 +++++++++++++++++++++++++++++++----
>   1 file changed, 107 insertions(+), 11 deletions(-)
> 
> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
> index 3e404e51ec64..0606c676fded 100644
> --- a/samples/landlock/sandboxer.c
> +++ b/samples/landlock/sandboxer.c


[...]

> @@ -232,16 +308,36 @@ int main(const int argc, char *const argv[], char *const *const envp)
>   		access_fs_rw &= ~ACCESS_ABI_2;

We need to check the ABI to make this sample work without a kernel 
supporting Landlock network access rights, and error out if the user 
explicitely asked for it anyway (with the environement variable).


>   	}
> 
> +	/* Adds optionally network bind() support. */
> +	env_port_name = getenv(ENV_TCP_BIND_NAME);
> +	if (env_port_name) {
> +		access_net_tcp |= LANDLOCK_ACCESS_NET_BIND_TCP;
> +	}
> +	/* Adds optionally network connect() support. */
> +	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
> +	if (env_port_name) {
> +		access_net_tcp |= LANDLOCK_ACCESS_NET_CONNECT_TCP;
> +	}
> +	ruleset_attr.handled_access_net = access_net_tcp;
> +
>   	ruleset_fd =
>   		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>   	if (ruleset_fd < 0) {
>   		perror("Failed to create a ruleset");
>   		return 1;
>   	}
> -	if (populate_ruleset(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
> +	if (populate_ruleset_fs(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
> +		goto err_close_ruleset;
> +	}
> +	if (populate_ruleset_fs(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
> +		goto err_close_ruleset;
> +	}
> +	if (populate_ruleset_net(ENV_TCP_BIND_NAME, ruleset_fd,
> +				 LANDLOCK_ACCESS_NET_BIND_TCP)) {
>   		goto err_close_ruleset;
>   	}
> -	if (populate_ruleset(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
> +	if (populate_ruleset_net(ENV_TCP_CONNECT_NAME, ruleset_fd,
> +				 LANDLOCK_ACCESS_NET_CONNECT_TCP)) {
>   		goto err_close_ruleset;
>   	}
>   	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
> --
> 2.25.1
> 
