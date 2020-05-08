Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4761CBB0E
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 01:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgEHXFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 19:05:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgEHXFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 19:05:03 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100C7C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 16:05:03 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id c64so3547011qkf.12
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 16:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiUVa5mVO89jeXQmai25H32mWUhzjICjk7pOMJIJk4M=;
        b=aeIWvzPXDXfpoIWJD4RSKGQirPc8lgF0hCA7z+WnsTXlqRhUtPwt4ABFjTPGSQ4MmW
         co9aA/P0GUUUWqi2b2tLG/UGKjI5T4MsFL7wOEefM5SJJFRdXctIb9yoofcvfMBAhpvX
         J/QuNRxp4qHlOOtTwNwjrBQweLSXxjbnyo68o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiUVa5mVO89jeXQmai25H32mWUhzjICjk7pOMJIJk4M=;
        b=nvnnqHCXzwvby7eDYjG2aClV5kEt4AF/W4yeC4numqluS6v3bia5EQdJY/qS+JRzOx
         NMbrNQGOtYSKXziKYmz7BZqDGgwUsrdTBz7O0m2+dio3NvpY4LGQ2s7KEEa+Qri56cvP
         jIHv/FMTnMf5HAGmx3M9gKyggC0NdN5hbEErA8FdD8vDEjU2X4wqDIepXzdL9qyb8q87
         RT+pCzyaADZnsb0X4YxT0hnah/GTTIJtgiiDON/EGAsXyVOZbI0y2kfsTfBoaxc1g17+
         4eTy9iod6myflWGCZF6xFOIsavavEgGQ4lP13UHZVSozXCjskt2/AJC5iOmeEF1BlL5A
         a0Gg==
X-Gm-Message-State: AGi0PuZC5EivYuHX6tC8zkKf27uoGtnQMMCiaYHgppT3zauLAYQX2At9
        SDUxh/e2Gk2vMQewnfI+3FZJj4OUPj5tpiQVletMlw==
X-Google-Smtp-Source: APiQypKgAkoL81J9siZ6ExsdQxNJg8FR8V54RCPQtvmozJqNCBpzRhfXUIlX/5mNKADU/Vf82qndSg3c1Brdxm5ukPo=
X-Received: by 2002:a05:620a:4f0:: with SMTP id b16mr5114221qkh.165.1588979101996;
 Fri, 08 May 2020 16:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200508225301.484094-1-colin.king@canonical.com>
In-Reply-To: <20200508225301.484094-1-colin.king@canonical.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 8 May 2020 16:04:50 -0700
Message-ID: <CACKFLinpQFupdmq63RH527sDrAj4nrV4vcR+eDy5zh4KqLh8Dg@mail.gmail.com>
Subject: Re: [PATCH] net: tg3: tidy up loop, remove need to compute off with a multiply
To:     Colin King <colin.king@canonical.com>
Cc:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 3:53 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently the value for 'off' is computed using a multiplication and
> a couple of statements later off is being incremented by len and
> this value is never read.  Clean up the code by removing the
> multiplication and just increment off by len on each iteration. Also
> use len instead of TG3_OCIR_LEN.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/broadcom/tg3.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> index ff98a82b7bc4..9dd9bd506bcc 100644
> --- a/drivers/net/ethernet/broadcom/tg3.c
> +++ b/drivers/net/ethernet/broadcom/tg3.c
> @@ -10798,16 +10798,14 @@ static int tg3_init_hw(struct tg3 *tp, bool reset_phy)
>  static void tg3_sd_scan_scratchpad(struct tg3 *tp, struct tg3_ocir *ocir)
>  {
>         int i;
> +       u32 off, len = TG3_OCIR_LEN;

Please use reverse X-mas tree style variable declarations.  Other than
that, it looks good.

Thanks.

>
> -       for (i = 0; i < TG3_SD_NUM_RECS; i++, ocir++) {
> -               u32 off = i * TG3_OCIR_LEN, len = TG3_OCIR_LEN;
> -
> +       for (i = 0, off = 0; i < TG3_SD_NUM_RECS; i++, ocir++, off += len) {
>                 tg3_ape_scratchpad_read(tp, (u32 *) ocir, off, len);
> -               off += len;
>
>                 if (ocir->signature != TG3_OCIR_SIG_MAGIC ||
>                     !(ocir->version_flags & TG3_OCIR_FLAG_ACTIVE))
> -                       memset(ocir, 0, TG3_OCIR_LEN);
> +                       memset(ocir, 0, len);
>         }
>  }
>
> --
> 2.25.1
>
