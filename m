Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4341B44D580
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 12:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbhKKLIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 06:08:51 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:34996 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhKKLIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 06:08:50 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4C7001FD4A;
        Thu, 11 Nov 2021 11:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636628761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WGHkWouMAgAnyKyKPxoN0Otx/VPml7UM+JLVGXjXP9Y=;
        b=a1WzM5pUltY+T0b2znfxiLLhDSfNgWRHXOgQTDASNjmkiIqUeX8xAfpOP7O3roy0qDM881
        ayBqBJS3F5FW45ywN2K5iCbXuxOyF9o1ShVJqseNvJMDO/FsJnkKlzWwN0h6XrWUHeg5gX
        ltnWK60d03aIigq2iWt6ze/IjXlIRaM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636628761;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WGHkWouMAgAnyKyKPxoN0Otx/VPml7UM+JLVGXjXP9Y=;
        b=Ff6vKYr3rouTirG1LgdhO2KfUmp6w1GcDO3ccTPeC3rNEJX4NqJEhK9vaOxyDLYWQ4Yllz
        hwgl8SDyy+V/a3Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EC6EA13B2B;
        Thu, 11 Nov 2021 11:06:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9x9ENBj5jGE3OAAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Thu, 11 Nov 2021 11:06:00 +0000
Subject: Re: [PATCH iproute2] bridge: use strtoi instead of atoi for checking
 value of cost/priority
To:     15720603159@163.com, netdev@vger.kernel.org
Cc:     jinag <jinag12138@gmail.com>
References: <20211111093323.5129-1-15720603159@163.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <c0743cd3-e03f-419d-4a27-d02e0d9a4e73@suse.de>
Date:   Thu, 11 Nov 2021 14:06:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211111093323.5129-1-15720603159@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/11/21 12:33 PM, 15720603159@163.com пишет:
> From: jinag <jinag12138@gmail.com>
> 
> Signed-off-by: jinag <jinag12138@gmail.com>
> ---
>   bridge/link.c | 14 ++++++++++++--
>   1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/bridge/link.c b/bridge/link.c
> index 205a2fe7..d60e1106 100644
> --- a/bridge/link.c
> +++ b/bridge/link.c
> @@ -308,13 +308,14 @@ static int brlink_modify(int argc, char **argv)
>   	__s8 bpdu_guard = -1;
>   	__s8 fast_leave = -1;
>   	__s8 root_block = -1;
> -	__u32 cost = 0;
> +	__s32 cost = 0;
>   	__s16 priority = -1;
>   	__s8 state = -1;
>   	__s16 mode = -1;
>   	__u16 flags = 0;
>   	struct rtattr *nest;
>   	int ret;
> +	char *end = NULL;
>   
>   	while (argc > 0) {
>   		if (strcmp(*argv, "dev") == 0) {
> @@ -367,10 +368,19 @@ static int brlink_modify(int argc, char **argv)
>   				return ret;
>   		} else if (strcmp(*argv, "cost") == 0) {
>   			NEXT_ARG();
> -			cost = atoi(*argv);
> +			cost = strtoul(*argv, &end, 10);
does it return a signed value?
> +			if ((cost <= 0) || (end == NULL) || (*end != '\0')) {
> +				fprintf(stderr, "Error: invalid cost value\n");
> +				return -1;
> +			}
>   		} else if (strcmp(*argv, "priority") == 0) {
>   			NEXT_ARG();
>   			priority = atoi(*argv);
> +			priority = strtol(*argv, &end, 10);
> +			if ((priority < 0) || (end == NULL) || (*end != '\0')) {
> +				fprintf(stderr, "Error: invalid priority\n");
> +				return -1;
> +			}
>   		} else if (strcmp(*argv, "state") == 0) {
>   			NEXT_ARG();
>   			char *endptr;
> 
