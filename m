Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5243C93FC
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 00:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhGNWsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 18:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbhGNWsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 18:48:39 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C6AC061760
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 15:45:47 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id e20so5775728ljn.8
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 15:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VZY1MuucrPtSmSp30OAQiYqQAOnsQCoU9oTNEDnDA2c=;
        b=kR7bqFDg5swVOvJGwGKJAKZpmRG8WEVb7WX8p8aUJH2GLKjUGvyXzOPI67BUGEhaR+
         kEhqtVlVnFgNIpjMym1ZBneUelCELU/v43djuxMRgQ32Z3SxwdZ0YsvKR/NPXIR5j/yL
         pBQvn+1zBRt6Qk/mWx8T9NSEZ5IxZNo9KWMkwPBnmw1+4qrk1iuUhMG8sBxara0JAAXh
         QQYN4kbyi6XvD+XycCHZCRjJJfXi3WKSdSPmgHVrIh6YjVNqQk8jHNuzmO47bgnSLBu9
         vCSveCyyMLYLU/b2W00xx41wPNQ3e7a7IE++nBE2EpOeemD8xG8saX0TTM6NAv6o4sSy
         6f0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VZY1MuucrPtSmSp30OAQiYqQAOnsQCoU9oTNEDnDA2c=;
        b=TlMUGh1EKhOl25q0vxQhVen1mT4ifW9UnWYUayM8AnFv5Tf3QJflDzKdIoePt3CArZ
         1ySkKLRIrrAa60JO8xpCHLBMHcueh0PDn1t44PTESl+ucljdMaML5Aw28Q8edr7CQyxn
         Tc1SAc/phqzYVRLRvKo3GubOBmvxq9vac3ix7iM9l4GgckVzfpsKGD4RuFk5ZTvWCahb
         FNjIFc26Ee6qW7y560upueGT/BzsRkxR+92HNFErx2tRT/5GIfJTYug00zaE713CP6fH
         C8NKLUXD3aVICfdH5R7BiIxhs7NQaO0eeFrtGBlaxdX7qocmV/YphUip4Rb2sR6t/zQ9
         diuw==
X-Gm-Message-State: AOAM531O0obLssPjQ2/s4xx2TVQp4tE1L39FYrdS4cVSeoaFJAfDouzP
        9pxq3EeIPnVFprLX1ixy34Pw3yqapx+VqH6IJWVyfA==
X-Google-Smtp-Source: ABdhPJzQQmKwrYEowCzDGnEbtSR4Nzl53qXWclJ23SGLzmPTEsbmXHiK8oAw3gtNqbTVm8GJLWF635Cnsj2CYWkuYhI=
X-Received: by 2002:a05:651c:308:: with SMTP id a8mr140735ljp.337.1626302745344;
 Wed, 14 Jul 2021 15:45:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210714073501.133736-1-haiyue.wang@intel.com>
In-Reply-To: <20210714073501.133736-1-haiyue.wang@intel.com>
From:   Catherine Sullivan <csully@google.com>
Date:   Wed, 14 Jul 2021 15:45:09 -0700
Message-ID: <CAH_-1qzu_X26sUehY9721+yG3xYVw_0eiPGb=0X4p0m7Jv+ddg@mail.gmail.com>
Subject: Re: [PATCH v1] gve: fix the wrong AdminQ buffer overflow check
To:     Haiyue Wang <haiyue.wang@intel.com>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Awogbemila <awogbemila@google.com>,
        Yangchun Fu <yangchun@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Bailey Forrest <bcf@google.com>, Kuo Zhao <kuozhao@google.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 12:58 AM Haiyue Wang <haiyue.wang@intel.com> wrote:
>
> The 'tail' pointer is also free-running count, so it needs to be masked
> as 'adminq_prod_cnt' does, to become an index value of AdminQ buffer.
>
> Fixes: 5cdad90de62c ("gve: Batch AQ commands for creating and destroying queues.")
> Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>

Reviewed-by: Catherine Sullivan <csully@google.com>

> ---
>  drivers/net/ethernet/google/gve/gve_adminq.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
> index 5bb56b454541..f089d33dd48e 100644
> --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> @@ -322,7 +322,8 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
>         tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
>
>         // Check if next command will overflow the buffer.
> -       if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) == tail) {
> +       if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) ==
> +           (tail & priv->adminq_mask)) {
>                 int err;
>
>                 // Flush existing commands to make room.
> @@ -332,7 +333,8 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
>
>                 // Retry.
>                 tail = ioread32be(&priv->reg_bar0->adminq_event_counter);
> -               if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) == tail) {
> +               if (((priv->adminq_prod_cnt + 1) & priv->adminq_mask) ==
> +                   (tail & priv->adminq_mask)) {
>                         // This should never happen. We just flushed the
>                         // command queue so there should be enough space.
>                         return -ENOMEM;
> --
> 2.32.0
>

Thanks!
