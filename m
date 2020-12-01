Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633492CAB03
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgLASsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:48:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgLASsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 13:48:15 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0596208C3;
        Tue,  1 Dec 2020 18:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606848455;
        bh=s7OHE4J+tFok6uAOdh77oNakSsL7VHDq9LEl6jJr29c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0WrGYcSjiPVUcLDCeOvLPPGxJp89aKRzeyvfR+BJ1wb5vX5aqSi64X550xYYESJ4s
         KBvguDTm4UcxCADkWIufbK46TziXWPNFS9OvU6hf36QyW24+Dyz8twrzMXwSmQ40CF
         nE92HxRcOdTrRNMKE/rqsO1vy614EpcasEhk18rA=
Date:   Tue, 1 Dec 2020 10:47:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH v3] net/af_unix: don't create a path for a binded socket
Message-ID: <20201201104734.2620a127@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201093306.32638-1-kda@linux-powerpc.org>
References: <20201201093306.32638-1-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Dec 2020 12:33:06 +0300 Denis Kirjanov wrote:
> in the case of the socket which is bound to an adress
> there is no sense to create a path in the next attempts
> 
> here is a program that shows the issue:
> 
> int main()
> {
>     int s;
>     struct sockaddr_un a;
> 
>     s = socket(AF_UNIX, SOCK_STREAM, 0);
>     if (s<0)
>         perror("socket() failed\n");
> 
>     printf("First bind()\n");
> 
>     memset(&a, 0, sizeof(a));
>     a.sun_family = AF_UNIX;
>     strncpy(a.sun_path, "/tmp/.first_bind", sizeof(a.sun_path));
> 
>     if ((bind(s, (const struct sockaddr*) &a, sizeof(a))) == -1)
>         perror("bind() failed\n");
> 
>     printf("Second bind()\n");
> 
>     memset(&a, 0, sizeof(a));
>     a.sun_family = AF_UNIX;
>     strncpy(a.sun_path, "/tmp/.first_bind_failed", sizeof(a.sun_path));
> 
>     if ((bind(s, (const struct sockaddr*) &a, sizeof(a))) == -1)
>         perror("bind() failed\n");
> }
> 
> kda@SLES15-SP2:~> ./test
> First bind()
> Second bind()
> bind() failed
> : Invalid argument
> 
> kda@SLES15-SP2:~> ls -la /tmp/.first_bind
> .first_bind         .first_bind_failed
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>

Is the deadlock fixed by the patch Michal pointed out no longer present?
