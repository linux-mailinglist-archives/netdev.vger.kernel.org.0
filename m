Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B4617EDDA
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgCJBOY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Mar 2020 21:14:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34458 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgCJBOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:14:21 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 55B8A15A04E39;
        Mon,  9 Mar 2020 18:14:21 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:14:20 -0700 (PDT)
Message-Id: <20200309.181420.880934692451984316.davem@davemloft.net>
To:     zeil@yandex-team.ru
Cc:     netdev@vger.kernel.org, khlebnikov@yandex-team.ru
Subject: Re: [PATCH net] cgroup, netclassid: periodically release file_lock
 on classid updating
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200305144557.GA78822@yandex-team.ru>
References: <20200305144557.GA78822@yandex-team.ru>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=koi8-r
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 18:14:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Yakunin <zeil@yandex-team.ru>
Date: Thu, 5 Mar 2020 17:45:57 +0300

> In our production environment we have faced with problem that updating
> classid in cgroup with heavy tasks cause long freeze of the file tables
> in this tasks. By heavy tasks we understand tasks with many threads and
> opened sockets (e.g. balancers). This freeze leads to an increase number
> of client timeouts.
> 
> This patch implements following logic to fix this issue:
> Áfter iterating 1000 file descriptors file table lock will be released
> thus providing a time gap for socket creation/deletion.
> 
> Now update is non atomic and socket may be skipped using calls:
> 
> dup2(oldfd, newfd);
> close(oldfd);
> 
> But this case is not typical. Moreover before this patch skip is possible
> too by hiding socket fd in unix socket buffer.
> 
> New sockets will be allocated with updated classid because cgroup state
> is updated before start of the file descriptors iteration.
> 
> So in common cases this patch has no side effects.
> 
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Applied and queued up for -stable, thank you.
