Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365D12EB486
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 21:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731391AbhAEUv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 15:51:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731374AbhAEUvx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 15:51:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF47D22D5A;
        Tue,  5 Jan 2021 20:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609879864;
        bh=5nqqU9f2Lt0gtMHfRqEIAk9ugHK0cIZf+Y13wmVzu7A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JzLCU51aCAYRhYjKvk28qXrT4W8V2h4gvmwkwBV3zks6cu0/+ffd0GmWntyHtybuy
         dR9boMyKJ9oTmHPpHyhnshNe9KUWRShbiJPeoJXEs74GWZgacgHHbXrwhKGQomhVRX
         Vzzmlvmg8qFgwVBwad7A12QBLmhFNqU9k1wgjpDiNFG0TJqrWNfO9SC/8gM2CoZuzB
         5OnO8jGDzmDjd5pC7HVdyDF4fnYdFACvNssHc1w2yLBjjpJXnSpRrf21YkECkGGu6P
         K7DYLmLSlu1uwZIAYh5NpZzkqiax8lxpLYgtioupAR9RfPcwSFkhOlbhAeGuohz96j
         Fiz0NU2YKCSZg==
Message-ID: <741209d2a42d46ebdb8249caaef7531f5ad8fa76.camel@kernel.org>
Subject: Re: mlx5 error when the skb linear space is empty
From:   Saeed Mahameed <saeed@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org
Date:   Tue, 05 Jan 2021 12:51:02 -0800
In-Reply-To: <1609757998.875103-1-xuanzhuo@linux.alibaba.com>
References: <1609757998.875103-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-04 at 18:59 +0800, Xuan Zhuo wrote:
> hi
> 
> In the process of developing xdp socket, we tried to directly use
> page to
> construct skb directly, to avoid data copy. And the MAC information
> is also in
> the page, which caused the linear space of skb to be empty. In this
> case, I
> encountered a problem :
> 
> mlx5_core 0000:3b:00.1 eth1: Error cqe on cqn 0x817, ci 0x8, qn
> 0x1dbb, opcode 0xd, syndrome 0x1, vendor syndrome 0x68
> 00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00000030: 00 00 00 00 60 10 68 01 0a 00 1d bb 00 0f 9f d2
> WQE DUMP: WQ size 1024 WQ cur size 0, WQE index 0xf, len: 64
> 00000000: 00 00 0f 0a 00 1d bb 03 00 00 00 08 00 00 00 00
> 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00000020: 00 00 00 2b 00 08 00 00 00 00 00 05 9e e3 08 00
> 00000030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> mlx5_core 0000:3b:00.1 eth1: ERR CQE on SQ: 0x1dbb
> 
> 
> And when I try to copy only the mac address into the linear space of
> skb, the
> other parts are still placed in the page. When constructing skb in
> this way, I
> found that although the data can be sent successfully, the sending
> performance
> is relatively poor!!
> 

Hi,

This is an expected behavior of ConnectX4-LX, ConnectX4-LX requires the
driver to copy at least the L2 headers into the linear part, in some
DCB/DSCP configuration it will require L3 headers.
to check what the current configuration, you can check from the driver
code:
mlx5e_calc_min_inline() // Calculates the minimum required headers to
copy to linear part per packet 

and sq->min_inline_mode; stores the minimum required by the FW.

This "must copy" requirement doesn't exist for ConnectX5 and above .. 

> I would like to ask, is there any way to solve this problem?
> 
> dev info:
>     driver: mlx5_core
>     version: 5.10.0+
>     firmware-version: 14.21.2328 (MT_2470112034)
>     expansion-rom-version:
>     bus-info: 0000:3b:00.0
>     supports-statistics: yes
>     supports-test: yes
>     supports-eeprom-access: no
>     supports-register-dump: no
>     supports-priv-flags: yes
> 
> 
> 
> 

