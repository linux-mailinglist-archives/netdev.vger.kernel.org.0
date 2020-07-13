Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3008F21E06D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 21:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbgGMTFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 15:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgGMTFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 15:05:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E319FC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 12:05:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4883A1295AA66;
        Mon, 13 Jul 2020 12:05:31 -0700 (PDT)
Date:   Mon, 13 Jul 2020 12:05:30 -0700 (PDT)
Message-Id: <20200713.120530.676426681031141505.davem@davemloft.net>
To:     borisp@mellanox.com
Cc:     kuba@kernel.org, john.fastabend@gmail.com, daniel@iogearbox.net,
        tariqt@mellanox.com, netdev@vger.kernel.org
Subject: Re: [PATCH] tls: add zerocopy device sendpage
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5aa3b1d7-ba99-546d-9440-2ffce28b1a11@mellanox.com>
References: <1594550649-3097-1-git-send-email-borisp@mellanox.com>
        <20200712.153233.370000904740228888.davem@davemloft.net>
        <5aa3b1d7-ba99-546d-9440-2ffce28b1a11@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 12:05:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boris Pismenny <borisp@mellanox.com>
Date: Mon, 13 Jul 2020 10:49:49 +0300

> An alternative approach that requires no knobs is to change the
> current TLS_DEVICE sendfile flow to skip the copy. It is really
> not necessary to copy the data, as the guarantees it provides to
> users, namely that users can modify page cache data sent via sendfile
> with no error, justifies the performance overhead.
> Users that sendfile data from the pagecache while modifying
> it cannot reasonably expect data on the other side to be
> consistent. TCP sendfile guarantees nothing except that
> the TCP checksum is correct. TLS sendfile with copy guarantees
> the same, but TLS sendfile zerocopy (with offload) will send
> the modified data, and this can trigger an authentication error
> on the TLS layer when inconsistent data is received. If the data
> is inconsistent, then letting the user know via an error is desirable,
> right?
> 
> If there are no objections, I'd gladly resubmit it with the approach
> described above.

The TLS signatures are supposed to be even stronger than the protocol
checksum, and therefore we should send out valid ones rather than
incorrect ones.

Why can't the device generate the correct TLS signature when
offloading?  Just like for the protocol checksum, the device should
load the payload into the device over DMA and make it's calculations
on that copy.

For SW kTLS, we must copy.  Potentially sending out garbage signatures
in a packet cannot be an "option".
