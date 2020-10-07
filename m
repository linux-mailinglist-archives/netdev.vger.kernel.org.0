Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B068B2868F9
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgJGUYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgJGUYm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 16:24:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D035920760;
        Wed,  7 Oct 2020 20:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602102282;
        bh=pydFyQDOUTefD4zNEZ5RRTTzL70Tgj4bgo8fz7F3Tt8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mu9Fka1BluWmzPhJNJ6YXjEA+32f+dNgubXNPGM0+9wkyiwb2sFYsTWGqFw3omVZZ
         z9BdNEQXQHUjFAnTCrBk8RufUvcELJ6yjU3S4mR0OeRTsLYVH+fwFtb3oNQWJ8qU17
         QemAwpeHA7Qxwvvs5Cf8OOryYIn7oJDAaFpUrfb0=
Date:   Wed, 7 Oct 2020 13:24:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net v3] net/tls: sendfile fails with ktls offload
Message-ID: <20201007132440.38f5f645@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007184021.27584-1-rohitm@chelsio.com>
References: <20201007184021.27584-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  8 Oct 2020 00:10:21 +0530 Rohit Maheshwari wrote:
> At first when sendpage gets called, if there is more data, 'more' in
> tls_push_data() gets set which later sets pending_open_record_frags, but
> when there is no more data in file left, and last time tls_push_data()
> gets called, pending_open_record_frags doesn't get reset. And later when
> 2 bytes of encrypted alert comes as sendmsg, it first checks for
> pending_open_record_frags, and since this is set, it creates a record with
> 0 data bytes to encrypt, meaning record length is prepend_size + tag_size
> only, which causes problem.
>  We should set/reset pending_open_record_frags based on more bit.
> 
> Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
