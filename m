Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0C62027A5
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 02:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgFUAoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 20:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbgFUAoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 20:44:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EFFC061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 17:44:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 754A7120ED49C;
        Sat, 20 Jun 2020 17:44:09 -0700 (PDT)
Date:   Sat, 20 Jun 2020 17:44:08 -0700 (PDT)
Message-Id: <20200620.174408.1728600398443363480.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: sock diag uAPI and MPTCP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <c5b53444ca4c79b887629c93d954dadbc4a777da.camel@redhat.com>
References: <c5b53444ca4c79b887629c93d954dadbc4a777da.camel@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 17:44:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 19 Jun 2020 12:54:40 +0200

> IPPROTO_MPTCP value (0x106) can't be represented using the current sock
> diag uAPI, as the 'sdiag_protocol' field is 8 bits wide.
> 
> To implement diag support for MPTCP socket, we will likely need a
> 'inet_diag_req_v3' with a wider 'sdiag_protocol'
> field. inet_diag_handler_cmd() could detect the version of
> the inet_diag_req_v* provided by user-space checking nlmsg_len() and
> convert _v2 reqs to _v3.
> 
> This change will be a bit invasive, as all in kernel diag users will
> then operate only on 'inet_diag_req_v3' (many functions' signature
> change required), but the code-related changes will be encapsulated
> by inet_diag_handler_cmd().

Another way to extend the size of a field is to add an attribute which
supercedes the header structure field when present.

We did this when we needed to make the fib rule table ID number larger,
see FRA_TABLE.

You'd only need to specify this when using protocol values larger than
8 bits in size.

