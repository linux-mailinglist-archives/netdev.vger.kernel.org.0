Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31103B0DD7
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhFVTxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232746AbhFVTxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 15:53:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73BB96100B;
        Tue, 22 Jun 2021 19:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624391477;
        bh=ugd2vmV/9IIOP3tZ87/ckyZcZ0G9dluioZ2VteFuD8c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jV1v4SlYKGgJFSYYy3bHhpJF015IJ3EhlF9N4lIN/Yn03dDkg13OD5ja+SWd3+Dvg
         x/I4mwzEzwV31cJDJoVaz2+OenwV9VHDMqW9vsLPRNWO8nBKuOp5w+AyhU9okxttoJ
         mW/pvSkpivuMUL0YbMSQgoEzZBNmd7I2uXp9Z1mw0LrI3zfXIn6GJnUASpaUU8TfzF
         tMe3KA1F04uw3WrhE1+l9S1DpIgeH2LDZcvB6NDT873eW6bYo/oy7Tr6ert3HLixBI
         LJDDHuotIfJ83u2nRdBYoVonCZRFo7ctVz6kk0v3xCeOymI28FoepK8UVb51LL81bw
         9ddmI2+gTGcUw==
Date:   Tue, 22 Jun 2021 12:51:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
Subject: Re: [PATCH net-next] ip: avoid OOM kills with large UDP sends over
 loopback
Message-ID: <20210622125116.44a97a55@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210622120426.17ef1acc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20210621231307.1917413-1-kuba@kernel.org>
        <8fe00e04-3a79-6439-6ec7-5e40408529e2@gmail.com>
        <20210622095422.5e078bd4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <462f87f4-cc90-1c0e-3a9f-c65c64781dc3@gmail.com>
        <20210622110935.35318a30@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <d4e2cf28-89f9-7c1f-91de-759de2c47fae@gmail.com>
        <20210622120426.17ef1acc@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 12:04:26 -0700 Jakub Kicinski wrote:
> For the UDP case we can either adapt the af_unix approach, and cap head
> size to SKB_MAX_ALLOC or try to allocate the full skb and fall back.
> Having alloc_skb_with_frags() itself re-balance head <> data
> automatically does not feel right, no?

Actually looking closer at the UDP code it appears it only uses the
giant head it allocated if the underlying device doesn't have SG.
We can make the head smaller and probably only improve performance 
for 99% of deployments. I'll send a v2.
