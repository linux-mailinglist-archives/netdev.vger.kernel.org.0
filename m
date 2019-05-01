Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B09591083A
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfEANTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:19:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60698 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfEANTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:19:51 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0FFB6146D4904;
        Wed,  1 May 2019 06:19:49 -0700 (PDT)
Date:   Wed, 01 May 2019 09:19:48 -0400 (EDT)
Message-Id: <20190501.091948.243588960568894414.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net] sctp: avoid running the sctp state machine
 recursively
From:   David Miller <davem@davemloft.net>
In-Reply-To: <3a5d5e96521a5f53ed36ca85219294c34be7d0ef.1556518579.git.lucien.xin@gmail.com>
References: <3a5d5e96521a5f53ed36ca85219294c34be7d0ef.1556518579.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 06:19:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 29 Apr 2019 14:16:19 +0800

> Ying triggered a call trace when doing an asconf testing:
 ...
> As it shows, the first sctp_do_sm() running under atomic context (NET_RX
> softirq) invoked sctp_primitive_ASCONF() that uses GFP_KERNEL flag later,
> and this flag is supposed to be used in non-atomic context only. Besides,
> sctp_do_sm() was called recursively, which is not expected.
> 
> Vlad tried to fix this recursive call in Commit c0786693404c ("sctp: Fix
> oops when sending queued ASCONF chunks") by introducing a new command
> SCTP_CMD_SEND_NEXT_ASCONF. But it didn't work as this command is still
> used in the first sctp_do_sm() call, and sctp_primitive_ASCONF() will
> be called in this command again.
> 
> To avoid calling sctp_do_sm() recursively, we send the next queued ASCONF
> not by sctp_primitive_ASCONF(), but by sctp_sf_do_prm_asconf() in the 1st
> sctp_do_sm() directly.
> 
> Reported-by: Ying Xu <yinxu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable.
