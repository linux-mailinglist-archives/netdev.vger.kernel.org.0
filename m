Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A004B2FC356
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 23:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbhASWZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 17:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729645AbhASWZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 17:25:01 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A64BC0613CF;
        Tue, 19 Jan 2021 14:24:21 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id q2so41351313iow.13;
        Tue, 19 Jan 2021 14:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EadHn0p5gKnVuIymeerOy3CQV3eLQ3su75tNWBGiCuQ=;
        b=MJGueoZEJZRrmN/tgyulQV0hLaATz7ozk9aLX4rafkwOmF09XAsz5r8iWl4INoccbY
         ea03blbJ1MYtpop0Ew3NRDR07gl+4ntDYz088i5XRXWdFqr1z0Z+VedmIWpsOyzhSaOh
         o7waqqB2UTGLsR/p8OPyVaAwoqVpv+ZYJaPhm0AbIsUWH+CnOH8p1zvIruWu6/9RuThm
         N9HLdbcUoewHf2MYnsBFv84VM4pN+UuuPN7WSh8dtQFrMmwhwKeaqSdKc0pFBaESQiNq
         CrbPVWpxnZzKqEK5R4bPsM1Zgj6pGxeWok0RYq2HSkb6dpmUXCi+DZcW/6CKAbgd6B/N
         xECQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EadHn0p5gKnVuIymeerOy3CQV3eLQ3su75tNWBGiCuQ=;
        b=W7ZMX127FX+wEFH2GHdQ3cBjy1WdzHr8Aq9gBPIAhnZ63cCh59eLDbf3d5gva20FYt
         zMJ8+79c/kghk9XbmvYPDPI4mocgA63RmrMDa5PHA4cUD5VtPLccyieoAYiyqAfvtBxF
         q8mEcXx5bzGJ09CMWVKLeRh1meTot1FzG0piifwNs3gj/RynEm6/Sp6J5L1cbtoeWH9z
         vIvDZfFD6Cvq1Sxi1VgNxrkH/Y6NweCr6C863InIXUFwCFm9TCLxzbR7vhclwKmokGyR
         rgbPSOAvDl7rY+pZlgpk47tTPLcCdSA8o8JWGwQxV/LLJsBo5JwO9/z+VfVUZREUk+Jg
         TBcg==
X-Gm-Message-State: AOAM532E30JspMY9lt/W4UXRjSiFEbhzjQQzzn0jWPPY26XwNR35OAsh
        P9tx78H1Li6qqHv3F3GvvvB3keT49Cxin/evmPc=
X-Google-Smtp-Source: ABdhPJxrjJRymcHTUnxi5DKTrTjveAMZWdIpGoLXeKvcvoYWgVOR3KuFI2PIFyiyfIwn3LWLsIaTphGK9nA3jkCZiI8=
X-Received: by 2002:a92:b6dd:: with SMTP id m90mr4633894ill.97.1611095060520;
 Tue, 19 Jan 2021 14:24:20 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610777159.git.lucien.xin@gmail.com> <34c9f5b8c31610687925d9db1f151d5bc87deba7.1610777159.git.lucien.xin@gmail.com>
 <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <aa69157e286b0178bf115124f4b2da254e07a291.1610777159.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 19 Jan 2021 14:24:09 -0800
Message-ID: <CAKgT0UencO4hnti1ShWpVUmKm9M0Y_MHHLkGvX-0UQNwYtT+ow@mail.gmail.com>
Subject: Re: [PATCH net-next 2/6] net: igb: use skb_csum_is_sctp instead of
 protocol check
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 15, 2021 at 10:14 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Using skb_csum_is_sctp is a easier way to validate it's a SCTP
> CRC checksum offload packet, and there is no need to parse the
> packet to check its proto field, especially when it's a UDP or
> GRE encapped packet.
>
> So this patch also makes igb support SCTP CRC checksum offload
> for UDP and GRE encapped packets.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
