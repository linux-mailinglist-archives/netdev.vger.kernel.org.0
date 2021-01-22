Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A43B2FFA01
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 02:37:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbhAVBfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 20:35:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:48008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbhAVBfU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 20:35:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1F312389F;
        Fri, 22 Jan 2021 01:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611279278;
        bh=zsnaoZ1Zo7W1sCfqP56PC9Q95DEzc0eJFLPKjS6g/Vc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IIY/TdR+FZsyaWAKFqIIlgxNCXdDUuL86BHg+6WiKU5mi80kFig/GwmzcXaNcwc9Q
         qObK8dc7fJHMrrRS9+RtWe802Tzcntp59Nyju99b1nGi9uwEm6S34CAFHogxxEBBPJ
         HweDWOTprKMx/xYhDM9GSRRuzYorSX6AFJY6HX/0E7qnEKYajmH0Yeaut/WjmFMwAJ
         FB8McS4i3v5itT4Z34qNzF35ItZnMotz20CO/KAE7TBEENfR4hca73iXfZ6PUGMqlN
         9Rc5Lndi5XYJYVEPVZgrL9TorCr7wSGB6r+cYtTS35/CD7KO/ZkPJ9JNi2TEhBJ4FA
         17D4x8Qmyy8Qg==
Date:   Thu, 21 Jan 2021 17:34:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2 net-next 5/5] mptcp: implement delegated actions
Message-ID: <20210121173437.1b945b01@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fbae7709d333eb2afcc79e69a8db3d952292564f.1611153172.git.pabeni@redhat.com>
References: <cover.1611153172.git.pabeni@redhat.com>
        <fbae7709d333eb2afcc79e69a8db3d952292564f.1611153172.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jan 2021 15:39:14 +0100 Paolo Abeni wrote:
> On MPTCP-level ack reception, the packet scheduler
> may select a subflow other then the current one.
> 
> Prior to this commit we rely on the workqueue to trigger
> action on such subflow.
> 
> This changeset introduces an infrastructure that allows
> any MPTCP subflow to schedule actions (MPTCP xmit) on
> others subflows without resorting to (multiple) process
> reschedule.

If your work doesn't reschedule there should not be multiple 
rescheds, no?

> A dummy NAPI instance is used instead. When MPTCP needs to
> trigger action an a different subflow, it enqueues the target
> subflow on the NAPI backlog and schedule such instance as needed.
> 
> The dummy NAPI poll method walks the sockets backlog and tries
> to acquire the (BH) socket lock on each of them. If the socket
> is owned by the user space, the action will be completed by
> the sock release cb, otherwise push is started.
> 
> This change leverages the delegated action infrastructure
> to avoid invoking the MPTCP worker to spool the pending data,
> when the packet scheduler picks a subflow other then the one
> currently processing the incoming MPTCP-level ack.
> 
> Additionally we further refine the subflow selection
> invoking the packet scheduler for each chunk of data
> even inside __mptcp_subflow_push_pending().

Is there much precedence for this sort of hijacking of NAPI 
for protocol work? Do you need it because of locking?
