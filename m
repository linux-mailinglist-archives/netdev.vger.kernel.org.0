Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1BF920F5B
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 21:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfEPTuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 15:50:20 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34023 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726519AbfEPTuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 15:50:19 -0400
Received: by mail-lj1-f195.google.com with SMTP id j24so4249768ljg.1;
        Thu, 16 May 2019 12:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KSYFmnA9eWWLhRZS08HYOCsYCy2SOuZ4e0aM+KE0WVc=;
        b=ANoFkUZ5sAwab5YdVJ0Xm2+8cDq5G/jPbZGJ7r6qhzsp+4oxAlT2wAqJBJAeFSRSqe
         +WY2OHOviCdRockUMRL9Zwzi5dBoQIEjxW1Z2XHmHolwZuTiEoO77CpuX9vD/aYGMkQR
         ZSnG9I7MxxWHbkb74p0AxLkQha0UAdJ3tRc8IyaRfdb5BNoIAjhGSLjkKnwWPK+VttX5
         SVvRlCfqYCL3/aWsSZ3y7BluJIIOb2C3Tqn8zMbl0mDXplsVCEBQFdCw73xePoZVPol+
         7h65ekuzls9ZIEcy3aUgKz1ZEdhPNx4FKD1FJc3DT66T2T8PXdqAWcCXjqnxEbqDZgel
         kmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KSYFmnA9eWWLhRZS08HYOCsYCy2SOuZ4e0aM+KE0WVc=;
        b=BCVB7MQ85SR6Dibb5P2/n9Zed+qSTTcK1MNKp/ZFNp6dnjtudz3hfgbolDKySTMYWD
         WnFxY8eSOkg2ezxQXjH820ypdn3+FH04d+3vg4btVIzJp4kdei/SdaysX1ZktU4UuFry
         bE3DUnO2SSxgYUvqLyPuMn2WXorc1JT2NCq/9zPv8E7MD0Nlisl91JJ2q5vWDfCWB10p
         +uwV75bgl67MgEf/CqTdgbOd/xKhf9BXWnxoOEZbfLb487au0g53kKR5m2JG2v2p+qYM
         jRZAlyDRrQHlbjeTNyW3N/Lw8x9PQjsUpx0hbGXC+/FtILIGhsiYPhJEOT47kF3zHde3
         qNYA==
X-Gm-Message-State: APjAAAVNGxNBOecrhqe/Q0k0ZIOdcmPbSluj2iNWgqlfhTUgmxRBwu3e
        U9Ee567vsSvhcBOKjhRHOmqcvd7Cz2WAO9AJCTY=
X-Google-Smtp-Source: APXvYqz/LEs1QdSNRfkt+ypL+QM5F568mGeQcYUfzZeAMEjhGP4XuGG0PdcYZLPcOShkWOGJd3v4F/jjK27Xx0NtDgo=
X-Received: by 2002:a2e:a294:: with SMTP id k20mr19646012lja.118.1558036217477;
 Thu, 16 May 2019 12:50:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190516033927.2425057-1-andriin@fb.com>
In-Reply-To: <20190516033927.2425057-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 16 May 2019 12:50:05 -0700
Message-ID: <CAADnVQLgL5NNbMjxUHhh1ydABTUnv2jrmah-hsweF0fPu0AY9w@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: move logging helpers into libbpf_internal.h
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 15, 2019 at 8:39 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> libbpf_util.h header was recently exposed as public as a dependency of
> xsk.h. In addition to memory barriers, it contained logging helpers,
> which are not supposed to be exposed. This patch moves those into
> libbpf_internal.h, which is kept as an internal header.
>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Fixes: 7080da890984 ("libbpf: add libbpf_util.h to header install.")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
