Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6665A8DC7D
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbfHNR51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:57:27 -0400
Received: from smtp8.emailarray.com ([65.39.216.67]:14761 "EHLO
        smtp8.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728655AbfHNR50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:57:26 -0400
Received: (qmail 15602 invoked by uid 89); 14 Aug 2019 17:57:25 -0000
Received: from unknown (HELO ?172.26.122.72?) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTk5LjIwMS42NC40) (POLARISLOCAL)  
  by smtp8.emailarray.com with (AES256-GCM-SHA384 encrypted) SMTP; 14 Aug 2019 17:57:25 -0000
From:   "Jonathan Lemon" <jlemon@flugsvamp.com>
To:     "Maxim Mikityanskiy" <maximmi@mellanox.com>
Cc:     "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        "=?utf-8?b?QmrDtnJuIFTDtnBlbA==?=" <bjorn.topel@intel.com>,
        "Saeed Mahameed" <saeedm@mellanox.com>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "Martin KaFai Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>
Subject: Re: [PATCH bpf-next v2] net: Don't call XDP_SETUP_PROG when nothing
 is changed
Date:   Wed, 14 Aug 2019 10:57:19 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <78BC2DFF-D2F5-494E-BDDE-10F42C8F9E51@flugsvamp.com>
In-Reply-To: <20190814143352.3759-1-maximmi@mellanox.com>
References: <5b123e9a-095f-1db4-da6e-5af6552430e1@iogearbox.net>
 <20190814143352.3759-1-maximmi@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14 Aug 2019, at 7:34, Maxim Mikityanskiy wrote:

> Don't uninstall an XDP program when none is installed, and don't install
> an XDP program that has the same ID as the one already installed.
>
> dev_change_xdp_fd doesn't perform any checks in case it uninstalls an
> XDP program. It means that the driver's ndo_bpf can be called with
> XDP_SETUP_PROG asking to set it to NULL even if it's already NULL. This
> case happens if the user runs `ip link set eth0 xdp off` when there is
> no XDP program attached.
>
> The symmetrical case is possible when the user tries to set the program
> that is already set.
>
> The drivers typically perform some heavy operations on XDP_SETUP_PROG,
> so they all have to handle these cases internally to return early if
> they happen. This patch puts this check into the kernel code, so that
> all drivers will benefit from it.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
