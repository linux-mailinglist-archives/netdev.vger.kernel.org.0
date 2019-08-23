Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70B1B9A607
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 05:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391469AbfHWDWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 23:22:39 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:39377 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfHWDWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 23:22:38 -0400
Received: by mail-yb1-f194.google.com with SMTP id s142so3409135ybc.6
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 20:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=icR6uljYTJT+QV52T8+cuAgtClttLlpE8f/dJZhaNeU=;
        b=b2AShZRWt+9MTFhoiavzjQ3aywReLLq/mIBk/Weck/bwbd2GJf/hW/9yHnVZXSNWly
         Y6rA0TF11Gz8P8UrapXC/h7AwqpXRLhF9Wm+rQx8BPPvIyBVrWH4saDkfJLUuye1jwJA
         7BAGlXPYfbZsFHy+z46pewK2B2o8uw5yXfmIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=icR6uljYTJT+QV52T8+cuAgtClttLlpE8f/dJZhaNeU=;
        b=uQEQWSM4UScSrs55qgzoaSjh1dlJNPX2T1cKDtUCRprQRpC2yhTXNd14GjHYmaxFcl
         V1wortibjDSUoLvHwA9A2sjBxS4U585gpNs5PCOsyx1BgKmYco6E+rDVpwAdNkSBoM8+
         9pGekP1TQlmBm+LvPD8b56oc4EyDrflXa4NYBLmir2uCqyKyHgVQvhn3s5ipZDTiTIXZ
         ARXdhGKBk6l08XaOayelK2Bm17FufqPNxDNFLc8zaqSeujujG21RmlNzxUXIBRj6r+jQ
         cdUD6a/iVUPur0o1XjrQigF5Vo0i1p8zhQWKhKzkijpC7xdvr/7AzUhKzIMdHF3dNUS6
         158Q==
X-Gm-Message-State: APjAAAXQSsJh5qza2WvpAVtIHtJp5zVAu8X79EjV5oHTPnWbkmo3+pYV
        oG+wrwjkpCgbvCshiRonfPKSJM4MmNxL1SkzjekEJw==
X-Google-Smtp-Source: APXvYqyA1CA2tjQT7dYqGLfldudSV2GeB5UosBWGyZDiDil4zSikktuGQOxxBFJz495Nsy6FoLBdcDDmHpCTMGZgbS4=
X-Received: by 2002:a25:3557:: with SMTP id c84mr1574747yba.298.1566530557716;
 Thu, 22 Aug 2019 20:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <E350D230-9E45-41FC-ADF5-5CF2317171DA@gmail.com>
In-Reply-To: <E350D230-9E45-41FC-ADF5-5CF2317171DA@gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 22 Aug 2019 20:22:25 -0700
Message-ID: <CACKFLinyPbrxFAdCC442FWoQ9woGeEMm-f+G1eHre5s7_q-DOQ@mail.gmail.com>
Subject: Re: BUG: bnxt_en driver fails to initialize
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 8:03 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On a recent net-next 932630fa902878f4c8c50d0b1260eeb9de16b0a4,
> installing the build on a box which has a Broadcom card with
> the 20.1 firmware, the driver refuses to initialize.  I tracked
> this down to:
>
>         static int bnxt_alloc_stats(struct bnxt *bp)
>         ...
>                  cpr->hw_stats = dma_alloc_coherent(&pdev->dev, size,
>                                                     &cpr->hw_stats_map,
>                                                     GFP_KERNEL);
>                  if (!cpr->hw_stats)
>                          return -ENOMEM;
>
> Where size == 0, so obviously it returns NULL, and -ENOMEM.

Thanks for the report.  I will send a patch to fix this later tonight.

>
> The same build, when installed on different box with the
> 20.6.167.0 firmware, works fine.  Details below.
>
>
