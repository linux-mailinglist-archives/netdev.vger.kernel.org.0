Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD51E2C33BB
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389200AbgKXWO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:14:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgKXWO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:14:57 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78FE820715;
        Tue, 24 Nov 2020 22:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606256097;
        bh=3uqlTjHCw8D/PoGvyhR94t8Oeg5C7QCEmj39EA363x8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oX4BllB96977rPGA3gc4lrfTcn3UzqQC4F6nZOulsSmlcsok9rpKGwuisZloqsW8m
         8vZNyKQHwjvFBFF5JFFQK27M+L3SOvChuuC+2rZauY0F8deRV3vX+3FYA39l4frg34
         r4p2ljnpBDmnW9DWjFLyjO3y5F4qxggj9Hdwf1ds=
Date:   Tue, 24 Nov 2020 14:14:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        kafai@fb.com, kernel-team@fb.com, edumazet@google.com,
        brakmo@fb.com, alexanderduyck@fb.com
Subject: Re: [net PATCH] tcp: Set ECT0 bit in tos/tclass for synack when BPF
 needs ECN
Message-ID: <20201124141455.432f73cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160593039663.2604.1374502006916871573.stgit@localhost.localdomain>
References: <160593039663.2604.1374502006916871573.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 19:47:44 -0800 Alexander Duyck wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> When a BPF program is used to select between a type of TCP congestion
> control algorithm that uses either ECN or not there is a case where the
> synack for the frame was coming up without the ECT0 bit set. A bit of
> research found that this was due to the final socket being configured to
> dctcp while the listener socket was staying in cubic.
> 
> To reproduce it all that is needed is to monitor TCP traffic while running
> the sample bpf program "samples/bpf/tcp_cong_kern.c". What is observed,
> assuming tcp_dctcp module is loaded or compiled in and the traffic matches
> the rules in the sample file, is that for all frames with the exception of
> the synack the ECT0 bit is set.
> 
> To address that it is necessary to make one additional call to
> tcp_bpf_ca_needs_ecn using the request socket and then use the output of
> that to set the ECT0 bit for the tos/tclass of the packet.
> 
> Fixes: 91b5b21c7c16 ("bpf: Add support for changing congestion control")
> Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>

Applied, thank you!
