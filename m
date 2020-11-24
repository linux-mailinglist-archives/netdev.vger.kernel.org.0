Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC282C2FAD
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404296AbgKXSIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:08:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404248AbgKXSIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 13:08:11 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 708D321D7A;
        Tue, 24 Nov 2020 18:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606241290;
        bh=a3zcbxyM7m3QhyNcCwvEWkswxRtkEpWapn/npBZTDtU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qqLLHvUK6BmYgrnlEQkR4uim+B6Zm/jfdijYnag2spkAJLR1ioOxkrfPdvBFz99ng
         Kx6KWXI1LfJjlvEYDK/mp5XnTePA0JTQpQTOwIBW8oVuxWbLUuXyMx95zkFmeNtrjg
         NNAvUaZmCcMCgD0B/A1XAetjcIJS3HnbhQWOR/+M=
Date:   Tue, 24 Nov 2020 10:08:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next] mptcp: be careful on MPTCP-level ack.
Message-ID: <20201124100809.08360e4c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <722e1a13493897c7cc194035e9b394e0dbeeb1af.1606213920.git.pabeni@redhat.com>
References: <722e1a13493897c7cc194035e9b394e0dbeeb1af.1606213920.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 12:20:11 +0100 Paolo Abeni wrote:
> -static void mptcp_send_ack(struct mptcp_sock *msk, bool force)
> +static inline bool tcp_can_send_ack(const struct sock *ssk)
> +{
> +	return !((1 << inet_sk_state_load(ssk)) &
> +	       (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_TIME_WAIT | TCPF_CLOSE));
> +}

Does the compiler really not inline this trivial static function?
