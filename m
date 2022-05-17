Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 643EC52AEDF
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 01:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiEQXyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 19:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiEQXyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 19:54:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B5747548;
        Tue, 17 May 2022 16:54:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A11BB81CFD;
        Tue, 17 May 2022 23:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887C7C385B8;
        Tue, 17 May 2022 23:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652831660;
        bh=B84+lcb6ddsH9wn03po93338LsAH3GQWTK0OpmlsHJc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nslXOtGaVoxikOExgYm3UwMqMXeGdYH+Bvq7uDwNsgwjUxa54+zFgEwsjrNs7oTAf
         N3JnuKaYjo9HYB/wQudEtx5XBvdC5CWNZmtJcCd7iAEYfKNoymJn74RIyn5rddfj4Y
         dPOd8pzp5RrYuVCa4gkQiA/tsrjVO6n27T4ujAvuPhO84EXM1TgRtaninGvl2B8HLq
         Fe9dqJSfWNqJrpVhYu9EtdKOuxF9ARC3LHUCagmHr7A0u2gEVkqWKaVyLBNiKXn8fh
         ofjNTE6No1yO5XhC/FuTjvrDcId+TyEIZ4XqwaAyOZ+6iRICbkCNOM80Pzmff7kX6D
         em+xZHkEi3IDg==
Date:   Tue, 17 May 2022 16:54:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC net-next] bonding: netlink error message support for
 options
Message-ID: <20220517165419.540f2dc8@kernel.org>
In-Reply-To: <20220517154419.44a1cb6a@hermes.local>
References: <5a6ba6f14b0fad6d4ba077a5230ee71cbf970934.1652819479.git.jtoppins@redhat.com>
        <20220517154419.44a1cb6a@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 15:44:19 -0700 Stephen Hemminger wrote:
> On Tue, 17 May 2022 16:31:19 -0400
> Jonathan Toppins <jtoppins@redhat.com> wrote:
> 
> >     This is an RFC because the current NL_SET_ERR_MSG() macros do not support
> >     printf like semantics so I rolled my own buffer setting in __bond_opt_set().
> >     The issue is I could not quite figure out the life-cycle of the buffer, if
> >     rtnl lock is held until after the text buffer is copied into the packet
> >     then we are ok, otherwise, some other type of buffer management scheme will
> >     be needed as this could result in corrupted error messages when modifying
> >     multiple bonds.  
> 
> Might be better for others in long term if NL_SET_ERR_MSG() had printf like
> semantics. Surely this isn't going to be first or last case.
> 
> Then internally, it could print right to the netlink message.

Dunno. I think pointing at the bad attr + exposing per-attr netlink
parsing policy + a string for a human worked pretty well so far.
IMHO printf() is just a knee jerk reaction, especially when converting
from netdev_err(). 

Augmenting structured information is much, much better long term.

To me the never ending stream of efforts to improve printk() is a
proof that once we let people printf() at will, efforts to contain 
it will be futile.
