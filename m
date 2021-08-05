Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462DD3E1574
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 15:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241654AbhHENPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 09:15:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241638AbhHENPk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 09:15:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A099761158;
        Thu,  5 Aug 2021 13:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628169326;
        bh=4NIJtcb7LVpgprmnn/ZQlhukqiHdGqkRtLckoCaJvdU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CXMAY1T79Sm5k41dm24uwiU6PcIptSDxPc2jrnQZZfS4DYXRDYHqJFZ2TMUkC6M9Y
         OaLduJy3BOjlphF+ILGXT+YYadrCr7e/oKej0qM1CRFAoK2wbAVaRyDP+TJajWb7ts
         o+ueEqX6GEvDxOHPOJHHZU2//aFH1/SFA5bhnOvsFl/iALJW+NGNR87OQa4RwLlWOD
         BxBUaKmdQulg/kiIKc4AA5VGhjWKUUS1j+86LzPw3IW2OC6PiHCaItWv6UeUNKOKg8
         POf9arRFTLRyljTghiL8jbmGj/qOxsriuLzHUSuPItuHQCrLPfSVgi39caFNRjr2OP
         jhw5LCR2jQqsQ==
Received: by mail-wm1-f51.google.com with SMTP id m28-20020a05600c3b1cb02902b5a8c22575so3464679wms.0;
        Thu, 05 Aug 2021 06:15:26 -0700 (PDT)
X-Gm-Message-State: AOAM532RgdvALtbzSOFF+jNUdXpPjSvMfXLw7vX/a/L5NLacPc91JHQW
        V/ApMRV0IirYc0K4RxI+dkP/NP/2tFTOOgR7QPE=
X-Google-Smtp-Source: ABdhPJx+NRm3dfDwrab5xgBSMUaJimXbhghgZk25OYmrxZH/Ca7tSBtp/oA5JvJTFsQKNt64ZbrCT61Tvd4FgcMNRGw=
X-Received: by 2002:a05:600c:3641:: with SMTP id y1mr4884578wmq.43.1628169325222;
 Thu, 05 Aug 2021 06:15:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210805082253.3654591-1-arnd@kernel.org> <CAGRGNgV89tdRvUXyfBCgmYMa3CXQV4oYeMeCq_-g5u1MtUkdKQ@mail.gmail.com>
In-Reply-To: <CAGRGNgV89tdRvUXyfBCgmYMa3CXQV4oYeMeCq_-g5u1MtUkdKQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 5 Aug 2021 15:15:08 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2W9s3K4x4MpaqHfsBOXq+bKAUYHh5hFAh7oExXZYuFTg@mail.gmail.com>
Message-ID: <CAK8P3a2W9s3K4x4MpaqHfsBOXq+bKAUYHh5hFAh7oExXZYuFTg@mail.gmail.com>
Subject: Re: [PATCH net-next v4] ethernet: fix PTP_1588_CLOCK dependencies
To:     Julian Calaby <julian.calaby@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Shannon Nelson <snelson@pensando.io>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        drivers@pensando.io, Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yangbo Lu <yangbo.lu@nxp.com>, Karen Xie <kxie@chelsio.com>,
        Networking <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 2:52 PM Julian Calaby <julian.calaby@gmail.com> wrote:
> On Thu, Aug 5, 2021 at 9:49 PM Arnd Bergmann <arnd@kernel.org> wrote:

> > diff --git a/drivers/scsi/cxgbi/cxgb4i/Kconfig b/drivers/scsi/cxgbi/cxgb4i/Kconfig
> > index 8b0deece9758..e78c07f08cdf 100644
> > --- a/drivers/scsi/cxgbi/cxgb4i/Kconfig
> > +++ b/drivers/scsi/cxgbi/cxgb4i/Kconfig
> > @@ -2,6 +2,7 @@
> >  config SCSI_CXGB4_ISCSI
> >         tristate "Chelsio T4 iSCSI support"
> >         depends on PCI && INET && (IPV6 || IPV6=n)
> > ++      depends on PTP_1588_CLOCK_OPTIONAL
>
> Extra +?
>

Indeed, this must have happened when I rebased onto net-next after
testing it on my current randconfig branch (which does not have the
typo).

v5 coming, thanks for noticing!

      Arnd
