Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFAD24505A3
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:36:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbhKONjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:39:43 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:56580 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbhKONjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 08:39:40 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 290DF1FD43;
        Mon, 15 Nov 2021 13:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636983404; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BFPsX5TtVH34IjNoVjv8JHz+1UYWr8E4w0lDWmVxRmQ=;
        b=GfhlbZHcAjho523bJML3/7fTLCrVQaoS9b9tBhya5q4yczW9bm9vqbgYiLCEzAPvsXBDnq
        IFkFQhzvYzkwlCorgEBTETb6QMOGevzGDZ8kfSTq63lMu//zYAN565e3fVl436w6B4VRBZ
        3HPcetHthwO+RA6kESX6u22mI21fb04=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636983404;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BFPsX5TtVH34IjNoVjv8JHz+1UYWr8E4w0lDWmVxRmQ=;
        b=cATFTOPUBDWqIUO/9Eb3z4InYQua5if3jq/i2DMfb1h9qzE5wAC7zgDfBYRjuGf7FoT2ol
        qBV3MNfA+QWVUOCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D59AF13DAB;
        Mon, 15 Nov 2021 13:36:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OzxfMGtikmGJCgAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Mon, 15 Nov 2021 13:36:43 +0000
Subject: Re: [PATCH iproute2] lnstat:fix buffer overflow in lnstat lnstat
 segfaults when called the following command: $ lnstat -w 1
To:     "jiangheng (H)" <jiangheng12@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "Chenxiang (EulerOS)" <rose.chen@huawei.com>
References: <6cc4b6c9c31e49508c07df7334831a73@huawei.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <9ca467b0-0f6e-81ec-c629-69f35cdce542@suse.de>
Date:   Mon, 15 Nov 2021 16:36:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <6cc4b6c9c31e49508c07df7334831a73@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/15/21 2:27 PM, jiangheng (H) пишет:
>  From d797c268003919f6e83c1bbdccebf62805dc2581 Mon Sep 17 00:00:00 2001
> From: jiangheng <jiangheng12@huawei.com>
> Date: Thu, 11 Nov 2021 18:20:26 +0800
> Subject: [PATCH iproute2] lnstat:fix buffer overflow in lnstat lnstat
Please adjust the subject line (lnstat is typed twice)

> segfaults when called the following command: $ lnstat -w 1
> 
> [root@pm-104 conf.d]# lnstat -w 1
> Segmentation fault (core dumped)
> 
> The maximum  value of th.num_lines is HDR_LINES(10),  h should not be equal to th.num_lines, array th.hdr may be out of bounds.
> 
> Signed-off-by jiangheng <jiangheng12@huawei.com>
> ---
> misc/lnstat.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/misc/lnstat.c b/misc/lnstat.c
> index 89cb0e7e..26be852d 100644
> --- a/misc/lnstat.c
> +++ b/misc/lnstat.c
> @@ -211,7 +211,7 @@ static struct table_hdr *build_hdr_string(struct lnstat_file *lnstat_files,
>   		ofs += width+1;
>   	}
>   	/* fill in spaces */
> -	for (h = 1; h <= th.num_lines; h++) {
> +	for (h = 1; h < th.num_lines; h++) {
>   		for (i = 0; i < ofs; i++) {
>   			if (th.hdr[h][i] == '\0')
>   				th.hdr[h][i] = ' ';
> --
> 2.27.0
> 
