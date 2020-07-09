Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1EC2197D8
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 07:27:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGIF12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 01:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgGIF10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 01:27:26 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E52CC061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 22:27:26 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id e13so714841qkg.5
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 22:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Top+hjt1kvKinZeV3VXOAy5s2ddaCsLylw+2nZp94Q=;
        b=MAvMM/92fRm7eKkwbFea24rjIQ+imcqiLn8C7KCcN4voXaCKhhFi+QMEJkGgX6wjjt
         pS7WFdVjVcixcSU12+N8J1LzKyrSepSrYnTeC+Nep/IaMSBxIFPQ9+WGQjoYq0KW8AyW
         xmnfABhpZSDYslZLyNAoHcO6AHvsGAb+MawTU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Top+hjt1kvKinZeV3VXOAy5s2ddaCsLylw+2nZp94Q=;
        b=VmRXHTYT6Le71hsj9n62Ox2Y5CZDp5p5UnFOUvmfBKMBdPESq5ZNT7NP2Y8lpYsygH
         cdBy9pdekVXlAHLXXHiikRNy+oSISSbz7wsDh8tg10AwHN1orEzqrIskdATnc5ugEdka
         acCYEtFYasQpmlietQI0tB4Tolyl+IZT6Wo6MoZTQumBTz1vSuvLebDOEs4Aa9/Q0yY+
         f3vxn3MHuaCg75gf4io/+vDju5hv5+P656OZdSRx5oMuIusyIf2TMvEcRVA6lpidmnl1
         FMCGO0FAzbrxzs3kZb1s9f+JlIk1K8jOwFs0icP/gBuiqselDf1p1S0TzA5FFIxFG0Dt
         QQiQ==
X-Gm-Message-State: AOAM533n9eDU3vx4sSF3N/uS1/TsUCcCLk37xbWGmjDeiLu13kjeNyb2
        GLfl+xM859PnsBLKbP7IgfRa/ydYGShrzwI90x867w==
X-Google-Smtp-Source: ABdhPJzTUHxUyLrEIPD8RJ+KnTh9kukNlZ4apYofV9j7g+ILIXwTTKA8b0JW60qlDxuiZ3IyDPtpBXE5G+gjslmSPbg=
X-Received: by 2002:ae9:ef83:: with SMTP id d125mr60265494qkg.287.1594272445219;
 Wed, 08 Jul 2020 22:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200709011814.4003186-1-kuba@kernel.org> <20200709011814.4003186-10-kuba@kernel.org>
In-Reply-To: <20200709011814.4003186-10-kuba@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Wed, 8 Jul 2020 22:27:13 -0700
Message-ID: <CACKFLikN6utQT2eXKtnhZFMYxt8Tem-An=6cxX6nXgPiO+k5UQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 09/10] bnxt: convert to new udp_tunnel_nic infra
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, Tariq Toukan <tariqt@mellanox.com>,
        mkubecek@suse.cz
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 6:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Convert to new infra, taking advantage of sleeping in callbacks.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 133 ++++++----------------
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h |   6 -
>  2 files changed, 34 insertions(+), 105 deletions(-)
>

> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> index 78e2fd63ac3d..352a56a18916 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -1752,10 +1752,8 @@ struct bnxt {
>  #define BNXT_FW_MAJ(bp)                ((bp)->fw_ver_code >> 48)
>
>         __be16                  vxlan_port;

We can also do away with vxlan_port and nge_port, now that we no
longer need to pass the port from NDO to workqueue.  We just need to
initialize the 2 firmware tunnel IDs to INVALID_HW_RING_ID before use
and after free.  But it is ok the way you have it too.

I like this v2 version better with the VXLAN and GENEVE types defined.

Thanks.

> -       u8                      vxlan_port_cnt;
>         __le16                  vxlan_fw_dst_port_id;
>         __be16                  nge_port;
> -       u8                      nge_port_cnt;
>         __le16                  nge_fw_dst_port_id;
>         u8                      port_partition_type;
>         u8                      port_count;
