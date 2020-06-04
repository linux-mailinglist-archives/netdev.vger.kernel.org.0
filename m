Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6639F1EE736
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 17:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgFDPDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 11:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728638AbgFDPDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 11:03:38 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0EEC08C5C0;
        Thu,  4 Jun 2020 08:03:38 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.93 #3 (Red Hat Linux))
        id 1jgrP5-0033lc-U6; Thu, 04 Jun 2020 15:03:35 +0000
Date:   Thu, 4 Jun 2020 16:03:35 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200604150335.GG23230@ZenIV.linux.org.uk>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <20200603011810-mutt-send-email-mst@kernel.org>
 <20200603165205.GU23230@ZenIV.linux.org.uk>
 <20200604054516-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604054516-mutt-send-email-mst@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 06:10:23AM -0400, Michael S. Tsirkin wrote:

> 	stac()
> 	for (i = 0; i < 64; ++i) {
> 	 get_user(flags, desc[i].flags)
unsafe_get_user(), please.
> 	 smp_rmb()
> 	 if (!(flags & VALID))
> 		break;
> 	 copy_from_user(&adesc[i], desc + i, sizeof adesc[i]);
... and that would raw_copy_from_user() (or unsafe_copy_from_user(),
for wrapper that would take a label to bugger off to)
> 	}
> 	clac()
