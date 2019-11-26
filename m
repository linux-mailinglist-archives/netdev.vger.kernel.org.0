Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5B610A5E5
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 22:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfKZVU6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Nov 2019 16:20:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42460 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZVU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 16:20:58 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 848CE14CEE321;
        Tue, 26 Nov 2019 13:20:57 -0800 (PST)
Date:   Tue, 26 Nov 2019 13:20:57 -0800 (PST)
Message-Id: <20191126.132057.498166931431808469.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH v2] net: port < inet_prot_sock(net) -->
 inet_port_requires_bind_service(net, port)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191125233704.186202-1-zenczykowski@gmail.com>
References: <CAHo-OoxYDpcpT+nZgYw7hkUY2wi+iRdtqR97xL_ALeC6h+aiKQ@mail.gmail.com>
        <20191125233704.186202-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 13:20:57 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Mon, 25 Nov 2019 15:37:04 -0800

> From: Maciej ¯enczykowski <maze@google.com>
> 
> Note that the sysctl write accessor functions guarantee that:
>   net->ipv4.sysctl_ip_prot_sock <= net->ipv4.ip_local_ports.range[0]
> invariant is maintained, and as such the max() in selinux hooks is actually spurious.
> 
> ie. even though
>   if (snum < max(inet_prot_sock(sock_net(sk)), low) || snum > high) {
> per logic is the same as
>   if ((snum < inet_prot_sock(sock_net(sk)) && snum < low) || snum > high) {
> it is actually functionally equivalent to:
>   if (snum < low || snum > high) {
> which is equivalent to:
>   if (snum < inet_prot_sock(sock_net(sk)) || snum < low || snum > high) {
> even though the first clause is spurious.
> 
> But we want to hold on to it in case we ever want to change what what
> inet_port_requires_bind_service() means (for example by changing
> it from a, by default, [0..1024) range to some sort of set).
> 
> Test: builds, git 'grep inet_prot_sock' finds no other references
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>

Applied, thanks.
