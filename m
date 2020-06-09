Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC581F48E1
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 23:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgFIV3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 17:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726888AbgFIV3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 17:29:05 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBDE1C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 14:29:05 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 74C7E127A7CE6;
        Tue,  9 Jun 2020 14:29:04 -0700 (PDT)
Date:   Tue, 09 Jun 2020 14:29:01 -0700 (PDT)
Message-Id: <20200609.142901.3888767961952002.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        lorenzo.bianconi@redhat.com, brouer@redhat.com
Subject: Re: [PATCH net] net: mvneta: do not redirect frames during
 reconfiguration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fd076dae0536d823e136ab4c114346602e02b6d7.1591653494.git.lorenzo@kernel.org>
References: <fd076dae0536d823e136ab4c114346602e02b6d7.1591653494.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jun 2020 14:29:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Tue,  9 Jun 2020 00:02:39 +0200

> Disable frames injection in mvneta_xdp_xmit routine during hw
> re-configuration in order to avoid hardware hangs
> 
> Fixes: b0a43db9087a ("net: mvneta: add XDP_TX support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Looking around, I wonder if the fundamental difference from the normal
TX path is that the XDP path doesn't use the TXQ enable/disable
machinery and checks like the normal ndo_start_xmit() paths do.

And that's why only the XDP path has this issue.

I'll apply this, so that the bug is fixed, but note that I consider
this kind of change adding a new flags mask and one state bit to solve
a problem to be ultimately inelegant and ususally pointing out a more
fundamental issue.

Thank you.
