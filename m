Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77DB9104F78
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 10:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfKUJl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 04:41:27 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43484 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbfKUJl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 04:41:26 -0500
Received: by mail-wr1-f65.google.com with SMTP id n1so3474654wra.10;
        Thu, 21 Nov 2019 01:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RHzvhSWDIF17bAOokqKZSwpGKUwX4v9Vyo2hjUcr/+k=;
        b=l5ugN99eVoPqJAzMroS78+UwJlBGWflqU7XpwuKuaho/2AZyQTwfl8OiFO3oA+ohSt
         KtUNfBZadkJUH9Uu/Yb8oN1MXyOVuNZvtKT5g2IEVgtIt7yl6TfhMlQT5HGJt00J2YW/
         mObSrPqXpaUUAtiX79kHoVL19FjQPOKdsdm0lgY52NiiqCxcC2FzE1NuJe7URA6gF2qU
         mmitP3uU3+hmHp7VcLJo4m/nUXB36caSt6Slqy6Yp/WQDaIrmFtcBemG4P0v0+pxftcA
         9lWjT4EFx/EuQ4Z0o0gjtbh58TeMCMs4yanggLm0NrvM+Rf6cY8MZy8iAdqEIo1Tt5vV
         tS0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RHzvhSWDIF17bAOokqKZSwpGKUwX4v9Vyo2hjUcr/+k=;
        b=c4vhwdiLBQbFuq9x3lNRFsWZpnXnfj0gubiAWsTG59M4znCAHzPKbcd35+HzJH6Pet
         3jZS2vlAaoDIOO+sBMxszkseczDhor18T5aCnaNnBlOz4GMj12mbG5MczM+PlfM3WW6A
         sm8K3HpBxZN9zBvw5QIA1FSvBKBiK3LWEjKB8TUQJpclCal6yYPLnbDA9L8NE57NwDUd
         t0XcqDAo7Da7K9fa59X/YJ6Z1VivsC9lD7yYiluiFTuyewpE9gko3yZ9ZeiJloucNQBC
         R8BgNV3PdkdwpG35muWUDqKzfar2WVqlfvaRKjptr/kKN+FtoyXhBLgQHloC7EuJT/Ho
         eUvw==
X-Gm-Message-State: APjAAAVHOxYjnHIo5L6UW77krXnSdBEIB0EtgK9Nxcp/WCOl20pno5hw
        3OZW1+ZgOGtQzUMK32nDFocU2k0GPq466YXy2/s=
X-Google-Smtp-Source: APXvYqy+r7Kvxfm5IbjSNLg82FBuYIhyWRE4hcSw0THrmoDVd/MQsKSKqcMSk1AFRQHIbEPFE4tEibFQ0MOH5oMZHZo=
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr8922401wrt.229.1574329284460;
 Thu, 21 Nov 2019 01:41:24 -0800 (PST)
MIME-Version: 1.0
References: <20191121092146.hnvdwnzpirskw3wr@kili.mountain>
In-Reply-To: <20191121092146.hnvdwnzpirskw3wr@kili.mountain>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Thu, 21 Nov 2019 15:11:13 +0530
Message-ID: <CA+sq2Cf=u509E-er_N8rzgkP4XdetNpogNqn+AVv-9AzmoQKrg@mail.gmail.com>
Subject: Re: [PATCH net-next] octeontx2-af: Fix uninitialized variable in debugfs
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 2:53 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> If rvu_get_blkaddr() fails, then this rvu_cgx_nix_cuml_stats() returns
> zero and we write some uninitialized data into the debugfs output.
>
> On the error paths, the use of the uninitialized "*stat" is harmless,
> but it will lead to a Smatch warning (static analysis) and a UBSan
> warning (runtime analysis) so we should prevent that as well.
>

Thanks for the fix.

Thanks,
Sunil.
