Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D2830692C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhA1A7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 19:59:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231191AbhA1A5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 19:57:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 861D164DD1;
        Thu, 28 Jan 2021 00:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611795363;
        bh=GNeySK//oA5sSbdd0ASJJufb+YqjhGpqsI7+o18dH+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KV8nM1tkterFMMGncJ0Ouxe4+T5HViuwIQ2K5oG4Utk4wUb7ltOcwvTlnTlOh8KF0
         yObQHQQsddU9FAY3V5CbzZLhccNdraiSNaeJd6IRgZGrEccSRAJJ04di/C3cUhJ99I
         wi60vC3HxxKklMlCA7F8f4IUbsjyvJj4ILtJpbdt8LaVdT3Vw5wqZ2YkoKn9nykEb1
         6g8XNqhCWvwklTEBQNBVX/ga5B32J94KF+Ed6dTyc7f1L/m1Ev9G2TEE8yLgb8sJuc
         TEQnUtvS3ANKrUNHnTTtMducM1cK9E+wgQwU7iljWtURwv399DKsbH94hEV3XZroNZ
         GGx7RTTy7E8Sw==
Date:   Wed, 27 Jan 2021 16:56:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiyou.wangcong@gmail.com
Cc:     Slava Bacherikov <mail@slava.cc>, willemb@google.com,
        open list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: BUG: Incorrect MTU on GRE device if remote is unspecified
Message-ID: <20210127165602.610b10c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e2dde066-44b2-6bb3-a359-6c99b0a812ea@slava.cc>
References: <e2dde066-44b2-6bb3-a359-6c99b0a812ea@slava.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 22:10:10 +0200 Slava Bacherikov wrote:
> Hi, I'd like to report a regression. Currently, if you create GRE
> interface on the latest stable or LTS kernel (5.4 branch) with
> unspecified remote destination it's MTU will be adjusted for header size
> twice. For example:
> 
> $ ip link add name test type gre local 127.0.0.32
> $ ip link show test | grep mtu
> 27: test@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group
> default qlen 1000
> 
> or with FOU
> 
> $ ip link add name test2   type gre local 127.0.0.32 encap fou
> encap-sport auto encap-dport 6666
> $ ip link show test2 | grep mtu
> 28: test2@NONE: <NOARP> mtu 1436 qdisc noop state DOWN mode DEFAULT
> group default qlen 1000
> 
> The same happens with GUE too (MTU is 1428 instead of 1464).
> As you can see that MTU in first case is 1452 (1500 - 24 - 24) and with
> FOU it's 1436 (1500 - 32 - 32), GUE 1428 (1500 - 36 - 36). If remote
> address is specified MTU is correct.
> 
> This regression caused by fdafed459998e2be0e877e6189b24cb7a0183224 commit.

Cong is this one on your radar?
