Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199DC33A39C
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 09:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbhCNIgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 04:36:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234806AbhCNIgP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 04:36:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B615F64EBE;
        Sun, 14 Mar 2021 08:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615710975;
        bh=ZS6V5nnNAhbzXMkBCECzzKS2KrJq8/t/D+B+J+8wv8A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VIUWbuYQ+4ZngiJMa1TKSbhSQKKquEkuecHoNiXxa9p2V+DUm+uVtRjk168NhwyZg
         NfCsSFq0zkbZFYUETd2S7KvLmU8tet3ZxYlttg7cFpVKxti2ByCXl+p8zORoTzQ0zB
         mu1zIOT7XWCwK9gqpr2VWSSknBSuM6seUgvD15Lk=
Date:   Sun, 14 Mar 2021 09:36:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fatih Yildirim <yildirim.fatih@gmail.com>
Cc:     santosh.shilimkar@oracle.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] net: rds: rds_send_probe memory leak
Message-ID: <YE3K+zeWnJ/hVpQS@kroah.com>
References: <a3036ea4ee2a06e4b3acd3b438025754d11f65fc.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3036ea4ee2a06e4b3acd3b438025754d11f65fc.camel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 11:23:10AM +0300, Fatih Yildirim wrote:
> Hi Santosh,
> 
> I've been working on a memory leak bug reported by syzbot.
> https://syzkaller.appspot.com/bug?id=39b72114839a6dbd66c1d2104522698a813f9ae2
> 
> It seems that memory allocated in rds_send_probe function is not freed.
> 
> Let me share my observations.
> rds_message is allocated at the beginning of rds_send_probe function.
> Then it is added to cp_send_queue list of rds_conn_path and refcount
> is increased by one.
> Next, in rds_send_xmit function it is moved from cp_send_queue list to
> cp_retrans list, and again refcount is increased by one.
> Finally in rds_loop_xmit function refcount is increased by one.
> So, total refcount is 4.
> However, rds_message_put is called three times, in rds_send_probe,
> rds_send_remove_from_sock and rds_send_xmit functions. It seems that
> one more rds_message_put is needed.
> Would you please check and share your comments on this issue?

Do you have a proposed patch that syzbot can test to verify if this is
correct or not?

thanks,

gre gk-h
