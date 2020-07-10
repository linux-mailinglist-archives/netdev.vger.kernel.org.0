Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BA221AC95
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 03:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgGJBu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 21:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbgGJBu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 21:50:56 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7B4C08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 18:50:56 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id k18so3275576qtm.10
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 18:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NJy+hFU/6xoC7X1qZQLVILhIMn28YhKI500+P1RXOH4=;
        b=EArwtel4TdIggpTJrjYBP2LZ8JibVqCm5PFKaph/mbXjd0OaK/O9eIBooGoxzbCZeE
         nz9WJM85yDiBXAf+XiJfPR6M+SJ7F5fa/hsp+yk2adTpyegeSd2DgycCwYQ9kzdcZrBJ
         pr6jPKULOmkKqlDKAqgxlFa3k4UDD/yC7oe94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NJy+hFU/6xoC7X1qZQLVILhIMn28YhKI500+P1RXOH4=;
        b=QMQ9yNpFwaL/dzoPfWc5FSPPB9hBfGwHvkhVexG0FfwvnWpG4iYZvn/r2+fCWwmhwc
         Ux9q6WDFICJr8yLZSAijhL+A6U6FJ2UsExxma9zo9RqH3vUk9ebU9j2vq9v6KMxhJCGf
         52M4K5O/6Zx21Cj+1ET0CiSJ29Lum/DZq8ThLDZh8nKT/3aAx7r5TAB3/lLdTjWaSJSF
         /pu/tZCyDkrUSwR4qhR7N4akGMqfSxt6C9N0cHqtmH51i3v2Wq4vqPKKWTHgX69O2kbQ
         EcXSjtkStTC6mc8PYJ43YTxuF295RJuN4N7v404fHZ6lcmPIt4iWGwxSZRnje1IUH4ck
         N1RA==
X-Gm-Message-State: AOAM5332FLfrGI/WwLbnoJAIvhQe9PzwOIQeyzCVAdhMyhBKqpB1Q9OI
        rdhSyF5vQU21Ozm2loO11+dtRcZ6yiC81Opv1L8ATsY+
X-Google-Smtp-Source: ABdhPJwsEBxbfN3ecBg1CQJmTU25uYEmExZ8rZt7q/2Fnw/a6qVn7JpySTFANpit9BTJyRkxdDiHEbDSlObphEzBTfg=
X-Received: by 2002:ac8:47c8:: with SMTP id d8mr24340490qtr.32.1594345855557;
 Thu, 09 Jul 2020 18:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200710004253.211130-1-kuba@kernel.org> <20200710004253.211130-10-kuba@kernel.org>
In-Reply-To: <20200710004253.211130-10-kuba@kernel.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Thu, 9 Jul 2020 18:50:43 -0700
Message-ID: <CACKFLimdXGgYOQZE7hpDdO=ivoDV9avx84q8Laty+RRBEW=tSw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 09/10] bnxt: convert to new udp_tunnel_nic infra
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        emil.s.tantilov@intel.com, alexander.h.duyck@linux.intel.com,
        jeffrey.t.kirsher@intel.com, Tariq Toukan <tariqt@mellanox.com>,
        mkubecek@suse.cz
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 5:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Convert to new infra, taking advantage of sleeping in callbacks.
>
> v2:
>  - use bp->*_fw_dst_port_id != INVALID_HW_RING_ID as indication
>    that the offload is active.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Thanks.
