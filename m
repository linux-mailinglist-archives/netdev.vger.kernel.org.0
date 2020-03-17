Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9965B188F30
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgCQUmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:42:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbgCQUmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 16:42:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACF7D20409;
        Tue, 17 Mar 2020 20:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584477765;
        bh=B3p7yslXOyHXr36SX2vD9T3TopY7rt7/c3b/W0a0NYk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I/S7Amiqf6frvq3odIGURYdwSnlhram+S0eVseo8qYaNtyxe6zbevFvkHvEivfgAL
         NeM14/dImpuNmr+X+rjFnajHb/q0OFsx2HnIdsByr/R6VtJGvVePax1mNRfofYcjLP
         stuoqQ7fASbbFm9AoK75niJLnacqh+wGC4MGbOKc=
Date:   Tue, 17 Mar 2020 13:42:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH RFC v1 01/15] xdp: add frame size to xdp_buff
Message-ID: <20200317134243.3c29a324@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <158446615272.702578.2884467013936153419.stgit@firesoul>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
        <158446615272.702578.2884467013936153419.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Mar 2020 18:29:12 +0100 Jesper Dangaard Brouer wrote:
> XDP have evolved to support several frame sizes, but xdp_buff was not
> updated with this information. The frame size (frame_sz) member of
> xdp_buff is introduced to know the real size of the memory the frame is
> delivered in.
> 
> When introducing this also make it clear that some tailroom is
> reserved/required when creating SKBs using build_skb().
> 
> It would also have been an option to introduce a pointer to
> data_hard_end (with reserved offset). The advantage with frame_sz is
> that (like rxq) drivers only need to setup/assign this value once per
> NAPI cycle. Due to XDP-generic (and some drivers) it's not possible to
> store frame_sz inside xdp_rxq_info, because it's varies per packet as it
> can be based/depend on packet length.

Do you reckon it would be too ugly to make xdp-generic suffer and have
it set the length in rxq per packet? We shouldn't handle multiple
packets from the same rxq in parallel, no?
