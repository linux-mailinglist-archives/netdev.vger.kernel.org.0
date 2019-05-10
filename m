Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB271A212
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 19:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbfEJRBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 13:01:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33208 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfEJRBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 13:01:09 -0400
Received: by mail-qt1-f196.google.com with SMTP id m32so4350215qtf.0
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 10:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=VRFwCStrPTcDuGWHYqKRGwK0QteT1eytgvDU9OCPpjI=;
        b=NZZ1I1eQkLXQ6xCXGOH14awUR/k7MvBdw6v3BAAPDHX3EBR+eTaus2RO/lQR2HpiKd
         9K+PRt2HqRoj7noZakib9DWItNHq7efiA1yqIp9DKDD1HNuuOs2ztL/ZtsYrA0EzhIVT
         X9luWvzn4ExEFiCm+Y9dK+2xtVSE6UKH9+5g/mEnrwUIKlumctcgNYQ8sC80boCjuWIQ
         uSlCyYF+dynU7Teeq8505VRV6MhDnDFvKJti2oi0DtENzPv2LRg8okzvhwtzDMdZLrYd
         qQZGI/reRfLiuOSfBdnv4+ra2hVMvKnkXSQMfCqu4lZPv5aADwyoaaxZQ8n7YcIP3nMW
         dNYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=VRFwCStrPTcDuGWHYqKRGwK0QteT1eytgvDU9OCPpjI=;
        b=nvdIsET6tEBgayuvwHU3l9VWY1RTHZYdCd3HA0U53RkRSkXd9hG0bTHDSfCNgQIoBN
         sPBLqrk8JURT3h9+7NOvNB84n6HC9Kb8q36hQhrze/BIlUTVrPrevam3oeyJ6Qj4dGjq
         aSdfWvhkJrGGBNP/Fq7QL2sX+0+J7arBIY1WuWMllmONWbR4La9JI/IXGlV4bqAbdia7
         2QtrO9Wgw6UB+9b9gUgE0ygFIQB2S1eD5YM7aGa/I/OuUWYQ5kXMbzjPbskAluhvkHoa
         DvkbnDx9B9TCTknTgCbuMFpQRH5Fk80YnmXE0f892rV5e0RyWkp1VstffC4G7rNXxAEB
         PdkQ==
X-Gm-Message-State: APjAAAVNaw32vAQeFjUxarJkbIStw9JAUw6Ta5OnwqCp9zJTAPBNPfX6
        PnLg++zYJWk65+M1MwJqdWOr+w==
X-Google-Smtp-Source: APXvYqyaSudbfKSzos3kVglffl0DKyyh0N26yZWHJaVk7acO/4CrH1FzAIUEynwgwv+aujKc02D6lQ==
X-Received: by 2002:ac8:342e:: with SMTP id u43mr3929573qtb.319.1557507668150;
        Fri, 10 May 2019 10:01:08 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x65sm2854001qke.58.2019.05.10.10.01.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 10 May 2019 10:01:08 -0700 (PDT)
Date:   Fri, 10 May 2019 10:00:54 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [bpf PATCH v4 1/4] bpf: tls, implement unhash to avoid
 transition out of ESTABLISHED
Message-ID: <20190510100054.29f7235c@cakuba.netronome.com>
In-Reply-To: <155746426913.20677.2783358822817593806.stgit@john-XPS-13-9360>
References: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
        <155746426913.20677.2783358822817593806.stgit@john-XPS-13-9360>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 May 2019 21:57:49 -0700, John Fastabend wrote:
> @@ -2042,12 +2060,14 @@ void tls_sw_free_resources_tx(struct sock *sk)
>  	if (atomic_read(&ctx->encrypt_pending))
>  		crypto_wait_req(-EINPROGRESS, &ctx->async_wait);
>  
> -	release_sock(sk);
> +	if (locked)
> +		release_sock(sk);
>  	cancel_delayed_work_sync(&ctx->tx_work.work);

So in the splat I got (on a slightly hacked up kernel) it seemed like
unhash may be called in atomic context:

[  783.232150]  tls_sk_proto_unhash+0x72/0x110 [tls]
[  783.237497]  tcp_set_state+0x484/0x640
[  783.241776]  ? __sk_mem_reduce_allocated+0x72/0x4a0
[  783.247317]  ? tcp_recv_timestamp+0x5c0/0x5c0
[  783.252265]  ? tcp_write_queue_purge+0xa6a/0x1180
[  783.257614]  tcp_done+0xac/0x260
[  783.261309]  tcp_reset+0xbe/0x350
[  783.265101]  tcp_validate_incoming+0xd9d/0x1530

I may have been unclear off-list, I only tested the patch no longer
crashes the offload :(

> -	lock_sock(sk);
> +	if (locked)
> +		lock_sock(sk);
>  
>  	/* Tx whatever records we can transmit and abandon the rest */
> -	tls_tx_records(sk, -1);
> +	tls_tx_records(sk, tls_ctx, -1);
>  
>  	/* Free up un-sent records in tx_list. First, free
>  	 * the partially sent record if any at head of tx_list.

