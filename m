Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEAD6542A
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 11:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfGKJwR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 05:52:17 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35585 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728282AbfGKJwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 05:52:17 -0400
Received: by mail-ot1-f67.google.com with SMTP id j19so5242731otq.2;
        Thu, 11 Jul 2019 02:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YnmEAV+3bK+9TtrRTMyEvlRiK/7mNez6zYs1L+5G8+0=;
        b=Ra4Wy3hTusHOAjr04l35ZvJXya4HnK7nQ5e4Jvo5LF3TA5nq3bs6H9Eyu6HPS1TJeg
         GXQYR5SD3WnkxJvko36jjnB26p914drlGBPcHi4JGPVxCG5ZcGSfSX5UcLa/kYdzf4S/
         ZNfZIRFXdDaDKoBQnnVCAgziNawjwpp7EDBe6+gs1z3UNmmp5BaVv+CpnNCrHmDTefkh
         uZsfZ1ty6wBU64Bv8mKyMWc5jC1CnMeBsWXOxVl207a++ptzpr9BXBEpEfjXlYLtQh3p
         lZjiQoUla86U/r58WFqaxtov+TAIOzTNyvytgrCKS63ROis1OG7uugX//qQ/xNshcV6+
         mmvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YnmEAV+3bK+9TtrRTMyEvlRiK/7mNez6zYs1L+5G8+0=;
        b=JjHkNckSCyNYDi1dmp5gTGBlKBtrom9gwNyN+teuXFrteaXT1m7IsXxCqZ/5mYfMRY
         osxhLyt21A/AgKYFLJ7EloyADqp165t2kvdeOIHz+LQybr/rHV0ITQifuTaAEgnevnPz
         RtnhX2tt0l5giYb8VoGPVw3DZAWMrtq6XwoLDa9V29ZbzPayeMxHbh1vBchMrGU7Fri1
         9wFPEoNmJoWhKNVH2+QgFF2XkZky+a5E3LYKTsX/fr1zt7Q5rix17F+yKUtFpuTddeoL
         qpS2AhTUqZFecGzMjrcZq4L3qPx85im8/HewhxN7RawIK6TTuPgZEp0QRgVHPxBOVFVT
         GqHg==
X-Gm-Message-State: APjAAAUFAx3ZtFeVVzGJAoTOtu0M8hBig4LWuFr5f37LEwLSEKinEYnY
        4gMgRbX5dlKR0LCoyZa4a/HokzSbtJ2AiTRYu4Y=
X-Google-Smtp-Source: APXvYqzfX3btBwyMNi/rv82bOVDD7JrGZA9S9HoK/qCYuNHXakkbUso0xterRPhCcI7xVPINhJM/QoABkOcGNjsoNyI=
X-Received: by 2002:a9d:7259:: with SMTP id a25mr591774otk.30.1562838736311;
 Thu, 11 Jul 2019 02:52:16 -0700 (PDT)
MIME-Version: 1.0
References: <1562244134-19069-1-git-send-email-magnus.karlsson@intel.com>
 <1562244134-19069-2-git-send-email-magnus.karlsson@intel.com> <57e022b7-ac0e-6a9c-5078-c44988fd9fe6@iogearbox.net>
In-Reply-To: <57e022b7-ac0e-6a9c-5078-c44988fd9fe6@iogearbox.net>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 11 Jul 2019 11:52:05 +0200
Message-ID: <CAJ8uoz1D7Pfvxw+5jSyCrL8p02_UVkVkQ=AQH6L9WFsq-D3Ybg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/6] xsk: replace ndo_xsk_async_xmit with ndo_xsk_wakeup
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, bruce.richardson@intel.com,
        ciara.loftus@intel.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Ye Xiaolong <xiaolong.ye@intel.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        kevin.laatz@intel.com, ilias.apalodimas@linaro.org,
        Kiran <kiran.patil@intel.com>, axboe@kernel.dk,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 9, 2019 at 1:50 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 07/04/2019 02:42 PM, Magnus Karlsson wrote:
> > This commit replaces ndo_xsk_async_xmit with ndo_xsk_wakeup. This new
> > ndo provides the same functionality as before but with the addition of
> > a new flags field that is used to specifiy if Rx, Tx or both should be
> > woken up. The previous ndo only woke up Tx, as implied by the
> > name. The i40e and ixgbe drivers (which are all the supported ones)
> > are updated with this new interface.
> >
> > This new ndo will be used by the new need_wakeup functionality of XDP
> > sockets that need to be able to wake up both Rx and Tx driver
> > processing.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  drivers/net/ethernet/intel/i40e/i40e_main.c          |  5 +++--
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.c           |  7 ++++---
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.h           |  2 +-
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c        |  5 +++--
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_txrx_common.h |  2 +-
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c         |  4 ++--
> >  drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c  |  2 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.h  |  2 +-
> >  drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  2 +-
> >  include/linux/netdevice.h                            | 14 ++++++++++++--
> >  net/xdp/xdp_umem.c                                   |  3 +--
> >  net/xdp/xsk.c                                        |  3 ++-
> >  12 files changed, 32 insertions(+), 19 deletions(-)
>
> Looks good, but given driver changes to support the AF_XDP need_wakeup
> feature are quite trivial, is there a reason that you updated mlx5 here
> but not for the actual support such that all three in-tree drivers are
> supported?

It should be easy to add it mlx5 for someone familiar with the driver.
I will send Maxim a mail and see if he can contribute a small patch
adding the support.

Thanks: Magnus

> Thanks,
> Daniel
