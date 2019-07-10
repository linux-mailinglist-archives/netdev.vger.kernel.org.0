Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD57263F5C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 04:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbfGJCgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 22:36:15 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37435 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfGJCgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 22:36:15 -0400
Received: by mail-qk1-f193.google.com with SMTP id d15so755529qkl.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 19:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Zlch6bLWAifHmhuVeVobSr22tj+vbfDoRuAccvPZYEY=;
        b=DwXvjqOcMWJodwGfmICVyRxcGFVv2G4GxXUNDEiIev6Y8Mp3NGs+URSdPLnLH6xYTB
         FPRf6zMnTitqLkgXjuKw8PytmtpsmL9+Tz7ZDhJgv6vZTQcc+IdaXQ5KgdB4OflT4oKD
         YYdCACSLIuxFbUQ/OWFIpqYTHGZuLPcJyvBZu1zBaWOK0JT9FrZ9WQkoYTRCQRLCoVfS
         3iLCyI2FZu3ZbXPnrJptv1MLNFKTGPTyWy7/dL+fg8woM9HN7d/L5iZcEs8OWqwbmcZR
         gwnG3dxYKC+b0A50PpxhSvCerbYhDIAQ8tRVxzca5uWYYCnXOBnqjQ5u9bWjre7Ud+m0
         //mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Zlch6bLWAifHmhuVeVobSr22tj+vbfDoRuAccvPZYEY=;
        b=PA54Yl21EMokIJr79/e+ludR15ocrFYWyCA4Bf9xA6kNgUI7RFvxXfMs6h7DoXGxWm
         Dn5NiIks3oMista0BRQP9GiLVJtwdVX2TYsJU185HrX665NcYkthWkYKeyV/xboWbqSJ
         LNT3b1kyqjXkX1H6svNFhki88ZEI1ACIafY79nUg/IqhxKXPLK4YPsOmr/Kgm87V/J4O
         WN7FeO19poIsIXJM5sf5Uzh7Ru5R57Hb+aHtHeDSW9aMz0HEle8NVk0YVbXza15jFauF
         7CYLDMNB3uHmRKaMJ9LYWSeXEGAlTzWwDx1pwRm+a6WyJ/qIi9mSxARrEdAHmBta8FsD
         ATQA==
X-Gm-Message-State: APjAAAWArGyTzf0AKATBd7pVZabwyU2GH5yx0QEyxecJhs39gLeOVKbd
        aL7eZxLGg+NRXGavV/NXLXtk+Q==
X-Google-Smtp-Source: APXvYqze8B2LgCM6gWk6hkhN3SDNfnfmd9Q1xReDmcqVezU30xFZaMwOsM7JiiQ75Zo0gTJxqXt2ww==
X-Received: by 2002:a37:e40b:: with SMTP id y11mr21406593qkf.88.1562726174572;
        Tue, 09 Jul 2019 19:36:14 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g22sm276484qtr.95.2019.07.09.19.36.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 19:36:14 -0700 (PDT)
Date:   Tue, 9 Jul 2019 19:36:10 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        edumazet@google.com, bpf@vger.kernel.org
Subject: Re: [bpf PATCH v2 6/6] bpf: sockmap/tls, close can race with map
 free
Message-ID: <20190709193610.1f090ed4@cakuba.netronome.com>
In-Reply-To: <156261331866.31108.6405316261950259075.stgit@ubuntu3-kvm1>
References: <156261310104.31108.4569969631798277807.stgit@ubuntu3-kvm1>
        <156261331866.31108.6405316261950259075.stgit@ubuntu3-kvm1>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 08 Jul 2019 19:15:18 +0000, John Fastabend wrote:
> @@ -836,22 +841,39 @@ static int tls_init(struct sock *sk)

There is a goto out above this which has to be turned into return 0;
if out now releases the lock.

>  	if (sk->sk_state != TCP_ESTABLISHED)
>  		return -ENOTSUPP;
>  
> +	tls_build_proto(sk);
> +
>  	/* allocate tls context */
> +	write_lock_bh(&sk->sk_callback_lock);
>  	ctx = create_ctx(sk);
>  	if (!ctx) {
>  		rc = -ENOMEM;
>  		goto out;
>  	}
>  
> -	tls_build_proto(sk);
>  	ctx->tx_conf = TLS_BASE;
>  	ctx->rx_conf = TLS_BASE;
>  	ctx->sk_proto = sk->sk_prot;
>  	update_sk_prot(sk, ctx);
>  out:
> +	write_unlock_bh(&sk->sk_callback_lock);
>  	return rc;
>  }
