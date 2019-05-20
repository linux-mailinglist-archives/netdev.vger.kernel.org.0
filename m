Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6E0240BF
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 20:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfETS5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 14:57:51 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44706 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfETS5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 14:57:51 -0400
Received: by mail-lj1-f194.google.com with SMTP id e13so13456322ljl.11
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 11:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OmaVPUNIZXzoguiohx42nQv5edtRi7vwn1kzPXHaCDU=;
        b=fMyll/PYRqDhUKiFB8FWnKnTIEQzIkiza71tvGxxVJhYoLtma2pufkLzZrNJzfHMCQ
         DEQUyJfZ/FKF9qXw4Gszyc7Cx/Wchwc6YJmaz6m/TMqJHRmLqjSWQnFpmV3uyA7JmLbe
         merYv5HX8zgk+6qeaa+yLv93n/+XXh57JMhmTAsXu/qsGMm4RTYfTixRoIzrDzByGpEV
         t498nAncnts0ff/6jHnDXDkJy+A4K6WC7xkUSaeb3OLLNwzfPKZPtPCFmrURE1bnpspH
         h0Mna6z+leiSlSL+sberZ70d7qdflrvzfoSwWOx88e+dDllUB5N64Y+xGHQt4tv6UOVs
         yt8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OmaVPUNIZXzoguiohx42nQv5edtRi7vwn1kzPXHaCDU=;
        b=Kv9z6cQeiUDimBaD1ixhkzid2btK4D70eanhqx7kcw9MgkRyFyp4wqkENSh1YeXUyI
         E6QVIpWLNttnzWxuXsQK/0USP2audixpzf5tl+PApq12hNj6ayRAK1pCQxQWQTyrrlop
         2Y0Nb1frl3yg8B/jPjMlkCNWAjbcIOEJK17o9141jnQcOvnQPpoUAt67Yu7rd5nQBU9a
         EJauVFtA7TKCe9KmCcKF7maTx5hvdahBE4YJOBozvXe1ojCbfZlIEMzAWWsVDYRsYJJe
         j4QiVKp4Z4JJvxyk94ZVLMhmWzD5Sxq2E0Kz9ZQcRTO2ypfQ7HakjEmF80gvz3h/MvwP
         vG0g==
X-Gm-Message-State: APjAAAV0NlJyECPh4CYk9/rGfQq6YVbOg6Fdhk0eAfQeAG/1gvktFkHb
        seFH4VfrZjP/i7ixe5XxX9sG8hPKH+nTFydusmI4dg==
X-Google-Smtp-Source: APXvYqy6M9AYAHvKJNCbUtN+nVQJi5irsspzQdgBoUYpuK5uXs+rCoPdY/21xnEcQ0CBbK70aIgXROavyXsEF4+arOE=
X-Received: by 2002:a2e:9d4e:: with SMTP id y14mr12542742ljj.199.1558378669341;
 Mon, 20 May 2019 11:57:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190517212117.2792415-1-kafai@fb.com>
In-Reply-To: <20190517212117.2792415-1-kafai@fb.com>
From:   Joe Stringer <joe@isovalent.com>
Date:   Mon, 20 May 2019 11:57:37 -0700
Message-ID: <CADa=Ryxc8cU8mx7i91GXjT+b4md3c01hqja9oVMZxSbbR+OVPw@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Check sk_fullsock() before returning from bpf_sk_lookup()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 2:21 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The BPF_FUNC_sk_lookup_xxx helpers return RET_PTR_TO_SOCKET_OR_NULL.
> Meaning a fullsock ptr and its fullsock's fields in bpf_sock can be
> accessed, e.g. type, protocol, mark and priority.
> Some new helper, like bpf_sk_storage_get(), also expects
> ARG_PTR_TO_SOCKET is a fullsock.
>
> bpf_sk_lookup() currently calls sk_to_full_sk() before returning.
> However, the ptr returned from sk_to_full_sk() is not guaranteed
> to be a fullsock.  For example, it cannot get a fullsock if sk
> is in TCP_TIME_WAIT.
>
> This patch checks for sk_fullsock() before returning. If it is not
> a fullsock, sock_gen_put() is called if needed and then returns NULL.
>
> Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
> Cc: Joe Stringer <joe@isovalent.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: Joe Stringer <joe@isovalent.com>
