Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E79496B0F
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 23:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730871AbfHTVFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 17:05:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51118 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730773AbfHTVFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 17:05:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 59A4D148858E9;
        Tue, 20 Aug 2019 14:05:12 -0700 (PDT)
Date:   Tue, 20 Aug 2019 14:05:11 -0700 (PDT)
Message-Id: <20190820.140511.46557475142867394.davem@davemloft.net>
To:     uli+renesas@fpond.eu
Cc:     linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        sergei.shtylyov@cogentembedded.com, niklas.soderlund@ragnatech.se,
        wsa@the-dreams.de, horms@verge.net.au, magnus.damm@gmail.com,
        geert@glider.be
Subject: Re: [PATCH v3] ravb: implement MTU change while device is up
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566327686-8996-1-git-send-email-uli+renesas@fpond.eu>
References: <1566327686-8996-1-git-send-email-uli+renesas@fpond.eu>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 20 Aug 2019 14:05:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ulrich Hecht <uli+renesas@fpond.eu>
Date: Tue, 20 Aug 2019 21:01:26 +0200

> This revision reverts the MTU change if re-opening the device fails.

But you leave the device closed if this happens.

You have to implement this properly, with a full prepare/commit sequence.

First allocate all of the necessary resources, such that you can guarantee
success.  If you cannot allocate these resources you must fail the operation
and leave the device _UP_ with the original MTU value.

If you can allocate the resource, you can fully commit to the MTU change
and return success.

You must not fail the operation in such a way that the device is left
inoperable.  But that is precisely what your patch currently does.
