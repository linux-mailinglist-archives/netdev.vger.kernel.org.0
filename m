Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C853F1305A5
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 04:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgAED7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 22:59:49 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:35517 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbgAED7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 22:59:48 -0500
Received: by mail-il1-f195.google.com with SMTP id g12so39840927ild.2
        for <netdev@vger.kernel.org>; Sat, 04 Jan 2020 19:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=18eeNYVg+KdDF1S+2I6rv209/QUZx5FUuIM8coNW8m8=;
        b=jyFipO2POzwWukyslGl9kEJPHx8hsy6fsmOYtkWSHRnOEhAVwoR0+RViJD5oxGcDxQ
         00kf2NmdAwL+OmpoFK7h+CdyvKRSTjb+iELijQSvNHAub9Ajy9I0h9WFa1fAYff/obvd
         +MioUTt6U5fOndHT4pFzwuG00pE6/oDpE89iebL39Ilefzh90bJUZjg8Rw9384muJO+O
         mEo1KpkGw1MPTsqeA0uBda673eitJYa9R/AUS/UnJPKK65SGMJO45KXBdsttRk369lLK
         Hlsl4Hkn6AXpG8O5whsVSRLRXJ/iJ9JvMRpqp2xQ5PIvm4Za4dPq5cxoSlof+g019O0u
         Sw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=18eeNYVg+KdDF1S+2I6rv209/QUZx5FUuIM8coNW8m8=;
        b=kLqSJA2Pu4lE5Jxcl/sCCk39Ic8LMckV6Ct5DTA+w0shemUl5dw48GcnE5xGyjeqof
         DhXFJFo82HJcAZf4uYL8wypEXe4O5+1f4Zf24N0kjoDtJSf5AzHhpYLltsXD7ug9AKgd
         PhjdTmUkK1eXLof4dAY98gAchwmnN2B84d1QIpkSTx1mMVUDE+6oTemstT6/e6466wyk
         Vm8CZ7rihT7S+8gAfGbM/k0DSeVyzjk6xHoFZC0l9wntr0Uyskw1/DgT37RCZEiZclxj
         nEOk3/43lI0eoV8y046kui+SZKvPUF+cC41vsbDDzrm47DU9byFiQ5zx4xS+IeNeXCM2
         4BBQ==
X-Gm-Message-State: APjAAAWsm9hfKDEOkZePg707Rx5/VG5XQoigdiFfFajiMQgJzncgGoCu
        DoPCXvAyAJo+UoNxOrI5gRyTaWmMisfmrFS5j8s=
X-Google-Smtp-Source: APXvYqx2WZg6r4psTzEjOlMsvzz/gzI6kJU8D0XgViCZPsf8wLJf95RtXfyH9s1p/cPrlu1Lmb3pYlratReSFRVZIG0=
X-Received: by 2002:a92:350d:: with SMTP id c13mr84856467ila.205.1578196788198;
 Sat, 04 Jan 2020 19:59:48 -0800 (PST)
MIME-Version: 1.0
References: <20200104221451.10379-1-andrew@lunn.ch>
In-Reply-To: <20200104221451.10379-1-andrew@lunn.ch>
From:   Chris Healy <cphealy@gmail.com>
Date:   Sat, 4 Jan 2020 19:59:37 -0800
Message-ID: <CAFXsbZrFqg1aRWG8uqMwv2c77O=s1HYncnbQ9u2MFq20VD=OPw@mail.gmail.com>
Subject: Re: [PATCH net v2] net: dsa: mv88e6xxx: Preserve priority when
 setting CPU port.
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested-by: Chris Healy <cphealy@gmail.com>

On Sat, Jan 4, 2020 at 2:14 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> The 6390 family uses an extended register to set the port connected to
> the CPU. The lower 5 bits indicate the port, the upper three bits are
> the priority of the frames as they pass through the switch, what
> egress queue they should use, etc. Since frames being set to the CPU
> are typically management frames, BPDU, IGMP, ARP, etc set the priority
> to 7, the reset default, and the highest.
>
> Fixes: 33641994a676 ("net: dsa: mv88e6xxx: Monitor and Management tables")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
>
> ---
> v2: Fix a couple of spelling errors.
> ---
>  drivers/net/dsa/mv88e6xxx/global1.c | 5 +++++
>  drivers/net/dsa/mv88e6xxx/global1.h | 1 +
>  2 files changed, 6 insertions(+)
>
> diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
> index 120a65d3e3ef..b016cc205f81 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1.c
> +++ b/drivers/net/dsa/mv88e6xxx/global1.c
> @@ -360,6 +360,11 @@ int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
>  {
>         u16 ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST;
>
> +       /* Use the default high priority for management frames sent to
> +        * the CPU.
> +        */
> +       port |= MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI;
> +
>         return mv88e6390_g1_monitor_write(chip, ptr, port);
>  }
>
> diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
> index bc5a6b2bb1e4..5324c6f4ae90 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1.h
> +++ b/drivers/net/dsa/mv88e6xxx/global1.h
> @@ -211,6 +211,7 @@
>  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST         0x2000
>  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST          0x2100
>  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST             0x3000
> +#define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI     0x00e0
>  #define MV88E6390_G1_MONITOR_MGMT_CTL_DATA_MASK                        0x00ff
>
>  /* Offset 0x1C: Global Control 2 */
> --
> 2.24.0
>
