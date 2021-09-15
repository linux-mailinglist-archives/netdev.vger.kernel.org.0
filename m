Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114B740C826
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbhIOPVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233977AbhIOPV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:21:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7B51961250;
        Wed, 15 Sep 2021 15:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631719209;
        bh=8Co9jLkNALX8XAMdsMk7BmOfE4EKMBOktCdDqRaa3QI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dkp8FWlVa9Z2GqBIFQxs25VaSdO3XQHgRblOT7UHh4bdQSyhxQPP3/M8VwcpwHnCT
         ook8YsNkAoineRZJbYgy6OqgUwpSpUqUBHyqq+5ZJYjUlg7erR8JiRa9miCrlwy0HW
         m75+uPzh25M11Z4sGHooe7S6pNaivDWc1Es62k0+JTGoakZUnBYBfBy+WZRh8aJMPS
         7MUKS3rO+VNrvy4ZD2X+WLnwL6VeCgNEJHzTIrq7OrzxMDmIItrKaE5bxBzIhi1XAP
         5/ok4x4fUKcZtwQ6lpBGvcFZj/wbKQX+stef8TDFJroguKc0JQW8PmIUZ5xU+HRKKR
         6ab2ZsKo5FsHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6A0C960A9E;
        Wed, 15 Sep 2021 15:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: sched: update default qdisc visibility
 after Tx queue cnt changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163171920942.21180.16902973034127753411.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 15:20:09 +0000
References: <20210913225332.662291-1-kuba@kernel.org>
In-Reply-To: <20210913225332.662291-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jhs@mojatatu.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 13 Sep 2021 15:53:29 -0700 you wrote:
> Matthew noticed that number of children reported by mq does not match
> number of queues on reconfigured interfaces. For example if mq is
> instantiated when there is 8 queues it will always show 8 children,
> regardless of config being changed:
> 
>  # ethtool -L eth0 combined 8
>  # tc qdisc replace dev eth0 root handle 100: mq
>  # tc qdisc show dev eth0
>  qdisc mq 100: root
>  qdisc pfifo_fast 0: parent 100:8 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:7 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:6 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:5 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:4 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:3 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:2 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:1 bands 3 priomap 1 2 ...
>  # ethtool -L eth0 combined 1
>  # tc qdisc show dev eth0
>  qdisc mq 100: root
>  qdisc pfifo_fast 0: parent 100:8 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:7 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:6 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:5 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:4 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:3 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:2 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:1 bands 3 priomap 1 2 ...
>  # ethtool -L eth0 combined 32
>  # tc qdisc show dev eth0
>  qdisc mq 100: root
>  qdisc pfifo_fast 0: parent 100:8 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:7 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:6 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:5 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:4 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:3 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:2 bands 3 priomap 1 2 ...
>  qdisc pfifo_fast 0: parent 100:1 bands 3 priomap 1 2 ...
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: sched: update default qdisc visibility after Tx queue cnt changes
    https://git.kernel.org/netdev/net-next/c/1e080f17750d
  - [net-next,2/3] netdevsim: add ability to change channel count
    https://git.kernel.org/netdev/net-next/c/2e367522ce6b
  - [net-next,3/3] selftests: net: test ethtool -L vs mq
    https://git.kernel.org/netdev/net-next/c/2d6a58996ee2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


