Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B35626C0B3
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 19:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388676AbfGQR6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 13:58:41 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:47009 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfGQR6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 13:58:41 -0400
Received: by mail-ed1-f65.google.com with SMTP id d4so26884827edr.13;
        Wed, 17 Jul 2019 10:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eO7nbcftwbGM4xdl7HUrpJSFLczO7ozAf0lOcGpNvos=;
        b=n1gZoVqxV0vV+ydTl97vaK8pVTIA8bhshiyDmmH4wDz0QmPQUc94JxT2cKfdGKvXQR
         u8OLZL7mdgHyK5xHBthbsm7eDGEj1Y+lD1mwjd2zUUanZa2ELAeC8tewKQYfmMDon86k
         MEkdUQX1jjBdENIdpdqVexE2enLQn3eRkJNP6HaPis4GOBLWr/DlCjRtlm5kFOh/lF4D
         o7zsg1mcSsoiVumeAhO//YvnxW3vF3VTpfoj8QJwolwUWG8kGc5Bph96MQ2eQenHmQnA
         jjNEt+nR3huL4jKsACY2dW68tnTYzisOwUgA5z6O+K59nfijzK7jVnF4HlTQazFYCsOf
         +0BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eO7nbcftwbGM4xdl7HUrpJSFLczO7ozAf0lOcGpNvos=;
        b=OsgK3sp8/ZTNU7NQBCzoY6QTe8Wmkq8DM44Gmg3bx6zhRoQU65ugirLlNaglp4pRPk
         N+J7+pdOxKfwJpxBgaxasYNzGtHePEgwKiE6pXGJP4LC/3j3facmKrIhW5ci5NDWjdSI
         qy+/hZaVpPDagqq3O1D4ruYO1AaMbGh0cTv/tP6Fzug/eBjra0z1dI5XdRLBSXfjKHdV
         kpCiLreAcgcuspGkRN11k7Si1xDfSdvGuiBapCuTXW/OzYHLi9sB9Y6zOjt7xUgYyZoo
         ItTsnwB29krPPRpchRHHIZ0agD+pQH3vGDHqIo8NEtsRRxT7YJcULQ325pfWJVt3w0pA
         lWog==
X-Gm-Message-State: APjAAAWVnJ2PXDWp7vLAnLboGLowt4D2Nd9Ei+V98H8XHgQ79x/AD9Rn
        IKkyAhzjfpKcEsyWqPTHuyixy0oojje/02yb7wk=
X-Google-Smtp-Source: APXvYqyaVmfvTIES3x3xjtugP/2cfgkwxZpK69vlVdL2soU0+rgfsWgVfLBSOBiyHGobZFwUDlWo2bY9dma2KLNPRBQ=
X-Received: by 2002:a17:906:19d3:: with SMTP id h19mr32298173ejd.300.1563386319311;
 Wed, 17 Jul 2019 10:58:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190717062956.127446-1-weiyongjun1@huawei.com>
In-Reply-To: <20190717062956.127446-1-weiyongjun1@huawei.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 17 Jul 2019 20:58:28 +0300
Message-ID: <CA+h21hr7whb1yk-W-81neG5kRcJR9iR70wzu93nLA_sjeT+ruQ@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: sja1105: Fix missing unlock on error in sk_buff()
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jul 2019 at 09:24, Wei Yongjun <weiyongjun1@huawei.com> wrote:
>
> Add the missing unlock before return from function sk_buff()
> in the error handling case.
>
> Fixes: f3097be21bf1 ("net: dsa: sja1105: Add a state machine for RX timestamping")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

>  net/dsa/tag_sja1105.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
> index 1d96c9d4a8e9..26363d72d25b 100644
> --- a/net/dsa/tag_sja1105.c
> +++ b/net/dsa/tag_sja1105.c
> @@ -216,6 +216,7 @@ static struct sk_buff
>                 if (!skb) {
>                         dev_err_ratelimited(dp->ds->dev,
>                                             "Failed to copy stampable skb\n");
> +                       spin_unlock(&sp->data->meta_lock);
>                         return NULL;
>                 }
>                 sja1105_transfer_meta(skb, meta);
>
>
>
