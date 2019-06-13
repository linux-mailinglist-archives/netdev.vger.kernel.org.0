Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 507F644553
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbfFMQn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:43:28 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38016 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730477AbfFMGnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 02:43:19 -0400
Received: by mail-qk1-f194.google.com with SMTP id a27so12030084qkk.5;
        Wed, 12 Jun 2019 23:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=flGs/zukBw/aJYyUovVgv99efBK9sWkhQiABa3roI/o=;
        b=megZvWjY8VwSIokUFMGe+HGyYwiYoCZVf4illXjf2hB0iW1H3Zsh8paEAJVEaCB4Wk
         sEiHz6cGLfTiVg0ZCP9qp1sKXyvz5ZsW1IlJgwqZuS9Q4WYjYvuP9SfWACFCnVJA0OIO
         ZT5t4HkobJSBmOUvT+jpWtp33dGEKlD1FFnVRNQqxF71J7pxtWno65N7hbfK6USDiyZN
         PidDNCrwL5ltud6gpaGrkb7ID2ilV+bFZoESs2LiBYIcFYSu4PgtWtaliNZb2p6bXcBn
         7junQwok4iSqE1phqZa9GysUKeIBv6cghuX5pUdnzrrtSCNK+m7wr9G2zV7WpUdEjJt5
         vysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=flGs/zukBw/aJYyUovVgv99efBK9sWkhQiABa3roI/o=;
        b=Hc/kUd8NJ7NPrA8juV8tlsUBsE1Pjhji43HJpSrOl9Oifq5FLhzYC8W9lAcDa54OED
         cfabRjFTXiz4m+xa/WsiSYaHOTvc0rt5PQQwWyv2CXEGDoNlqolTQtA3+u+FmEMKJlZb
         x/5p3E397BqSEWyo69tzf6Z0AQ30EN7UkwYP1b9K98sExSUZ9VTdPk5RPOvS3+jay3TG
         ouJbTf+NLyMVvRncyik3XmVlqVfwqlWFWL4G8j5j9qsAUQexiek8M6sJtVbszWrBgLJ2
         9R6iNPF0nlcgX+16I7RVXioH+TdaUCyfXPwjKo2EQaDsI3ZZVKJjbOcWEDIP6mZSr3W6
         0l3Q==
X-Gm-Message-State: APjAAAW03UxT96Mx6xzfycWvZ+QoMPHM4PhZ/cf/8dJWaWxPrqn18QCc
        qrllUQSH++J8XBDifADvZlGSRuAmttqCxaIhiUA=
X-Google-Smtp-Source: APXvYqy9qKc3dDKrBdfAu5wW1ZVxAlIFPRi1b+Bo2iiKumfS1L0sMfnIgAQQQwf5oA911kNGLXPTt+Iodu+XLWwluYA=
X-Received: by 2002:ae9:de81:: with SMTP id s123mr516623qkf.339.1560408197897;
 Wed, 12 Jun 2019 23:43:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190612160541.2550-1-m@lambda.lt>
In-Reply-To: <20190612160541.2550-1-m@lambda.lt>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 Jun 2019 23:43:06 -0700
Message-ID: <CAEf4BzZHSP=ua_sO=431PXDjNB6mVn7QXFWL12sQAZDjz1D1PQ@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/2] bpf: simplify definition of BPF_FIB_LOOKUP
 related flags
To:     Martynas Pumputis <m@lambda.lt>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 11:06 AM Martynas Pumputis <m@lambda.lt> wrote:
>
> Previously, the BPF_FIB_LOOKUP_{DIRECT,OUTPUT} flags were defined
> with the help of BIT macro. This had the following issues:
>
> - In order to user any of the flags, a user was required to depend
>   on <linux/bits.h>.
> - No other flag in bpf.h uses the macro, so it seems that an unwritten
>   convention is to use (1 << (nr)) to define BPF-related flags.
>

Makes sense!

Acked-by: Andrii Nakryiko <andriin@fb.com>

> Signed-off-by: Martynas Pumputis <m@lambda.lt>
> ---
>  include/uapi/linux/bpf.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 63e0cf66f01a..a8f17bc86732 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3376,8 +3376,8 @@ struct bpf_raw_tracepoint_args {
>  /* DIRECT:  Skip the FIB rules and go to FIB table associated with device
>   * OUTPUT:  Do lookup from egress perspective; default is ingress
>   */
> -#define BPF_FIB_LOOKUP_DIRECT  BIT(0)
> -#define BPF_FIB_LOOKUP_OUTPUT  BIT(1)
> +#define BPF_FIB_LOOKUP_DIRECT  (1U << 0)
> +#define BPF_FIB_LOOKUP_OUTPUT  (1U << 1)
>
>  enum {
>         BPF_FIB_LKUP_RET_SUCCESS,      /* lookup successful */
> --
> 2.21.0
>
