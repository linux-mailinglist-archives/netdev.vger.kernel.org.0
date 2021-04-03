Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535423534B4
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 18:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbhDCQ0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 12:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbhDCQ0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 12:26:15 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA5FC0613E6;
        Sat,  3 Apr 2021 09:26:12 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lSj65-0070RZ-Az; Sat, 03 Apr 2021 18:26:05 +0200
Message-ID: <b8a83042f83af92e87550085175da5c1d95cc4b0.camel@sipsolutions.net>
Subject: Re: [PATCH] net: netlink: fix error check in
 genl_family_rcv_msg_doit
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pavel Skripkin <paskripkin@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Sat, 03 Apr 2021 18:26:04 +0200
In-Reply-To: <20210403151312.31796-1-paskripkin@gmail.com>
References: <20210403151312.31796-1-paskripkin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-04-03 at 15:13 +0000, Pavel Skripkin wrote:
> genl_family_rcv_msg_attrs_parse() can return NULL
> pointer:
> 
>         if (!ops->maxattr)
>                 return NULL;
> 
> But this condition doesn't cause an error in
> genl_family_rcv_msg_doit

And I'm almost certain that in fact it shouldn't cause an error!

If the family doesn't set maxattr then it doesn't want to have generic
netlink doing the parsing, but still it should be possible to call the
ops. Look at fs/dlm/netlink.c for example, it doesn't even have
attributes. You're breaking it with this patch.

Also, the (NULL) pointer is not actually _used_ anywhere, so why would
it matter?

johannes

