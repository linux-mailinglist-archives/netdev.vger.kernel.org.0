Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30021EA5A3
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 16:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbgFAOQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 10:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbgFAOQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 10:16:46 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EEFC03E96B
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 07:16:45 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id y13so9371159eju.2
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 07:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0RXojda16OnGmgNKSmtyw7Ld824D2dHnKxVXAUlbFzY=;
        b=WpEPYsC/ouh8NovMeea6DUrUXsf+lzEHm8v1a0KYLtGsk+v/WgYML58SySY8kzD0M6
         LWLBesNp0LiPUYwcVKUSU2JY01tohZ9kgJUjGphJuJrKtlz9p9GJucOTnx2MNTcqhtU7
         feRrBOkjkQTEBWzj0nmPugJaW+2MPLnJttSVI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0RXojda16OnGmgNKSmtyw7Ld824D2dHnKxVXAUlbFzY=;
        b=rpxQc8Pq/B9+GdvIeY0ebIn3SPNJsiMCG/oZpmoVMZfTI+vJ5UVZa1EcvADhJaL4mz
         5E5yFDnKNI/WKsKJvgsZY2CSeKMb1MDVKulXs3TEIltbVA/pMd2sb2tjTTo+icQl5tUG
         eaFbjQ6iiVKQ+MtkUS+OMwS5zd8o58Zv1vwxI9ptuF61wMVYnkB3pkr1vmdwTdFmWSK9
         7vyCbMew0q1z3BmlWgShcWMS/DHU5Y0foal2GJG2US5bJ6RzX/M4zUbPM2X0U8LbbkIi
         JBvJwmvQfayWhzZFmIKu8BBfj5124wgZRQn5UqLG6oMam9UzfGgBVfnllY3VVTM+aIZr
         p6aA==
X-Gm-Message-State: AOAM532+MFoGt6+GHnliCwLQpzeygHQr4u+C51uFnoLAjBIrLWT8Ly1x
        1KLeVn4fqdmeZZOm6mXTXvFusQ==
X-Google-Smtp-Source: ABdhPJz3oDHtYW6LNlLnXVNxbQecxUE4mFbdUo8WW2phtjh2jfRhgHK3IHNuF6iZ3E48SSkesyI4kg==
X-Received: by 2002:a17:906:818:: with SMTP id e24mr8375878ejd.453.1591021004391;
        Mon, 01 Jun 2020 07:16:44 -0700 (PDT)
Received: from toad ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id w13sm5759430eju.124.2020.06.01.07.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 07:16:44 -0700 (PDT)
Date:   Mon, 1 Jun 2020 16:16:14 +0200
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        alexei.starovoitov@gmail.com, daniel@iogearbox.net
Subject: Re: [bpf-next PATCH 1/3] bpf: refactor sockmap redirect code so its
 easy to reuse
Message-ID: <20200601161614.4bea42b0@toad>
In-Reply-To: <159079360110.5745.7024009076049029819.stgit@john-Precision-5820-Tower>
References: <159079336010.5745.8538518572099799848.stgit@john-Precision-5820-Tower>
        <159079360110.5745.7024009076049029819.stgit@john-Precision-5820-Tower>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 16:06:41 -0700
John Fastabend <john.fastabend@gmail.com> wrote:

> We will need this block of code called from tls context shortly
> lets refactor the redirect logic so its easy to use. This also
> cleans up the switch stmt so we have fewer fallthrough cases.
> 
> No logic changes are intended.
> 
> Fixes: d829e9c4112b5 ("tls: convert to generic sk_msg interface")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Keeping out_free in the extracted helper might have been cleaner.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
