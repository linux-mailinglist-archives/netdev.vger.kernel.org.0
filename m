Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9AD429E6
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408869AbfFLOtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 10:49:31 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33633 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732553AbfFLOtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 10:49:31 -0400
Received: by mail-lf1-f65.google.com with SMTP id y17so12365623lfe.0;
        Wed, 12 Jun 2019 07:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xEKT6ItiZQHVhHf54W42oiyZcYvIqaQ579wMUJoLtLc=;
        b=POYD+8CxBItHMDs3+dOewoJ9vXWx8ZfLpkap2WxaRkaR0pSUJkpPK/PdqyaQCJSNuB
         DmmWRHYKYOV04Zi4LlYpq3yNsa/3SQDtImpJrtkdVsWylxZ71pm0L5DUNqIcsCv2uSso
         d1EyL0UhLHPHdI0bB+5ZwqweGHBx2vGMp6eQXOcEkPfInjjTesDk5ZbxCdsDHFxqcz0/
         +dBWc1uMJipk3VAwAAOxjdhq/2Pqy6D78gGr3SczRr2UbF/qfrMejNY1O0pdTMMcDURq
         PhNkhxJNgnVkFWSOgsu1BFT9ioNDyt/SQsns84hNeNjkH5ar1EEZ/je0Ng+lq40aIAHW
         jfHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xEKT6ItiZQHVhHf54W42oiyZcYvIqaQ579wMUJoLtLc=;
        b=tlH8mA+4YkrYksT8pUfXpDqaMGB5TiLh0+dGtQSdrIo4eXUPW/7nVs3ploaLsbM6/O
         UJZg9WEzJhd3LwHmZMYAvePffYrpIbyqPYAf/M3+BR26NQbCbK80fndRJ6g+b1FGevtO
         IB1MyRjkJyhJ8PB6JmkwBPaKHWA+p5dxR4mPz4iWkEDlKpdAshsLGBVQT+d09BCGWCmU
         6kf6RfazVaTmca9TbdC1RwST5Rs4dqQ93tLA1+KlKkPIUAzgWfeeD+BHr653Qr5lZDBV
         FokLVTqixjRSo1WzsPViLGnMjK2wmw/4kXLu+q7PWgCGUYR9eOHPDAdMMikVb0/VjGID
         XLSw==
X-Gm-Message-State: APjAAAXmhaTSxjO8S30DIVtHUXYKguHjfm+kfnanut16FFPla9LDa2VR
        IOnCBMI1AolW3p6AOIW9Rm2oHO8KXMWpDalwUCg=
X-Google-Smtp-Source: APXvYqz3x46DS6iUxojDs9ZM6LZTE/NGP7E799OcOVLOMtWEww2bEKHAJOBdRjb0MGq0QrsuT80f5rE+run0i0iEhWg=
X-Received: by 2002:a19:ab1a:: with SMTP id u26mr3825421lfe.6.1560350969202;
 Wed, 12 Jun 2019 07:49:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190612132645.19385-1-m@lambda.lt>
In-Reply-To: <20190612132645.19385-1-m@lambda.lt>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Jun 2019 07:49:17 -0700
Message-ID: <CAADnVQKNmAp-HeVE3-r_GV0in=PuVU9UE6LZ=-+09zzRWyyGEA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Simplify definition of BPF_FIB_LOOKUP related flags
To:     Martynas Pumputis <m@lambda.lt>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 6:25 AM Martynas Pumputis <m@lambda.lt> wrote:
>
> Previously, the BPF_FIB_LOOKUP_{DIRECT,OUTPUT} flags were defined
> with the help of BIT macro. This had the following issues:
>
> - In order to user any of the flags, a user was required to depend
>   on <linux/bits.h>.
> - No other flag in bpf.h uses the macro, so it seems that an unwritten
>   convention is to use (1 << (nr)) to define BPF-related flags.
>
> Signed-off-by: Martynas Pumputis <m@lambda.lt>
> ---
>  include/uapi/linux/bpf.h       | 4 ++--
>  tools/include/uapi/linux/bpf.h | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Makes sense to me.
Please split it into two patches.
One for kernel uapi and one for user space.
Since user bits are synced to github/libbpf independently.

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
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 63e0cf66f01a..a8f17bc86732 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
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
