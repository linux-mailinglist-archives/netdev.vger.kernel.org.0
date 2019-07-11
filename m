Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D2765172
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 07:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbfGKFbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 01:31:04 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35840 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfGKFbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 01:31:03 -0400
Received: by mail-io1-f65.google.com with SMTP id o9so9911769iom.3
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 22:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pAQB/Y8xs+j93HMSHAN7MXn/ps2uNzO6vXJO40MXdLo=;
        b=tlujGk14eGvspjpjzlMJmJGPW02ZKCrBcsclMROZe/a6wEB1zT6ARD+16mYnoln3Bd
         C5cEIdwuz381gl7n0x/q4a0FTllb+DHxC/hdNoztgjK+LfHuKMvyJDxEIpk3c70Yt9gz
         mJ0vwYH0yywTxG/5e+xw1ynpfgGLVwDzUfeTOAgFoFNWQx+JwCJoHo8zl4KHxwjMcTOR
         /SIYSJWrDPkxsOeUfDnEo2EPW6NSmdvNpvBGvPRu7n6d81/r/U4NVmYRY2HbNgPr9wn2
         WlqZeqQSLGUrw5O02HXV+ulvt9JbfIEGQKjQQneSyVVgMYBEkgIxvUHJD3saCpcGOCa2
         basQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pAQB/Y8xs+j93HMSHAN7MXn/ps2uNzO6vXJO40MXdLo=;
        b=FjIDgm55to8WetxR+7cRIPBUnqh0JouyumyvfwtZbT6v+Mxz8cltsrfle0RAGrCdZI
         jF23Vh4ITVYzF3EeYZCVS1Epgx8npk3VmvvJ11nMiWxFlHdNkgDWWIuMxUaI2LqVDGpD
         iHQ6RcHErs1nCezhF96zxv3wTdA2pop3ZnNkCqTJfhQ2U5jIW3tokLIzXytIP7Oge8iw
         4LtdPx1aldFvbkGlJxzMH+npm/XUeiBtVRcqq9TDCdPiaXOI+gT/pUlCwzYXL/SjJbFb
         rL8OZYt9jblC0tzs6loZ708c2Eqk5ht0IHtTyymcShGdBFdzgfM/Okae4d1wLaoaYbf0
         jltw==
X-Gm-Message-State: APjAAAXJcKoCJvIr7nCsgVMmv2uwooLXWYA0q+FGy4d5mOApAyWq2l92
        x+1sWcXO1HqWMjLcDDhIEQ8Lg9geBfzHX8ck57JpoA==
X-Google-Smtp-Source: APXvYqzeXQAxMqqaOK5d+BWM+pZVriw+5T4jAe3tCL/W3XE/0CCY1rQEeU4zeQZbRtSaxxq/VzYEwl+DFPtWBgwCXUw=
X-Received: by 2002:a5e:9e42:: with SMTP id j2mr2374159ioq.133.1562823062694;
 Wed, 10 Jul 2019 22:31:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAPpJ_edDcaBq+0DocPmS-yYM10B4MkWvBn=f6wwbYdqzSGmp_g@mail.gmail.com>
 <20190711052427.5582-1-jian-hong@endlessm.com> <20190711052427.5582-2-jian-hong@endlessm.com>
In-Reply-To: <20190711052427.5582-2-jian-hong@endlessm.com>
From:   Jian-Hong Pan <jian-hong@endlessm.com>
Date:   Thu, 11 Jul 2019 13:30:25 +0800
Message-ID: <CAPpJ_eeD67KHXEVG6y95EprKvM6MQNH30AyDcXQicjpTObwoSA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] rtw88: pci: Use DMA sync instead of remapping in
 RX ISR
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-wireless@vger.kernel.org,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Daniel Drake <drake@endlessm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jian-Hong Pan <jian-hong@endlessm.com> =E6=96=BC 2019=E5=B9=B47=E6=9C=8811=
=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=881:25=E5=AF=AB=E9=81=93=EF=BC=
=9A
>
> Since each skb in RX ring is reused instead of new allocation, we can
> treat the DMA in a more efficient way by DMA synchronization.
>
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Cc: <stable@vger.kernel.org>
> ---

Sorry, also forget to place the version difference here

v2:
 - New patch by following [PATCH v3 1/2] rtw88: pci: Rearrange the
   memory usage for skb in RX ISR.

v3:
 - Remove rtw_pci_sync_rx_desc_cpu and call dma_sync_single_for_cpu in
   rtw_pci_rx_isr directly.
 - Remove the return value of rtw_pci_sync_rx_desc_device.
 - Use DMA_FROM_DEVICE instead of PCI_DMA_FROMDEVICE.

v4:
 - Same as v3.

>  drivers/net/wireless/realtek/rtw88/pci.c | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wirel=
ess/realtek/rtw88/pci.c
> index c415f5e94fed..68fae52151dd 100644
> --- a/drivers/net/wireless/realtek/rtw88/pci.c
> +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> @@ -206,6 +206,23 @@ static int rtw_pci_reset_rx_desc(struct rtw_dev *rtw=
dev, struct sk_buff *skb,
>         return 0;
>  }
>
> +static void rtw_pci_sync_rx_desc_device(struct rtw_dev *rtwdev, dma_addr=
_t dma,
> +                                       struct rtw_pci_rx_ring *rx_ring,
> +                                       u32 idx, u32 desc_sz)
> +{
> +       struct device *dev =3D rtwdev->dev;
> +       struct rtw_pci_rx_buffer_desc *buf_desc;
> +       int buf_sz =3D RTK_PCI_RX_BUF_SIZE;
> +
> +       dma_sync_single_for_device(dev, dma, buf_sz, DMA_FROM_DEVICE);
> +
> +       buf_desc =3D (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
> +                                                    idx * desc_sz);
> +       memset(buf_desc, 0, sizeof(*buf_desc));
> +       buf_desc->buf_size =3D cpu_to_le16(RTK_PCI_RX_BUF_SIZE);
> +       buf_desc->dma =3D cpu_to_le32(dma);
> +}
> +
>  static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
>                                 struct rtw_pci_rx_ring *rx_ring,
>                                 u8 desc_size, u32 len)
> @@ -782,8 +799,8 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, st=
ruct rtw_pci *rtwpci,
>                 rtw_pci_dma_check(rtwdev, ring, cur_rp);
>                 skb =3D ring->buf[cur_rp];
>                 dma =3D *((dma_addr_t *)skb->cb);
> -               pci_unmap_single(rtwpci->pdev, dma, RTK_PCI_RX_BUF_SIZE,
> -                                PCI_DMA_FROMDEVICE);
> +               dma_sync_single_for_cpu(rtwdev->dev, dma, RTK_PCI_RX_BUF_=
SIZE,
> +                                       DMA_FROM_DEVICE);
>                 rx_desc =3D skb->data;
>                 chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat, &rx_=
status);
>
> @@ -818,7 +835,8 @@ static void rtw_pci_rx_isr(struct rtw_dev *rtwdev, st=
ruct rtw_pci *rtwpci,
>
>  next_rp:
>                 /* new skb delivered to mac80211, re-enable original skb =
DMA */
> -               rtw_pci_reset_rx_desc(rtwdev, skb, ring, cur_rp, buf_desc=
_sz);
> +               rtw_pci_sync_rx_desc_device(rtwdev, dma, ring, cur_rp,
> +                                           buf_desc_sz);
>
>                 /* host read next element in ring */
>                 if (++cur_rp >=3D ring->r.len)
> --
> 2.22.0
>
