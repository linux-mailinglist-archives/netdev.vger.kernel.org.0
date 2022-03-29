Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20D1D4EAE86
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 15:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiC2Nca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 09:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiC2Nc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 09:32:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9B02DD72
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 06:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46798B81756
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 13:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B22C3410F;
        Tue, 29 Mar 2022 13:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648560643;
        bh=hmHBWKHVme3R9M2FfdHc5uogPNVFO7+CIYu09mPq/j4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d8XHlAcY/KSciSkrL1HBODzUdMs6uGL6kkRgIicmwBDns072nYOEzm3wzZvGA4Of7
         7YQmDu/Pn5PtaGvvjt6fCYwB6ifDHDh8nyuaAYWJ1yqLn9S2kCFbboFdxU+/sUAIdS
         S7irkFh2e5TgdpE/P74docTPWgn0MZ7mLd21JiZQ=
Date:   Tue, 29 Mar 2022 15:30:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Antonio Quartulli <antonio@openvpn.net>
Cc:     Xin Long <lucien.xin@gmail.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCHv5 net-next 1/2] udp: call udp_encap_enable for v6 sockets
 when enabling encap
Message-ID: <YkMKAGujYMNOJMU6@kroah.com>
References: <cover.1612342376.git.lucien.xin@gmail.com>
 <fc62f5e225f83d128ea5222cc752cb1c38c92304.1612342376.git.lucien.xin@gmail.com>
 <3842df54-8323-e6e7-9a06-de1e78e099ae@openvpn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3842df54-8323-e6e7-9a06-de1e78e099ae@openvpn.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 03:24:49PM +0200, Antonio Quartulli wrote:
> Hi all,
> 
> On 03/02/2021 09:54, Xin Long wrote:
> > When enabling encap for a ipv6 socket without udp_encap_needed_key
> > increased, UDP GRO won't work for v4 mapped v6 address packets as
> > sk will be NULL in udp4_gro_receive().
> > 
> > This patch is to enable it by increasing udp_encap_needed_key for
> > v6 sockets in udp_tunnel_encap_enable(), and correspondingly
> > decrease udp_encap_needed_key in udpv6_destroy_sock().
> > 
> 
> This is a non-negligible issue that other users (in or out of tree) may hit
> as well.
> 
> At OpenVPN we are developing a kernel device driver that has the same
> problem as UDP GRO. So far the only workaround is to let users upgrade to
> v5.12+.
> 
> I would like to propose to take this patch in stable releases.
> Greg, is this an option?
> 
> Commit in the linux kernel is:
> a4a600dd301ccde6ea239804ec1f19364a39d643


What stable tree(s) should this apply to, and where have you tested it?

thanks,

greg k-h
