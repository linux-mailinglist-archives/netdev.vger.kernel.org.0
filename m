Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67609215F9A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 21:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgGFTph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 15:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbgGFTph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 15:45:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0F0C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 12:45:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D4A7F127E67A2;
        Mon,  6 Jul 2020 12:45:36 -0700 (PDT)
Date:   Mon, 06 Jul 2020 12:45:36 -0700 (PDT)
Message-Id: <20200706.124536.774178117550894539.davem@davemloft.net>
To:     jchapman@katalix.com
Cc:     netdev@vger.kernel.org, gnault@redhat.com
Subject: Re: [PATCH net] l2tp: add sk_reuseport checks to
 l2tp_validate_socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200706121259.GA20199@katalix.com>
References: <20200706121259.GA20199@katalix.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Jul 2020 12:45:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: James Chapman <jchapman@katalix.com>
Date: Mon, 6 Jul 2020 13:12:59 +0100

> The crash occurs in the socket destroy path. bpf_sk_reuseport_detach
> assumes ownership of sk_user_data if sk_reuseport is set and writes a
> NULL pointer to the memory pointed to by
> sk_user_data. bpf_sk_reuseport_detach is called via
> udp_lib_unhash. l2tp does its socket cleanup through sk_destruct,
> which fetches private data through sk_user_data. The BUG_ON fires
> because this data has been corrupted.

The ownership of sk_user_data has to be handled more cleanly.

BPF really has no business taking over this as it is for the protocols
to use and what L2TP is doing is quite natural and normal.  Exactly
what sk_user_data was designed to be used for.

I'm not applying this, please take this up with the BPF folks.  They
need to store their metadata elsewhere.
